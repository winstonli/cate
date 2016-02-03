//
//  CustomEventType.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import UIKit

class CustomEventType: EventType {
    
    let name: String
    
    init(name: String) {
        self.name = name
    }
    
    var description: String {
        return name
    }
    
    func getColour() -> UIColor {
        return UIColor(colorLiteralRed: 255.0 / 255.0, green: 118.0 / 255.0, blue: 0.0, alpha: 1.0)
    }
    
    func equals(eventType: EventType) -> Bool {
        let cet = eventType as? CustomEventType
        if let c = cet {
            return name == c.name
        }
        return false
    }
    
    func raw() -> String {
        return name
    }
    
}
