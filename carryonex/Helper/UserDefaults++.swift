//
//  UserDefaults++.swift
//  carryonex
//
//  Created by Chen, Zian on 11/2/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

let usernameKey = "com.carryonex.user-default.key.username"
let deviceTokenKey = "com.carryonex.user-default.key.device-token"
let hasSpotlightHome = "hasSpotlightHome"
let hasSpotlightOrderList = "hasSpotlightOrderList"

extension UserDefaults {
    
    //Username
    static func setUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: usernameKey)
        UserDefaults.standard.synchronize()
    }
    
    static func getUsername() -> String? {
        return UserDefaults.standard.string(forKey: usernameKey)
    }
    
    static func removeUsername() {
        UserDefaults.standard.removeObject(forKey: usernameKey)
    }
    
    //Device Token
    static func getDeviceToken() -> String? {
        return UserDefaults.standard.string(forKey: deviceTokenKey)
    }
    
    static func setDeviceToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: deviceTokenKey)
        UserDefaults.standard.synchronize()
    }
    
    // Spotlight
    static func setHasSpotlighHome(isFinished: Bool) {
        UserDefaults.standard.set(isFinished, forKey: hasSpotlightHome)
    }
    
    static func getHasSoptlightHome() -> Bool {
        return UserDefaults.standard.bool(forKey: hasSpotlightHome)
    }
    
}
