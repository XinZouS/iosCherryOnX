//
//  String++.swift
//  carryonex
//
//  Created by Xin Zou on 9/15/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

extension String {
    
    func formatToPhoneNum(countryCode: String) -> String {
        var phone = self
        let len = self.count
        let strIdx = self.startIndex
        
        if len < 10 {
            return self
        }
        if len == 10 { // U.S. phone: (201)657-1234
            phone = String(
                format: "(%@)%@-%@",
                self.substring(with: self.index(strIdx, offsetBy: 0) ..< self.index(strIdx, offsetBy: 3) ),
                self.substring(with: self.index(strIdx, offsetBy: 3) ..< self.index(strIdx, offsetBy: 6) ),
                self.substring(with: self.index(strIdx, offsetBy: 6) ..< self.endIndex )
            )
        }
        if len == 11 { // Chinese phone: 138.6666.8888
            phone = String(
                format: "%@.%@.%@",
                self.substring(with: self.index(strIdx, offsetBy: 0) ..< self.index(strIdx, offsetBy: 3) ),
                self.substring(with: self.index(strIdx, offsetBy: 3) ..< self.index(strIdx, offsetBy: 7) ),
                self.substring(with: self.index(strIdx, offsetBy: 7) ..< self.endIndex )
            )
        }
        return "+\(countryCode) \(phone)"
    }
    
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

// 
