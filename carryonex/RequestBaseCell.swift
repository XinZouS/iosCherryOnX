//
//  RequestBaseCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/21/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class RequestBaseCell : UICollectionViewCell {
    
    var requestController : RequestController?
    
    var titleLabelWidthConstraint   : NSLayoutConstraint?
    var titleLabelCenterYConstraint : NSLayoutConstraint?
    var underlineViewBottomConstraint:NSLayoutConstraint?
    
    let titleLabel : UILabel = {
        let l = UILabel()
//        l.backgroundColor = .cyan
        l.text = "cell demo"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    
    let textField : UITextField = {
        let t = UITextField()
//        t.backgroundColor = .yellow
//        t.placeholder = " "
        t.textAlignment = .right
        t.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16)
        t.returnKeyType = .done
        return t
    }()

    let underlineView = UIView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupTitleLabel()
        
        setupTextField()
        
        setupUnderlineView()
        
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = titleLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
        titleLabelCenterYConstraint = titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        titleLabelCenterYConstraint?.isActive = true
    } 
    
    private func setupTextField(){
        addSubview(textField)
        textField.addConstraints(left: titleLabel.rightAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        textField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
    }
    
    private func setupUnderlineView(){
        underlineView.backgroundColor = .lightGray
        addSubview(underlineView)
        underlineView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
        underlineViewBottomConstraint = underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        underlineViewBottomConstraint?.isActive = true
    }
    
    
    
    func addExtraContentToRight(_ content: UIView){
        addSubview(content)
        content.addConstraints(left: titleLabel.rightAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        content.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func addExtraContentToBottom(_ content: UIView){
        addSubview(content)
        content.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 22)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


