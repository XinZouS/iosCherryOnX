//
//  Double++.swift
//  carryonex
//
//  Created by Xin Zou on 12/6/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation


extension Double {
    
    public func roundUp2Decimal() -> Double {
        let rd = Int(self * 100)
        let v = Double(rd) / 100.0
        print("get rd = \(rd), return v = \(v)")
        return v
    }

}
