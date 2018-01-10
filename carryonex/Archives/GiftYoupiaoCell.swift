//
//  GiftYoupiaoCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/30/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class GiftYoupiaoCell: UICollectionViewCell {
    
    let imageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = #imageLiteral(resourceName: "CarryonEx_Waiting_B")
        return v
    }()
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 14)
        b.text = "prize name: iPad(10.5')"
        return b
    }()
    
    let originalCostLabel : UILabel = {
        let b = UILabel()
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
        b.font = UIFont.systemFont(ofSize: 14)
        b.textColor = textThemeColor
        b.text = "游票"
        return b
    }()
    
    let youpiaoNumLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 14)
        b.textColor = textThemeColor
        b.text = "66"
        return b
    }()
    
    lazy var getPrizeButton : UIButton = {
        let att = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let str = NSAttributedString(string: "立即兑换", attributes: att)
        let b = UIButton()
        b.addTarget(self, action: #selector(getPrizeButtonTapped), for: .touchUpInside)
        b.setAttributedTitle(str, for: .normal)
        b.backgroundColor = buttonThemeColor
        return b
    }()
    
    let remainNumLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 12)
        b.textColor = .lightGray
        b.textAlignment = .right
        b.text = "剩余6件"
        return b
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCellAppearance()
        
        setupImageView()
        setupTitleLabel()
        setupOriginalCostLabel()
        setupYoupiaoContents()
        setupGetPrizeButton()
        setupRemainNumLabel()
    }
    
    
    
    private func setupCellAppearance(){
        backgroundColor = .white
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
    }
    
    private func setupImageView(){
        let h = self.bounds.height * 0.4
        let margin: CGFloat = 5
        addSubview(imageView)
        imageView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: margin, topConstent: margin, rightConstent: margin, bottomConstent: 0, width: 0, height: h)
    }
    
    private func setupTitleLabel(){
        let margin: CGFloat = 3
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: imageView.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: margin, topConstent: margin, rightConstent: margin, bottomConstent: 0, width: 0, height: 20)
    }
    
    private func setupOriginalCostLabel(){
        setupOriginalPrize()
        addSubview(originalCostLabel)
        originalCostLabel.addConstraints(left: titleLabel.leftAnchor, top: titleLabel.bottomAnchor, right: titleLabel.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 16)
    }
    
    private func setupYoupiaoContents(){
        let margin: CGFloat = 5
        addSubview(youpiaoImageView)
        youpiaoImageView.addConstraints(left: leftAnchor, top: originalCostLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: margin, topConstent: margin, rightConstent: 0, bottomConstent: 0, width: 26, height: 20)
        
        addSubview(youpiaoNameLabel)
        youpiaoNameLabel.addConstraints(left: youpiaoImageView.rightAnchor, top: youpiaoImageView.topAnchor, right: nil, bottom: youpiaoImageView.bottomAnchor, leftConstent: 2, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 40, height: 0)
        
        addSubview(youpiaoNumLabel)
        youpiaoNumLabel.addConstraints(left: youpiaoNameLabel.rightAnchor, top: youpiaoNameLabel.topAnchor, right: rightAnchor, bottom: youpiaoNameLabel.bottomAnchor, leftConstent: 3, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupGetPrizeButton(){
        let margin: CGFloat = 8
        let w = self.bounds.width / 2 - 10
        addSubview(getPrizeButton)
        getPrizeButton.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: bottomAnchor, leftConstent: margin, topConstent: 0, rightConstent: 0, bottomConstent: margin, width: w, height: 23)
        getPrizeButton.layer.cornerRadius = 10
        getPrizeButton.layer.masksToBounds = true
    }
    
    private func setupRemainNumLabel(){
        addSubview(remainNumLabel)
        remainNumLabel.addConstraints(left: getPrizeButton.rightAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 10, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 0, height: 20)
        remainNumLabel.centerYAnchor.constraint(equalTo: getPrizeButton.centerYAnchor).isActive = true
    }
        
        
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





extension GiftYoupiaoCell {
    
    // TODO: let user get prize
    func getPrizeButtonTapped(){
        DLog("TODO: let user get prize!!!")
    }
    
    func setupOriginalPrize(){
        let attStr: NSMutableAttributedString = NSMutableAttributedString(string: "原价：$888")
        let rg = NSMakeRange(0, attStr.length)
        attStr.addAttribute(NSForegroundColorAttributeName, value: UIColor.lightGray, range: rg)
        attStr.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: rg)
        attStr.addAttribute(NSBaselineOffsetAttributeName, value: 0, range: rg)
        attStr.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: rg)

        originalCostLabel.attributedText = attStr
    }
    
}
