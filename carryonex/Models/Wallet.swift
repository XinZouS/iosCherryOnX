//
//  Wallet.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation
import Unbox

enum WalletKeyInDB: String {
    case nounce = "nounce"
    case creditAvailable = "available_credit"
    case creditPending   = "pending_credit"
    case apiVersion = "api_version"
    case userId = "user_id"
    case ephemeralKey = "ephemeralkey"
    case currency = "currency"
    
    case orderString = "order_string" //alipay
    case prepayId = "prepay_id" //Wechat
    
    case walletInfo = "wallet"
    case paymentTotal = "payment_total"
    case incomeTotal = "income_total"
    case incomes = "incomes"
    case payments = "payments"
}

struct Wallet {
    let walletInfo: WalletInfo
    let paymentTotal: Int
    let incomeTotal: Int
    var incomes: [Transaction]
    var payments: [Transaction]
    
    func availableCredit() -> String {
        return String(format: "$%.2f", Double(incomeTotal) / 100.0)
    }
}

extension Wallet: Unboxable {
    init(unboxer: Unboxer) throws {
        self.walletInfo = try unboxer.unbox(key: WalletKeyInDB.walletInfo.rawValue)
        self.paymentTotal = try unboxer.unbox(key: WalletKeyInDB.paymentTotal.rawValue)
        self.incomeTotal = try unboxer.unbox(key: WalletKeyInDB.incomeTotal.rawValue)
        self.incomes = try unboxer.unbox(key: WalletKeyInDB.incomes.rawValue)
        self.payments = try unboxer.unbox(key: WalletKeyInDB.payments.rawValue)
    }
}

enum WalletInfoKey: String {
    case id = "id"
    case timestamp = "timestamp"
    case stripeCustomerId = "stripe_customer_id"
}

struct WalletInfo {
    let id: Int
    let timestamp: Int
    let stripeCustomerId: String
}

extension WalletInfo: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: WalletInfoKey.id.rawValue)
        self.timestamp = try unboxer.unbox(key: WalletInfoKey.timestamp.rawValue)
        self.stripeCustomerId = try unboxer.unbox(key: WalletInfoKey.stripeCustomerId.rawValue)
    }
}
