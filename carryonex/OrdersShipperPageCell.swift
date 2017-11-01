//
//  OrdersShipperPageCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/4/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class OrdersShipperPageCell : OrdersSenderPageCell {
    
    struct Pair {
        let trip     : Trip
        let requests : [Request]
        init(_ trp: Trip, _ reqs: [Request]) {
            self.requests = reqs
            self.trip = trp
        }
    }
    
    var pairList: [Pair] = []

    let cellIdOrderLogShipperHeader = "cellIdOrderLogShipperHeader"
    let cellIdOrderLogShipperCell   = "cellIdOrderLogShipperCell"
    let cellIdOrderLogShipperEmtpyCell = "cellIdOrderLogShipperEmtpyCell"
    
    override func registerCollectionView(){
        collectionView.register(OrderLogShipperCell.self, forCellWithReuseIdentifier: cellIdOrderLogShipperCell)
        collectionView.register(OrdersShipperHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellIdOrderLogShipperHeader)
        collectionView.register(OrdersLogShipperEmptyCell.self, forCellWithReuseIdentifier: cellIdOrderLogShipperEmtpyCell)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return pairList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let n = pairList[section].requests.count
        return n == 0 ? 1 : n // 1 is for displaying an empty cell as hint for user
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let pair = pairList[indexPath.section]

        if pair.requests.count == 0 { // display an empty cell as hint for user
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOrderLogShipperEmtpyCell, for: indexPath) as! OrdersLogShipperEmptyCell
            cell.ordersLogCtl = self.ordersLogCtl
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOrderLogShipperCell, for: indexPath) as! OrderLogShipperCell
            cell.request = pair.requests[indexPath.item]
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
