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
    func putItemCategoryInfo(){
        for (key,value) in request.numberOfItem{
            let showContent = UILabel()
            switch key{
            case "Mail":
                showContent.text = "邮件 X \(value)"
                contentStackView.addArrangedSubview(showContent)
            case "Clothes":
                showContent.text = "衣服 X \(value)"
                contentStackView.addArrangedSubview(showContent)
            case "Shoes":
                showContent.text = "鞋子 X \(value)"
                contentStackView.addArrangedSubview(showContent)
            case "Handbag":
                showContent.text = "手包 X \(value)"
                contentStackView.addArrangedSubview(showContent)
            case "Food":
                showContent.text = "食物 X \(value)"
                contentStackView.addArrangedSubview(showContent)
            case "Health Care":
                showContent.text = "药品 X \(value)"
                contentStackView.addArrangedSubview(showContent)
            case "Electronics":
                showContent.text = "电子产品 X \(value)"
                contentStackView.addArrangedSubview(showContent)
            case "Cosmetics":
                showContent.text = "化妆品 X \(value)"
                contentStackView.addArrangedSubview(showContent)
            case "Jewelry":
                showContent.text = "首饰 X \(value)"
                contentStackView.addArrangedSubview(showContent)
            default:
                break;
            }
        }
    }
}

extension PaymentController {
    
    
    func paymentSelectedByCheckbox(){
        print("paymentSelectedByCheckbox !!!!!!!!")
    }
    
    func okButtonTapped(){
        print("okButtonTapped!!!!")
        ApiServers.shared.sentOrderInformation(address: request.destinationAddress!)
        let waitingCtl = WaitingController()
        waitingCtl.isForShipper = false
        
        // TODO: how to dismiss current page and present the new waitingCtl ????
//        present(waitingCtl, animated: true)
        
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

