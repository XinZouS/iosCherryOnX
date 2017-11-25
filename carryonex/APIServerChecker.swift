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
        //self.checkPostUserSos()
        //self.checkPostUserInfo()
    }
    
    static func checkPostUserSos() {
        let phone = "6469279306"
        ApiServers.shared.postUserForgetPassword(phone: phone, password: "abc123") { (success, error) in
            debugPrint("Success: \(success)")
            if let error = error {
                debugPrint("Error: \(error)")
            }
        }
    }
    
    static func checkPostUserInfo() {
        let userInfo: [String: Any] = [
            ProfileUserKey.userId.rawValue: 19,
            ProfileUserKey.realName.rawValue: "陈子安",
            ProfileUserKey.imageUrl.rawValue: "https://i.ytimg.com/vi/8BYa0U1h5Fs/hqdefault.jpg"
        ]
        
        ApiServers.shared.postUserUpdateInfo(info: userInfo) { (user, error) in
            if let realName = user?.realName {
                print("Update user info real name: \(realName)")
            }
            
            if let imageUrl = user?.imageUrl {
                print("Update user info imageUrl: \(imageUrl)")
            }
        }
    }
}
