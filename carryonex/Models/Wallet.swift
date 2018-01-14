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
    case incomeTotal = "income_total"
    case historyIncomes = "history_incomes"
    case historyIncomeTotal = "history_income_total"
    case payments = "payments"
    case paymentTotal = "payment_total"
    case payouts = "payouts"
}

struct Wallet {
    let walletInfo: WalletInfo
    let paymentTotal: Int
    let incomeTotal: Int
    let historyIncomeTotal: Int
    var payouts: [Transaction]
    var payments: [Transaction]
    var historyIncomes: [Transaction]
    
    func availableCreditDecimal() -> Double {
        return Double(incomeTotal) / 100.0
    }
    
    func availableCredit() -> String {
        return String(format: "%.2f", Double(incomeTotal) / 100.0)
    }
    
    func totalIncome() -> String {
        return String(format: "%.2f", Double(historyIncomeTotal) / 100.0)
    }
}

extension Wallet: Unboxable {
    init(unboxer: Unboxer) throws {
        self.walletInfo = try unboxer.unbox(key: WalletKeyInDB.walletInfo.rawValue)
        self.payouts = try unboxer.unbox(key: WalletKeyInDB.payouts.rawValue)
        self.incomeTotal = try unboxer.unbox(key: WalletKeyInDB.incomeTotal.rawValue)
        self.payments = try unboxer.unbox(key: WalletKeyInDB.payments.rawValue)
        self.paymentTotal = try unboxer.unbox(key: WalletKeyInDB.paymentTotal.rawValue)
        self.historyIncomes = try unboxer.unbox(key: WalletKeyInDB.historyIncomes.rawValue)
        self.historyIncomeTotal = try unboxer.unbox(key: WalletKeyInDB.historyIncomeTotal.rawValue)
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
