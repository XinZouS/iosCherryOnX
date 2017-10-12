//
//  Wallet.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

 
class Wallet : NSObject {
    
    var id : String = "123456789"
    
    var creditAvailable : Float = 6.00
    var creditPending :   Float = 3.00
    
    var transactionIds = [String]() // ["12", "23"]
    var transactions = [Transaction]()
    
    var checkingAccounts = [CheckingAccount]()
    var creditAccounts = [CreditAccount]()
    
    static var sharedInstance = Wallet()
    
    
    private override init() {
        super.init()
        
        fakeAccounts() // remove this before publish !!!!!!!!!
        
    }
    
    func fakeAccounts(){
        checkingAccounts.append(CheckingAccount())
        creditAccounts.append(CreditAccount())
    }
    
}




