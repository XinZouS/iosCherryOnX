//
//  DeeplinkNavigator.swift
//  carryonex
//
//  Created by Zian Chen on 12/6/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

enum NavigationPage: String {
    case home = "home"
    case trip = "trip"
    case request = "request"
    case requestDetail = "request-detail"
    case carrierList = "carrier-list"
    case senderList = "sender-list"
    case settings = "settings"
}

class DeeplinkNavigator: NSObject {
    
    static func handleDeeplink(_ deeplink: URL) {
        
        guard let host = deeplink.host, let page = NavigationPage(rawValue: host) else {
            print("Invalid Deeplink")
            return
        }
        
        switch page {
        case .trip:
            startNewTrip()
        case .carrierList:
            selectOrder(category: .carrier)
        case .senderList:
            selectOrder(category: .sender)
        case .settings:
            goSettings()
        case .request:
            if let tripCode = URL.getQueryStringParameter(url: deeplink.absoluteString, param: "trip_code") {
                startNewRequest(tripCode: tripCode)
            }
        /*
        case .requestDetail:
        */
        default: //home
            print("Do nothing")
        }
    }
    
    static private func startNewRequest(tripCode: String) {
        let tabViewController = AppDelegate.shared().mainTabViewController!
        tabViewController.selectTabIndex(index: TabViewIndex.home)
        if let navigation = tabViewController.viewControllers?.first as? UINavigationController {
            if let requestViewController = UIStoryboard.init(name: "Sender", bundle: nil).instantiateInitialViewController() as? ItemListYouxiangInputController {
                requestViewController.tripCode = tripCode
                navigation.pushViewController(requestViewController, animated: true)
            }
        }
    }
    
    static private func goSettings() {
        let tabViewController = AppDelegate.shared().mainTabViewController!
        tabViewController.selectTabIndex(index: TabViewIndex.settings)
    }
    
    static private func startNewTrip() {
        let tabViewController = AppDelegate.shared().mainTabViewController!
        tabViewController.selectTabIndex(index: TabViewIndex.home)
        if let navigation = tabViewController.viewControllers?.first as? UINavigationController {
            if let tripViewController = UIStoryboard.init(name: "Carrier", bundle: nil).instantiateInitialViewController() {
                navigation.pushViewController(tripViewController, animated: true)
            }
        }
    }
    
    static private func selectOrder(category: TripCategory) {
        let tabViewController = AppDelegate.shared().mainTabViewController!
        tabViewController.selectTabIndex(index: TabViewIndex.order)
        if let navigation = tabViewController.viewControllers?.first as? UINavigationController {
            navigation.popToRootViewController(animated: false)
            if let orderListViewController = navigation.viewControllers.first as? OrderListViewController {
                if category == .carrier {
                    orderListViewController.animateListMoveLeft()
                } else {
                    orderListViewController.animateListMoveRight()
                }
            }
        }
    }
}
