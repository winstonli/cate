//
//  TimetablePersistable.swift
//  cate
//
//  Created by Winston Li on 31/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

class DaysPersistable: NSObject, NSCoding {
    
    private static let MONDAY = "Days.MONDAY"
    private static let TUESDAY = "Days.TUESDAY"
    private static let WEDNESDAY = "Days.WEDNESDAY"
    private static let THURSDAY = "Days.THURSDAY"
    private static let FRIDAY = "Days.FRIDAY"
    
    let MONDAY: [EventPersistable]
    let TUESDAY: [EventPersistable]
    let WEDNESDAY: [EventPersistable]
    let THURSDAY: [EventPersistable]
    let FRIDAY: [EventPersistable]
    
    init(MONDAY: [EventPersistable], TUESDAY: [EventPersistable], WEDNESDAY: [EventPersistable], THURSDAY: [EventPersistable], FRIDAY: [EventPersistable]) {
        self.MONDAY = MONDAY
        self.TUESDAY = TUESDAY
        self.WEDNESDAY = WEDNESDAY
        self.THURSDAY = THURSDAY
        self.FRIDAY = FRIDAY
    }
    
    convenience init(days: Days, subjectIdMap: [String: SubjectPersistable]) {
        let MONDAY = days.MONDAY.map({ event in
            EventPersistable(event: event, subjectIdMap: subjectIdMap)
        })
        let TUESDAY = days.TUESDAY.map({ event in
            EventPersistable(event: event, subjectIdMap: subjectIdMap)
        })
        let WEDNESDAY = days.WEDNESDAY.map({ event in
            EventPersistable(event: event, subjectIdMap: subjectIdMap)
        })
        let THURSDAY = days.THURSDAY.map({ event in
            EventPersistable(event: event, subjectIdMap: subjectIdMap)
        })
        let FRIDAY = days.FRIDAY.map({ event in
            EventPersistable(event: event, subjectIdMap: subjectIdMap)
        })
        self.init(
            MONDAY: MONDAY,
            TUESDAY: TUESDAY,
            WEDNESDAY: WEDNESDAY,
            THURSDAY: THURSDAY,
            FRIDAY: FRIDAY
        )
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let MONDAY = aDecoder.decodeObjectForKey(DaysPersistable.MONDAY) as! [EventPersistable]
        let TUESDAY = aDecoder.decodeObjectForKey(DaysPersistable.TUESDAY) as! [EventPersistable]
        let WEDNESDAY = aDecoder.decodeObjectForKey(DaysPersistable.WEDNESDAY) as! [EventPersistable]
        let THURSDAY = aDecoder.decodeObjectForKey(DaysPersistable.THURSDAY) as! [EventPersistable]
        let FRIDAY = aDecoder.decodeObjectForKey(DaysPersistable.FRIDAY) as! [EventPersistable]
        self.init(
            MONDAY: MONDAY,
            TUESDAY: TUESDAY,
            WEDNESDAY: WEDNESDAY,
            THURSDAY: THURSDAY,
            FRIDAY: FRIDAY
        )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(MONDAY, forKey: DaysPersistable.MONDAY)
        aCoder.encodeObject(TUESDAY, forKey: DaysPersistable.TUESDAY)
        aCoder.encodeObject(WEDNESDAY, forKey: DaysPersistable.WEDNESDAY)
        aCoder.encodeObject(THURSDAY, forKey: DaysPersistable.THURSDAY)
        aCoder.encodeObject(FRIDAY, forKey: DaysPersistable.FRIDAY)
    }
    
    func toDays(subjectIdMap: [String: Subject]) -> Days {
        let MONDAY = self.MONDAY.map({ event in
            event.toEvent(subjectIdMap)
        })
        let TUESDAY = self.TUESDAY.map({ event in
            event.toEvent(subjectIdMap)
        })
        let WEDNESDAY = self.WEDNESDAY.map({ event in
            event.toEvent(subjectIdMap)
        })
        let THURSDAY = self.THURSDAY.map({ event in
            event.toEvent(subjectIdMap)
        })
        let FRIDAY = self.FRIDAY.map({ event in
            event.toEvent(subjectIdMap)
        })
        return Days(
            MONDAY: MONDAY,
            TUESDAY: TUESDAY,
            WEDNESDAY: WEDNESDAY,
            THURSDAY: THURSDAY,
            FRIDAY: FRIDAY
        )
    }
    
}

class TimetablePersistable: NSObject, NSCoding {
    
    private static let days = "Timetable.days"
    private static let firstDayOfTerm = "Timetable.firstDayOfTerm"
    
    let days: DaysPersistable
    let firstDayOfTerm: NSDate
    
    init(days: DaysPersistable, firstDayOfTerm: NSDate) {
        self.days = days
        self.firstDayOfTerm = firstDayOfTerm
    }
    
    convenience init(timetable: Timetable, subjectIdMap: [String: SubjectPersistable]) {
        let days = DaysPersistable(
            MONDAY: timetable.days.MONDAY.map({ event in
                EventPersistable(event: event, subjectIdMap: subjectIdMap)
            }),
            TUESDAY: timetable.days.TUESDAY.map({ event in
                EventPersistable(event: event, subjectIdMap: subjectIdMap)
            }),
            WEDNESDAY: timetable.days.WEDNESDAY.map({ event in
                EventPersistable(event: event, subjectIdMap: subjectIdMap)
            }),
            THURSDAY: timetable.days.THURSDAY.map({ event in
                EventPersistable(event: event, subjectIdMap: subjectIdMap)
            }),
            FRIDAY: timetable.days.FRIDAY.map({ event in
                EventPersistable(event: event, subjectIdMap: subjectIdMap)
            })
        )
        let firstDayOfTerm = timetable.firstDayOfTerm
        self.init(
            days: days,
            firstDayOfTerm: firstDayOfTerm
        )
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let days = aDecoder.decodeObjectForKey(TimetablePersistable.days) as! DaysPersistable
        let firstDayOfTerm = aDecoder.decodeObjectForKey(TimetablePersistable.firstDayOfTerm) as! NSDate
        self.init(
            days: days,
            firstDayOfTerm: firstDayOfTerm
        )
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(days, forKey: TimetablePersistable.days)
        aCoder.encodeObject(firstDayOfTerm, forKey: TimetablePersistable.firstDayOfTerm)
    }
    
    func toTimetable(subjectIdMap: [String: Subject]) -> Timetable {
        let days = self.days.toDays(subjectIdMap)
        let firstDayOfTerm = self.firstDayOfTerm
        let subjects = subjectIdMap
        return Timetable(
            days: days,
            firstDayOfTerm: firstDayOfTerm,
            subjects: subjects
        )
    }
    
}
