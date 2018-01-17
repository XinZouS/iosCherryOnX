//
//  String++.swift
//  carryonex
//
//  Created by Xin Zou on 9/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
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
    
    func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                DLog(error.localizedDescription)
            }
        }
        return nil
    }
    
    func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(str, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0..<digestLength {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize()
        
        return String(format: hash as String)
    }
}
