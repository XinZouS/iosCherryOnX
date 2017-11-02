//
//  OrdersShipperPageCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/4/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class OrdersShipperPageCell : OrdersBasePageCell {
    
    let cellIdOrderLogShipperHeader = "cellIdOrderLogShipperHeader"
    let cellIdOrderLogShipperCell   = "cellIdOrderLogShipperCell"
    let cellIdOrderLogShipperEmtpyCell = "cellIdOrderLogShipperEmtpyCell"
    
    
    var dataSource: [TripOrder]? {
        didSet{
            setupCollectionViewHidden()
        }
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        registerCollectionView()
        setupBackgroundButton()
        
        fetchRequests()
    }
    
    private func registerCollectionView(){
        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.register(OrderLogShipperCell.self, forCellWithReuseIdentifier: cellIdOrderLogShipperCell)
        collectionView.register(OrdersShipperHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellIdOrderLogShipperHeader)
        collectionView.register(OrdersLogShipperEmptyCell.self, forCellWithReuseIdentifier: cellIdOrderLogShipperEmtpyCell)
    }
    
    override func setupBackgroundButton(){
        let att = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        var str = NSAttributedString()
        str = NSAttributedString(string: "出发看世界", attributes: att)
        backgroundLabel.text = "行程空空的哪都没去呢，\n世界这么大，难道不想去看看吗？"
        
        backgroundButton.setAttributedTitle(str, for: .normal)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



extension OrdersShipperPageCell: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tripOrder = dataSource?[section], let req = tripOrder.requests {
            return (req.count > 0) ? req.count : 1
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let tripOrder = dataSource?[indexPath.section], let reqs = tripOrder.requests else {
            return UICollectionViewCell()
        }
        
        if reqs.count == 0 { // display an empty cell as hint for user
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOrderLogShipperEmtpyCell, for: indexPath) as! OrdersLogShipperEmptyCell
            cell.ordersLogCtl = self.ordersLogCtl
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOrderLogShipperCell, for: indexPath) as! OrderLogShipperCell
            cell.request = reqs[indexPath.row]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: cellIdOrderLogShipperHeader, for: indexPath)
            return header
        }else{
            return UICollectionReusableView()
        }
    }
    
}


extension OrdersShipperPageCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 100) // for each log item in one page
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
}
