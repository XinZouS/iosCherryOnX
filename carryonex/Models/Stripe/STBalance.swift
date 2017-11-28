//
//  STBalance.swift
//  carryonex
//
//  Created by Chen, Zian on 11/27/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct STBalance: Unboxable {
    //availabe and pending see STBalanceAccount
    
    let object: String?
    let available: [STBalanceAccount]?
    let connectReserved: [STBalanceAccount]?
    let livemode: Bool?
    let pending: [STBalanceAccount]?
    let stripeReserved: [STBalanceAccount]?
    
    
    init(unboxer: Unboxer) throws {
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.available = try? unboxer.unbox(key: STKeys.available.rawValue)
        self.connectReserved = try? unboxer.unbox(key: STKeys.connectReserved.rawValue)
        self.livemode = try? unboxer.unbox(key: STKeys.livemode.rawValue)
        self.pending = try? unboxer.unbox(key: STKeys.pending.rawValue)
        self.stripeReserved = try? unboxer.unbox(key: STKeys.stripeReserved.rawValue)
    }
 
}

//For available and pending
struct STBalanceAccount: Unboxable {
    let currency: String?
    let amount: Double?
    //skip source_types
    
    init(unboxer: Unboxer) throws {
        self.currency = unboxer.unbox(key: STKeys.currency.rawValue)
        self.amount = unboxer.unbox(key: STKeys.amount.rawValue)
    }
    
}
