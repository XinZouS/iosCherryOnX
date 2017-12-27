//
//  UIButton++.swift
//  carryonex
//
//  Created by Xin Zou on 8/25/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setupAppearance(backgroundColor bgClr: UIColor, title: String, textColor: UIColor, fontSize: CGFloat) {
        self.backgroundColor = bgClr
        
        let attributes:[String:Any] = [
            NSFontAttributeName: UIFont.systemFont(ofSize: fontSize),
            NSForegroundColorAttributeName: textColor]
        let attribStr = NSAttributedString(string: title, attributes: attributes)

        self.setAttributedTitle(attribStr, for: .normal)
        
        
    }
    
    
}


