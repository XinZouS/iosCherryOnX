//
//  OrdersLogBaseCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/4/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class OrdersSenderPageCell: OrdersBasePageCell {
    
    let cellIdOrderLogSenderCell = "cellIdOrderLogSenderCell"
    
    var dataSource: [TripOrder]? {
        didSet{
            setupCollectionViewHidden()
        }
    }
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        registerCollectionView()
        setupBackgroundButton()
        
        fetchRequests()
        setupCollectionViewHidden()
    }
    
    private func registerCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(OrderLogShipperCell.self, forCellWithReuseIdentifier: cellIdOrderLogSenderCell)
    }

    override func setupBackgroundButton(){
        let att = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        var str = NSAttributedString()
        str = NSAttributedString(string: "立刻去发货", attributes: att)
        backgroundLabel.text = "订单空空的，快去给亲友\n送点礼物表达思念吧！"
        backgroundButton.setAttributedTitle(str, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension OrdersSenderPageCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?[section].requests?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let tripOrder = dataSource?[indexPath.section], let reqs = tripOrder.requests else {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOrderLogSenderCell, for: indexPath) as! OrderLogSenderCell
        
        cell.ordersLogCtl = self.ordersLogCtl
        cell.request = reqs[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let currPage = dataSource?.count,
            let currItm = dataSource?[currPage - 1].requests?.count,
            isFetching == false else { return }
        
        let section = indexPath.section
        if section == currPage - 1, indexPath.item == currItm - 1 {
            fetchRequests()
        }
    }
    
}

extension OrdersSenderPageCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 100) // for each log item in one page
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

