//
//  ExerciseType.swifgt.swift
//  cate
//
//  Created by Winston Li on 23/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import EVReflection

enum ExerciseType: String, EVRawString, EVAssociated {
    
    case White = "WHITE"
    case Grey = "GREY"
    case Green = "GREEN"
    case Pink = "PINK"
    
    func color() -> UIColor {
        switch self {
        case .Grey:
            return UIColor.lightGrayColor()
        case .Green:
//            return UIColor(colorLiteralRed: 137.0 / 255.0, green: 231.0 / 255.0, blue: 115.0 / 255.0, alpha: 1.0)
//            return UIColor(colorLiteralRed: 191.0 / 255.0, green: 223.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0)
            return UIColor(colorLiteralRed: 147.0 / 255.0, green: 214.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
        case .Pink:
            return UIColor(colorLiteralRed: 240.0 / 255.0, green: 150.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
        default:
            return UIColor.blackColor()
        }
    }
    
}
