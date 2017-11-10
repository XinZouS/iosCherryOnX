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
        _ = youxiangField.resignFirstResponder()
    }
    
    func okButtonTapped(){
        
        guard let youxiangNumber = youxiangField.text else {
            displayAlert(title: "游箱号为空", message: "请输入游箱号", action: "好")
            return
        }
        okButton.isEnabled = false // not allow user tap too much
        
        ApiServers.shared.getTripInfo(id: youxiangNumber) { (success, trip, error) in
            
            if !success && error == nil {
                self.displayAlert(title: "查无此邮箱", message: "请输入游箱号", action: "好")
                self.okButton.isEnabled = true
                return
            }
            
            if let error = error {
                self.displayAlert(title: "获取游箱错误", message: "错误: \(error.localizedDescription)", action: "好")
                self.okButton.isEnabled = true
                return
            }
            
            if trip != nil {
                self.okButton.isEnabled = false
                
                let layout = UICollectionViewFlowLayout()
                layout.scrollDirection = .vertical
                layout.minimumLineSpacing = 1
                
                let requestCtl = RequestController(collectionViewLayout: layout)
                requestCtl.trip = trip
                self.navigationController?.pushViewController(requestCtl, animated: true)
            }
        }
        
    }
}
