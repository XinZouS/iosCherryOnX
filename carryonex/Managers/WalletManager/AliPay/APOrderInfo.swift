//
//  APOrderInfo.swift
//  carryonex
//
//  Created by Zian Chen on 12/5/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class APOrderInfo: NSObject {

    let appId: String
    let method: String
    let charset: String
    let version: String
    let bizContentDesc: String
    let signType: String
    
    var format: String?
    var returnUrl: String?
    var notifyUrl: String?
    var appAuthToken: String?
    
    init(appId: String, method: String = "alipay.trade.app.pay", charset: String = "utf-8",
         version: String = "1.0", bizContentDesc: String, signType: String = "RSA2") {
        self.appId = appId
        self.method = method
        self.charset = charset
        self.version = version
        self.bizContentDesc = bizContentDesc
        self.signType = signType
    }
    
    func descriptionString(encoded: Bool) -> String {
        var tmpDict: [String:String] = [
            "app_id": appId,
            "method": method,
            "charset": charset,
            "timestamp": APUtilities.nowTimestamp(),
            "version" : version,
            "biz_content": bizContentDesc,
            "sign_type": signType
        ]
        
        if let format = format, !format.isEmpty {
            tmpDict["format"] = format
        }
        
        if let returnUrl = returnUrl, !returnUrl.isEmpty {
            tmpDict["return_url"] = returnUrl
        }
        
        if let notifyUrl = notifyUrl, !notifyUrl.isEmpty {
            tmpDict["notify_url"] = notifyUrl
        }
        
        if let appAuthToken = appAuthToken, !appAuthToken.isEmpty {
            tmpDict["app_auth_token"] = appAuthToken
        }
        
        return APUtilities.componentString(data: tmpDict, encoded: encoded)
    }
    
}


