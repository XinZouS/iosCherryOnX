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
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    static func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
    
    static func color(_ red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(
            displayP3Red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha))
    }
    
    
    struct MyTheme {
        static let morningBlue = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5803921569, alpha: 1)
        static let morningWhite = #colorLiteral(red: 0.9058823529, green: 0.9215686275, blue: 0.9294117647, alpha: 1)
        
        static let noonYellow = #colorLiteral(red: 0.9843137255, green: 0.5725490196, blue: 0.0862745098, alpha: 1)
        static let noonWhite = #colorLiteral(red: 0.8078431373, green: 0.8588235294, blue: 0.8901960784, alpha: 1)
        
        static let afternoonBlue = #colorLiteral(red: 0, green: 0.3294117647, blue: 0.5803921569, alpha: 1)
        static let afternoonWhite = #colorLiteral(red: 0.9058823529, green: 0.9215686275, blue: 0.9294117647, alpha: 1)
        
        static let nightBlue = #colorLiteral(red: 0.1284747124, green: 0.1093071476, blue: 0.3388965428, alpha: 1)
        static let nightCyan = #colorLiteral(red: 0.1916682422, green: 0.6344442368, blue: 0.7353702188, alpha: 1)        
    }
}

