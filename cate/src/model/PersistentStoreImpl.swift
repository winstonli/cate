//
//  PersistentStoreImpl.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class PersistentStoreImpl : PersistentStore {
    
    static let appSupportDir = NSFileManager().URLsForDirectory(.ApplicationSupportDirectory, inDomains: .UserDomainMask).first!
    static let storePath = appSupportDir.URLByAppendingPathComponent("modelv0").path!
    
    func loadOrCreateModel() -> Model {
        if let model: Model = NSKeyedUnarchiver.unarchiveObjectWithFile(PersistentStoreImpl.storePath) as? Model {
            return model
        }
        let _ = try? NSFileManager().createDirectoryAtURL(PersistentStoreImpl.appSupportDir, withIntermediateDirectories: false, attributes: nil)
        let model: Model = Model(persistentStore: self)
        return model
    }
    
    func saveModel(model: Model) {
        NSKeyedArchiver.archiveRootObject(model, toFile: PersistentStoreImpl.storePath)
    }
    
}
