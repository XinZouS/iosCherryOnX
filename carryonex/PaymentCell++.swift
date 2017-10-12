//
//  PaymentCell++.swift
//  carryonex
//
//  Created by Xin Zou on 8/27/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension PaymentCell {
    
    
    
    func checkboxTapped(){
        paymentController.paymentSelectedByCheckbox()
        paymentController.paymentSelected = self.payment
    }
    
    
    
    
    
}
