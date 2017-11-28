//
//  STRefund.swift
//  carryonex
//
//  Created by Chen, Zian on 11/27/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct STRefund: Unboxable {
    //skip metadata
    let id: String?
    let object: String?
    let amount: Int?
    let balanceTransaction: String?
    let charge: String?
    let created: TimeInterval?
    let currency: String?
    //let metadata: String? // skipped
    let reason: String?
    let receiptNumber: String?
    let status: String?
    
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.balanceTransaction = try? unboxer.unbox(key: STKeys.balanceTransaction.rawValue)
        self.charge = try? unboxer.unbox(key: STKeys.charge.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        //self.metadata: String? // skipped
        self.reason = try? unboxer.unbox(key: STKeys.reason.rawValue)
        self.receiptNumber = try? unboxer.unbox(key: STKeys.receiptNumber.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)

    }
    
}
