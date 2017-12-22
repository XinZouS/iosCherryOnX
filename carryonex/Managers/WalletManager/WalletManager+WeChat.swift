//
//  WalletManager+WeChat.swift
//  carryonex
//
//  Created by Zian Chen on 12/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation
import Unbox

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
        
        ApiServers.shared.postWalletWXPay(totalAmount: request.priceBySender, userId: request.ownerId, requestId: request.id) { (wxOrder, error, timestamp) in
            
            guard let wxOrder = wxOrder else {
                if let error = error {
                    print("wechatPayAuth Error: \(error.localizedDescription)")
                }
                return
            }
            
            self.processingPackage = wxOrder.prepayId
            
            let request = PayReq()
            request.openID = wxOrder.appId
            request.partnerId = wxOrder.mchId
            request.prepayId = wxOrder.prepayId
            request.package = wxOrder.prepayId
            request.nonceStr = wxOrder.nonceStr
            request.timeStamp = UInt32(wxOrder.timestamp)
            request.sign = wxOrder.sign
            WXApi.send(request)
        }
    }
}

enum WXOrderKey: String {
    case nonceStr = "nonce_str"
    case resultCode = "result_code"
    case mchId = "mch_id"
    case appId = "appid"
    case returnMsg = "return_msg"
    case tradeType = "trade_type"
    case sign = "sign"
    case returnCode = "return_code"
    case prepayId = "prepay_id"
    case timestamp = "timestamp"
}

struct WXOrder {
    let nonceStr: String
    let resultCode: String
    let mchId: String
    let appId: String
    let returnMsg: String
    let tradeType: String
    let sign: String
    let returnCode: String
    let prepayId: String
    let timestamp: Int
}

extension WXOrder: Unboxable {
    init(unboxer: Unboxer) throws {
        self.nonceStr = try unboxer.unbox(key: WXOrderKey.nonceStr.rawValue)
        self.resultCode = try unboxer.unbox(key: WXOrderKey.resultCode.rawValue)
        self.mchId = try unboxer.unbox(key: WXOrderKey.mchId.rawValue)
        self.appId = try unboxer.unbox(key: WXOrderKey.appId.rawValue)
        self.returnMsg = try unboxer.unbox(key: WXOrderKey.returnMsg.rawValue)
        self.tradeType = try unboxer.unbox(key: WXOrderKey.tradeType.rawValue)
        self.sign = try unboxer.unbox(key: WXOrderKey.sign.rawValue)
        self.returnCode = try unboxer.unbox(key: WXOrderKey.returnCode.rawValue)
        self.prepayId = try unboxer.unbox(key: WXOrderKey.prepayId.rawValue)
        self.timestamp = try unboxer.unbox(key: WXOrderKey.timestamp.rawValue)
    }
}
