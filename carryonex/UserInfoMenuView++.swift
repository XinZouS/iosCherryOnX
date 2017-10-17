//
//  UserInfoMenuView++.swift
//  carryonex
//
//  Created by Xin Zou on 10/15/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

extension UserInfoMenuView {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.homePageCtl?.userInfoMenuViewAnimateHide()
        // titles : [String] = ["钱包","订单","客服","设置","游票兑换"]
        switch indexPath.item {
        case 0:
            let walletCtl = WalletController()
            let walletNav = UINavigationController(rootViewController: walletCtl)
            self.homePageCtl?.present(walletNav, animated: true)
            walletNav.title = titles[indexPath.item]

        case 1:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let ordersLogCtl = OrdersLogController(collectionViewLayout: layout)
            let ordersNav = UINavigationController(rootViewController: ordersLogCtl)
            self.homePageCtl?.present(ordersNav, animated: true)
            
        case 2:
            print("TODO: open 客服 page...")
            let inviteFriendCtl = InviteFriendController()
            self.homePageCtl?.present(inviteFriendCtl, animated: true)
            
        case 3:
            let userSettingCtl = UserSettingController()
            userSettingCtl.userProfileView = self.userProfileView
            let settingNavigationCtl = UINavigationController(rootViewController: userSettingCtl)
            userSettingCtl.title = self.titles[indexPath.item]
            self.homePageCtl?.present(settingNavigationCtl, animated: true, completion: nil)
            
        case 4:
            print("TODO: open 游票兑换")
            
        default:
            print("Error!!! undefined item selected at row: \(indexPath.item)")
        }

    }
    
}
