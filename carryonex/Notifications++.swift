//
//  Notifications++.swift
//  carryonex
//
//  Created by Chen, Zian on 11/2/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

extension Notification.Name {
    /// Used as a namespace for all `URLSessionTask` related notifications.
    public struct Network {
        public static let Invalid = Notification.Name(rawValue: "com.carryonex.notification.name.network.invalid")
    }
    
    public struct WeChat {
        public static let changeHeadImg = Notification.Name(rawValue: "com.carryonex.notification.name.wechat.changeHeadImg")
        public static let Authenticated = Notification.Name(rawValue: "com.carryonex.notification.name.wechat.authenticated")
        public static let AuthenticationFailed = Notification.Name(rawValue: "com.carryonex.notification.name.wechat.authentication-failed")
    }
}
