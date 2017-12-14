//
//  UITextField++.swift
//  carryonex
//
//  Created by Xin Zou on 12/13/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

@IBDesignable
class ThemTextField: UITextField {
    
    private let underlineView: UIView = {
        let v = UIView()
        v.backgroundColor = colorTextFieldUnderLineLightGray
        return v
    }()
    
    // constraints:
    @IBInspectable var underlineLeft: CGFloat = 0
    @IBInspectable var underlineRight: CGFloat = 0
    @IBInspectable var underlineHeigh: CGFloat = 1
    @IBInspectable var underlineTopY: CGFloat = 0
    
    // colors:
    @IBInspectable var cursorColor: UIColor = colorTheamRed
    @IBInspectable var defaultLineColor: UIColor = colorTextFieldUnderLineLightGray
    @IBInspectable var activeLineColor: UIColor = colorTheamRed

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        setupCursor()
        self.addSubview(underlineView)
        underlineView.addConstraints(left: self.leftAnchor,
                                     top: self.bottomAnchor,
                                     right: self.rightAnchor,
                                     bottom: nil,
                                     leftConstent: underlineLeft,
                                     topConstent: underlineTopY,
                                     rightConstent: underlineRight,
                                     bottomConstent: 0,
                                     width: 0,
                                     height: underlineHeigh)
    }
    
    private func setupCursor(){
        let traits = self.value(forKey: "textInputTraits") as AnyObject
        traits.setValue(cursorColor, forKey: "insertionPointColor")
    }
        
    public func editingDidBegin(){
        underlineView.backgroundColor = activeLineColor
    }
    
    public func editingDidEnd(){
        underlineView.backgroundColor = defaultLineColor
    }
    
    
}

