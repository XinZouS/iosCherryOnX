//
//  ProfileUser.swift
//  carryonex
//
//  Created by Chen, Zian on 10/18/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import Unbox

enum ProfileUserKey: String {
    case id          = "id"
    case email       = "email"
    case username    = "username"
    case phone       = "phone"
    case realName    = "real_name"
    case status      = "status"
    case token       = "token"
    case imageUrl    = "image_url"
    case pubDate     = "pub_date"
    case timestamp   = "timestamp"
    case salt        = "salt"
    case passportUrl = "passport_url"
    case idAUrl      = "ida_url"
    case idBUrl      = "idb_url"
    case walletId    = "wallet_id"
    case isIdVerified = "id_verified"
    case isPhoneVerified = "phone_verified"
    case deviceToken = "device_token"
}

class ProfileUser: Unboxable  {
    
    var id: String?
    var username: String?
    var token: String?
    var realName: String?
    var phone: String?
    var phoneCountryCode: String?
    var email: String?
    var imageUrl: String?
    var idAUrl: String?
    var idBUrl: String?
    var passportUrl: String?
    var isIdVerified: Bool = false
    var isPhoneVerified: Bool = false
    var status: Status?
    var deviceToken: String?
    
    init() {
        //Initialization
    }
    
    func printAllData(){
        let allData = """
        id = \(id ?? "")
        username = \(username ?? "")
        token = \(token ?? "")
        realName = \(realName ?? "")
        phone = \(phone ?? ""), countryCode = \(phoneCountryCode ?? "")
        email = \(email ?? "")
        imageUrl = \(imageUrl ?? "")
        idA_Url = \(idAUrl ?? "")
        idB_Url = \(idBUrl ?? "")"
        passportUrl = \(passportUrl ?? "")
        isIdVerified = \(isIdVerified)
        isPhoneVerified = \(isPhoneVerified)
        deviceToken = \(deviceToken ?? "")
        """
        print(allData)
    }
 
    required init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: ProfileUserKey.id.rawValue)
        self.username = try? unboxer.unbox(key: ProfileUserKey.username.rawValue)
        self.token = try? unboxer.unbox(key: ProfileUserKey.token.rawValue)
        
        self.status = try? unboxer.unbox(key: ProfileUserKey.status.rawValue)
        self.realName = try? unboxer.unbox(key: ProfileUserKey.realName.rawValue)
        self.phone = try? unboxer.unbox(key: ProfileUserKey.phone.rawValue)
        self.email = try? unboxer.unbox(key: ProfileUserKey.email.rawValue)
        
        self.imageUrl = try? unboxer.unbox(key: ProfileUserKey.imageUrl.rawValue)
        self.idAUrl = try? unboxer.unbox(key: ProfileUserKey.idAUrl.rawValue)
        self.idBUrl = try? unboxer.unbox(key: ProfileUserKey.idBUrl.rawValue)
        self.passportUrl = try? unboxer.unbox(key: ProfileUserKey.passportUrl.rawValue)
        
        self.isPhoneVerified = try unboxer.unbox(key: ProfileUserKey.isPhoneVerified.rawValue)
        self.isIdVerified = try unboxer.unbox(key: ProfileUserKey.isIdVerified.rawValue)
        self.deviceToken = try? unboxer.unbox(key: ProfileUserKey.deviceToken.rawValue)
    }
}


class Status: Unboxable  {
    var id: Int?
    var description: String?
    
    required init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: "id")
        self.description = try? unboxer.unbox(key: "description")
    }
}
