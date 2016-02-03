//
//  Work.swift
//  cate
//
//  Created by Winston Li on 22/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

class Work: EVObject {
    
    var subjects: [Subject]!
    var deadlines: [Deadline]!
    var upcoming: [Upcoming]!
    var firstDayOfTerm: NSDate!
    
    private(set) var subjectIdMap: [String: Subject] = [:]
    
    init(subjects: [Subject], deadlines: [Deadline], upcoming: [Upcoming], firstDayOfTerm: NSDate, subjectIdMap: [String: Subject]) {
        self.subjects = subjects
        self.deadlines = deadlines
        self.upcoming = upcoming
        self.firstDayOfTerm = firstDayOfTerm
        self.subjectIdMap = subjectIdMap
    }
    
    required init() {
        super.init()
    }
    
    func addSubjectReferences() {
        subjects.forEach({ subject in
            subjectIdMap[subject.id] = subject
            subject.notes.forEach({ note in
                note.subject = subject
            })
            subject.tutorials.forEach({ tutorial in
                tutorial.subject = subject
            })
        })
        deadlines.forEach({ deadline in
            deadline.subject = subjectIdMap[deadline.subjectId]
        })
        upcoming.forEach({ upcoming in
            upcoming.subject = subjectIdMap[upcoming.subjectId]
        })
    }
    
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if key != "subjectIdMap" {
            super.setValue(value, forUndefinedKey: key)
        }
    }
    
    func toPersistable() -> WorkPersistable {
        return WorkPersistable(work: self)
    }
    
}
