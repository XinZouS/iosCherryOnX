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
        ApiServers.shared.postWalletAliPay(totalAmount: String(request.priceBySender), userId: userId, requestId: requestId) { (orderString, error) in
            AlipaySDK.defaultService().payOrder(orderString, fromScheme: "carryonex") { (result) in
                print("Result Dict: \(result)")
            }
        }
    }
}
