//
//  ItemTypeListController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/19/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension ItemTypeListController {
    
    
    func setupNavigationBar(){
        navigationItem.title = "货物清单"
        
        let barBtn = UIBarButtonItem(title: "确认清单", style: .plain, target: self, action: #selector(submitButtonTapped))
        navigationItem.rightBarButtonItem = barBtn
    }

    func submitButtonTapped(){
        guard submitButton.isEnabled == true else {
            showAlertFromItemTypeListController()
            return
        }
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        
        

        updateRequestItemNumber() /// count by ItemIdEnums

        let requestCtl = RequestController(collectionViewLayout: layout)
        requestCtl.costByItem = 16.66
        requestCtl.request = self.request
        navigationController?.pushViewController(requestCtl, animated: true)
    }
    
    private func updateRequestItemNumber(){
        for item in itemCategoryList {
            guard item.count > 0, let nameEn = item.nameEN else { continue }
            self.request.numberOfItem[nameEn] = item.count
        }
        print("now get items: ", self.request.numberOfItem)
    }
    

    
    // do this in viewDidLoad()
    internal func addItemTypesToList(){
        print("TODO: addItemTypesToList from Server, now use fake data.")
        self.itemCategoryList = ItemCategory.sharedInstance.getFullList()
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
    
    func displayAlert(title: String, message: String, action: String) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        v.addAction(action)
        present(v, animated: true, completion: nil)
    }
    
}

