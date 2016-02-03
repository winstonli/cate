//
//  NotePersistable.swift
//  cate
//
//  Created by Winston Li on 31/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class NotePersistable: NSObject, NSCoding {
    
    private static let sequence = "Note.sequence"
    private static let specName = "Note.specName"
    private static let specLink = "Note.specLink"
    private static let fileType = "Note.fileType"
    private static let size = "Note.size"
    private static let loaded = "Note.loaded"
    private static let owner = "Note.owner"
    private static let hits = "Note.hits"
    private static let subject = "Note.subject"
    
    let sequence: Int
    let specName: String
    let specLink: String?
    let fileType: String
    let size: Int64
    let loaded: NSDate
    let owner: String
    let hits: Int
    
    var subject: SubjectPersistable!
    
    init(sequence: Int, specName: String, specLink: String?, fileType: String, size: Int64, loaded: NSDate, owner: String, hits: Int, subject: SubjectPersistable?) {
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
    
    convenience init(note: Note) {
        let sequence = note.sequence
        let specName = note.specName
        let specLink = note.specLink
        let fileType = note.fileType
        let size = note.size
        let loaded = note.loaded
        let owner = note.owner
        let hits = note.hits
        self.init(
            sequence: sequence,
            specName: specName,
            specLink: specLink,
            fileType: fileType,
            size: size,
            loaded: loaded,
            owner: owner,
            hits: hits,
            subject: nil
        )
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let sequence = aDecoder.decodeIntegerForKey(NotePersistable.sequence)
        let specName = aDecoder.decodeObjectForKey(NotePersistable.specName) as! String
        let specLink = aDecoder.decodeObjectForKey(NotePersistable.specLink) as! String?
        let fileType = aDecoder.decodeObjectForKey(NotePersistable.fileType) as! String
        let size = aDecoder.decodeInt64ForKey(NotePersistable.size)
        let loaded = aDecoder.decodeObjectForKey(NotePersistable.loaded) as! NSDate
        let owner = aDecoder.decodeObjectForKey(NotePersistable.owner) as! String
        let hits = aDecoder.decodeIntegerForKey(NotePersistable.hits)
        let subject = aDecoder.decodeObjectForKey(NotePersistable.subject) as! SubjectPersistable
        self.init(
            sequence: sequence,
            specName: specName,
            specLink: specLink,
            fileType: fileType,
            size: size,
            loaded: loaded,
            owner: owner,
            hits: hits,
            subject: subject
        )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(sequence, forKey: NotePersistable.sequence)
        aCoder.encodeObject(specName, forKey: NotePersistable.specName)
        aCoder.encodeObject(specLink, forKey: NotePersistable.specLink)
        aCoder.encodeObject(fileType, forKey: NotePersistable.fileType)
        aCoder.encodeInt64(size, forKey: NotePersistable.size)
        aCoder.encodeObject(loaded, forKey: NotePersistable.loaded)
        aCoder.encodeObject(owner, forKey: NotePersistable.owner)
        aCoder.encodeInteger(hits, forKey: NotePersistable.hits)
        aCoder.encodeObject(subject, forKey: NotePersistable.subject)
    }
    
    func toNote() -> Note {
        let sequence = self.sequence
        let specName = self.specName
        let specLink = self.specLink
        let fileType = self.fileType
        let size = self.size
        let loaded = self.loaded
        let owner = self.owner
        let hits = self.hits
        let subject: Subject? = nil
        return Note(sequence: sequence,
             specName: specName,
             specLink: specLink,
             fileType: fileType,
             size: size,
             loaded: loaded,
             owner: owner,
             hits: hits,
             subject: subject
        )
    }
    
}
