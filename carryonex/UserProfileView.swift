//
//  UserProfileView.swift
//  carryonex
//
//  Created by Xin Zou on 8/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class UserProfileView: UIView {
 
    var homePageCtl : HomePageController?
    
    var userInfoViewCtl : UserInfoViewController?
    
//    let profileView: UIImageView = {
//        let v = UIImageView()
//        //v.backgroundColor = UIColor.green
//        v.layer.cornerRadius = 40
//        v.layer.masksToBounds = true
//        v.image = #imageLiteral(resourceName: "yadianwenqing")
//        return v
//    }()
    
    let nameLabel: UILabel = {
        let b = UILabel()
        b.text = "姓名??"
        b.textColor = .white
        b.font = UIFont.systemFont(ofSize: 18)
        b.textAlignment = .center
        b.backgroundColor = .clear
        return b
    }()
    
    let phoneLabel: UILabel = {
        let b = UILabel()
        b.text = "xxx.xxx.6666"
        b.textColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .center
        b.backgroundColor = .clear
        return b
    }()
    
    private let profileImgHW: CGFloat = 60
    
    lazy var profileImgButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .clear
        b.setTitle(" ", for: .normal)
        b.setImage(#imageLiteral(resourceName: "CarryonEx_User"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFill
        b.imageView?.layer.cornerRadius = 30
        b.imageView?.layer.masksToBounds = true
        b.layer.cornerRadius = 30
        b.layer.masksToBounds = true
        b.layer.shadowColor = UIColor(red:0,green:0,blue:0,alpha:0.3).cgColor
        b.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        b.layer.shadowOpacity = 1.0
        b.layer.shadowRadius = 1.0
        b.layer.masksToBounds = false
        b.addTarget(self, action: #selector(profileButtonTapped), for: .touchUpInside)
        return b
    }()
    
//    lazy var isCarrierSegmentControl: UISegmentedControl = {
//        let s = UISegmentedControl(items: ["寄件人","揽件人"])
//        //s.tintColor = .white
//        s.tintColor = buttonThemeColor
//        s.selectedSegmentIndex = 0
//        s.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 16)], for: .normal)
//        s.addTarget(self, action: #selector(changeUserCarrierState), for: .valueChanged)
//        return s
//    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = barColorGray
        
        setupProfileImgButton()
        
        addSubview(nameLabel)
        nameLabel.addConstraints(left: leftAnchor, top: profileImgButton.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 20)
        
        addSubview(phoneLabel)
        phoneLabel.addConstraints(left: leftAnchor, top: nameLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 6, rightConstent: 0, bottomConstent: 0, width: 0, height: 20)
        
//        addSubview(isCarrierSegmentControl)
//        isCarrierSegmentControl.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: -5, topConstent: 120, rightConstent: -5, bottomConstent: 0, width: 0, height: 55)
//        isCarrierSegmentControl.selectedSegmentIndex = User.shared.isShipper! ? 1 : 0
        
        loadProfileImageFromLocalFile()
        loadNameAndPhoneInfo()
    }
    
    private func setupProfileImgButton(){
        addSubview(profileImgButton)
        profileImgButton.translatesAutoresizingMaskIntoConstraints = false
        profileImgButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImgButton.widthAnchor.constraint(equalToConstant: profileImgHW).isActive = true
        profileImgButton.heightAnchor.constraint(equalToConstant: profileImgHW).isActive = true
        profileImgButton.topAnchor.constraint(equalTo: topAnchor, constant: 30).isActive = true
        //profileImgButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



