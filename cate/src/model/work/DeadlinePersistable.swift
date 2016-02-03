//
//  DeadlinePersistable.swift
//  cate
//
//  Created by Winston Li on 31/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class DeadlinePersistable: NSObject, NSCoding {
    
    private static let sequence: String = "Deadline.sequence"
    private static let name: String = "Deadline.name"
    private static let category: String = "Deadline.category"
    private static let type: String = "Deadline.type"
    private static let startTime: String = "Deadline.startTime"
    private static let dueTime: String = "Deadline.dueTime"
    private static let submitted: String = "Deadline.submitted"
    private static let specUrl: String = "Deadline.specUrl"
    private static let subject: String = "Deadline.subject"
    
    let sequence: Int
    let name: String
    let category: String
    let type: ExerciseType
    let startTime: NSDate
    let dueTime: NSDate
    let submitted: Bool
    let specUrl: String?
    
    var subject: SubjectPersistable
    
    init(sequence: Int,
         name: String,
         category: String,
         type: ExerciseType,
         startTime: NSDate,
         dueTime: NSDate,
         submitted: Bool,
         specUrl: String?,
         subject: SubjectPersistable) {
        
        self.sequence = sequence
        self.name = name
        self.category = category
        self.type = type
        self.startTime = startTime
        self.dueTime = dueTime
        self.submitted = submitted
        self.specUrl = specUrl
        self.subject = subject
    }
    
    convenience init(deadline: Deadline, subjectIdMap: [String: SubjectPersistable]) {
        let sequence = deadline.sequence
        let name = deadline.name
        let category = deadline.category
        let type = deadline.type
        let startTime = deadline.startTime
        let dueTime = deadline.dueTime
        let submitted = deadline.submitted
        let specUrl = deadline.specUrl
        let subject = subjectIdMap[deadline.subjectId]!
        self.init(
            sequence: sequence,
            name: name,
            category: category,
            type: type,
            startTime: startTime,
            dueTime: dueTime,
            submitted: submitted,
            specUrl: specUrl,
            subject: subject
        )
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let sequence = aDecoder.decodeIntegerForKey(DeadlinePersistable.sequence)
        let name = aDecoder.decodeObjectForKey(DeadlinePersistable.name) as! String
        let category = aDecoder.decodeObjectForKey(DeadlinePersistable.category) as! String
        let type = ExerciseType(rawValue: (aDecoder.decodeObjectForKey(DeadlinePersistable.type) as! String))!
        let startTime = aDecoder.decodeObjectForKey(DeadlinePersistable.startTime) as! NSDate
        let dueTime = aDecoder.decodeObjectForKey(DeadlinePersistable.dueTime) as! NSDate
        let submitted = aDecoder.decodeBoolForKey(DeadlinePersistable.submitted)
        let specUrl = aDecoder.decodeObjectForKey(DeadlinePersistable.specUrl) as! String?
        let subject = aDecoder.decodeObjectForKey(DeadlinePersistable.subject) as! SubjectPersistable
        self.init(
            sequence: sequence,
            name: name,
            category: category,
            type: type,
            startTime: startTime,
            dueTime: dueTime,
            submitted: submitted,
            specUrl: specUrl,
            subject: subject
        )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(sequence, forKey: DeadlinePersistable.sequence)
        aCoder.encodeObject(name, forKey: DeadlinePersistable.name)
        aCoder.encodeObject(category, forKey: DeadlinePersistable.category)
        aCoder.encodeObject(type.rawValue, forKey: DeadlinePersistable.type)
        aCoder.encodeObject(startTime, forKey: DeadlinePersistable.startTime)
        aCoder.encodeObject(dueTime, forKey: DeadlinePersistable.dueTime)
        aCoder.encodeBool(submitted, forKey: DeadlinePersistable.submitted)
        aCoder.encodeObject(specUrl, forKey: DeadlinePersistable.specUrl)
        aCoder.encodeObject(subject, forKey: DeadlinePersistable.subject)
    }
    
    func toDeadline(subjectIdMap: [String: Subject]) -> Deadline {
        let subjectId = self.subject.id
        let sequence = self.sequence
        let name = self.name
        let category = self.category
        let type = self.type
        let startTime = self.startTime
        let dueTime = self.dueTime
        let submitted = self.submitted
        let specUrl = self.specUrl
        let subject = subjectIdMap[subjectId]!
        return Deadline(subjectId: subjectId,
            sequence: sequence,
            name: name,
            category: category,
            type: type,
            startTime: startTime,
            dueTime: dueTime,
            submitted: submitted,
            specUrl: specUrl,
            subject: subject
        )
    }
    
}
