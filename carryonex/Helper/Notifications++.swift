//
//  Notifications++.swift
//  carryonex
//
//  Created by Chen, Zian on 11/2/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation

extension Notification.Name {
    /// Used as a namespace for all `URLSessionTask` related notifications.
    public struct Network {
        public static let Invalid = Notification.Name(rawValue: "com.carryonex.notification.name.network.invalid")
    }
    
    public struct User {
        public static let Invalid = Notification.Name(rawValue: "com.carryonex.notification.name.user.invalid")
    }
    
    public struct WeChat {
        public static let ChangeProfileImg = Notification.Name(rawValue: "com.carryonex.notification.name.wechat.change-profile-img")
        public static let Authenticated = Notification.Name(rawValue: "com.carryonex.notification.name.wechat.authenticated")
        public static let AuthenticationFailed = Notification.Name(rawValue: "com.carryonex.notification.name.wechat.authentication-failed")
        public static let PaySuccess = Notification.Name(rawValue: "com.carryonex.notification.name.wechat.pay-success")
        public static let PayFailed = Notification.Name(rawValue: "com.carryonex.notification.name.wechat.pay-failed")
    }
    
    public struct TripOrderStore {
        public static let StoreUpdated = Notification.Name(rawValue: "com.carryonex.notification.name.tripOrderStore.store-updated")
    }
    
    public struct Alipay {
        public static let PaymentProcessed = Notification.Name(rawValue: "com.carryonex.notification.name.alipay.payment-processed")
    }
}
