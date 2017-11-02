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
    
    func dataListDidSet(){
        guard let data = dataSource, data.count > 0 else {
            collectionView.isHidden = true
            return
        }
        
        collectionView.isHidden = false
    }

    
    func fetchRequests() {
        print("fetchRequests in OrdersSenderPageCell++")
        
        ApiServers.shared.getUsersTrips(userType: .sender, offset: 0, pageCount: 4) { (tripOrders, error) in
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            
            self.dataSource = tripOrders
        }
        
        /*
        let r0 = Request.fakeRequestDemo()
        r0.cost = 300.65

        let r1 = Request.fakeRequestDemo()
        r1.cost = 12.65
        
        let r2 = Request.fakeRequestDemo()
        r2.statusId = RequestStatus.shipping.rawValue
        r2.cost = 80.25
        
        let r3 = Request.fakeRequestDemo()
        r3.statusId = RequestStatus.finished.rawValue
        r3.cost = 6.20
        
        let r4 = Request.fakeRequestDemo()
        r4.statusId = RequestStatus.shipping.rawValue
        r4.cost = 90.80
        
        let r5 = Request.fakeRequestDemo()
        r5.statusId = RequestStatus.finished.rawValue
        r5.cost = 650.80
        
        let fakeRequests = [r0, r1, r2, r3, r4, r5]
        self.dataList = [] //fakeRequests
        */
        
//        ApiServers.sharedInstance.fetchRequests { (requests: [Request]) in
//            self.dataList = requests
//            self.collectionView.reloadData()
//        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let ordersDetailPage = OrderDetailPage(collectionViewLayout: layout)
            ordersLogCtl.navigationController?.pushViewController(ordersDetailPage, animated: true)
    }
    
    func fetchOrdersLogList(){
        print("TODO: fetchOrdersLogList from server, OrdersLogPageCell.fetchOrdersLogList() !!!!!")
    }
    
    func updateUIContentsForRequestsList(){
        print("TODO: updateUIContentsForRequestsList [..] ...")
    }
    
    func backgroundButtonTapped(){
        guard let id = self.reuseIdentifier else { return }
        if id == ordersLogCtl.cellIdSenderPage {
            ordersLogCtl.navigationController?.pushViewController(ItemListYouxiangInputController(), animated: true)
        }else{
            let postTripCtl = PostTripController(collectionViewLayout: UICollectionViewFlowLayout())
            ordersLogCtl.navigationController?.pushViewController(postTripCtl, animated: true)
        }

    }
    
}
