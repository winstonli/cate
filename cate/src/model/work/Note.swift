//
//  Note.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

class Note: EVObject {
    
    var sequence: Int = -1
    var specName: String!
    var specLink: String?
    var fileType: String!
    var size: Int64 = -1
    var loaded: NSDate!
    var owner: String!
    var hits: Int = -1
    
    var subject: Subject?
    
    required init() {
        super.init()
    }
    
    init(sequence: Int,
         specName: String,
         specLink: String?,
         fileType: String,
         size: Int64,
         loaded: NSDate,
         owner: String,
         hits: Int,
         subject: Subject?) {
            
        self.sequence = sequence
        self.specName = specName
        self.specLink = specLink
        self.fileType = fileType
        self.size = size
        self.loaded = loaded
        self.owner = owner
        self.hits = hits
        self.subject = subject
            
    }
    
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if key != "subject" {
            super.setValue(value, forUndefinedKey: key)
        }
    }
    
    func createResource() -> Resource {
        return Resource(name: specName, subjectName: subject!.name, url: specLink!, fileType: fileType)
    }
    
}
