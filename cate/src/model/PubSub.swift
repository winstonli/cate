//
//  NetworkListener.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class PubSub<T: Listener> {
    
    private var listeners: Set<T> = []
    
    func add(listener: T) {
        listeners.insert(listener)
    }
    
    func remove(listener: T) {
        listeners.remove(listener)
    }
    
    func publish(msg: (T) -> ()) {
        listeners.forEach(msg)
    }
    
}

protocol Listener: class, Hashable {
    
}

func ==<T: Listener>(lhs: T, rhs: T) -> Bool {
    return lhs === rhs
}
