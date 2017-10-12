//
//  RequestInfoView.swift
//  carryonex
//
//  Created by Xin Zou on 8/31/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class RequestInfoView : UIView {
    
    var request: Request? {
        didSet{
            setupLabelTextInfoFromRequest()
        }
    }
    
    let labelTextList = ["订单编号：", "订单人：", "运货费用：", "取货地点：", "送达地点：", "货物详情：", "期望到达时间："]
    
    let idLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    let ownerLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    let costLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    let departatureLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    let departatureTextView: UITextView = {
        let v = UITextView()
        v.isEditable = false
        v.font = UIFont.systemFont(ofSize: 16)
        v.backgroundColor = .white
        v.layer.borderColor = UIColor.lightGray.cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 3
        v.layer.masksToBounds = true
        v.textColor = .black
        return v
    }()
    
    let destinationLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    let destinationTextView: UITextView = {
        let v = UITextView()
        v.isEditable = false
        v.font = UIFont.systemFont(ofSize: 16)
        v.backgroundColor = .white
        v.layer.borderColor = UIColor.lightGray.cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 3
        v.layer.masksToBounds = true
        v.textColor = .black
        return v
    }()
    
    let itemDetailLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    let itemDetailStackView : UIStackView = {
        let v = UIStackView()
        v.backgroundColor = .green
        v.axis = .horizontal
        v.alignment = UIStackViewAlignment.leading
        v.distribution = .fillEqually
        return v
    }()
    
    let expectDeliveryTimeLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    let underlineView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupLabels()
        
    }
    
    
    private func setupLabels(){
        
        let leftMargin: CGFloat = 30
        let rightMargin:CGFloat = 30
        let lineMargin: CGFloat = 10
        
        let labelWidth: CGFloat = 130
        let labelHiegh: CGFloat = 20
        
        let txViewHeigh:CGFloat = 60 // 3 lines
        let txViewLeftMargin: CGFloat = leftMargin + labelWidth - 50
        
        // 订单编号
        addSubview(idLabel)
        idLabel.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: labelHiegh)
        
        // 订单人
        addSubview(ownerLabel)
        ownerLabel.addConstraints(left: leftAnchor, top: idLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: labelHiegh)
        
        // 运货费用
        addSubview(costLabel)
        costLabel.addConstraints(left: leftAnchor, top: ownerLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: labelHiegh)
        
        // 取货地点
        addSubview(departatureLabel)
        departatureLabel.addConstraints(left: leftAnchor, top: costLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: 0, bottomConstent: 0, width: labelWidth, height: labelHiegh)
        
        addSubview(departatureTextView)
        departatureTextView.addConstraints(left: leftAnchor, top: departatureLabel.topAnchor, right: rightAnchor, bottom: nil, leftConstent: txViewLeftMargin, topConstent: -6, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: txViewHeigh)
        
        // 送达地点
        addSubview(destinationLabel)
        destinationLabel.addConstraints(left: leftAnchor, top: departatureTextView.bottomAnchor, right: nil, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: 0, bottomConstent: 0, width: labelWidth, height: labelHiegh)
        
        addSubview(destinationTextView)
        destinationTextView.addConstraints(left: leftAnchor, top: destinationLabel.topAnchor, right: rightAnchor, bottom: nil, leftConstent: txViewLeftMargin, topConstent: -6, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: txViewHeigh)
        
        // 货物详情
        addSubview(itemDetailLabel)
        itemDetailLabel.addConstraints(left: leftAnchor, top: destinationTextView.bottomAnchor, right: nil, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: 0, bottomConstent: 0, width: labelWidth, height: labelHiegh)
        
        addSubview(itemDetailStackView)
        itemDetailStackView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: txViewLeftMargin, topConstent: 0, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: 33)
        itemDetailStackView.centerYAnchor.constraint(equalTo: itemDetailLabel.centerYAnchor).isActive = true
        
        // 期望到达时间
        addSubview(expectDeliveryTimeLabel)
        expectDeliveryTimeLabel.addConstraints(left: leftAnchor, top: itemDetailLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: leftMargin, topConstent: lineMargin, rightConstent: rightMargin, bottomConstent: 0, width: 0, height: labelHiegh)
        
        // 我是逗逼的分隔线
        addSubview(underlineView)
        underlineView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
    }
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




class ItemDetailView: UIView {
    
    let iconImgView : UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "yadianwenqing")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    
    let countLabel: UILabel = {
        let b = UILabel()
        b.textColor = .black
        b.text = "x6"
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageAndLabel()
        
    }
    
    
    private func setupImageAndLabel(){
        addSubview(iconImgView)
        iconImgView.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 25, height: 0)
        
        addSubview(countLabel)
        countLabel.addConstraints(left: iconImgView.rightAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    public func setup(iconImg: UIImage, num: Int){
        self.iconImgView.image = iconImg
        self.countLabel.text = " x\(num)"
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

