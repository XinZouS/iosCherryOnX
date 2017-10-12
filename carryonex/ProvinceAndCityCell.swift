//
//  provinceAndCityCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/9/28.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit


class ProvinceAndCityCell : UITableViewCell {
    
    var addressCtl : AddressController!
    
    
    let labelHeigh: CGFloat = 20
    let sideMargin: CGFloat = 30
    var idString: String!
    
    let underline: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    var titleLabelWidthConstraint   : NSLayoutConstraint?
    var titleLabelCenterYConstraint : NSLayoutConstraint?
    var underlineViewBottomConstraint:NSLayoutConstraint?
    
    let titleLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "cell demo"
        l.font = UIFont.systemFont(ofSize: 16)
        return l
    }()
    
    let textField : UITextField = {
        let t = UITextField()
        //        t.backgroundColor = .yellow
        //        t.placeholder = " "
        t.textAlignment = .right
        t.font = UIFont.systemFont(ofSize: 16)
        t.returnKeyType = .done
        return t
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        setupTitleLabel()
        
        setupTextField()
        
        setupUnderlineView()
        
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: sideMargin, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 140, height: labelHeigh)
    }
    
    private func setupTextField(){
        addSubview(textField)
        textField.addConstraints(left: titleLabel.rightAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 30)
        textField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        textField.delegate = self
    }
    
    private func setupUnderlineView(){
        addSubview(underline)
        underline.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 10, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 1)
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
