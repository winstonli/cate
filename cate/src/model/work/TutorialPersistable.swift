//
//  TutorialPersistable.swift
//  cate
//
//  Created by Winston Li on 31/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class TutorialPersistable: NSObject, NSCoding {
    
    private static let sequence = "Tutorial.sequence"
    private static let name = "Tutorial.name"
    private static let category = "Tutorial.category"
    private static let specUrl = "Tutorial.specUrl"
    private static let subject = "Tutorial.subject"
    
    let sequence: Int
    let name: String
    let category: String
    let specUrl: String?
    
    var subject: SubjectPersistable!
    
    init(sequence: Int, name: String, category: String, specUrl: String?, subject: SubjectPersistable?) {
        self.sequence = sequence
        self.name = name
        self.category = category
        self.specUrl = specUrl
        self.subject = subject
    }
    
    convenience init(tutorial: Tutorial) {
        let sequence = tutorial.sequence
        let name = tutorial.name
        let category = tutorial.category
        let specUrl = tutorial.specUrl
        let subject: SubjectPersistable? = nil
        self.init(
            sequence: sequence,
            name: name,
            category: category,
            specUrl: specUrl,
            subject: subject
        )
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let sequence = aDecoder.decodeIntegerForKey(TutorialPersistable.sequence)
        let name = aDecoder.decodeObjectForKey(TutorialPersistable.name) as! String
        let category = aDecoder.decodeObjectForKey(TutorialPersistable.category) as! String
        let specUrl = aDecoder.decodeObjectForKey(TutorialPersistable.specUrl) as! String?
        let subject = aDecoder.decodeObjectForKey(TutorialPersistable.subject) as! SubjectPersistable
        self.init(
            sequence: sequence,
            name: name,
            category: category,
            specUrl: specUrl,
            subject: subject
        )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(sequence, forKey: TutorialPersistable.sequence)
        aCoder.encodeObject(name, forKey: TutorialPersistable.name)
        aCoder.encodeObject(category, forKey: TutorialPersistable.category)
        aCoder.encodeObject(specUrl, forKey: TutorialPersistable.specUrl)
        aCoder.encodeObject(subject, forKey: TutorialPersistable.subject)
    }
    
    func toTutorial() -> Tutorial {
        let sequence = self.sequence
        let name = self.name
        let category = self.category
        let specUrl = self.specUrl
        let subject: Subject? = nil
        return Tutorial(
            sequence: sequence,
            name: name,
            category: category,
            specUrl: specUrl,
            subject: subject
        )
    }
    
}
