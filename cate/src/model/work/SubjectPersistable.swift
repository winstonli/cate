//
//  SubjectPersistable.swift
//  cate
//
//  Created by Winston Li on 31/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class SubjectPersistable: NSObject, NSCoding {
    
    private static let id: String = "Subject.id"
    private static let name: String = "Subject.name"
    private static let notes: String = "Subject.notes"
    private static let tutorials: String = "Subject.tutorials"
    
    let id: String
    let name: String
    let notes: [NotePersistable]
    let tutorials: [TutorialPersistable]
    
    init(id: String, name: String, notes: [NotePersistable], tutorials: [TutorialPersistable]) {
        self.id = id
        self.name = name
        self.notes = notes
        self.tutorials = tutorials
    }
    
    convenience init(subject: Subject) {
        let id = subject.id
        let name = subject.name
        let notes = subject.notes.map({ note in
            NotePersistable(note: note)
        })
        let tutorials = subject.tutorials.map({ tutorial in
            TutorialPersistable(tutorial: tutorial)
        })
        self.init(
            id: id,
            name: name,
            notes: notes,
            tutorials: tutorials
        )
        self.notes.forEach({ note in
            note.subject = self
        })
        self.tutorials.forEach({ tutorial in
            tutorial.subject = self
        })
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey(SubjectPersistable.id) as! String
        let name = aDecoder.decodeObjectForKey(SubjectPersistable.name) as! String
        let notes = aDecoder.decodeObjectForKey(SubjectPersistable.notes) as! [NotePersistable]
        let tutorials = aDecoder.decodeObjectForKey(SubjectPersistable.tutorials) as! [TutorialPersistable]
        self.init(
            id: id,
            name: name,
            notes: notes,
            tutorials: tutorials
        )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: SubjectPersistable.id)
        aCoder.encodeObject(name, forKey: SubjectPersistable.name)
        aCoder.encodeObject(notes, forKey: SubjectPersistable.notes)
        aCoder.encodeObject(tutorials, forKey: SubjectPersistable.tutorials)
    }
    
    func toSubject() -> Subject {
        let id = self.id
        let name = self.name
        let notes = self.notes.map({ note in
            note.toNote()
        })
        let tutorials = self.tutorials.map({ tutorial in
            tutorial.toTutorial()
        })
        let subject = Subject(
            id: id,
            name: name,
            notes: notes,
            tutorials: tutorials
        )
        notes.forEach({ note in
            note.subject = subject
        })
        tutorials.forEach({ tutorial in
            tutorial.subject = subject
        })
        return subject
    }

}
