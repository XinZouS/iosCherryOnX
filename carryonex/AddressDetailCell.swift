//
//  AddressDetailCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class AddressDetailCell : UITableViewCell, UITextViewDelegate {
    
    var addressCtl : AddressController!

    var idString: String!

    let sideMargin: CGFloat = 30

    var isChinese : Bool = true {
        didSet{
            hintLabel.isHidden = isChinese
        }
    }
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.text = ""
        b.textAlignment = .left
        b.textColor = .black
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    
    let hintLabel: UILabel = {
        let b = UILabel()
        b.text = "请使用英文填写帮助揽件人将货物顺利送达"
        b.font = UIFont.systemFont(ofSize: 12)
        b.textColor = textThemeColor
        b.numberOfLines = 2
        b.isHidden = true
        return b
    }()
    
    lazy var textView: UITextView = {
        let v = UITextView()
        v.delegate = self
        v.backgroundColor = .white
        v.textColor = .lightGray
        v.layer.borderColor = borderColorLightGray.cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 3
        v.layer.masksToBounds = true
        v.text = "请如实填写货物送达的详细地址，例如区县，街道名称，门牌号码，楼层，房间号和特殊事宜等信息"
        v.font = UIFont.systemFont(ofSize: 16)
        v.returnKeyType = .done
        return v
    }()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTitleLabel()
        setupHintLabel()
        setupTextView()
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: sideMargin, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 120, height: 20)
    }
    
    private func setupHintLabel(){
        addSubview(hintLabel)
        hintLabel.addConstraints(left: titleLabel.rightAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 30)
    }
    
    private func setupTextView(){
        addSubview(textView)
        textView.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: sideMargin, topConstent: 10, rightConstent: sideMargin, bottomConstent: 20, width: 0, height: 0)
        textView.delegate = self 
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
