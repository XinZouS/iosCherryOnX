//
//  OrderDetailPage.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/17.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit



class OrderDetailPage: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var request = Request()
    
    let DetailUserNameCelId = "DetailUserNameCelId"
    let DetailCreditLevelCellId = "DetailCreditLevelCellId"
    let DetailItemPictureCellId = "DetailItemPictureCellId"
    let DetailItemDetailCellId = "DetailItemDetailCellId"
    let DetailGetLocationCellId = "DetailGetLocationCellId"
    let DetailSentLocationCellId = "DetailSentLocationCellId"
    let DetailPriceCellId = "DetailPriceCellId"
    let DetailButtonCellId = "DetailButtonCellId"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request.numberOfItem.removeAll() // reset NumOfItems in the current Request
    }
    
    
    private func setupNavigationBar(){
        title = "订单详情"
        UINavigationBar.appearance().tintColor = buttonColorWhite
        navigationController?.navigationBar.tintColor = buttonColorWhite
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: buttonColorWhite]
    }
    
    private func setupCollectionView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 1
        }
        collectionView?.backgroundColor = .white
        
        // reset content area: UIEdgeInsetsMake(top, left, bottom, right)
        //collectionView?.contentInset = UIEdgeInsetsMake(0, 20, 50, 20) // replaced by constraints:
        let w : CGFloat = UIScreen.main.bounds.width < 325 ? 20 : 30
        collectionView?.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: w, topConstent: 10, rightConstent: w, bottomConstent: 40, width: 0, height: 0)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(DetailUserNameCell.self, forCellWithReuseIdentifier: DetailUserNameCelId)
        collectionView?.register(DetailUserNameCell.self, forCellWithReuseIdentifier: DetailCreditLevelCellId)
        collectionView?.register(DetailUserNameCell.self, forCellWithReuseIdentifier: DetailItemPictureCellId)
        collectionView?.register(DetailUserNameCell.self, forCellWithReuseIdentifier: DetailItemDetailCellId)
        collectionView?.register(DetailUserNameCell.self, forCellWithReuseIdentifier: DetailGetLocationCellId)
        collectionView?.register(DetailUserNameCell.self, forCellWithReuseIdentifier: DetailSentLocationCellId)
        collectionView?.register(DetailUserNameCell.self, forCellWithReuseIdentifier: DetailPriceCellId)
        collectionView?.register(DetailUserNameCell.self, forCellWithReuseIdentifier: DetailButtonCellId)
        collectionView?.isScrollEnabled = true
    }
    
    /// collectionView delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellId : String = DetailUserNameCelId
        switch indexPath.item{
        case 1:
            cellId = DetailCreditLevelCellId
        case 2:
            cellId = DetailItemPictureCellId
        case 3:
            cellId = DetailItemDetailCellId
        case 4:
            cellId = DetailGetLocationCellId
        case 5:
            cellId = DetailSentLocationCellId
        case 6:
            cellId = DetailPriceCellId
        case 7:
            cellId = DetailButtonCellId
        default:
            cellId = DetailUserNameCelId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DetailUserNameCell
        cell.orderDetailPage = self
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.width
        let h : CGFloat = 50
        
        switch indexPath.item {
        case 0:
            return CGSize(width: w, height: 100)
        case 1:
            return CGSize(width: w, height: 50)
        case 2:
            return CGSize(width: w, height: 200)
        case 3:
            return CGSize(width: w, height: 50)
        case 4:
            return CGSize(width: w, height: 50)
        case 5:
            return CGSize(width: w, height: 100)
        case 6:
            return CGSize(width: w, height: 50)
        default:
            return CGSize(width: w, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

}
