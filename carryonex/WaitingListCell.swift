//
//  WaitingListCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/23.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit


class WaitingListCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var waitingListCtl : WaitingListController!
    let cellIdOrderLogSenderCell = "cellIdOrderLogSenderCell"
    
    var dataList: [Request]?
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .white
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupCollectionViewPage()
    }
    
    func setupCollectionViewPage(){
        addSubview(collectionView)
        collectionView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 60, rightConstent: 0, bottomConstent: 60, width: 0, height: 0)
    }
    
    
    /// - MARK: collectionView delegate, for page container
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOrderLogSenderCell, for: indexPath) as! OrderLogSenderCell
        
        if indexPath.item < (dataList?.count)! {
            cell.request = dataList?[indexPath.item]
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 100) // for each log item in one page
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

