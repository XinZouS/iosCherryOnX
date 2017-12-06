//
//  APBizContent.swift
//  carryonex
//
//  Created by Zian Chen on 12/5/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class APBizContent: NSObject {

    let subject: String
    let outTradeNo: String
    let totalAmount: String
    let sellerId: String
    var productCode: String = "QUICK_MSECURITY_PAY"
    var body: String?
    var timeoutExpress: String?
    
    init(subject: String, outTradeNo: String, totalAmount: String, sellerId: String) {
        self.subject = subject
        self.outTradeNo = outTradeNo
        self.totalAmount = totalAmount
        self.sellerId = sellerId
    }
    
    func packageString() -> String? {
        var tmpDict: [String:String] = [
            "subject": subject,
            "out_trade_no": outTradeNo,
            "total_amount": totalAmount,
            "seller_id": sellerId,
            "product_code": productCode
        ]
        
        if let body = body, !body.isEmpty {
            tmpDict["body"] = body
        }
        
        if let timeoutExpress = timeoutExpress, !timeoutExpress.isEmpty {
            tmpDict["timeout_express"] = timeoutExpress
        }
        
        let tmpData = try! JSONSerialization.data(withJSONObject: tmpDict, options: .prettyPrinted)
        let tmpStr = String.init(data: tmpData, encoding: .utf8)
        return tmpStr
    }
    
}
