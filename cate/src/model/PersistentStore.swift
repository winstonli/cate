//
//  PersistentStore.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

protocol PersistentStore {
    
    func loadOrCreateModel() -> Model
    func saveModel(model: Model)
    
}
