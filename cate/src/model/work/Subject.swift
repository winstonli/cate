//
//  Subject.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

class Subject: EVObject {
    
    var id: String!
    var name: String!
    var notes: [Note]!
    var tutorials: [Tutorial]!
    
    required init() {
        super.init()
    }
    
    init(id: String, name: String, notes: [Note], tutorials: [Tutorial]) {
        self.id = id
        self.name = name
        self.notes = notes
        self.tutorials = tutorials
    }
    
    func numNotesWithLink() -> Int {
        return notes.filter({ note in
            note.specLink != nil
        }).count
    }
    
}
