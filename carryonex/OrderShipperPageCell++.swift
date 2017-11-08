//
//  OrderShipperPageCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

extension OrdersShipperPageCell {
    
    func fetchRequests() {
        
//        ApiServers.shared.getUsersTrips(userType: .carrier, offset: 0, pageCount: 4) { (tripOrders, error) in
//            if let error = error {
//                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
//                return
//            }
//            self.dataSource = tripOrders
//        }
        
        
        ///TODO: remove these fake data before launch, now keep it for empty cell testing;
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
        
        let a1 = Address(country: .UnitedStates, state: "NY", city: "New York", detailAddress: "bala bala~~", zipCode: "10001", recipient: "ZhangSan", phoneNum: "012345688")
        let a2 = Address(country: .China, state: "GuangDong", city: "GuangZhou", detailAddress: "Ke cun", zipCode: "510006", recipient: "Micle", phoneNum: "0987655432")
        
        let p1 = Trip()
        p1.tripCode = "66888"
        p1.startAddress = a1
        p1.endAddress = a2
        
        let p2 = Trip()
        p2.tripCode = "23333"
        p2.startAddress = a2
        p2.endAddress = a1
        
        let t1 = TripOrder(trip: p1, requests: [])
        let t2 = TripOrder(trip: p2, requests: [r1])
        let t3 = TripOrder(trip: Trip(), requests: [r2, r3, r4])

        self.dataSource = [t1, t2, t3]
//        self.dataSource = []
 
    }
    
    public func setupCollectionViewHidden(){
        guard let data = dataSource, data.count > 0 else {
            collectionView.isHidden = true
            return
        }
        collectionView.isHidden = false
    }
    

    override func backgroundButtonTapped() {
        let postTripCtl = PostTripController(collectionViewLayout: UICollectionViewFlowLayout())
        ordersLogCtl.navigationController?.pushViewController(postTripCtl, animated: true)
    }

    
}
