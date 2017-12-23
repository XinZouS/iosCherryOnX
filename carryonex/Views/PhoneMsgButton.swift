//
//  PhoneButton.swift
//  carryonex
//
//  Created by Xin Zou on 12/22/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class PhoneMsgButton: UIButton {
    
    public var isActive: Bool = true {
        didSet {
            self.alpha = isActive ? 1 : 0.5
            self.isEnabled = isActive
        }
    }
    
    
    
}

