//
//  Transaction.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation
import Unbox

enum TransactionKey: String {
    case timestamp = "timestamp"
    case amount = "amount"
    case currency = "currency"
    case requestId = "request_id"
    case platform = "platform"
    case statusId = "status_id"
}

struct Transaction {
    let timestamp: Int
    let amount: Int
    let currency: String
    let requestId: Int
    let platform: String
    let statusId: Int
    
    func getTransactionDate() -> String {
        return Date.getTimeString(format: "MM-dd-yyyy", time: TimeInterval(timestamp))
    }
    
    func amountString() -> String {
        return String(format: "%.2f", Double(amount) / 100.0)
    }
}

extension Transaction: Unboxable {
    init(unboxer: Unboxer) throws {
        self.timestamp = try unboxer.unbox(key: TransactionKey.timestamp.rawValue)
        self.amount = try unboxer.unbox(key: TransactionKey.amount.rawValue)
        self.currency = try unboxer.unbox(key: TransactionKey.currency.rawValue)
        self.requestId = try unboxer.unbox(key: TransactionKey.requestId.rawValue)
        self.platform = try unboxer.unbox(key: TransactionKey.platform.rawValue)
        self.statusId = try unboxer.unbox(key: TransactionKey.statusId.rawValue)
    }
}
