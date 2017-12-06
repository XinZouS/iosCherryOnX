//
//  APUtilities.swift
//  carryonex
//
//  Created by Zian Chen on 12/5/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation

let aliPid = "2088821540881344"
let aliAppId = "2017111409922946"

class APUtilities {
    
    static func componentString(data: [String: String], encoded: Bool) -> String {
        var tmpArray = [String]()
        let sortedKeyArray = data.keys.sorted()
        for key in sortedKeyArray {
            if let value = data[key], let orderItem = itemWithKey(key: key, value: value, encoded: encoded), orderItem.count > 0 {
                tmpArray.append(orderItem)
            }
        }
        return tmpArray.joined(separator: "&")
    }
    
    static private func itemWithKey(key: String, value: String, encoded: Bool) -> String? {
        var itemValue = value
        if key.count > 0 && value.count > 0 {
            if encoded {
                itemValue = encodeValue(value)
            }
            return "\(key)=\(itemValue)"
        }
        return nil
    }
    
    static private func encodeValue(_ value: String) -> String {
        var encodedValue = value
        if !encodedValue.isEmpty {
            let charset = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[]").inverted
            encodedValue = value.addingPercentEncoding(withAllowedCharacters: charset)!
        }
        return encodedValue
    }
    
    static func nowTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: Date())
    }
}
