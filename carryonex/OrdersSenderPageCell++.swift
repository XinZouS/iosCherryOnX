//
//  OrdersSenderPageCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension OrdersSenderPageCell {
    
    
    func registerCollectionView(){
        collectionView.register(OrderLogSenderCell.self, forCellWithReuseIdentifier: cellIdOrderLogSenderCell)
    }
    
    func fetchRequests() {
        print("fetchRequests in OrdersSenderPageCell++")
        
        let r0 = Request.fakeRequestDemo()
        r0.cost = 300.65

        let r1 = Request.fakeRequestDemo()
        r1.cost = 12.65
        
        let r2 = Request.fakeRequestDemo()
        r2.status = RequestStatus.shipping.rawValue
        r2.cost = 80.25
        
        let r3 = Request.fakeRequestDemo()
        r3.status = RequestStatus.finished.rawValue
        r3.cost = 6.20
        
        let r4 = Request.fakeRequestDemo()
        r4.status = RequestStatus.shipping.rawValue
        r4.cost = 90.80
        
        let r5 = Request.fakeRequestDemo()
        r5.status = RequestStatus.finished.rawValue
        r5.cost = 650.80
        
        let fakeRequests = [r0, r1, r2, r3, r4, r5]
        self.dataList = fakeRequests
        
        
//        ApiServers.sharedInstance.fetchRequests { (requests: [Request]) in
//            self.dataList = requests
//            self.collectionView.reloadData()
//        }
    }
    
    func fetchOrdersLogList(){
        print("TODO: fetchOrdersLogList from server, OrdersLogPageCell.fetchOrdersLogList() !!!!!")
    }
    
    
    
    func updateUIContentsForRequestsList(){
        print("TODO: updateUIContentsForRequestsList [..] ...")
    }
    
    
}
