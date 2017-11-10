//
//  ItemTypeListController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/19/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

extension ItemTypeListController {
    
    func submitButtonTapped(){
        guard submitButton.isEnabled else {
            showAlertFromItemTypeListController()
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1

        let requestCtl = RequestController(collectionViewLayout: layout)
        requestCtl.costByItem = 16.66
        requestCtl.request = self.request
        navigationController?.pushViewController(requestCtl, animated: true)
    }
    
    func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // do this in viewDidLoad()
    internal func addItemTypesToList(){
        print("TODO: addItemTypesToList from Server, now use fake data.")
        self.itemCategoryList = CategoryManager.shared.getFullList()
    }
}


// MARK: - Pop alert view
extension ItemTypeListController {
    
    func showAlertFromItemTypeListController(){
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.showAlertFromPhotoIdAfterDelay), userInfo: nil, repeats: false)
    }
    
    internal func showAlertFromPhotoIdAfterDelay(){
        DispatchQueue.main.async {
            let msg = "请选择至少一个货物数量来发送"
            self.displayAlert(title: "❗️您还没选货物呢", message: msg, action: "朕知道了")
        }
    }
}

