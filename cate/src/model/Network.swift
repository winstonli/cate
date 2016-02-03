//
//  Network.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import Alamofire
import EVReflection
import SocketIOClientSwift

let NETWORK_url: String = "https://winston.li:1338"
let NETWORK_namespace: String = "/app/cate/api/v0"

class Network<T: NetworkListener> {
    
    private var socketIO: SocketIOClient?

    let pubSub: PubSub<T>
    
    init() {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        EVReflection.setDateFormatter(dateFormatter)
        self.pubSub = PubSub<T>()
    }
    
    func connect() {
        self.socketIO?.disconnect()
        let socketIO = SocketIOClient(socketURL: NETWORK_url, options: [.Nsp(NETWORK_namespace), .ForceWebsockets(true), .Log(false), .Secure(true)])
        self.socketIO = socketIO
        socketIO.on("connect", callback: { [weak self] (objs, ack) in
            Log.info("connect")
            self?.pubSub.publish({ l in
                l.onConnect()
            })
        })
        socketIO.on("disconnect", callback: { [weak self] (objs, ack) in
            Log.info("disconnect")
            self?.pubSub.publish({ l in
                l.onDisconnect()
            })
        })
        socketIO.on("authSuccess", callback: { [weak self] (objs, ack) in
            Log.info("authSuccess")
            let user: User = User(dictionary: objs[0] as! NSDictionary)
            self?.pubSub.publish({ l in
                if let picUrl = user.picUrl {
                    self?.getPic(picUrl)
                }
                l.onAuthSuccess(user)
            })
        })
        socketIO.on("authLoginFailed", callback: { [weak self] (objs, ack) in
            Log.info("authLoginFailed")
            self?.pubSub.publish({ l in
                l.onAuthLoginFailed()
            })
        })
        socketIO.on("authKick", callback: { [weak self] (objs, ack) in
            Log.info("authKick")
            self?.pubSub.publish({ l in
                l.onAuthKick()
            })
        })
        socketIO.on("updateWork", callback: { [weak self] (objs, ack) in
            Log.info("updateWork")
            let work: Work = Work(dictionary: objs.first as! NSDictionary)
            self?.pubSub.publish({ l in
                l.onUpdateWork(work)
            })
        })
        socketIO.on("updateTimetable", callback: { [weak self] (objs, ack) in
            Log.info("updateTimetable")
            let timetable: Timetable = Timetable(dictionary: objs.first as! NSDictionary)
            self?.pubSub.publish({ l in
                l.onUpdateTimetable(timetable)
            })
        })
        socketIO.on("motd", callback: { (objs, ack) in
            Log.info("motd")
            Model.get().motd = objs[0] as? String
        })
        socketIO.connect()
    }
    
    func disconnect() {
        if let socketIO = self.socketIO {
            socketIO.disconnect()
            socketIO.removeAllHandlers()
            self.socketIO = nil
        }
    }
    
    func auth(auth: Auth) {
        socketIO?.emit("auth", auth.toDictionary())
    }
    
    func delay(millis: Int64, call: () -> ()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, millis * Int64(NSEC_PER_MSEC)), dispatch_get_main_queue(), call)
    }
    
    func deauth() {
        socketIO?.emit("deauth")
    }
    
    func getPic(url: String) {
        if let auth = Model.get().auth {
            Alamofire.request(.GET, url).authenticate(user: auth.username, password: auth.password).validate().responseData({ [weak self] response in
                guard response.result.error == nil && response.result.isSuccess && response.result.value != nil else {
                    self?.getPic(url)
                    return
                }
                let data = response.result.value!
                Model.get().pic = data
            })
        }
    }
    
}
