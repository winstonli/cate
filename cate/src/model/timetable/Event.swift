//
//  Event.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

class Event: EVObject {
    
    static let dateFormatter: NSDateFormatter = {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        return dateFormatter
    }()
    
    var day: DayOfWeek!
    var subjectId: String?
    var subjectName: String!
    var type: EventType!
    var weeks: [Int]!
    var courses: [String]!
    var rooms: [String]!
    var lecturers: [String]!
    var startTime: String!
    var endTime: String!
    
    var subject: Subject?
    
    init(day: DayOfWeek, subjectId: String?, subjectName: String, type: EventType, weeks: [Int], courses: [String], rooms: [String], lecturers:  [String], startTime: String, endTime: String, subject: Subject?) {
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
    
    init(copy: Event) {
        day = copy.day
        subjectId = copy.subjectId
        subjectName = copy.subjectName
        type = copy.type
        weeks = copy.weeks
        courses = copy.courses
        rooms = copy.rooms
        lecturers = copy.lecturers
        startTime = copy.startTime
        endTime = copy.endTime
        subject = copy.subject
    }
    
    required init() {
        super.init()
    }
    
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        switch key {
        case "day":
            day = DayOfWeek(rawValue: value as! String)
        case "type":
            type = DefaultEventType.parse(value as! String)
        case "subject":
            break
        default:
            fatalError("invalid field: \(key)")
        }
    }
    
    private static func timeStringToDate(hm: String) -> NSDate {
        return dateFormatter.dateFromString(hm)!.normaliseTime()
    }
    
    func getStartTimeAsDate() -> NSDate {
        return Event.timeStringToDate(startTime)
    }
    
    func getEndTimeAsDate() -> NSDate {
        return Event.timeStringToDate(endTime)
    }
    
    func canCombineWith(event: Event) -> Bool {
        return day == event.day &&
        subjectId == event.subjectId &&
        subjectName == event.subjectName &&
        type.equals(event.type) &&
        weeks == event.weeks &&
        courses == event.courses &&
        rooms == event.rooms &&
        lecturers == event.lecturers &&
        endTime == event.startTime
    }
    
    func combineWith(event: Event) {
        endTime = event.endTime
    }
    
    func isPending(date: NSDate) -> Bool {
        return date.normaliseTime().compare(getStartTimeAsDate()) == .OrderedAscending
    }
    
    func isOccurring(date: NSDate) -> Bool {
        let normalised = date.normaliseTime()
        return normalised.compare(getStartTimeAsDate()) != .OrderedAscending &&
               normalised.compare(getEndTimeAsDate()) == .OrderedAscending
    }
    
    func isOver(date: NSDate) -> Bool {
        return date.normaliseTime().compare(getEndTimeAsDate()) == .OrderedDescending
    }
    
}
