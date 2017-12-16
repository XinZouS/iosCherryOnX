//
//  WalletManager+WeChat.swift
//  carryonex
//
//  Created by Zian Chen on 12/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation

enum WechatResultStatus: Int {
    case success = 0
    case failure = -1
    case cancelledByUser = -2
    
    func statusDescription() -> String {
        switch self {
        case .success:
            return "订单支付成功"
        case .failure:
            return "订单支付失败"
        case .cancelledByUser:
            return "用户取消"
        }
    }
}

//WeChat
extension WalletManager {
    func wechatPayAuth(request: Request) {
        //let userId = String(request.ownerId)
        //let requestId = String(request.id)
        //let total = String(request.priceBySender)
        
        //Get needed value from backend
        let request = PayReq()
        request.openID = "wx9dc6e6f4fe161a4f"
        request.partnerId = ""
        request.prepayId = ""
        request.package = "Sign=WXPay"
        request.nonceStr = ""
        request.timeStamp = 0
        request.sign = ""
        WXApi.send(request)
    }
}

extension WalletManager: WXApiDelegate {
    func onResp(_ resp: BaseResp!) {
        
    }
}
