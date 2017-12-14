//
//  CheckingAccount.swift
//  carryonex
//
//  Created by Xin Zou on 9/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

 
class CheckingAccount : NSObject {
    
    var id: Int?
    
    var accountNumber: String = "1234567890"
    var typeString : String = "Chase Checking"
    
    var firstName: String = "firstname"
    var lastName : String = "lastname"
    
    var routingNumber: String = "routingNumber 123456789"
    
    var billingAddress : String = "addressID"
    
    
    
    override init() {
        super.init()
        
        
    }
    
}


