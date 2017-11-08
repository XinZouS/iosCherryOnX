//
//  OrdersSenderPageCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

extension OrdersSenderPageCell {
        
    func fetchRequests() {
        
        guard isFetching == false else { return }
        
        let currPage = dataSource?.count ?? 0
        let requPage = 4
        
        isFetching = true
        ApiServers.shared.getUsersTrips(userType: .sender, offset: currPage, pageCount: requPage) { (tripOrders, error) in
            
            self.isFetching = false
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            if let tripOrders = tripOrders {
                self.dataSource == nil ? self.dataSource = tripOrders : self.dataSource?.append(contentsOf: tripOrders as [TripOrder])
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                })
            }
        }        
    }
    
    public func setupCollectionViewHidden(){
        guard let data = dataSource, data.count > 0 else {
            collectionView.isHidden = true
            return
        }
        collectionView.isHidden = false
    }
    

    override func backgroundButtonTapped(){
        ordersLogCtl.navigationController?.pushViewController(ItemListYouxiangInputController(), animated: true)
    }
    
}
