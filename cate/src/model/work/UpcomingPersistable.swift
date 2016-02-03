//
//  UpcomingPersistable.swift
//  cate
//
//  Created by Winston Li on 31/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class UpcomingPersistable: NSObject, NSCoding {
    
    private static let sequence: String = "Upcoming.sequence"
    private static let name = "Upcoming.name"
    private static let category = "Upcoming.category"
    private static let type = "Upcoming.type"
    private static let startTime = "Upcoming.startTime"
    private static let subject = "Upcoming.subject"
    
    let sequence: Int
    let name: String
    let category: String
    let type: ExerciseType
    let startTime: NSDate
    
    let subject: SubjectPersistable
    
    init(sequence: Int, name: String, category: String, type: ExerciseType, startTime: NSDate, subject: SubjectPersistable) {
        self.sequence = sequence
        self.name = name
        self.category = category
        self.type = type
        self.startTime = startTime
        self.subject = subject
    }
    
    convenience init(upcoming: Upcoming, subjectIdMap: [String: SubjectPersistable]) {
        let sequence = upcoming.sequence
        let name = upcoming.name
        let category = upcoming.category
        let type = upcoming.type
        let startTime = upcoming.startTime
        let subject = subjectIdMap[upcoming.subjectId]!
        self.init(
            sequence: sequence,
            name: name,
            category: category,
            type: type,
            startTime: startTime,
            subject: subject
        )
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let sequence = aDecoder.decodeIntegerForKey(UpcomingPersistable.sequence)
        let name = aDecoder.decodeObjectForKey(UpcomingPersistable.name) as! String
        let category = aDecoder.decodeObjectForKey(UpcomingPersistable.category) as! String
        let type = ExerciseType(rawValue: aDecoder.decodeObjectForKey(UpcomingPersistable.type) as! String)!
        let startTime = aDecoder.decodeObjectForKey(UpcomingPersistable.startTime) as! NSDate
        let subject = aDecoder.decodeObjectForKey(UpcomingPersistable.subject) as! SubjectPersistable
        self.init(
            sequence: sequence,
            name: name,
            category: category,
            type: type,
            startTime: startTime,
            subject: subject
        )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(sequence, forKey: UpcomingPersistable.sequence)
        aCoder.encodeObject(name, forKey: UpcomingPersistable.name)
        aCoder.encodeObject(category, forKey: UpcomingPersistable.category)
        aCoder.encodeObject(type.rawValue, forKey: UpcomingPersistable.type)
        aCoder.encodeObject(startTime, forKey: UpcomingPersistable.startTime)
        aCoder.encodeObject(subject, forKey: UpcomingPersistable.subject)
    }
    
    func toUpcoming(subjectIdMap: [String: Subject]) -> Upcoming {
        let sequence = self.sequence
        let name = self.name
        let category = self.category
        let type = self.type
        let startTime = self.startTime
        let subject = subjectIdMap[self.subject.id]!
        return Upcoming(
            subjectId: subject.id,
            sequence: sequence,
            name: name,
            category: category,
            type: type,
            startTime: startTime,
            subject: subject
        )
    }
    
}
