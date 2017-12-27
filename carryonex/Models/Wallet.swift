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
}

class Wallet : NSObject, Unboxable {
    
    var nounce : String?
    
    var creditAvailable : Float = 0.00
    var creditPending :   Float = 0.00
    
    var checkingAccounts = [CheckingAccount]()
    var creditAccounts = [CreditAccount]()
    
    static var sharedInstance = Wallet() 
    
    
    override init() {
        super.init()
        
    }
    
    required init(unboxer: Unboxer) throws {
        self.nounce = try? unboxer.unbox(key: WalletKeyInDB.nounce.rawValue)
        self.creditAvailable = (try? unboxer.unbox(key: WalletKeyInDB.creditAvailable.rawValue)) ?? 0.0
        self.creditPending   = (try? unboxer.unbox(key: WalletKeyInDB.creditPending.rawValue)) ?? 0.0
    }
    
    func fakeAccounts(){
        checkingAccounts.append(CheckingAccount())
        creditAccounts.append(CreditAccount())
    }
    
}

