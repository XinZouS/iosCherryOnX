//
//  CUser.swift
//  carryonex
//
//  Created by Xin Zou on 10/17/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import Unbox

enum UserKey: String {
    case appToken  = "app_token"
    case timestamp = "timestamp"
    case id       = "id"
    case username = "username"
    case password = "password"
    case token       = "user_token"
    case realName    = "real_name"
    case phone       = "phone"
    case email       = "email"
    case imageUrl    = "image_url"
    case idCardA_Url = "ida_url"
    case idCardB_Url = "idb_url"
    case passportUrl = "passport_url"
    case isVerified  = "status_id"
    case walletId    = "wallet_id"
}

struct CUser {
    var id:         String?
    var username:   String?
    var password:   String?
    var token:      String?
    var realName:   String? // username is for login, realName is for display
    var phone:      String?
    var email:      String?
    var imageUrl:   String?
}

extension CUser: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: UserKey.id.rawValue)
        self.username = try? unboxer.unbox(key: UserKey.username.rawValue)
        self.password = try? unboxer.unbox(key: UserKey.password.rawValue)
        self.token = try? unboxer.unbox(key: UserKey.token.rawValue)
        self.realName = try? unboxer.unbox(key: UserKey.realName.rawValue)
        self.phone = try? unboxer.unbox(key: UserKey.phone.rawValue)
        self.email = try? unboxer.unbox(key: UserKey.email.rawValue)
        self.imageUrl = try? unboxer.unbox(key: UserKey.imageUrl.rawValue)
    }
}
