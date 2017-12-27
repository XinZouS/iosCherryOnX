//
//  GiftPrizeCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/30/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//


import UIKit


class GiftPrizeCell: UICollectionViewCell {
    
    let imageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 20)
        return b
    }()
    
    let originalCostLabel : UILabel = {
        let att: [String : Any] = [
            NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle,
            NSStrikethroughColorAttributeName: UIColor.lightGray,
            NSForegroundColorAttributeName   : UIColor.lightGray,
            NSFontAttributeName              : UIFont.systemFont(ofSize: 14)
        ]
        let attString = NSAttributedString(string: " 原价：$666 ", attributes: att)
        let b = UILabel()
        b.attributedText = attString
        return b
    }()
    
    let youpiaoImageView : UIImageView = {
        let v = UIImageView()
        v.tintColor = textThemeColor
        v.image = #imageLiteral(resourceName: "carryonex_youpiao")
        return v
    }()
    
    let youpiaoNameLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 18)
        b.textColor = textThemeColor
        b.text = "游票"
        return b
    }()
    
    let youpiaoNumLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 18)
        b.textColor = textThemeColor
        b.text = "66"
        return b
    }()
    
    lazy var getLuckyPrizeButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(getLuckyPrizeButtonTapped), for: .touchUpInside)
        b.layer.cornerRadius = 30
        b.layer.masksToBounds = true
        b.backgroundColor = buttonColorWhite
        b.layer.borderColor = buttonThemeColor.cgColor
        b.layer.borderWidth = 1
        b.layer.shadowColor = UIColor.gray.cgColor
        b.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        b.layer.shadowOpacity = 1.0
        b.layer.shadowRadius = 1.0
        //b.layer.masksToBounds = false; ??????? need this ??????
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let m: CGFloat = 10
        setupImageView()
        setupGetLuckyPrizeButton()
        setupTitleLabel(leftConstent: m)
        setupYoupiaoContents(leftConstent: m)
        setupOriginalCostLabel(leftConstent: m)
    }
    
    
    
    private func setupImageView(){
        let margin: CGFloat = 2
        let w = self.bounds.height - (margin * 2)
        addSubview(imageView)
        imageView.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: bottomAnchor, leftConstent: margin, topConstent: margin, rightConstent: 0, bottomConstent: margin, width: w, height: 0)
    }
    
    private func setupGetLuckyPrizeButton(){
        let sz: CGFloat = 36
        addSubview(getLuckyPrizeButton)
        getLuckyPrizeButton.addConstraints(left: nil, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: sz, height: sz)
        getLuckyPrizeButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupTitleLabel(leftConstent leftCst: CGFloat){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: imageView.rightAnchor, top: topAnchor, right: getLuckyPrizeButton.leftAnchor, bottom: nil, leftConstent: leftCst, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
    }
    
    private func setupYoupiaoContents(leftConstent leftCst: CGFloat){
        addSubview(youpiaoImageView)
        youpiaoImageView.addConstraints(left: imageView.rightAnchor, top: titleLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: leftCst, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 26, height: 20)
        
        addSubview(youpiaoNameLabel)
        youpiaoNameLabel.addConstraints(left: youpiaoImageView.rightAnchor, top: youpiaoImageView.topAnchor, right: nil, bottom: youpiaoImageView.bottomAnchor, leftConstent: 3, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 30, height: 0)
        
        addSubview(youpiaoNumLabel)
        youpiaoNumLabel.addConstraints(left: youpiaoNameLabel.rightAnchor, top: youpiaoImageView.topAnchor, right: nil, bottom: youpiaoImageView.bottomAnchor, leftConstent: 3, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 30, height: 0)
    }
    
    private func setupOriginalCostLabel(leftConstent leftCst: CGFloat){
        addSubview(originalCostLabel)
        originalCostLabel.addConstraints(left: youpiaoNumLabel.rightAnchor, top: youpiaoImageView.topAnchor, right: getLuckyPrizeButton.leftAnchor, bottom: youpiaoImageView.bottomAnchor, leftConstent: 5, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 20)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension GiftPrizeCell {
    
    // TODO: setup get prize for user
    func getLuckyPrizeButtonTapped(){
        print("getLuckyPrizeButtonTapped..")
    }
    
    
}
