//
//  TabTitleMenuBar++.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension TabTitleMenuBar {
    
    // scr
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        ordersLogController?.scrollToItemAt(num: indexPath.item)
    }
    
    func changeBarTitleForScrolling(atSender: Bool){
            let fountBold = UIFont.systemFont(ofSize: 16, weight: 1.6)
            let fountSmal = UIFont.systemFont(ofSize: 14)
            senderCell.titleLabel.font = atSender ? fountBold : fountSmal
            shipperCell.titleLabel.font = atSender ? fountSmal : fountBold
    }

    
}
