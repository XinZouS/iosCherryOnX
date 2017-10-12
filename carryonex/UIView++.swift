//
//  UIView++.swift
//  carryonex
//
//  Created by Xin Zou on 8/8/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


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
    
    static func rgb(r:CGFloat, g:CGFloat, b:CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

 
let buttonFont = "Verdana"


extension UIView{
    
    func addConstraints(left:NSLayoutXAxisAnchor? = nil, top:NSLayoutYAxisAnchor? = nil, right:NSLayoutXAxisAnchor? = nil, bottom:NSLayoutYAxisAnchor? = nil, leftConstent:CGFloat? = 0, topConstent:CGFloat? = 0, rightConstent:CGFloat? = 0, bottomConstent:CGFloat? = 0, width:CGFloat? = 0, height:CGFloat? = 0){
        
        var anchors = [NSLayoutConstraint]()
        self.translatesAutoresizingMaskIntoConstraints = false
        
        if left != nil {
            anchors.append(leftAnchor.constraint(equalTo: left!, constant: leftConstent!))
        }
        if top != nil {
            anchors.append(topAnchor.constraint(equalTo: top!, constant: topConstent!))
        }
        if right != nil {
            anchors.append(rightAnchor.constraint(equalTo: right!, constant: -rightConstent!))
        }
        if bottom != nil {
            anchors.append(bottomAnchor.constraint(equalTo: bottom!, constant: -bottomConstent!))
        }
        if let width = width, width > CGFloat(0) {
            anchors.append(widthAnchor.constraint(equalToConstant: width))
        }
        if let height = height, height > CGFloat(0) {
            anchors.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        for anchor in anchors {
            anchor.isActive = true
        }
    }
    
}



