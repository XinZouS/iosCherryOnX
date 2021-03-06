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
    case tripDetail = "trip_detail"
    case requestDetail = "request_detail"
    case carrierList = "carrier_list"
    case senderList = "sender_list"
    case settings = "settings"
    case comments = "comments"
}

class DeeplinkNavigator: NSObject {
    
    static func handleDeeplink(_ deeplink: URL) {
        
        if ProfileManager.shared.getCurrentUser() == nil {
            AppDelegate.shared().deferredDeeplink = deeplink
            return
        }
        
        guard let host = deeplink.host, let page = NavigationPage(rawValue: host) else {
            DLog("Invalid Deeplink")
            return
        }
        
        switch page {
        case .trip:
            navigateToNewTrip()
        case .carrierList:
            navigateToOrderList(category: .carrier)
        case .senderList:
            navigateToOrderList(category: .sender)
        case .settings:
            navigateToSettings()
        case .request:
            if let tripCode = URL.getQueryStringParameter(url: deeplink.absoluteString, param: "trip_code") {
                navigateToNewRequest(tripCode: tripCode)
            }
        case .tripDetail:
            if let requestId = URL.getQueryStringParameter(url: deeplink.absoluteString, param: "request_id"),
                let id = Int(requestId) {
                navigateToRequest(id)
            }
        case .requestDetail:
            if let requestId = URL.getQueryStringParameter(url: deeplink.absoluteString, param: "request_id"), let id = Int(requestId) {
                navigateToRequest(id)
            }
        case .comments:
            AppDelegate.shared().handleMainNavigation(navigationSegue: .historyComment, sender: nil)
        default: //home
            DLog("Do nothing")
        }
    }
    
    static private func navigateToNewRequest(tripCode: String) {
        
        if let newRequestCodeViewController = UIViewController.topViewController() as? ItemListYouxiangInputController {
            newRequestCodeViewController.tripCode = tripCode
            return
        }
        
        let tabViewController = AppDelegate.shared().mainTabViewController!
        tabViewController.selectTabIndex(index: TabViewIndex.home)
//        if let navigation = tabViewController.viewControllers?.first as? UINavigationController {
//            if let requestViewController = UIStoryboard.init(name: "Sender", bundle: nil).instantiateInitialViewController() as? ItemListYouxiangInputController {
//                requestViewController.tripCode = tripCode
//                navigation.pushViewController(requestViewController, animated: true)
//            }
//        }
        // use this to hide tabbar:
        if let navigation = tabViewController.viewControllers?.first as? UINavigationController {
            if let homeVC = navigation.viewControllers.first as? NewHomePageController {
                homeVC.handleNavigation(segue: MainNavigationSegue.addRequest, sender: tripCode)
                navigateToNewRequest(tripCode: tripCode)
            }
        }
    }
    
    static private func navigateToRequest(_ requestId: Int) {
        
        if UIViewController.topViewController() as? OrdersRequestDetailViewController != nil ||
            UIViewController.topViewController() as? OrdersTripDetailViewController != nil {
            return
        }
        
        let tabViewController = AppDelegate.shared().mainTabViewController!
        tabViewController.selectTabIndex(index: TabViewIndex.order)
        
        if let request = TripOrderDataStore.shared.getRequest(requestId: requestId), let category = request.category() {
            if category == .carrier {
                AppDelegate.shared().handleMainNavigation(navigationSegue: .requestDetail, sender: request)
            } else {
                AppDelegate.shared().handleMainNavigation(navigationSegue: .tripDetail, sender: request)
            }
            
        } else {
            DLog("Unable to obtain request / category from request: \(requestId)")
        }
    }
    
    static private func navigateToSettings() {
        let tabViewController = AppDelegate.shared().mainTabViewController!
        tabViewController.selectTabIndex(index: TabViewIndex.settings)
    }
    
    static func navigateToNewTrip() {
        let tabViewController = AppDelegate.shared().mainTabViewController!
        tabViewController.selectTabIndex(index: TabViewIndex.home)
        if let navigation = tabViewController.viewControllers?.first as? UINavigationController {
            if let tripViewController = UIStoryboard.init(name: "Carrier", bundle: nil).instantiateInitialViewController() {
                navigation.pushViewController(tripViewController, animated: true)
            }
        }
    }
    
    static func navigateToOrderList(category: TripCategory) {
        let tabViewController = AppDelegate.shared().mainTabViewController!
        tabViewController.selectTabIndex(index: TabViewIndex.order)
        if let navigation = tabViewController.viewControllers![1] as? UINavigationController {
            navigation.popToRootViewController(animated: false)
            if let orderListViewController = navigation.viewControllers.first as? OrderListViewController {
                orderListViewController.listType = category
            }
        }
    }
}
