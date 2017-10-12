//
//  UILabel++.swift
//  carryonex
//
//  Created by Xin Zou on 8/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


@IBDesignable class UILabelTopAligned : UILabel {
    
    
    var currRect = CGRect(x: 0, y: 0, width: 10, height: 10)
    
    
    override func drawText(in rect: CGRect) {
        
        if let strText = text {
            let strTextAsNSStr = strText as NSString
            
            let mySize = CGSize(width: self.frame.width, height: CGFloat.greatestFiniteMagnitude)
            let option = NSStringDrawingOptions.usesLineFragmentOrigin
            let attrib = [NSFontAttributeName: font]
            
            let labelStrSize = strTextAsNSStr.boundingRect(with: mySize, options: option, attributes: attrib, context: nil).size
            
            self.currRect =  CGRect(x: 0, y: 0, width: self.frame.width, height: ceil(labelStrSize.height))
        }else{
            self.currRect = rect
        }
        super.drawText(in: currRect)
    }
    
}

