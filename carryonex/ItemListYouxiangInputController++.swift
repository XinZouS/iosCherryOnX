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
        let ItemTypeListCtl = ItemTypeListController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(ItemTypeListCtl, animated: true)
    }
}
