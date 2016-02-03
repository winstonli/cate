//
//  Timetable.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

/* Stored in a stupid way because of the way Swift handles reflection.
   Makes deserialisation pretty much automatic, though. */
class Days: EVObject {
    var MONDAY: [Event]!
    var TUESDAY: [Event]!
    var WEDNESDAY: [Event]!
    var THURSDAY: [Event]!
    var FRIDAY: [Event]!
    
    required init() {
        super.init()
    }
    
    init(MONDAY: [Event], TUESDAY: [Event], WEDNESDAY: [Event], THURSDAY: [Event], FRIDAY: [Event]) {
        self.MONDAY = MONDAY
        self.TUESDAY = TUESDAY
        self.WEDNESDAY = WEDNESDAY
        self.THURSDAY = THURSDAY
        self.FRIDAY = FRIDAY
    }
    
}

class Timetable: EVObject {
    
    var days: Days!
    var firstDayOfTerm: NSDate!
    var subjects: [String: Subject]!
    
    required init() {
        super.init()
    }
    
    init(days: Days, firstDayOfTerm: NSDate, subjects: [String: Subject]) {
        self.days = days
        self.firstDayOfTerm = firstDayOfTerm
        self.subjects = subjects
    }
    
    override func setValue(value: AnyObject!, forUndefinedKey key: String) {
        if key != "firstDayOfTerm" {
            super.setValue(value, forUndefinedKey: key)
        }
    }
    
    func getEventsIndexedByDay() -> [[Event]] {
        return [days.MONDAY, days.TUESDAY, days.WEDNESDAY, days.THURSDAY, days.FRIDAY]
    }
    
    func getAllEvents() -> [Event] {
        return getEventsIndexedByDay().flatMap{ $0 }
    }
    
    func addSubjectReferences(work: Work) {
        getAllEvents().forEach({ event in
            if let subjectId: String = event.subjectId {
                event.subject = work.subjectIdMap[subjectId]
            }
        })
        subjects = work.subjectIdMap
        firstDayOfTerm = work.firstDayOfTerm
    }
    
    private func combine(events: [Event]) -> [Event] {
        var combined: [Event] = []
        for var i = 0; i < events.count; ++i {
            let e = Event(copy: events[i])
            var j = 1
            for ; i + j < events.count; ++j {
                let next = events[i + j]
                if e.canCombineWith(next) {
                    e.combineWith(next)
                } else {
                    break
                }
            }
            i += (j - 1)
            combined.append(e)
        }
        return combined
    }
    
    func getForTime(time: NSDate) -> ([Event], Bool) {
        let dayIndex: Int = time.getDayWithMondayZero()
        if dayIndex >= 5 {
            return ([], false)
        }
        
        let weekNumber: Int = time.getWeekNumberFrom(firstDayOfTerm)
        let unfiltered: [Event] = getEventsIndexedByDay()[dayIndex]
        let filtered = unfiltered.filter({ event in
            (event.subjectId == nil || subjects[event.subjectId!] != nil) &&
            event.weeks.contains(weekNumber)
        })
        let remaining = combine(filtered).filter({ event in
            (event.isPending(time) || event.isOccurring(time))
        })
        return (remaining, !filtered.isEmpty)
    }
    
    func getNextDay(today: NSDate) -> (DayDesc, [Event]) {
        var desc: DayDesc = .Tomorrow
        var events: [Event] = []
        var weekNumber: Int = 0
        var currentDay = today.startOfNextDay()
        repeat {
            (events, _) = getForTime(currentDay)
            if !events.isEmpty {
                return (desc, events)
            }
            currentDay = currentDay.startOfNextDay()
            weekNumber = currentDay.getWeekNumberFrom(firstDayOfTerm)
            desc = .OtherDate(currentDay)
        } while (weekNumber <= 11)
        return (.None, [])
    }
    
    func toPersistable(subjectIdMap: [String: SubjectPersistable]) -> TimetablePersistable {
        return TimetablePersistable(timetable: self, subjectIdMap: subjectIdMap)
    }
    
}

enum DayDesc: CustomStringConvertible {
    
    static let dayDescFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()
    
    case None
    case Tomorrow
    case OtherDate(NSDate)
    
    var description: String {
        switch self {
        case .Tomorrow:
            return "Tomorrow"
        case .OtherDate(let date):
            return DayDesc.dayDescFormatter.stringFromDate(date)
        default:
            fatalError()
        }
    }
}
