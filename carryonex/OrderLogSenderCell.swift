//
//  OrderLogBaseCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/4/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class OrderLogSenderCell : UICollectionViewCell {
    
    var request : Request! {
        didSet{
            updateUIContentsForRequest()
        }
    }
    
    
    let leftMargin: CGFloat = 5
    let topMargin : CGFloat = 10
    let labelHeight:CGFloat = 30
    let buttonWidthShort:CGFloat = UIScreen.main.bounds.width < 330 ? 45 : 60 // i5 screen.width = 320
    let buttonWidthLong :CGFloat = UIScreen.main.bounds.width < 330 ? 80 : 90
    
    let statusLabel: UILabel = {
        let b = UILabel()
        b.layer.borderColor = textThemeColor.cgColor
        b.layer.borderWidth = 1
        b.textColor = textThemeColor
        b.backgroundColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .center
        b.text = "等待接单"
        return b
    }()
    
    let requestIdLabel : UILabel = {
        let b = UILabel()
        b.text = "0123456789ABCD"
        b.font = UIFont.systemFont(ofSize: 15)
        b.backgroundColor = .white
        return b
    }()
    
    lazy var contactButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(contactInfoButtonTapped), for: .touchUpInside)
        b.layer.borderColor = UIColor.lightGray.cgColor
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        //b.setTitle("联系", for: .normal)
        return b
    }()
    lazy var detailButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(detailButtonTapped), for: .touchUpInside)
        b.layer.borderColor = UIColor.lightGray.cgColor
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        //b.setTitle("详情", for: .normal)
        return b
    }()
    var detailButtonWidthConstraint: NSLayoutConstraint!
    
    let lineTopView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    let lineMiddleView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    let lineBottomView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    let itemsTextView : UITextView = {
        let v = UITextView()
        v.backgroundColor = .white
        v.textAlignment = .left
        v.text = "衣服*6，电子产品*1"
        v.isEditable = false
        return v
    }()
    
    let addressLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 12)
        b.backgroundColor = .white
        b.text = "出发地 --> 目的地"
        b.textColor = .lightGray
        b.textAlignment = .left
        return b
    }()
    
    let costLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.boldSystemFont(ofSize: 18)
        b.backgroundColor = .white
        b.textAlignment = .right
        b.text = "$66.6"
        return b
    }()
    
    
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBorderLineViews()
        setupStatusLabel()
        setupRequestIdLabel()
        setupButtons()
        setupMiddleLineView()
        setupCostLabel()
        setupItemTextView()
        setupAddressLabel()
    }
    
    private func setupBorderLineViews(){
        addSubview(lineTopView)
        lineTopView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
        
        addSubview(lineBottomView)
        lineBottomView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
    }
    
    private func setupStatusLabel(){
        let labelWidth: CGFloat = UIScreen.main.bounds.width < 330 ? 76 : 90
        addSubview(statusLabel)
        statusLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: labelWidth, height: 0)
    }
    
    private func setupRequestIdLabel(){
        addSubview(requestIdLabel)
        requestIdLabel.addConstraints(left: statusLabel.rightAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: leftMargin, topConstent: topMargin, rightConstent: 90, bottomConstent: 0, width: 0, height: labelHeight)
    }
    
    private func setupButtons(){
        // button 详情
        let rightCst: CGFloat = UIScreen.main.bounds.width < 330 ? 10 : 16
        addSubview(detailButton)
        detailButton.addConstraints(left: nil, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: topMargin, rightConstent: rightCst, bottomConstent: 0, width: 0, height: labelHeight - 5)
        
        detailButtonWidthConstraint = detailButton.widthAnchor.constraint(equalToConstant: buttonWidthShort)
        detailButtonWidthConstraint.isActive = true
        
        // button 联系
        addSubview(contactButton)
        contactButton.addConstraints(left: nil, top: topAnchor, right: detailButton.leftAnchor, bottom: nil, leftConstent: 0, topConstent: topMargin, rightConstent: 10, bottomConstent: 0, width: buttonWidthShort, height: labelHeight - 5)
    }
    
    // lines ----------------------
    private func setupMiddleLineView(){
        addSubview(lineMiddleView)
        lineMiddleView.addConstraints(left: statusLabel.rightAnchor, top: requestIdLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 3, topConstent: 0, rightConstent: 5, bottomConstent: 0, width: 0, height: 1)
    }
    
    private func setupCostLabel(){
        let rightCst: CGFloat = UIScreen.main.bounds.width < 330 ? 3 : 10
        addSubview(costLabel)
        costLabel.addConstraints(left: nil, top: lineMiddleView.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: rightCst, bottomConstent: 0, width: 76, height: 40)
    }
    
    private func setupItemTextView(){
        addSubview(itemsTextView)
        itemsTextView.addConstraints(left: statusLabel.rightAnchor, top: lineMiddleView.bottomAnchor, right: costLabel.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: labelHeight)
    }
    
    private func setupAddressLabel(){
        addSubview(addressLabel)
        addressLabel.addConstraints(left: statusLabel.rightAnchor, top: itemsTextView.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: leftMargin, topConstent: 3, rightConstent: leftMargin, bottomConstent: 0, width: 0, height: 16)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
