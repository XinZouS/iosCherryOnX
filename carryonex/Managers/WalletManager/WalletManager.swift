//
//  WalletManager.swift
//  carryonex
//
//  Created by Zian Chen on 11/19/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation
import Stripe

class WalletManager: NSObject {
    static let shared = WalletManager()

    //Stripe
    var stripePaymentContext: STPPaymentContext?
    weak var delegate: WalletStripeDelegate?
    
    //Wechat
    var processingPackage: String?
}

