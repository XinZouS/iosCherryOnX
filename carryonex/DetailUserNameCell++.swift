//
//  DetailUserNameCell++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

extension DetailUserNameCell{
    func senderImgBtnTapped(){
        let orderDetailCommentPageCtl = OrderDetailCommentPageController(collectionViewLayout: UICollectionViewFlowLayout())
        orderDetailPage?.navigationController?.pushViewController(orderDetailCommentPageCtl, animated: true)
    }
}
