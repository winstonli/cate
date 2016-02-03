//
//  PersistentStoreFake.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class PersistentStoreFake : PersistentStore {

    func loadOrCreateModel() -> Model {
        fatalError("unimplemented")
    }
    
    func saveModel(model: Model) {
        
    }
    
}
