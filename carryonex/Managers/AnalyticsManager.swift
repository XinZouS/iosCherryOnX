//
//  AnalyticsManager.swift
//  carryonex
//
//  Created by Zian Chen on 12/18/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Crashlytics

enum AnalyticsTimeKey: String {
    case registrationProcessTime = "registration-process-time"
    case loginProcessTime = "login-process-time"
}

enum AnalyticsCountKey: String {
    case registerByWeChatCount = "register-by-wechat-count"
    case registerByEmailCount = "register-by-email-count"
    case loginByWeChatCount = "login-by-wechat-count"
    case loginByEmailCount = "login-by-email-count"
}

class AnalyticsManager: NSObject {
    
    //For time keys
    var registrationTime: Int = -1
    var loginTime: Int = -1
    
    //For count keys
    var loginByWeChatCount: Int = -1
    var loginByEmailCount: Int = -1
    
    static let shared = AnalyticsManager()
}

extension AnalyticsManager {
    
    public func startTimeTrackingKey(_ key: AnalyticsTimeKey) {
        switch key {
        case .registrationProcessTime:
            registrationTime = Date.getTimestampNow()
        case .loginProcessTime:
            loginTime = Date.getTimestampNow()
        }
    }
    
    public func finishTimeTrackingKey(_ key: AnalyticsTimeKey) {
        var keyTime: Int = -1
        switch key {
        case .registrationProcessTime:
            keyTime = registrationTime
        case .loginProcessTime:
            keyTime = loginTime
        }
        
        if keyTime != -1 {
            let timeSpent: Int = Date.getTimestampNow() - keyTime
            Answers.logCustomEvent(withName: key.rawValue, customAttributes: ["time": timeSpent])
        }
        
        clearTimeTrackingKey(key)
    }
    
    public func clearTimeTrackingKey(_ key: AnalyticsTimeKey) {
        switch key {
        case .registrationProcessTime:
            registrationTime = -1
        case .loginProcessTime:
            loginTime = -1
        }
    }
    
    func trackCount(_ key: AnalyticsCountKey) {
        Answers.logCustomEvent(withName: key.rawValue, customAttributes: nil)
    }
    
}
