//
//  APAuthInfo.swift
//  carryonex
//
//  Created by Zian Chen on 12/5/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class APAuthInfo: NSObject {
    
    //签约平台内的appid
    var appID: String
    
    //商户签约id
    var pid: String
    
    //授权类型,AUTHACCOUNT:授权;LOGIN:登录
    var authType: String
    
    //商户请求id需要为unique,回调使用
    var targetID: String
    
    init(appID: String, pid: String, authType: String, targetID: String) {
        self.appID = appID
         self.pid = pid
         self.authType = authType
         self.targetID = targetID
    }
    
    func descriptionString() -> String? {
        if appID.count != 16 || pid.count != 16 {
            return nil
        }
        
        let tmpDict: [String : String] = [
            "app_id": appID,
            "pid": pid,
            "apiname": "com.alipay.account.auth",
            "method": "alipay.open.auth.sdk.code.get",
            "app_name": "mc",
            "biz_type": "openservice",
            "product_id": "APP_FAST_LOGIN",
            "scope": "scope",
            "target_id": targetID,
            "auth_type": authType
        ]
        
        return APUtilities.componentString(data: tmpDict, encoded: false)
    }
}
