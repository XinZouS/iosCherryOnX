//
//  OrderShipperPageCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

extension OrdersShipperPageCell {
    
    override func dataListDidSet(){
        
        guard let data = dataSource, data.count > 0 else {
            collectionView.isHidden = true
            return
        }
        
        collectionView.isHidden = false
        
        self.collectionView.reloadData()
    }
    
    override func fetchRequests() {
        
        ApiServers.shared.getUsersTrips(userType: .carrier, offset: 0, pageCount: 4) { (tripOrders, error) in
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            
            self.dataSource = tripOrders
            
//            if let tripOrders = tripOrders {
//                for order in tripOrders {
//                    print("Trip: \(order.trip)")
//                    print("Requests: \(order.requests!)")
//                }
//            } else {
//                print("Trip order is nil")
//            }
        }
        
        /*
        let r1 = Request.fakeRequestDemo()
        r1.cost = 30.25
        
        let r2 = Request.fakeRequestDemo()
        r2.statusId = RequestStatus.shipping.rawValue
        r2.cost = 60.88
        
        let r3 = Request.fakeRequestDemo()
        r3.statusId = RequestStatus.finished.rawValue
        r3.cost = 160.55
        
        let r4 = Request.fakeRequestDemo()
        r4.cost = 9.8
        
        //let fakeRequests = [r1, r2, r3, r4]
        self.dataList = []
        */
        
//        ApiServers.sharedInstance.fetchRequests { (requests: [Request]) in
//            self.dataList = requests
//            self.collectionView.reloadData()
//        }
    }

    
}
