//
//  UIDesignableTextField.swift
//  carryonex
//
//  Created by Xin Zou on 11/13/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

@IBDesignable
class UIDesignableTextField: UITextField {
    
    @IBInspectable var rightImage: UIImage? {
        didSet{
            updateRightView()
        }
    }
    
    @IBInspectable var rightPadding: CGFloat = 5 {
        didSet{
            updateRightView()
        }
    }
    
    func updateRightView(){
        if let img = rightImage {
            rightViewMode = .always
            let sz: CGFloat = 15
            let imgView = UIImageView(frame: CGRect(x: -rightPadding, y: 0, width: sz, height: sz))
            imgView.contentMode = .scaleAspectFit
            imgView.image = img
            
            var vw: CGFloat = rightPadding + 20
            if borderStyle == .none || borderStyle == .line {
                vw += 5
            }
            let view = UIView(frame: CGRect(x: 0, y: 0, width: vw, height: sz))
            view.addSubview(imgView)
            
            rightView = view
            
        } else {
            rightViewMode = .never
        }
    }
    

}

