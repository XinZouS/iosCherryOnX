//
//  String++.swift
//  carryonex
//
//  Created by Xin Zou on 9/15/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

extension String {
    
    //ZIAN: ONLY FOR THIS SERVER!!! KNOW YOUR PURPOSE BEFORE USING IT!
    func isTrue() -> Bool {
        return self.lowercased() == "true" || self == "1"
    }
    
    func isFalse() -> Bool {
        return self.lowercased() == "false" || self == "0"
    }
    
    func toBool() -> Bool {
        if self.lowercased() == "false" || self == "0" {
            return false
        }
        return true
    }
    
    func quickTossPassword() -> String {
        return String(self.reversed()) + carryonSalt
    }
}
