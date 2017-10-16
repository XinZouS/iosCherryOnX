//
//  UserGuideController.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class UserGuideController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let userGuidePageCellSenderId = "userGuidePageCellSenderId"
    let userGuidePageCellShipperId = "userGuidePageCellShipperId"

    let tabTitleMenuBarHeight : CGFloat = 40
    let tabTitleMenuBar = TabTitleMenuBar()
    
    let faqs = ["如何接单","计费标准","认证与个人资料","如何提交身份认证"]
    let titlesShipper = ["订单与行程","如何取消订单","运费到账时间","账号与信息","时效","安全与控诉"]
    let titlesSender  = ["订单与行程","物品类型","如何取消订单","支付与账户","账号与信息","时效","安全与控诉"]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabMenuBar()
        setupCollectonView()
    }
    
    private func setupTabMenuBar(){
        view.addSubview(tabTitleMenuBar)
        tabTitleMenuBar.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: tabTitleMenuBarHeight)
        
        tabTitleMenuBar.userGuideController = self
    }
    
    private func setupCollectonView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 5
        }
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsetsMake(tabTitleMenuBarHeight, 0, 0, 0) // top, left, bottom, right
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(tabTitleMenuBarHeight, 0, 0, 0)
        // !!!!!! constraints will NOT working for this collectionView...why??? setup in childViews.
        //collectionView?.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        collectionView?.register(UserGuidePageCell.self, forCellWithReuseIdentifier: userGuidePageCellSenderId)
        collectionView?.register(UserGuidePageCell.self, forCellWithReuseIdentifier: userGuidePageCellShipperId)
        collectionView?.isPagingEnabled = true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitleMenuBar.titleList.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UserGuidePageCell()
        if indexPath.item == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: userGuidePageCellSenderId, for: indexPath) as! UserGuidePageCell
            cell.titles = [faqs, titlesSender]
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: userGuidePageCellShipperId, for: indexPath) as! UserGuidePageCell
            cell.titles = [faqs, titlesShipper]
        }
        cell.backgroundColor = .white
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    

    
}


