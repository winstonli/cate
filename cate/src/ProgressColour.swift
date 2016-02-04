//
//  ProgressColour.swift
//  cate
//
//  Created by Winston Li on 24/01/2016.
//  Copyright © 2016 Winston Li. All rights reserved.
//

import Foundation
import UIKit
    
func +(lhs: (Float, Float, Float), rhs: (Float, Float, Float)) -> (Float, Float, Float) {
    let (lr, lg, lb) = lhs
    let (rr, rg, rb) = rhs
    return (lr + rr, lg + rg, lb + rb)
}

func -(lhs: (Float, Float, Float), rhs: (Float, Float, Float)) -> (Float, Float, Float) {
    let (lr, lg, lb) = lhs
    let (rr, rg, rb) = rhs
    return (lr - rr, lg - rg, lb - rb)
}

func *(lhs: Float, rhs: (Float, Float, Float)) -> (Float, Float, Float) {
    let (rr, rg, rb) = rhs
    return (lhs * rr, lhs * rg, lhs * rb)
}

class ProgressColour {
    
    static let zero: (Float, Float, Float) = (225.0, 0.0, 0.0)
    static let quarter: (Float, Float, Float) = (255.0, 120.0, 0.0)
    static let half: (Float, Float, Float) = (255.0, 225.0, 0.0)
    static let threeq: (Float, Float, Float) = (168.0, 225.0, 0.0)
    static let full: (Float, Float, Float) = (45.0, 191.0, 0.0)
    
//    static let zero: (Float, Float, Float) = (255.0, 0.0, 84.0)
//    static let quarter: (Float, Float, Float) = (255.0, 118.0, 0.0)
//    static let half: (Float, Float, Float) = (255.0, 192.0, 0.0)
//    static let threeq: (Float, Float, Float) = (127.5, 208.0, 18.0)
//    static let full: (Float, Float, Float) = (0.0, 224.0, 36.0)
    
//    static let zero: (Float, Float, Float) = (255.0, 0.0, 84.0)
//    static let quarter: (Float, Float, Float) = (255.0, 118.0, 0.0)
//    static let half: (Float, Float, Float) = (255.0, 225.0, 0.0)
//    static let threeq: (Float, Float, Float) = (168.0, 225.0, 0.0)
//    static let full: (Float, Float, Float) = (0.0, 224.0, 36.0)
    
    private static func getCol(val: Float) -> (Float, Float, Float) {
        if val < 0.0 {
            return zero
        }
        if val >= 0.0 && val < 0.25 {
            return ((val / 0.25) * (quarter - zero) + zero)
        }
        if val >= 0.25 && val < 0.50 {
            return ((((val - 0.25) / 0.25) * (half - quarter)) + quarter)
        }
        if val >= 0.50 && val < 0.75 {
            return (half - ((val - 0.50) / 0.25) * (half - threeq))
        }
        return (threeq - ((val - 0.75) / 0.25) * (threeq - full))
    }
    
    static func fromPercentage(percentage: Float) -> UIColor {
        let (r, g, b) = getCol(percentage)
        return UIColor(colorLiteralRed: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
}
