//
//  Tutorial.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

class Tutorial: EVObject {
    
    var sequence: Int = -1
    var name: String!
    var category: String!
    var specUrl: String?
    
    var subject: Subject?
    
    required init() {
        super.init()
    }
    
    init(sequence: Int, name: String, category: String, specUrl: String?, subject: Subject?) {
        self.sequence = sequence
        self.name = name
        self.category = category
        self.specUrl = specUrl
        self.subject = subject
    }
    
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if key != "subject" {
            super.setValue(value, forUndefinedKey: key)
        }
    }
    
    func createResource() -> Resource {
        return Resource(name: name, subjectName: subject!.name, url: specUrl!)
    }
    
}
