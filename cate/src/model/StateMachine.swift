//
//  StateMachine.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class StateMachine<T> {
    
    private let pubSub: PubSub<StateListener<T>>
    
    var state: T {
        didSet {
            pubSub.publish({ [unowned self] l in
                l.onStateChanged(oldValue, self.state)
            })
        }
    }
    
    init(state: T) {
        pubSub = PubSub<StateListener<T>>()
        self.state = state
    }
    
    func listen(listener: StateListener<T>) {
        forcePublish(listener)
        listenWithoutCall(listener)
    }
    
    func listenWithoutCall(listener: StateListener<T>) {
        pubSub.add(listener)
    }
    
    func forcePublish(listener: StateListener<T>) {
        listener.onStateChanged(nil, state)
    }
    
    func unlisten(listener: StateListener<T>) {
        pubSub.remove(listener)
    }
    
}

class StateListener<T>: Listener {
    
    var onStateChanged: (T?, T) -> ()?
    
    var hashValue: Int {
        return Int(ObjectIdentifier(self).uintValue)
    }
    
    init(onStateChanged: (T?, T) -> ()) {
        self.onStateChanged = onStateChanged
    }
    
}
