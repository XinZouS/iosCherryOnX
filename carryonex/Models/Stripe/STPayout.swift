//
//  STPayout.swift
//  carryonex
//
//  Created by Chen, Zian on 11/27/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct STPayout: Unboxable {
    //Skip meta data
    
    let id: String?
    let object: String?
    let amount: Int?
    let arrivalDate: TimeInterval?
    let automatic: Bool?
    let balanceTransaction: String?
    let created: TimeInterval?
    let currency: String?
    let description: String?
    let destination: String?
    let failureBalanceTransaction: String?
    let failureCode: String?
    let failureMessage: String?
    let livemode: Bool?
    //let metadata: //skipped
    let orderId: String?
    let method: String?
    let sourceType: String?
    let statementDescriptor: String?
    let status: String?
    let type: String?
    
    
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.arrivalDate = try? unboxer.unbox(key: STKeys.arrivalDate.rawValue)
        self.automatic = try? unboxer.unbox(key: STKeys.automatic.rawValue)
        self.balanceTransaction = try? unboxer.unbox(key: STKeys.balanceTransaction.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.description = try? unboxer.unbox(key: STKeys.description.rawValue)
        self.destination = try? unboxer.unbox(key: STKeys.destination.rawValue)
        self.failureBalanceTransaction = try? unboxer.unbox(key: STKeys.failureBalanceTransaction.rawValue)
        self.failureCode = try? unboxer.unbox(key: STKeys.failureCode.rawValue)
        self.failureMessage = try? unboxer.unbox(key: STKeys.failureMessage.rawValue)
        self.livemode = try? unboxer.unbox(key: STKeys.livemode.rawValue)
        //self.metadata: //skipped
        self.orderId = try? unboxer.unbox(key: STKeys.orderId.rawValue)
        self.method = try? unboxer.unbox(key: STKeys.method.rawValue)
        self.sourceType = try? unboxer.unbox(key: STKeys.sourceType.rawValue)
        self.statementDescriptor = try? unboxer.unbox(key: STKeys.statementDescriptor.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)
        self.type = try? unboxer.unbox(key: STKeys.type.rawValue)
    }
    
    
}

