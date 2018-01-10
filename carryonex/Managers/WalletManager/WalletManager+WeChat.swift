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
    
    func initializeWeChatWallet() {
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.PaySuccess, object: nil, queue: nil) { [weak self] (notification) in
            self?.wechatValidation(true)
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.PayFailed, object: nil, queue: nil) { [weak self] (notification) in
            self?.wechatValidation(false)
        }
    }
    
    private func wechatValidation(_ success: Bool) {
        if let order = self.lastOrder {
            ApiServers.shared.postWalletWXVerify(order: order, isSuccess: success, completion: { (success, error) in
                if let error = error {
                    DLog("WX Validation Error: \(error.localizedDescription)")
                    return
                }
                DLog("WX Validation successful")
                self.lastOrder = nil
            })
        }
    }
    
    func wechatPayAuth(request: Request, completion:(() -> Void)?) {
        
        ApiServers.shared.postWalletWXPay(totalAmount: request.priceBySender, userId: request.ownerId, requestId: request.id) { (wxOrder, error) in
            
            completion?()
            
            guard let wxOrder = wxOrder else {
                if let error = error {
                    DLog("wechatPayAuth Error: \(error.localizedDescription)")
                }
                return
            }
            
            let request = PayReq()
            request.openID = wxOrder.appId
            request.partnerId = wxOrder.partnerId
            request.prepayId = wxOrder.prepayId
            request.package = wxOrder.package
            request.nonceStr = wxOrder.nonceStr
            request.timeStamp = UInt32(wxOrder.timestamp)
            request.sign = wxOrder.sign
            
            self.lastOrder = wxOrder
            
            WXApi.send(request)
        }
    }
}

enum WXOrderKey: String {
    case nonceStr = "noncestr"
    case partnerId = "partnerid"
    case appId = "appid"
    case package = "package"
    case sign = "sign"
    case prepayId = "prepayid"
    case timestamp = "timestamp"
    case outTradeNo = "out_trade_no"
}

struct WXOrder {
    let nonceStr: String
    let partnerId: String
    let appId: String
    let package: String
    let sign: String
    let prepayId: String
    let timestamp: Int
    let outTradeNo: String
}

extension WXOrder: Unboxable {
    init(unboxer: Unboxer) throws {
        self.nonceStr = try unboxer.unbox(key: WXOrderKey.nonceStr.rawValue)
        self.partnerId = try unboxer.unbox(key: WXOrderKey.partnerId.rawValue)
        self.appId = try unboxer.unbox(key: WXOrderKey.appId.rawValue)
        self.package = try unboxer.unbox(key: WXOrderKey.package.rawValue)
        self.sign = try unboxer.unbox(key: WXOrderKey.sign.rawValue)
        self.prepayId = try unboxer.unbox(key: WXOrderKey.prepayId.rawValue)
        self.timestamp = try unboxer.unbox(key: WXOrderKey.timestamp.rawValue)
        self.outTradeNo = try unboxer.unbox(key: WXOrderKey.outTradeNo.rawValue)
    }
}
