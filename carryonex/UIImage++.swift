//
//  UIImage++.swift
//  carryonex
//
//  Created by Xin Zou on 11/24/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

extension UIImage {
    
    func scaleTo(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0) // 1.0???
        draw(in: CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
        let newImg = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImg
    }
    
}
