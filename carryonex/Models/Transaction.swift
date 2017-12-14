//
//  Transaction.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import Unbox
 
enum TransactionStatus : String, UnboxableEnum {
    case pending = "处理中"
    case finished = "交易完成"
}

enum TransactionKeyInDB: String {
    case nounce = "nounce"
    case type = "ttype"
}


struct Transaction : Unboxable {
    
    var nounce : String?
    var type : String?
    
    var payeeName: String?
    var payeeId :  String?
    
    var amount : Float?
    
    var status : String = TransactionStatus.pending.rawValue
    
    
    init() {
    }
    
    init(unboxer: Unboxer) throws {
        self.nounce = try? unboxer.unbox(key: TransactionKeyInDB.nounce.rawValue)
        self.type = try? unboxer.unbox(key: TransactionKeyInDB.type.rawValue)
    }
    
}


