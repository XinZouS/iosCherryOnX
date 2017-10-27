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
        guard let data = dataList, data.count > 0 else { return }
        for req in data {
//            let tId = req.tripId ?? ""
//            ApiServers.shared.getTrips(queryRoute: .infoById, query: tId, query2: nil, completion: { (msg, getTrips) in
//                if let matchTrip = getTrips?.first as? Trip {
//                    let newPair = Pair(matchTrip, [req])
//                    self.pairList.append(newPair)
//                }
//            })
            // fake data for testing:
            let matchTrip = Trip()
            let newPair = Pair(matchTrip, [req, req])
            self.pairList.append(newPair)
        }
        self.collectionView.reloadData()
//        DispatchQueue.main.async {
//
//        }
    }
    
    override func fetchRequests() {
        print("fetchRequests in OrdersShipperPageCell++")
        
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
        
        let fakeRequests = [r1, r2, r3, r4]
        self.dataList = fakeRequests
        
        
//        ApiServers.sharedInstance.fetchRequests { (requests: [Request]) in
//            self.dataList = requests
//            self.collectionView.reloadData()
//        }
    }

    
    
}
