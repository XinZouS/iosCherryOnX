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
    case carrierDetailFillTime = "carrier-detail-fill-time"
    case carrierShareTime = "carrier-share-time"
    case senderCompleteTripidTime = "sender-complete-tripid-time"
    case senderDetailFillTime = "sender-detail-fill-time"
    case senderAddPriceTime = "sender-add-price-time"
    case senderPlacePriceTime = "sender-place-price-time"
    case senderDetailTotalTime = "sender-detail-total-time"
    case requestPayTime = "request-pay-time"
    case profileImageSettingTime = "profile-image-setting-time"
    case cashOutTime = "cash-out-time"
}

enum AnalyticsCountKey: String {
    case registerByWeChatCount = "register-by-wechat-count"
    case registerByEmailCount = "register-by-email-count"
    case loginByWeChatCount = "login-by-wechat-count"
    case loginByEmailCount = "login-by-email-count"
    case senderPlacePriceCount = "sender-place-price-count"
    case requestAcceptCount = "request-accept-count"
    case otherProfileVisitCount = "other-profile-visit-count"
    case wechatPayCount = "wechat-pay-count"
    case alipayPayCount = "alipay-pay-count"
    case historicCommentCheckCount = "historic-comment-check-count"
    case walletOpenCount = "wallet-open-count"
    case cashOutCount = "cash-out-count"
}

enum AnalyticsKey: String {
    case viewImageCount = "view-image-count" // 张
    case carrierPrePublishDay = "carrier-pre-publish-day" // 天
}

class AnalyticsManager: NSObject {
    
    //For time keys
    var registrationTime: Int = -1
    var loginTime: Int = -1
    var carrierDetailFillTime: Int = -1
    var carrierShareTime: Int = -1
    var senderCompleteTripidTime: Int = -1
    var senderDetailFillTime: Int = -1
    var senderAddPriceTime: Int = -1
    var senderPlacePriceTime: Int = -1
    var senderDetailTotalTime: Int = -1
    var requestPayTime: Int = -1
    var profileImageSettingTime: Int = -1
    var cashOutTime: Int = -1
    
    //For count keys
    var loginByWeChatCount: Int = -1
    var loginByEmailCount: Int = -1
    var registerByWeChatCount: Int = -1
    var registerByEmailCount: Int = -1
    var senderPlacePriceCount: Int = -1
    var requestAcceptCount: Int = -1
    var otherProfileVisitCount: Int = -1
    var wechatPayCount: Int = -1
    var alipayPayCount: Int = -1
    var historicCommentCheckCount: Int = -1
    var walletOpenCount: Int = -1
    var cashOutCount: Int = -1

    static let shared = AnalyticsManager()
}

extension AnalyticsManager {
    
    public func startTimeTrackingKey(_ key: AnalyticsTimeKey) {
        switch key {
        case .registrationProcessTime:
            registrationTime = Date.getTimestampNow()
        case .loginProcessTime:
            loginTime = Date.getTimestampNow()
        case .carrierDetailFillTime:
            carrierDetailFillTime = Date.getTimestampNow()
        case .carrierShareTime:
            carrierShareTime = Date.getTimestampNow()
        case .senderCompleteTripidTime:
            senderCompleteTripidTime = Date.getTimestampNow()
        case .senderDetailFillTime:
            senderDetailFillTime = Date.getTimestampNow()
        case .senderAddPriceTime:
            senderAddPriceTime = Date.getTimestampNow()
        case .senderPlacePriceTime:
            senderPlacePriceTime = Date.getTimestampNow()
        case .senderDetailTotalTime:
            senderDetailTotalTime = Date.getTimestampNow()
        case .requestPayTime:
            requestPayTime = Date.getTimestampNow()
        case .profileImageSettingTime:
            profileImageSettingTime = Date.getTimestampNow()
        case .cashOutTime:
            cashOutTime = Date.getTimestampNow()
        }
    }
    
    public func finishTimeTrackingKey(_ key: AnalyticsTimeKey) {
        var keyTime: Int = -1
        switch key {
        case .registrationProcessTime:
            keyTime = registrationTime
        case .loginProcessTime:
            keyTime = loginTime
        case .carrierDetailFillTime:
            keyTime = carrierDetailFillTime
        case .carrierShareTime:
            keyTime = carrierShareTime
        case .senderCompleteTripidTime:
            keyTime = senderCompleteTripidTime
        case .senderDetailFillTime:
            keyTime = senderDetailFillTime
        case .senderAddPriceTime:
            keyTime = senderAddPriceTime
        case .senderPlacePriceTime:
            keyTime = senderPlacePriceTime
        case .senderDetailTotalTime:
            keyTime = senderDetailTotalTime
        case .requestPayTime:
            keyTime = requestPayTime
        case .profileImageSettingTime:
            keyTime = profileImageSettingTime
        case .cashOutTime:
            keyTime = cashOutTime
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
        case .carrierDetailFillTime:
            carrierDetailFillTime = -1
        case .carrierShareTime:
            carrierShareTime = -1
        case .senderCompleteTripidTime:
            senderCompleteTripidTime = -1
        case .senderDetailFillTime:
            senderDetailFillTime = -1
        case .senderAddPriceTime:
            senderAddPriceTime = -1
        case .senderPlacePriceTime:
            senderPlacePriceTime = -1
        case .senderDetailTotalTime:
            senderDetailTotalTime = -1
        case .requestPayTime:
            requestPayTime = -1
        case .profileImageSettingTime:
            profileImageSettingTime = -1
        case .cashOutTime:
            cashOutTime = -1
        }
    }
    
    public func trackCount(_ key: AnalyticsCountKey) {
        Answers.logCustomEvent(withName: key.rawValue, customAttributes: nil)
    }
    
    public func track(_ key: AnalyticsKey, attributes:[String: Any]?) {
        Answers.logCustomEvent(withName: key.rawValue, customAttributes: attributes)
    }
}
