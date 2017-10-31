//
//  GiftPrizeCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
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
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupTitleLabel()
        setupOriginalCostLabel()
        setupYoupiaoContents()
    }
    
    
    
    private func setupImageView(){
        addSubview(imageView)
        imageView.addConstraints(left: leftAnchor, top: topAnchor, right: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, leftConstent: <#T##CGFloat?#>, topConstent: <#T##CGFloat?#>, rightConstent: <#T##CGFloat?#>, bottomConstent: <#T##CGFloat?#>, width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: <#T##NSLayoutXAxisAnchor?#>, top: <#T##NSLayoutYAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, leftConstent: <#T##CGFloat?#>, topConstent: <#T##CGFloat?#>, rightConstent: <#T##CGFloat?#>, bottomConstent: <#T##CGFloat?#>, width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
    }
    
    private func setupOriginalCostLabel(){
        addSubview(originalCostLabel)
        originalCostLabel.addConstraints(left: <#T##NSLayoutXAxisAnchor?#>, top: <#T##NSLayoutYAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, leftConstent: <#T##CGFloat?#>, topConstent: <#T##CGFloat?#>, rightConstent: <#T##CGFloat?#>, bottomConstent: <#T##CGFloat?#>, width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
    }
    
    private func setupYoupiaoContents(){
        addSubview(youpiaoImageView)
        youpiaoImageView.addConstraints(left: <#T##NSLayoutXAxisAnchor?#>, top: <#T##NSLayoutYAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, leftConstent: <#T##CGFloat?#>, topConstent: <#T##CGFloat?#>, rightConstent: <#T##CGFloat?#>, bottomConstent: <#T##CGFloat?#>, width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
        
        addSubview(youpiaoNameLabel)
        youpiaoNameLabel.addConstraints(left: <#T##NSLayoutXAxisAnchor?#>, top: <#T##NSLayoutYAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, leftConstent: <#T##CGFloat?#>, topConstent: <#T##CGFloat?#>, rightConstent: <#T##CGFloat?#>, bottomConstent: <#T##CGFloat?#>, width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
        
        addSubview(youpiaoNumLabel)
        youpiaoNumLabel.addConstraints(left: <#T##NSLayoutXAxisAnchor?#>, top: <#T##NSLayoutYAxisAnchor?#>, right: <#T##NSLayoutXAxisAnchor?#>, bottom: <#T##NSLayoutYAxisAnchor?#>, leftConstent: <#T##CGFloat?#>, topConstent: <#T##CGFloat?#>, rightConstent: <#T##CGFloat?#>, bottomConstent: <#T##CGFloat?#>, width: <#T##CGFloat?#>, height: <#T##CGFloat?#>)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

