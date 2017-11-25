//
//  APIServerChecker.swift
//  carryonex
//
//  Created by Zian Chen on 11/25/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class APIServerChecker: NSObject {
    
    static func testAPIServers() {
        self.checkPostUserSos()
    }
    
    static func checkPostUserSos() {
        let phone = "6469279306"
        ApiServers.shared.postUserForgetPassword(phone: phone, password: "montag") { (success, error) in
            debugPrint("Success: \(success)")
            if let error = error {
                debugPrint("Error: \(error)")
            }
        }
    }
}
