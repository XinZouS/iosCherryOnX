//
//  ItemListYouxiangInputController++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/27.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

extension ItemListYouxiangInputController {
    
    func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func okButtonTapped(){
        
        guard let youxiangNumber = youxiangField.text else {
            displayAlert(title: "游箱号为空", message: "请输入游箱号", action: "好")
            return
        }
        
        ApiServers.shared.getTripInfo(id: youxiangNumber) { (success, trip, error) in
            
            if !success && error == nil {
                self.displayAlert(title: "查无此邮箱", message: "请输入游箱号", action: "好")
                return
            }
            
            if let error = error {
                self.displayAlert(title: "获取游箱错误", message: "错误: \(error.localizedDescription)", action: "好")
                return
            }
            
            if trip != nil {
                let itemTypeListCtl = ItemTypeListController(collectionViewLayout: UICollectionViewFlowLayout())
                itemTypeListCtl.trip = trip
                self.navigationController?.pushViewController(itemTypeListCtl, animated: true)
            }
        }
        
    }
}
