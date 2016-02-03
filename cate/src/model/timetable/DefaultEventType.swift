//
//  EventType.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

enum DefaultEventType: String, EventType, EVRawString, EVAssociated {
    
    static func parse(name: String) -> EventType {
        let type: EventType? = DefaultEventType(rawValue: name)
        if let defaultEvent: EventType = type {
            return defaultEvent
        }
        return CustomEventType(name: name)
    }
    
    static let toStringMapping: [DefaultEventType: String] = [
        .Lecture: "Lecture",
        .Tutorial: "Tutorial",
        .Lab: "Lab",
        .Exam: "Exam",
        .Test: "Test"
    ]
    
    static let toColourMapping: [DefaultEventType: UIColor] = [
        .Lecture: UIColor(colorLiteralRed: 0.0, green: 159.0 / 255.0, blue: 248.0, alpha: 1.0),
        .Tutorial: UIColor(colorLiteralRed: 223.0 / 255.0, green: 70.0 / 255.0, blue: 219.0 / 255.0, alpha: 1.0),
        .Lab: UIColor(colorLiteralRed: 0.0, green: 224.0 / 255.0, blue: 36.0 / 255.0, alpha: 1.0),
        .Exam: UIColor(colorLiteralRed: 255.0, green: 0.0, blue: 84.0, alpha: 1.0),
        .Test: UIColor(colorLiteralRed: 255.0, green: 0.0, blue: 84.0, alpha: 1.0)
    ]
    
    case Lecture = "LECTURE"
    case Tutorial = "TUTORIAL"
    case Lab = "LAB"
    case Exam = "EXAM"
    case Test = "TEST"
    
    var description: String {
        return DefaultEventType.toStringMapping[self]!
    }
    
    func getColour() -> UIColor {
        return DefaultEventType.toColourMapping[self]!
    }
    
    func equals(eventType: EventType) -> Bool {
        let det = eventType as? DefaultEventType
        if let d = det {
            return self == d
        }
        return false
    }
    
    func raw() -> String {
        return rawValue
    }
    
}
