//
//  DetailBarView.swift
//  carryonex
//
//  Created by Xin Zou on 10/30/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class DetailBarView : UIView {
    
    var giftCtl : GiftController?
    
    let profileImageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = #imageLiteral(resourceName: "CarryonEx_Profile_Orange")
        return v
    }()
    
    let nameLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 16)
        b.text = "userName"
        return b
    }()
    
    let youpiaoImageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleToFill
        v.image = #imageLiteral(resourceName: "carryonex_youpiao")
        return v
    }()
    
    let youpiaoNameLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 14)
        b.text = "游票"
        return b
    }()
    let youpiaoNumLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 16)
        b.textColor = textThemeColor
        b.text = "X 166"
        return b
    }()
    
    lazy var youpiaoButton : UIButton = {
        let att = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]
        let tit = NSAttributedString(string: "赚游票", attributes: att)
        let b = UIButton()
        b.addTarget(self, action: #selector(youpiaoButtonTapped), for: .touchUpInside)
        b.setAttributedTitle(tit, for: .normal)
        b.backgroundColor = buttonThemeColor
        return b
    }()
    
    let underLineView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupProfileContents()
        setupYoupiaoContents()
        setupYoupiaoButton()
        setupUnderLineView()
    }
    
    private func setupProfileContents(){
        let sz : CGFloat = 32
        addSubview(profileImageView)
        profileImageView.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: 10, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: sz, height: sz)
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = sz / 2
        
        addSubview(nameLabel)
        nameLabel.addConstraints(left: profileImageView.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: 5, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 100, height: 26)
        nameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    private func setupYoupiaoContents(){
        let h : CGFloat = 20
        addSubview(youpiaoImageView)
        youpiaoImageView.addConstraints(left: nameLabel.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: 5, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 24, height: h)
        youpiaoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(youpiaoNameLabel)
        youpiaoNameLabel.addConstraints(left: youpiaoImageView.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: 2, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 36, height: h)
        youpiaoNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(youpiaoNumLabel)
        youpiaoNumLabel.addConstraints(left: youpiaoNameLabel.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 60, height: h)
        youpiaoNumLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    private func setupYoupiaoButton(){
        let h : CGFloat = 26
        addSubview(youpiaoButton)
        youpiaoButton.addConstraints(left: nil, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 20, bottomConstent: 0, width: 70, height: h)
        youpiaoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        youpiaoButton.layer.masksToBounds = true
        youpiaoButton.layer.cornerRadius = h / 2.6
    }
    
    private func setupUnderLineView(){
        addSubview(underLineView)
        underLineView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
    }

    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension DetailBarView {
    
    func youpiaoButtonTapped(){
        DLog("TODO: youpiaoButtonTapped in DetailBarView")
    }
}
