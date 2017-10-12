//
//  Transaction.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

 
enum TransactionStatus : String {
    case pending = "处理中"
    case finished = "交易完成"
}

class Transaction : NSObject {
    
    var id : String = "transactionId-xxx"
    
    var payeeName: String = "userName-payee"
    var payeeId :  String = "userId-payee"
    
    var amount : Float = 0.0
    
    var status : String = TransactionStatus.pending.rawValue
    
    
    override init() {
        super.init()
        
    }
    
}


