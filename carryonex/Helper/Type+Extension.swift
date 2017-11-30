//
//  Type+Extension.swift
//  carryonex
//
//  Created by Zian Chen on 11/30/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation

extension Integer {
    var boolValue: Bool {
        if self == 0 {
            return false
        } else {
            return true
        }
    }
}
