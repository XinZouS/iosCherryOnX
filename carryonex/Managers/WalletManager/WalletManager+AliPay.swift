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
        
        /*
        let sellerId = ""   //TODO add seller id
        let bizContent = APBizContent(subject: request.ownerRealName ?? "name",
                                      outTradeNo: String(request.id),
                                      totalAmount: request.priceString(),
                                      sellerId: sellerId)
        bizContent.body = request.note
        
        guard let bizContentString = bizContent.descriptionString() else {
            debugPrint("Invalid request content:\(request.id)")
            return
        }
        let order = APOrderInfo(appId: aliAppId, bizContentDesc: bizContentString)
        let orderInfo = order.descriptionString(encoded: false)
        let orderInfoEncoded = order.descriptionString(encoded: true)
        //print("Order specs: \(orderInfo)")
        //print("Order encoded: \(orderInfoEncoded)")
        
        let signedString = orderInfo //TODO: SIGN IT WITH MENGDI
        let orderString = "\(orderInfoEncoded)&sign=\(signedString)"
        print("signed: \(signedString)")
        print("order: \(orderString)")
        */
        
        /*
        AlipaySDK.defaultService().payOrder(orderString, fromScheme: "carryonex") { (resultDic) in
            print("Result Dict")
        }
         
        let orderTradeNo = String(request.id + request.ownerId)
        let userId = String(request.ownerId)
        let request = String(request.id)
        ApiServers.shared.postWalletAliPay(orderTradeNo, totalAmount: "0.50", userId: userId, requestId: request) { (error) in
            
        }
         */
    }
    
}
