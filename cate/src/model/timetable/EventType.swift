//
//  EventType.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import UIKit

protocol EventType: CustomStringConvertible {
    
    func getColour() -> UIColor
    func equals(eventType: EventType) -> Bool
    func raw() -> String
    
}
