//
//  UserGuideController++.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

extension UserGuideController {
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let itemsSum = CGFloat(tabTitleMenuBar.titleList.count)
        let deltaX = view.bounds.width / itemsSum * 0.5
        tabTitleMenuBar.barViewCenterXConstraint.constant = scrollView.contentOffset.x / itemsSum + deltaX
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let xItem = Int(targetContentOffset.pointee.x / view.bounds.width)
        let indexPath = IndexPath(item: xItem, section: 0)
        tabTitleMenuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        changeBarTitleTo(isSender: indexPath.item == 0)
    }

    func scrollToItemAt(num: Int){
        let indexPath = IndexPath(item: num, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        changeBarTitleTo(isSender: num == 0)
    }
    
    private func changeBarTitleTo(isSender: Bool){
        tabTitleMenuBar.changeBarTitleForScrolling(atSender: isSender)
    }


}
