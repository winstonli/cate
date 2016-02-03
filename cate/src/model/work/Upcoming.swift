//
//  Upcoming.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

class Upcoming: EVObject {
    
    var subjectId: String!
    var sequence: Int = -1
    var name: String!
    var category: String!
    var type: ExerciseType!
    var startTime: NSDate!
    
    var subject: Subject?
    
    required init() {
        super.init()
    }
    
    init(subjectId: String, sequence: Int, name: String, category: String, type: ExerciseType, startTime: NSDate, subject: Subject) {
        self.subjectId = subjectId
        self.sequence = sequence
        self.name = name
        self.category = category
        self.type = type
        self.startTime = startTime
        self.subject = subject
    }
    
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if key == "type" {
            type = ExerciseType(rawValue: value as! String)!
        } else if key != "subject" {
            super.setValue(value, forUndefinedKey: key)
        }
    }
    
    func timeRemainingAsString() -> String {
        return NSDate().offsetAsString(startTime, ifPassedDate: "Now")
    }
    
}
