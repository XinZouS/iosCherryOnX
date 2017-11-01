//
//  OrdersShipperPageCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/4/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class OrdersShipperPageCell : OrdersSenderPageCell {
    
//    struct Pair {
//        let trip     : Trip
//        let requests : [Request]
//        init(_ trp: Trip, _ reqs: [Request]) {
//            self.requests = reqs
//            self.trip = trp
//        }
//    }
//    
//    var pairList: [Pair] = []

    let cellIdOrderLogShipperHeader = "cellIdOrderLogShipperHeader"
    let cellIdOrderLogShipperCell   = "cellIdOrderLogShipperCell"
    let cellIdOrderLogShipperEmtpyCell = "cellIdOrderLogShipperEmtpyCell"
    
    override func registerCollectionView(){
        collectionView.register(OrderLogShipperCell.self, forCellWithReuseIdentifier: cellIdOrderLogShipperCell)
        collectionView.register(OrdersShipperHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellIdOrderLogShipperHeader)
        collectionView.register(OrdersLogShipperEmptyCell.self, forCellWithReuseIdentifier: cellIdOrderLogShipperEmtpyCell)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataSource?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let tripOrder = dataSource?[section], let req = tripOrder.requests {
            return req.count
        }
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40)
    }
    
}
