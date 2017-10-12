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
        ordersLogController.scrollToItemAt(num: indexPath.item)
    }
    
    
}
