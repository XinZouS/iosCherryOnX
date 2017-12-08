//
//  WalletManager+AliPay.swift
//  carryonex
//
//  Created by Zian Chen on 12/5/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation

//Ali Pay
extension WalletManager {
    func aliPayAuth(request: Request) {
        let userId = String(request.ownerId)
        let requestId = String(request.id)
        let total = String(format: "%.2f", (Double(request.priceBySender) / 100.0))
        ApiServers.shared.postWalletAliPay(totalAmount: total, userId: userId, requestId: requestId) { (orderString, error) in
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: "carryonex") { (result) in
                //print("Result Dict: \(result)")
            }
        }
    }
}
