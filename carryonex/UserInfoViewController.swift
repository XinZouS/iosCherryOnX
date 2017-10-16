//
//  UserInfoView.swift
//  carryonex
//
//  Created by Xin Zou on 8/10/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

 


class UserInfoViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let contents: [String] = ["订单记录","我的钱包","邀请好友","计费标准","需要帮助"]
    
    private let userInfoCellId = "userInfoCellId"
    
    private let userProfileH: CGFloat = 160
    
    internal let userProfileView = UserProfileView()
    
    //internal let activityIndicator = UIActivityIndicatorCustomizeView()
    
    
    private let margin: CGFloat = 40
    
    lazy var logoutButton: UIButton = {
        let b = UIButton()
        b.setTitle("退出登陆", for: .normal)
        b.setImage( UIImage.init(named: "CarryonEx_Exit.png"), for: .normal)
        b.imageView?.contentMode = .scaleAspectFit
        //b.backgroundColor = buttonColorRed
        b.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        return b
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarItems()
        
        setupCollectionView()
        
        setupUserProfileView()
        
        setupLogoutButton()
        
        //setupActivityIndicatorCustomizeView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        User.shared.saveIntoLocalDisk()
    }
    
    
    private func setupNavigationBarItems(){
        title = "我的帐户"
        let leftBackBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "CarryonEx_Back"), style: .plain, target: self, action: #selector(dismissSelfToLeft))
        navigationItem.setLeftBarButton(leftBackBtn, animated: false)
    }
    
    private func setupCollectionView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsetsMake(userProfileH + 30, margin, 50, margin) // top, left, bottom, right;
        collectionView?.isScrollEnabled = false
        collectionView?.isPagingEnabled = false
        
        collectionView?.register(UserInfoViewCell.self, forCellWithReuseIdentifier: userInfoCellId)
    }
    
    private func setupUserProfileView(){
        view.addSubview(userProfileView)
        userProfileView.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: userProfileH)
        userProfileView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        userProfileView.userInfoViewCtl = self
    }
    
    private func setupLogoutButton(){
        view.addSubview(logoutButton)
        logoutButton.addConstraints(left: view.leftAnchor, top: nil, right: nil, bottom: view.bottomAnchor, leftConstent: 15, topConstent: 0, rightConstent: 0, bottomConstent: 5, width: 30, height: 30)
    }

//    private func setupActivityIndicatorCustomizeView(){
//        view.addSubview(activityIndicator)
//        activityIndicator.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 60, height: 60)
//        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        activityIndicator.stopAnimating()
//    }
     
    
    
    // MARK: CollectionView delegate
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contents.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userInfoCellId, for: indexPath) as! UserInfoViewCell
        cell.titleLabel.text = contents[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = UIScreen.main.bounds.width - (margin * 2)
        let h: CGFloat = 50
        return CGSize(width: w, height: h)
    }
    
        
    
    
}


