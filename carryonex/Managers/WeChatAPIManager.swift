//
//  WeChatAPIManager.swift
//  carryonex
//
//  Created by Zian Chen on 12/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class WeChatAPIManager: NSObject {
    static let shared = WeChatAPIManager()
}

extension WeChatAPIManager: WXApiDelegate {
    
    func onResp(_ resp: BaseResp!) {
        if let resp = resp as? SendAuthResp {
            handleSendAuthResp(resp: resp)
            
        } else if let resp = resp as? PayResp {
            handlePayResponse(resp: resp)
        }
    }
    
    private func handleSendAuthResp(resp: SendAuthResp) {
        if resp.errCode == 0  {
            if wxloginStatus == "fillProfile"{
                NotificationCenter.default.post(name: Notification.Name.WeChat.ChangeProfileImg, object: resp)
            } else {
                NotificationCenter.default.post(name: Notification.Name.WeChat.Authenticated, object: resp)
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name.WeChat.AuthenticationFailed, object: resp)
        }
    }
    
    private func handlePayResponse(resp: PayResp) {
        if resp.errCode == 0 {
            NotificationCenter.default.post(name: Notification.Name.WeChat.PaySuccess, object: resp)
        } else {
            NotificationCenter.default.post(name: Notification.Name.WeChat.PayFailed, object: resp)
        }
    }
}
