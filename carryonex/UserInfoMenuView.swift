//
//  UserInfoMenuView.swift
//  carryonex
//
//  Created by Xin Zou on 10/14/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class UserInfoMenuView : UIView {
    
    var homePageCtl : HomePageController? {
        didSet{
            userProfileView.homePageCtl = self.homePageCtl!
        }
    }
    
    internal let titles : [String] = ["钱包","订单","客服","设置","游票兑换"]
    internal let icons  : [UIImage] = [#imageLiteral(resourceName: "carryonex_wallet"), #imageLiteral(resourceName: "carryonex_sheet"), #imageLiteral(resourceName: "carryonex_customerServers"), #imageLiteral(resourceName: "carryonex_setting"), #imageLiteral(resourceName: "carryonex_youpiao")]
    
    internal let userInfoCellId = "userInfoCellId"
    
    private let userProfileH: CGFloat = 160
    
    internal let userProfileView = UserProfileView()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .white
        v.delegate = self
        v.dataSource = self
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        setupProfileView()
        setupCollectionView()
        
    }
    
    private func setupProfileView(){
        addSubview(userProfileView)
        userProfileView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: userProfileH)
    }
    
    private func setupCollectionView(){
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
        collectionView.isScrollEnabled = false
        collectionView.isPagingEnabled = false
        collectionView.register(UserInfoViewCell.self, forCellWithReuseIdentifier: userInfoCellId)
        
        let margin : CGFloat = 30
        addSubview(collectionView)
        collectionView.addConstraints(left: leftAnchor, top: userProfileView.bottomAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: margin, rightConstent: 0, bottomConstent: margin, width: 0, height: 0)
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// UICollectionViewDelegates
extension UserInfoMenuView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userInfoCellId, for: indexPath) as! UserInfoViewCell
        cell.titleLabel.text = titles[indexPath.item]
        cell.imageView.image = icons[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = self.bounds.width
        return CGSize(width: w, height: 50)
    }
    
}

