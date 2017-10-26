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
    
    var pairList = [Pair]()

        
    let cellIdOrderLogShipperHeader = "cellIdOrderLogShipperHeader"
    let cellIdOrderLogShipperCell = "cellIdOrderLogShipperCell"
    
    override func registerCollectionView(){
        collectionView.register(OrderLogShipperCell.self, forCellWithReuseIdentifier: cellIdOrderLogShipperCell)
        collectionView.register(OrdersShipperHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: cellIdOrderLogShipperHeader)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return pairList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if pairList.count == 0 {
            return 0
        }else{
            return pairList[section].requests.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOrderLogShipperCell, for: indexPath) as! OrderLogShipperCell
        
        let pair = pairList[indexPath.section]
        for req in pair.requests {
            cell.request = req
        }

        return cell
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
