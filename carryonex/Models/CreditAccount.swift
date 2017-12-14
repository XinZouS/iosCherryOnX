//
//  CreditAccount.swift
//  carryonex
//
//  Created by Xin Zou on 9/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

 
enum CreditAccountType: String {
    case VISA = "VISA"
    case Master = "Master"
    case Discover = "Discover"
}

class CreditAccount : CheckingAccount {
    
    var expireDate : Date = Date(timeIntervalSinceNow: 99999)
    var safeCode : String = "123"
    
    
    
    override init() {
        super.init()
        
        typeString = CreditAccountType.VISA.rawValue
    }
    
    func imageOfAccountType(type: CreditAccountType) -> UIImage {
        switch type {
            case .VISA:
                return #imageLiteral(resourceName: "CarryonEx_WechatPay")
            case .Master:
                return #imageLiteral(resourceName: "CarryonEx_PayPal")
            case .Discover:
                return #imageLiteral(resourceName: "CarryonEx_PayPal")
            
//        default:
//            return #imageLiteral(resourceName: "CarryonEx_CreditCard")
        }
    }
    
}

