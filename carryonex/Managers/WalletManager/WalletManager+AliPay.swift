//
//  WalletManager+AliPay.swift
//  carryonex
//
//  Created by Zian Chen on 12/5/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation

enum AliPayResultStatus: String {
    case success = "9000"
    case processing = "8000"
    case failed = "4000"
    case repeated = "5000"
    case cancelledByUser = "6001"
    case networkProblem = "6002"
    case unknown = "6004"
    case invalid = "-1"
    
    func statusDescription() -> String {
        switch self {
        case .success:
            return "订单支付成功"
        case .processing:
            return "正在处理中"
        case .failed:
            return "订单支付失败"
        case .repeated:
            return "付款成功"
        case .cancelledByUser:
            return "用户中途取消"
        case .networkProblem:
            return "网络问题"
        case .unknown:
            return "付款过程出现未知问题"
        default:
            return "付款无效"
        }
    }
}

//Ali Pay
extension WalletManager {
    
    func aliPayAuth(request: Request) {
        let userId = String(request.ownerId)
        let requestId = String(request.id)
        let total = String(format: "%.2f", (Double(request.priceBySender) / 100.0))
        ApiServers.shared.postWalletAliPay(totalAmount: total, userId: userId, requestId: requestId) { (orderString, error) in
            if let error = error {
                print("aliPayAuth: \(error.localizedDescription)")
                return
            }
            
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: "carryonex") { (result) in
                if let result = result {
                    print("Result Dict: \(result)")
                }
            }
        }
    }
    
    /*
     [AnyHashable("resultStatus"): 9000,
     AnyHashable("result"): {
        "alipay_trade_app_pay_response":
            {"code":"10000","msg":"Success","app_id":"2017111409922946","auth_app_id":"2017111409922946","charset":"utf-8","timestamp":"2017-12-09 04:36:06","total_amount":"8.00","trade_no":"2017120921001004700589662022","seller_id":"2088821540881344","out_trade_no":"CO_77_0"},
        "sign":"gCtfE64YPRUCnnS1YGKc+mMn7rJvgCgTP/CfnpSd+CgWiz+mwq0PolJZB74F8M3LOVWNOos83gYtR1u2PJw/VWdp9aT6UhjSy4FgyXoug1EPaLh8iNvegPU7dVieZhx3sNAW8o9n9bzfy9xKNLcchXnXaSjuxs9Mgx81rJnTi4ZIShIKf/zJFautcGb/nTu3xypIc5iRf3sdmIKze0P8kSOa7Zy8tB/rnAHP63/evxicAynOhV45XnjQatrUlvI627udQW9UtnddiMFfGgu8Zao87q/Mv6DjoI5rkWASA2uoe/lPqDiv/tiB+fV7sSs67QDI95rtbF8D2z/RF1fPlA==",
        "sign_type":"RSA2"},
     AnyHashable("memo"): ]
     */
    
    func aliPayProcessOrderCallbackHandler(result: [AnyHashable: Any]) {
        if let resultStatus = result["resultStatus"] as? String {
            if let status = AliPayResultStatus(rawValue: resultStatus) {
                NotificationCenter.default.post(name: Notification.Name.Alipay.PaymentProcessed, object: status)
            } else {
                NotificationCenter.default.post(name: Notification.Name.Alipay.PaymentProcessed, object: nil)
            }
        }
    }
}
