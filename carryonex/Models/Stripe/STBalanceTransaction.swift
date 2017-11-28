//
//  STBalanceTransaction.swift
//  carryonex
//
//  Created by Chen, Zian on 11/27/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct STBalanceTransaction: Unboxable {
    //fee_details see STFeedDetail
    let id: String?
    let object: String?
    let amount: Int?
    let availableOn: TimeInterval?
    let created: TimeInterval?
    let currency: String? //Three-letter ISO currency code, in lowercase. Must be a supported currency.
    let description: String?
    let fee: Int?
    let feeDetails: [STFeeDetail]?
    let net: Int?
    let source: String?
    let status: String?
    let type: String?
    
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.availableOn = try? unboxer.unbox(key: STKeys.availableOn.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.description = try? unboxer.unbox(key: STKeys.description.rawValue)
        self.fee = try? unboxer.unbox(key: STKeys.fee.rawValue)
        self.feeDetails = try? unboxer.unbox(key: STKeys.feeDetails.rawValue)
        self.net = try? unboxer.unbox(key: STKeys.net.rawValue)
        self.source = try? unboxer.unbox(key: STKeys.source.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)
        self.type = try? unboxer.unbox(key: STKeys.type.rawValue)
    }
    
    
}



struct STFeeDetail {
    let amount: Int?
    let application: String?
    let currency: String?
    let description: String?
    let type: String?
    
    init(unboxer: Unboxer) throws {
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.application = try? unboxer.unbox(key: STKeys.application.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.description = try? unboxer.unbox(key: STKeys.description.rawValue)
        self.type = try? unboxer.unbox(key: STKeys.type.rawValue)
    }
    
    
}

