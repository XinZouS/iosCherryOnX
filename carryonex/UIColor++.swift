//
//  UIColor++.swift
//  carryonex
//
//  Created by Xin Zou on 10/14/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation



// arranged by scale
let buttonColorRed    = UIColor(r: 255, g: 100, b: 100)
let buttonColorOrange = UIColor(r: 255, g: 166, b: 123)
let buttonColorGreen  = UIColor(r: 100, g: 255, b: 100)
let buttonColorGold   = UIColor(r: 244, g: 207, b: 143)
let buttonColorPurple = UIColor(r: 160, g: 90, b: 253)
let buttonColorWhite  = UIColor(r: 255, g: 255, b: 255)

/// App theme color: Gold
let buttonThemeColor   = UIColor(r: 244, g: 207, b: 143)
let textThemeColor   = UIColor(r: 242, g: 180, b: 69)

let menuColorLightPurple = UIColor(r: 246, g: 230, b: 255)
let menuColorLightOrange = UIColor(r: 255, g: 160, b: 133)

let barColorGray = UIColor(r:50,g:50,b:50)
let barColorLightGray = UIColor(r:174,g:174,b:174)
let borderColorLightGray = UIColor(r:232,g:232,b:232)
let pickerColorLightGray = UIColor(r:247,g:247,b:247)
let calendarColorLightGray = UIColor(r:201,g:201,b:201)


extension UIColor {
    
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static func rgb(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            colorLiteralRed: Float(1.0) / Float(255.0) * Float(red),
            green: Float(1.0) / Float(255.0) * Float(green),
            blue: Float(1.0) / Float(255.0) * Float(blue),
            alpha: alpha)
    }
}
