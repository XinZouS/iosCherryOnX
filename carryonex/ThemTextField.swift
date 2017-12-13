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
    
    
    @IBInspectable var underlineLeft: CGFloat = 0 {
        didSet{
            updateUnderline()
        }
    }
    @IBInspectable var underlineRight: CGFloat = 0 {
        didSet{
            updateUnderline()
        }
    }
    @IBInspectable var underlineHeigh: CGFloat = 1 {
        didSet{
            updateUnderline()
        }
    }
    @IBInspectable var underlineTopY: CGFloat = 0 {
        didSet{
            updateUnderline()
        }
    }
    
    @IBInspectable var cursorColor: UIColor = colorTheamRed
    @IBInspectable var defaultLineColor: UIColor = colorTextFieldUnderLineLightGray
    @IBInspectable var activeLineColor: UIColor = colorTheamRed

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTarget(self, action: #selector(editingDidBegin), for: .editingDidBegin)
        self.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        setupCursor()
        updateUnderline()
        self.addSubview(underlineView)
    }
    
    private func setupCursor(){
        let traits = self.value(forKey: "textInputTraits") as AnyObject
        traits.setValue(cursorColor, forKey: "insertionPointColor")
    }
    
    private func setupUnderlineView(startOffset: CGFloat = 0, endOffset: CGFloat = 0, topOffset: CGFloat = 0, heigh h: CGFloat){
        underlineView.frame = CGRect(x: 0 + startOffset, y: self.bounds.height + topOffset, width: self.bounds.width + endOffset, height: h)
    }
    
    private func updateUnderline(){
        setupUnderlineView(startOffset: underlineLeft,
                           endOffset: underlineRight,
                           topOffset: underlineTopY,
                           heigh: underlineHeigh)
    }
    
    public func editingDidBegin(){
        underlineView.backgroundColor = activeLineColor
    }
    
    public func editingDidEnd(){
        underlineView.backgroundColor = defaultLineColor
    }
    
    
}

