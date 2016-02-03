//
//  NSDate+Offset.swift
//  cate
//
//  Created by Winston Li on 24/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation

enum TimeUnit: String {
    case Year = "y"
    case Month = "mo"
    case Day = "d"
    case Hour = "h"
    case Minute = "m"
    case Second = "s"
    case None
}


class UTCCalendar {
    
    static let cal: NSCalendar = {
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        cal.timeZone = NSTimeZone(abbreviation: "UTC")!
        return cal
    }()
    
}

extension NSDate {
    
    func getWeekNumberFrom(firstDay: NSDate) -> Int {
        let components: NSDateComponents = UTCCalendar.cal.components(.WeekOfYear, fromDate: firstDay, toDate: self, options: [])
        return components.weekOfYear + 1
    }
    
    func getDayWithMondayZero() -> Int {
        let weekday = UTCCalendar.cal.component(.Weekday, fromDate: self)
        let day = (weekday + 5) % 7
        assert(day >= 0 && day < 7)
        return day
    }
    
    private func from(date: NSDate) -> [(Int, TimeUnit)] {
        let components: NSDateComponents = UTCCalendar.cal.components([.Year, .Month, .Day, .Hour, .Minute, .Second], fromDate: self, toDate: date, options: [])
        return [
            (components.year, .Year),
            (components.month, .Month),
            (components.day, .Day),
            (components.hour, .Hour),
            (components.minute, .Minute),
            (components.second, .Second)
        ]
    }
    
    func offsetTo(date: NSDate) -> ((Int, TimeUnit), (Int, TimeUnit)?) {
        let comps = from(date)
        let thresholds = [3, 12, 3, 10, 10, 60]
        for (i, t) in thresholds.enumerate() {
            let (num, unit) = comps[i]
            if num > 0 {
                if i + 1 < thresholds.count && num < t {
                    return ((num, unit), comps[i + 1])
                }
                return ((num, unit), nil)
            }
        }
        return ((0, .None), nil)
    }
    
    func offsetAsString(date: NSDate, ifPassedDate: String) -> String {
        let ((num, unit), lesser) = offsetTo(date)
        if let lesser = lesser {
            return "\(num)\(unit.rawValue), \(lesser.0)\(lesser.1.rawValue)"
        }
        if unit == .None {
            return ifPassedDate
        }
        return "\(num)\(unit.rawValue)"
    }
    
    func remainingPercentageFrom(end: NSDate, start: NSDate) -> Float {
        let toEnd = end.timeIntervalSinceDate(self)
        let total = end.timeIntervalSinceDate(start)
        return Float(toEnd / total)
    }
    
    func normaliseTime() -> NSDate {
        let comps = UTCCalendar.cal.components([.Hour, .Minute], fromDate: self)
        return UTCCalendar.cal.dateFromComponents(comps)!
    }
    
    func startOfDay() -> NSDate {
        let calendar = UTCCalendar.cal
        let components: NSDateComponents = calendar.components([.Year, .Month, .Day], fromDate: self)
        return calendar.dateFromComponents(components)!
    }
    
    func startOfNextDay() -> NSDate {
        return UTCCalendar.cal.dateByAddingUnit(.Day, value: 1, toDate: startOfDay(), options: [])!
    }
    
}
