//
//  NetworkListenerImpl.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

protocol NetworkListener: class, Listener {
    
    func onConnect()
    
    func onDisconnect()
    
    func onAuthSuccess(user: User)
    
    func onAuthLoginFailed()
    
    func onAuthKick()
    
    func onUpdateTimetable(timetable: Timetable)
    
    func onUpdateWork(work: Work)
    
    func onConnectTimeout()
    
}
