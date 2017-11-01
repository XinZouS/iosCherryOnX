//
//  OrderShipperPageCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation




extension OrdersShipperPageCell: OrdersSenderPageCellDelegate {
    
    override func dataListDidSet(){
        guard let data = dataList else { return }
        
        guard data.count > 0 else {
            collectionView.isHidden = true
            return
        }
        collectionView.isHidden = false

        let emptyPair = Pair(Trip(), []) // TODO: remove this, for testing only.
        self.pairList.append(emptyPair)
        for req in data {
            //TODO: should get data from Server, now fake data for testing:
            let matchTrip = Trip()
            let newPair = Pair(matchTrip, [req, req])
            self.pairList.append(newPair)
        }
        self.collectionView.reloadData()

    }
    
    // TODO: fetchRequest from Server!!
    override func fetchRequests() {
        
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
        
        
//        ApiServers.sharedInstance.fetchRequests { (requests: [Request]) in
//            self.dataList = requests
//            self.collectionView.reloadData()
//        }
    }

    
}
