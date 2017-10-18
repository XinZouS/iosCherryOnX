//
//  DetailUserNameCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/18.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailUserNameCell : UICollectionViewCell{
    
    var orderDetailPage : OrderDetailPage?
    
    var titleLabelWidthConstraint   : NSLayoutConstraint?
    var titleLabelCenterYConstraint : NSLayoutConstraint?
    
    var senderImgBtnWidthConstraint   : NSLayoutConstraint?
    var senderImgBtnCenterYConstraint : NSLayoutConstraint?
    
    var underlineViewBottomConstraint:NSLayoutConstraint?
    
    let nameLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "玖"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    let localLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "美国纽约"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    let youxiangLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "邮箱号：1234"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    lazy var senderImgBtn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 40
        b.backgroundColor = .lightGray
//        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
//    let textField : UITextField = {
//        let t = UITextField()
//        //        t.backgroundColor = .yellow
//        //        t.placeholder = " "
//        t.textAlignment = .right
//        t.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16)
//        t.returnKeyType = .done
//        return t
//    }()
    
    
    let underlineView = UIView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupNameLabel()
        setupLocalLabel()
        setupYouxiangLabel()
        setupSenderImgBtn()
//        setupTextField()
        
        setupUnderlineView()
        
    }
    func setupSenderImgBtn(){
        addSubview(senderImgBtn)
        var imgName = "CarryonEx_Logo"
        senderImgBtn.setImage(UIImage(named: imgName), for: .normal)
        senderImgBtn.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 50, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 80, height: 80)
        senderImgBtnWidthConstraint = senderImgBtn.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        senderImgBtnWidthConstraint?.isActive = true
    }
    func setupNameLabel(){
        addSubview(nameLabel)
        nameLabel.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: 150, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    func setupLocalLabel(){
        addSubview(localLabel)
        localLabel.addConstraints(left: leftAnchor, top: nameLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 150, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    func setupYouxiangLabel(){
        addSubview(youxiangLabel)
        youxiangLabel.addConstraints(left: leftAnchor, top: localLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 150, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
//    private func setupTextField(){
//        addSubview(textField)
//        textField.addConstraints(left: titleLabel.rightAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
//        textField.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
//    }
    
    private func setupUnderlineView(){
        underlineView.backgroundColor = .lightGray
        addSubview(underlineView)
        underlineView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
        underlineViewBottomConstraint = underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        underlineViewBottomConstraint?.isActive = true
    }
    
    
    
//    func addExtraContentToRight(_ content: UIView){
//        addSubview(content)
//        content.addConstraints(left: titleLabel.rightAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
//        content.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//    }
//    
//    func addExtraContentToBottom(_ content: UIView){
//        addSubview(content)
//        content.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 22)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
