//
//  WorkPersistable.swift
//  cate
//
//  Created by Winston Li on 31/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class WorkPersistable: NSObject, NSCoding {
    
    private static let subjects: String = "Work.subjects"
    private static let deadlines: String = "Work.deadlines"
    private static let upcoming: String = "Work.upcoming"
    private static let firstDayOfTerm: String = "Work.firstDayOfTerm"
    private static let subjectIdMap: String = "Work.subjectIdMap"
    
    private let subjects: [SubjectPersistable]
    private let deadlines: [DeadlinePersistable]
    private let upcoming: [UpcomingPersistable]
    private let firstDayOfTerm: NSDate
    
    let subjectIdMap: [String: SubjectPersistable]
    
    init(subjects: [SubjectPersistable], deadlines: [DeadlinePersistable], upcoming: [UpcomingPersistable], firstDayOfTerm: NSDate, subjectIdMap: [String: SubjectPersistable]) {
        self.subjects = subjects
        self.deadlines = deadlines
        self.upcoming = upcoming
        self.firstDayOfTerm = firstDayOfTerm
        self.subjectIdMap = subjectIdMap
    }
    
    convenience init(work: Work) {
        let subjects = work.subjects.map({ subject in
            SubjectPersistable(subject: subject)
        })
        var subjectIdMap: [String: SubjectPersistable] = [:]
        subjects.forEach({ subject in
            subjectIdMap[subject.id] = subject
        })
        let deadlines = work.deadlines.map({ deadline in
            DeadlinePersistable(deadline: deadline, subjectIdMap: subjectIdMap)
        })
        let upcoming = work.upcoming.map({ upcoming in
            UpcomingPersistable(upcoming: upcoming, subjectIdMap: subjectIdMap)
        })
        let firstDayOfTerm = work.firstDayOfTerm
        self.init(subjects: subjects, deadlines: deadlines, upcoming: upcoming, firstDayOfTerm: firstDayOfTerm, subjectIdMap: subjectIdMap)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let subjects = aDecoder.decodeObjectForKey(WorkPersistable.subjects) as! [SubjectPersistable]
        let deadlines = aDecoder.decodeObjectForKey(WorkPersistable.deadlines) as! [DeadlinePersistable]
        let upcoming = aDecoder.decodeObjectForKey(WorkPersistable.upcoming) as! [UpcomingPersistable]
        let firstDayOfTerm = aDecoder.decodeObjectForKey(WorkPersistable.firstDayOfTerm) as! NSDate
        let subjectIdMap = aDecoder.decodeObjectForKey(WorkPersistable.subjectIdMap) as! [String: SubjectPersistable]
        self.init(
            subjects: subjects,
            deadlines: deadlines,
            upcoming: upcoming,
            firstDayOfTerm: firstDayOfTerm,
            subjectIdMap: subjectIdMap
        )
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(subjects, forKey: WorkPersistable.subjects)
        aCoder.encodeObject(deadlines, forKey: WorkPersistable.deadlines)
        aCoder.encodeObject(upcoming, forKey: WorkPersistable.upcoming)
        aCoder.encodeObject(firstDayOfTerm, forKey: WorkPersistable.firstDayOfTerm)
        aCoder.encodeObject(subjectIdMap, forKey: WorkPersistable.subjectIdMap)
    }
    
    func toWork() -> Work {
        let subjects = self.subjects.map({ subject in
            subject.toSubject()
        })
        var subjectIdMap: [String: Subject] = [:]
        subjects.forEach({ subject in
            subjectIdMap[subject.id] = subject
        })
        let deadlines = self.deadlines.map({ deadline in
            deadline.toDeadline(subjectIdMap)
        })
        let upcoming = self.upcoming.map({ upcoming in
            upcoming.toUpcoming(subjectIdMap)
        })
        let firstDayOfTerm = self.firstDayOfTerm
        return Work(
            subjects: subjects,
            deadlines: deadlines,
            upcoming: upcoming,
            firstDayOfTerm: firstDayOfTerm,
            subjectIdMap: subjectIdMap
        )
    }
    
}
