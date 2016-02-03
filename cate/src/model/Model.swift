//
//  Model.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import Locksmith

enum ModelState {
    case NoAuth
    case AuthPendingUser
    case AuthPendingData
    case Auth
    case Kick
    case Failed
}

class Model : NSObject, NetworkListener, NSCoding {
    
    private static let MOTD_KEY = "key_Model.motd"
    private static let PIC_KEY = "key_Model.pic"
    private static let USER_KEY = "key_Model.user"
    private static let WORK_KEY = "key_Model.work"
    private static let TIMETABLE_KEY = "key_Model.timetable"
    
    private static var model: Model!
    
    static func loadOrInit() -> Model {
        let persistentStore: PersistentStore = PersistentStoreImpl()
        model = persistentStore.loadOrCreateModel()
        return model
    }
    
    static func get() -> Model {
        return model
    }
    
    private let persistentStore: PersistentStore
    var network: Network<Model>!
    
    let stateMachine: StateMachine<ModelState>
    let pubSub: PubSub<ModelListener>
    
    var ownStateListener: StateListener<ModelState>!
    
    var motd: String? {
        didSet {
            if let motd = motd {
                pubSub.publish({ l in
                    l.onMotdReceived?(motd)
                })
            }
        }
    }
    var pic: NSData? {
        willSet {
            if auth != nil {
                self.pic = newValue
            }
        }
        didSet {
            if let pic = self.pic {
                pubSub.publish({ l in
                    l.onPicReceived?(pic)
                })
            }
        }
    }
    var auth: Auth?
    var user: User? {
        didSet {
            guard user != nil else {
                return
            }
            pubSub.publish({ [unowned self] l in
                l.onUserChanged?(self.user)
            })
        }
    }
    var work: Work? {
        didSet {
            guard work != nil else {
                return
            }
            self.work!.addSubjectReferences()
            pubSub.publish({ [unowned self] l in
                l.onWorkChanged?(self.work)
            })
            if let timetable = self.timetable {
                timetable.addSubjectReferences(self.work!)
            }
        }
    }
    var timetable: Timetable? {
        didSet {
            guard timetable != nil else {
                return
            }
            if let work = self.work {
                self.timetable!.addSubjectReferences(work)
                pubSub.publish({ [unowned self] l in
                    l.onTimetableChanged?(self.timetable)
                })
            }
        }
    }
    
    convenience init(persistentStore: PersistentStore) {
        self.init(persistentStore: persistentStore, auth: nil, user: nil, work: nil, timetable: nil, motd: nil, pic: nil)
    }
    
    init(persistentStore: PersistentStore, auth: Auth?, user: User?, work: Work?, timetable: Timetable?, motd: String?, pic: NSData?) {
        self.persistentStore = persistentStore;
        self.auth = auth
        self.user = user
        self.work = work
        self.timetable = timetable
        self.motd = motd
        self.pic = pic
        let initial: ModelState
        if auth == nil {
            initial = .NoAuth
            assert(user == nil && work == nil && timetable == nil)
        } else if user == nil {
            initial = .AuthPendingUser
            assert(work == nil && timetable == nil)
        } else if (work == nil) != (timetable == nil) {
            initial = .AuthPendingData
        } else {
            initial = .Auth
        }
        pubSub = PubSub<ModelListener>()
        stateMachine = StateMachine<ModelState>(state: initial)
        super.init()
        ownStateListener = StateListener<ModelState>(onStateChanged: { [unowned self] (from, to) in
            switch to {
            case .Failed:
                self.stateMachine.state = .NoAuth
            default:
                break
            }
        })
        stateMachine.listen(ownStateListener)
    }
    
    deinit {
        stateMachine.unlisten(ownStateListener)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let auth: Auth?
        if let savedSession: [String: AnyObject] = Locksmith.loadDataForUserAccount("savedSession") {
            auth = Auth(username: savedSession["username"] as! String, password: savedSession["password"] as! String)
        } else {
            auth = nil
        }
        let user: User? = (aDecoder.decodeObjectForKey(Model.USER_KEY) as! UserPersistable?)?.toUser()
        let work: Work? = (aDecoder.decodeObjectForKey(Model.WORK_KEY) as! WorkPersistable?)?.toWork()
        let timetable: Timetable? = (aDecoder.decodeObjectForKey(Model.TIMETABLE_KEY) as! TimetablePersistable?)?.toTimetable(work!.subjectIdMap)
        let motd: String? = aDecoder.decodeObjectForKey(Model.MOTD_KEY) as! String?
        let pic: NSData? = aDecoder.decodeObjectForKey(Model.PIC_KEY) as! NSData?
        self.init(persistentStore: PersistentStoreImpl(), auth: auth, user: user, work: work, timetable: timetable, motd: motd, pic: pic)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        if let auth: Auth = self.auth {
            _ = try? Locksmith.deleteDataForUserAccount("savedSession")
            try! Locksmith.saveData(["username": auth.username, "password": auth.password], forUserAccount: "savedSession")
        } else {
            _ = try? Locksmith.deleteDataForUserAccount("savedSession")
        }
        let work = self.work?.toPersistable()
        aCoder.encodeObject(user?.toPersistable(), forKey: Model.USER_KEY)
        aCoder.encodeObject(work, forKey: Model.WORK_KEY)
        aCoder.encodeObject(timetable?.toPersistable(work!.subjectIdMap), forKey: Model.TIMETABLE_KEY)
        aCoder.encodeObject(motd, forKey: Model.MOTD_KEY)
        aCoder.encodeObject(pic, forKey: Model.PIC_KEY)
    }
    
    func authIfNeeded() {
        if let _ = self.auth {
            network.connect()
        }
    }
    
    func saveToPersistentStore() {
        persistentStore.saveModel(self)
    }
    
    func listen(listener: ModelListener) {
        listener.onUserChanged?(user)
        listener.onWorkChanged?(work)
        listener.onTimetableChanged?(timetable)
        listener.onPicReceived?(pic)
        listener.onMotdReceived?(motd)
        pubSub.add(listener)
    }
    
    // MARK: NetworkListener
    
    func onConnect() {
        if (stateMachine.state == .AuthPendingUser) || stateMachine.state == .Auth && auth != nil {
            network?.auth(auth!)
        }
    }
    
    func onDisconnect() {
        
    }
    
    func onConnectTimeout() {
        doLogout()
    }
    
    func onAuthSuccess(user: User) {
        self.user = user
        if stateMachine.state == .AuthPendingUser {
            stateMachine.state = .AuthPendingData
        }
    }
    
    func onAuthLoginFailed() {
        auth = nil
        stateMachine.state = .Failed
    }
    
    func onAuthKick() {
        self.auth = nil
        self.user = nil
        stateMachine.state = .Kick
    }
    
    func onUpdateWork(work: Work) {
        assert(stateMachine.state == .AuthPendingData || stateMachine.state == .Auth)
        self.work = work
        if (timetable != nil) {
            stateMachine.state = .Auth
        }
    }
    
    func onUpdateTimetable(timetable: Timetable) {
        assert(stateMachine.state == .AuthPendingData || stateMachine.state == .Auth)
        self.timetable = timetable
        if (work != nil) {
            stateMachine.state = .Auth
        }
    }
    
    // MARK: actions
    
    func doLogin(username: String, password: String) {
        assert(stateMachine.state == .NoAuth)
        network.connect()
        let auth = Auth(username: username, password: password)
        self.auth = auth
        stateMachine.state = .AuthPendingUser
    }
    
    func doLogout() {
        network.deauth()
        network.disconnect()
        motd = nil
        pic = nil
        auth = nil
        user = nil
        work = nil
        timetable = nil
        stateMachine.state = .NoAuth
        saveToPersistentStore()
    }
    
}

class ModelListener: Listener {
    
    let onUserChanged: ((User?) -> ())?
    let onWorkChanged: ((Work?) -> ())?
    let onTimetableChanged: ((Timetable?) -> ())?
    let onPicReceived: ((NSData?) -> ())?
    let onMotdReceived: ((String?) -> ())?
    
    init(onUserChanged: ((User?) -> ())?, onWorkChanged: ((Work?) -> ())?, onTimetableChanged: ((Timetable?) -> ())?, onPicReceived: ((NSData?) -> ())?, onMotdReceived: ((String?) -> ())?) {
        self.onUserChanged = onUserChanged
        self.onWorkChanged = onWorkChanged
        self.onTimetableChanged = onTimetableChanged
        self.onPicReceived = onPicReceived
        self.onMotdReceived = onMotdReceived
    }
    
    var hashValue: Int {
        return Int(ObjectIdentifier(self).uintValue)
    }
    
}
