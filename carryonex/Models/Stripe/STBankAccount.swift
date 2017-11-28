//
//  STBankAccount.swift
//  carryonex
//
//  Created by Chen, Zian on 11/27/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct STBankAccount: Unboxable {
    //skip metadata
    let id: String?
    let object: String?
    let account: String?
    let accountHolderName: String?
    let accountHolderType: String?
    let bankName: String?
    let country: String?
    let currency: String?
    let customer: String?
    let defaultForCurrency: Bool?
    let fingerprint: String?
    let last4: String?
    //let metadata: Hashable? // skipped
    let routingNumber: String?
    let status: String?
    
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.account = try? unboxer.unbox(key: STKeys.account.rawValue)
        self.accountHolderName = try? unboxer.unbox(key: STKeys.accountHolderName.rawValue)
        self.accountHolderType = try? unboxer.unbox(key: STKeys.accountHolderType.rawValue)
        self.bankName = try? unboxer.unbox(key: STKeys.bankName.rawValue)
        self.country = try? unboxer.unbox(key: STKeys.country.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.customer = try? unboxer.unbox(key: STKeys.customer.rawValue)
        self.defaultForCurrency = try? unboxer.unbox(key: STKeys.defaultForCurrency.rawValue)
        self.fingerprint = try? unboxer.unbox(key: STKeys.fingerprint.rawValue)
        self.last4 = try? unboxer.unbox(key: STKeys.last4.rawValue)
        self.routingNumber = try? unboxer.unbox(key: STKeys.routingNumber.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)
        
    }
    
}

