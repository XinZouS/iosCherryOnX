//
//  PaymentController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/27/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



/// MARK: collection delegate

extension PaymentController {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return payments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: paymentCellId, for: indexPath) as! PaymentCell
        cell.paymentController = self
        cell.iconImageView.image = paymentIcons[indexPath.item]
        cell.titleLabel.text = paymentTitles[indexPath.item]
        cell.payment = payments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.width
        let h: CGFloat = 50
        return CGSize(width: w, height: h)
    }
    
    // for selection on collectionView
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PaymentCell {
            print("select payment: \(cell.payment)")
//            cell.checkbox.isSelected = true
            cell.checkbox.setCheckState(.checked, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PaymentCell {
            print("deselect!!! payment: \(cell.payment)")
//            cell.checkbox.isSelected = false
            cell.checkbox.setCheckState(.unchecked, animated: true)
        }
    }
}

extension PaymentController {
    
    func paymentSelectedByCheckbox(){
        print("paymentSelectedByCheckbox !!!!!!!!")
    }
    
    func okButtonTapped(){
        print("okButtonTapped!!!!")
        
        if let endAddress = request.endAddress {
            ApiServers.shared.sentOrderInformation(address: endAddress)
        }
        
        let waitingCtl = WaitingController()
        waitingCtl.isForShipper = false
        
        // paging transition animation for waitingController
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.navigationController?.view.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.pushViewController(waitingCtl, animated: false)
    }
    
    
}

