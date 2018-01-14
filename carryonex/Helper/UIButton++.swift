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
    
    public func setImageFrom(url: URL) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.setImage(UIImage(data: data), for: .normal)
                }
            } catch {
                self.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
                DLog("UIButton++ :: unable to get image data from url: \(url.absoluteString)")
            }
        }
    }

    
    
}


