//
//  RequestArrangingController.swift
//  carryonex
//
//  Created by Xin Zou on 8/27/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FacebookShare



class WaitingController: UIViewController {
    
    var isForShipper : Bool = false
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 18)
        b.textAlignment = .center
        b.text = "安排接单"
        return b
    }()
    
    lazy var closeButton: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Close"), for: .normal)
        b.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return b
    }()
    
    let imageView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .white
        v.contentMode = .scaleAspectFit
        v.image = #imageLiteral(resourceName: "CarryonEx_Waiting_B")
        return v
    }()
    
    let hintTextView : UITextView = {
        let b = UITextView()
        b.text = "游箱正在为您安排揽件人，当揽件人接到此单，游箱会第一时间通知您！"
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .center
        return b
    }()
    
    let underlineView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    let sharingTitle : UILabel = {
        let b = UILabel()
        b.font = UIFont.boldSystemFont(ofSize: 12)
        b.textAlignment = .center
        b.text = "分享给好友"
        return b
    }()
    
    var shareStackView : UIStackView!
    
    lazy var wechatButton : UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Wechat_Icon"), for: .normal)
        b.addTarget(self, action: #selector(shareToWechat), for: .touchUpInside)
        return b
    }()
    
    lazy var momentButton : UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Moment_Icon"), for: .normal)
        b.addTarget(self, action: #selector(shareToMonent), for: .touchUpInside)
        return b
    }()

    lazy var weiboButton : UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Weibo_Icon"), for: .normal)
        b.addTarget(self, action: #selector(shareToWeibo), for: .touchUpInside)
        return b
    }()
    
    lazy var facebookButton : UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Facebook_Icon"), for: .normal)
        b.addTarget(self, action: #selector(shareToFacebook), for: .touchUpInside)
        return b
    }()
//    let facebookSharingContent : FBSDKShareLinkContent = {
//        let content = FBSDKShareLinkContent()
//        let p3 = FBSDKSharePhoto(image: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"), userGenerated: true)
//        let p1 = FBSDKSharePhoto(image: #imageLiteral(resourceName: "CarryonEx_OnBoarding-01-1"), userGenerated: true)
//        let p2 = FBSDKSharePhoto(image: #imageLiteral(resourceName: "CarryonEx_OnBoarding-02-1"), userGenerated: true)
//        content.imageURL = URL(string: "https://s3-us-west-2.amazonaws.com/carryoneximage/userIdPhotos/userIdString123/passport-IMG_0005.JPG")
//        // = [p1, p2, p3]
//        content.contentURL = URL(string: "https://www.carryonex.com/")
//        content.contentTitle = "CarryonEx 中秋大促"
//        content.contentDescription = "中秋大促 中秋大促 中秋大促"
//        
//        return content
//    }()
//    lazy var facebookButton : FBSDKShareButton = {
//        let p3 = FBSDKSharePhoto(image: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"), userGenerated: true)
//        let p1 = FBSDKSharePhoto(image: #imageLiteral(resourceName: "CarryonEx_OnBoarding-01-1"), userGenerated: true)
//        let p2 = FBSDKSharePhoto(image: #imageLiteral(resourceName: "CarryonEx_OnBoarding-02-1"), userGenerated: true)
//        content.imageURL = URL(string: "https://s3-us-west-2.amazonaws.com/carryoneximage/userIdPhotos/userIdString123/passport-IMG_0005.JPG")
//        // = [p1, p2, p3]
//        content.contentURL = URL(string: "https://www.carryonex.com/")
//        content.contentTitle = "CarryonEx 中秋大促"
//        content.contentDescription = "中秋大促 中秋大促 中秋大促"
//        
//        let b = FBSDKShareButton()
//        b.shareContent = content
//        return b
//    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupTitleAndButton()
        
        setupImageView()
        
        setupHintTextView()
        
        setupUnderlineAndSharingLabel()
        
        setupShareStackView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupStatusBar() // for light background
    }
    
    
    func setupStatusBar(){
        UIApplication.shared.statusBarStyle = .default
    }
    
    func setupNavigationBar(){
        title = "安排接单"
    }
    
    private func setupTitleAndButton(){
        view.addSubview(titleLabel)
        titleLabel.addConstraints(left: nil, top: view.topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 30, rightConstent: 0, bottomConstent: 0, width: 150, height: 30)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(closeButton)
        closeButton.addConstraints(left: nil, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 40, rightConstent: 20, bottomConstent: 0, width: 20, height: 20)
    }
    
    func setupImageView(){
        let imgWidth: CGFloat = view.bounds.width - 60
        let imgHeigh: CGFloat = imgWidth * (3.0 / 4.0) // image is 3:4
        view.addSubview(imageView)
        imageView.addConstraints(left: nil, top: titleLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 30, rightConstent: 0, bottomConstent: 0, width: imgWidth, height: imgHeigh)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imageView.image = isForShipper ? #imageLiteral(resourceName: "CarryonEx_waiting_A") : #imageLiteral(resourceName: "CarryonEx_Waiting_B")
    }
    func setupHintTextView(){
        let sideMargin: CGFloat = 40
        view.addSubview(hintTextView)
        hintTextView.addConstraints(left: view.leftAnchor, top: imageView.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 20, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 80)
        
        let a = "游箱正在为您匹配发件人，当匹配到发件人，游箱会第一时间通知您！"
        let b = "游箱正在为您安排揽件人，当揽件人接到此单，游箱会第一时间通知您！"
        hintTextView.text = isForShipper ? a : b
    }
    
    private func setupUnderlineAndSharingLabel(){
        view.addSubview(underlineView)
        underlineView.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 120, width: 0, height: 1)
        
        view.addSubview(sharingTitle)
        sharingTitle.addConstraints(left: nil, top: underlineView.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 90, height: 20)
        sharingTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupShareStackView(){
        
        let w : CGFloat = 40, h : CGFloat = 40, l : CGFloat = 0
        let v1 = UIView(), v2 = UIView(), v3 = UIView(), v4 = UIView()
        
//        facebookButton.shareContent = facebookSharingContent
        
        v1.addSubview(wechatButton)
        v2.addSubview(momentButton)
        v3.addSubview(weiboButton)
        v4.addSubview(facebookButton)
        wechatButton.addConstraints(left: nil, top: v1.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        momentButton.addConstraints(left: nil, top: v2.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        weiboButton.addConstraints(left: nil, top: v3.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        facebookButton.addConstraints(left: nil, top: v4.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        wechatButton.centerXAnchor.constraint(equalTo: v1.centerXAnchor).isActive = true
        momentButton.centerXAnchor.constraint(equalTo: v2.centerXAnchor).isActive = true
        weiboButton.centerXAnchor.constraint(equalTo: v3.centerXAnchor).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: v4.centerXAnchor).isActive = true
        
        shareStackView = UIStackView(arrangedSubviews: [v1, v2, v3, v4])
        shareStackView.axis = .horizontal
        shareStackView.distribution = .fillEqually
        
        view.addSubview(shareStackView)
        shareStackView.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 40, topConstent: 0, rightConstent: 40, bottomConstent: 30, width: 0, height: h)
    }
    

    
}

