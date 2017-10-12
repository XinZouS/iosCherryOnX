//
//  YouxiangCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/21/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class YouxiangCell: RequestBaseCell {
    
    enum HintString: String {
        case success = "✅游箱号匹配成功，请填写下方货物信息。✅游箱号匹配成功，请填写下方货物信息。"
        case fail = "❌抱歉我们无法找到此行程，请确认您的游箱号输入正确。"
    }
    
    var hintLabelHeightConstraint : NSLayoutConstraint?
    
    var cellHighIdentity : CGFloat = 0
    
    var hintString:String = "测试用：666666 " {
        didSet{
            youxiangHintLabel.text = hintString
//            let labelH : CGFloat = youxiangHintLabel.currRect.height
//            hintLabelHeightConstraint?.constant = labelH
//            heightAnchor.constraint(equalToConstant: cellHighIdentity + labelH).isActive = true
//            hintLabelAnimation()
//            requestController?.layoutAnimation()
        }
    }

    let youxiangHintLabel: UILabelTopAligned = {
        let l = UILabelTopAligned()
        l.text = "searching .. .."
        l.textAlignment = .center
        l.textColor = textThemeColor
        l.backgroundColor = .white
        l.numberOfLines = 2
        l.font = UIFont.systemFont(ofSize: 14)
        return l
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellHighIdentity = frame.height
        
        textField.keyboardType = .numberPad
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        titleLabelWidthConstraint?.isActive = false
        titleLabelWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: 100)
        titleLabelWidthConstraint?.isActive = true
        
        addSubview(youxiangHintLabel)
        youxiangHintLabel.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 33) // height = 33
        
        //*** trying to change hight with textField, somehow it didnot work.....
//        hintLabelHeightConstraint = youxiangHintLabel.heightAnchor.constraint(equalToConstant: 30)
//        hintLabelHeightConstraint?.isActive = true
        
        titleLabelCenterYConstraint?.constant = -15
        underlineViewBottomConstraint?.isActive = false
        underlineViewBottomConstraint = underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40) // lift up the line 40 px
        underlineViewBottomConstraint?.isActive = true
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



