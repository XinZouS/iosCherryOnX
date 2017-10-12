//
//  OrdersShipperPageCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/4/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class OrdersShipperPageCell : OrdersSenderPageCell {
    
    let cellIdOrderLogShipperCell = "cellIdOrderLogShipperCell"
    
    override func registerCollectionView(){
        collectionView.register(OrderLogShipperCell.self, forCellWithReuseIdentifier: cellIdOrderLogShipperCell)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOrderLogShipperCell, for: indexPath) as! OrderLogShipperCell
        
        if indexPath.item < (dataList?.count)! {
            cell.request = dataList?[indexPath.item]
        }
        
        return cell
    }

}
