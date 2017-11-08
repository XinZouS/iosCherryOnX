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
        
        ApiServers.shared.getUsersTrips(userType: .sender, offset: 0, pageCount: 4) { (tripOrders, error) in
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }

            self.dataSource = tripOrders
        }
        
//        let r0 = Request.fakeRequestDemo()
//        r0.cost = 300.65
//
//        let r1 = Request.fakeRequestDemo()
//        r1.cost = 12.65
//
//        let r2 = Request.fakeRequestDemo()
//        r2.statusId = RequestStatus.shipping.rawValue
//        r2.cost = 80.25
//
//        let r3 = Request.fakeRequestDemo()
//        r3.statusId = RequestStatus.finished.rawValue
//        r3.cost = 6.20
//
//        let r4 = Request.fakeRequestDemo()
//        r4.statusId = RequestStatus.shipping.rawValue
//        r4.cost = 90.80
//
//        let r5 = Request.fakeRequestDemo()
//        r5.statusId = RequestStatus.finished.rawValue
//        r5.cost = 650.80
//
//        let t0 = TripOrder(trip: Trip(), requests: [r0])
//        let t1 = TripOrder(trip: Trip(), requests: [r1])
//        let t2 = TripOrder(trip: Trip(), requests: [r2])
//        let t3 = TripOrder(trip: Trip(), requests: [r3])
//        let t4 = TripOrder(trip: Trip(), requests: [r4])
//        let t5 = TripOrder(trip: Trip(), requests: [r5])
//
//        self.dataSource = [t0, t1, t2, t3, t4, t5]
//
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
