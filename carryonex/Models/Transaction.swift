//
//  Transaction.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation
import Unbox

enum TransactionStatus: Int {
    case unknown = -1
    case paymentInit = 33
    case paymentError = 34
    case paymentPaid = 35
    case paymentRefunded = 36
    case paymentPending = 37
    case paymentDone = 38
    case payoutDone = 39
    case incomeRefunded = 40
    case incomePending = 41
    case incomeDone = 42
    
    //TODO: localization
    func displayString() -> String {
        switch self {
        case .paymentInit:
            return "发起支付"
        case .paymentError:
            return "错误"
        case .paymentPaid:
            return "过账中"
        case .paymentRefunded:
            return "退款"
        case .paymentPending:
            return "未到账"
        case .paymentDone:
            return "已转账"
        case .payoutDone:
            return "已到账"
        case .incomeRefunded:
            return "退款"
        case .incomePending:
            return "未到账"
        case .incomeDone:
            return "已到账"
        default:
            return "未知状态"
        }
    }
    
    func displayColor() -> UIColor {
        if self == .payoutDone {
            return UIColor.carryon_payoutTransactionStatus
        }
        return UIColor.carryon_normalTransactionStatus
    }
}

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
    
    func statusString() -> String {
        if let status = TransactionStatus(rawValue: statusId) {
            return status.displayString()
        }
        return TransactionStatus.unknown.displayString()
    }
    
    func transactionTypeString() -> String {
        if let status = TransactionStatus(rawValue: statusId) {
            switch status {
            case .paymentInit, .paymentError, .paymentPaid, .paymentRefunded, .paymentPending, .paymentDone:
                return "支付"
            case .payoutDone:
                return "提现"
            case .incomeRefunded, .incomePending, .incomeDone:
                return "收入"
            default:
                return "未知状态"
            }
        }
        return "未知状态"
    }
    
    func transactionTypeColor() -> UIColor {
        if let status = TransactionStatus(rawValue: statusId) {
            return status.displayColor()
        }
        return TransactionStatus.unknown.displayColor()
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
