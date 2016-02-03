//
//  EventPersistable.swift
//  cate
//
//  Created by Winston Li on 31/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class EventPersistable: NSObject, NSCoding {
    
    private static let day = "Event.day"
    private static let subjectId = "Event.subjectId"
    private static let subjectName = "Event.subjectName"
    private static let type = "Event.type"
    private static let weeks = "Event.weeks"
    private static let courses = "Event.courses"
    private static let rooms = "Event.rooms"
    private static let lecturers = "Event.lecturers"
    private static let startTime = "Event.startTime"
    private static let endTime = "Event.endTime"
    private static let subject = "Event.subject"
    
    let day: DayOfWeek
    let subjectId: String?
    let subjectName: String
    let type: EventType
    let weeks: [Int]
    let courses: [String]
    let rooms: [String]
    let lecturers: [String]
    let startTime: String
    let endTime: String
    
    let subject: SubjectPersistable?
    
    init(day: DayOfWeek, subjectId: String?, subjectName: String, type: EventType, weeks: [Int], courses: [String], rooms: [String], lecturers: [String], startTime:  String, endTime: String, subject: SubjectPersistable?) {
        self.day = day
        self.subjectId = subjectId
        self.subjectName = subjectName
        self.type = type
        self.weeks = weeks
        self.courses = courses
        self.rooms = rooms
        self.lecturers = lecturers
        self.startTime = startTime
        self.endTime = endTime
        self.subject = subject
    }
    
    convenience init(event: Event, subjectIdMap: [String: SubjectPersistable]) {
        let day = event.day
        let subjectId = event.subjectId
        let subjectName = event.subjectName
        let type = event.type
        let weeks = event.weeks
        let courses = event.courses
        let rooms = event.rooms
        let lecturers = event.lecturers
        let startTime = event.startTime
        let endTime = event.endTime
        let subject: SubjectPersistable?
        if let subjectId = subjectId {
            subject = subjectIdMap[subjectId]
        } else {
            subject = nil
        }
        self.init(
            day: day,
            subjectId: subjectId,
            subjectName: subjectName,
            type: type,
            weeks: weeks,
            courses: courses,
            rooms: rooms,
            lecturers: lecturers,
            startTime: startTime,
            endTime: endTime,
            subject: subject
        )
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let day = DayOfWeek(rawValue: (aDecoder.decodeObjectForKey(EventPersistable.day) as! String))!
        let subjectId = aDecoder.decodeObjectForKey(EventPersistable.subjectId) as! String?
        let subjectName = aDecoder.decodeObjectForKey(EventPersistable.subjectName) as! String
        let type = DefaultEventType.parse((aDecoder.decodeObjectForKey(EventPersistable.type) as! String))
        let weeks = aDecoder.decodeObjectForKey(EventPersistable.weeks) as! [Int]
        let courses = aDecoder.decodeObjectForKey(EventPersistable.courses) as! [String]
        let rooms = aDecoder.decodeObjectForKey(EventPersistable.rooms) as! [String]
        let lecturers = aDecoder.decodeObjectForKey(EventPersistable.lecturers) as! [String]
        let startTime = aDecoder.decodeObjectForKey(EventPersistable.startTime) as! String
        let endTime = aDecoder.decodeObjectForKey(EventPersistable.endTime) as! String
        let subject = aDecoder.decodeObjectForKey(EventPersistable.subject) as! SubjectPersistable?
        self.init(
            day: day,
            subjectId: subjectId,
            subjectName: subjectName,
            type: type,
            weeks: weeks,
            courses: courses,
            rooms: rooms,
            lecturers: lecturers,
            startTime: startTime,
            endTime: endTime,
            subject: subject
        )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(day.rawValue, forKey: EventPersistable.day)
        aCoder.encodeObject(subjectId, forKey: EventPersistable.subjectId)
        aCoder.encodeObject(subjectName, forKey: EventPersistable.subjectName)
        aCoder.encodeObject(type.raw(), forKey: EventPersistable.type)
        aCoder.encodeObject(weeks, forKey: EventPersistable.weeks)
        aCoder.encodeObject(courses, forKey: EventPersistable.courses)
        aCoder.encodeObject(rooms, forKey: EventPersistable.rooms)
        aCoder.encodeObject(lecturers, forKey: EventPersistable.lecturers)
        aCoder.encodeObject(startTime, forKey: EventPersistable.startTime)
        aCoder.encodeObject(endTime, forKey: EventPersistable.endTime)
        aCoder.encodeObject(subject, forKey: EventPersistable.subject)
    }
    
    func toEvent(subjectIdMap: [String: Subject]) -> Event {
        let day = self.day
        let subjectId = self.subjectId
        let subjectName = self.subjectName
        let type = self.type
        let weeks = self.weeks
        let courses = self.courses
        let rooms = self.rooms
        let lecturers = self.lecturers
        let startTime = self.startTime
        let endTime = self.endTime
        let subject: Subject?
        if let subjectId = subjectId {
            subject = subjectIdMap[subjectId]
        } else {
            subject = nil
        }
        return Event(
            day: day,
            subjectId: subjectId,
            subjectName: subjectName,
            type: type,
            weeks: weeks,
            courses: courses,
            rooms: rooms,
            lecturers: lecturers,
            startTime: startTime,
            endTime: endTime,
            subject: subject
        )
    }
    
}
