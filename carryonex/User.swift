//
//  User.swift
//  carryonex
//
//  Created by Xin Zou on 8/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import Unbox

enum UserKeyInDB: String {
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

class User: Unboxable {
    var id:         String? = "demoUser"
    var username:   String? = ""
    var password:   String? = ""
    var token:      String? = ""
    var realName:   String? = ""
    var phoneCountryCode: String? = ""
    var email:      String? = ""
    var imageUrl:   String? = ""
    var phone:      String? = "" {
        didSet{
            setupPhoneAndCountryCode()
        }
    }
    
    required init() {
        //to satisfy extension
    }
    
    func setupUserByLocal(dictionary: [String : Any]) {
        id          = dictionary["id"] as? String ?? "demoUser"
        username    = dictionary["username"] as? String ?? ""
        password    = dictionary["password"] as? String ?? ""
        token       = dictionary["token"] as? String ?? ""
        realName    = dictionary["realName"] as? String ?? ""
        phone       = dictionary["phone"] as? String ?? ""
        phoneCountryCode = dictionary["phoneCountryCode"] as? String ?? ""
        email       = dictionary["email"] as? String ?? ""
        imageUrl    = dictionary["imageUrl"] as? String ?? ""
    }
    
    func setupByDictionaryFromDB(_ dictionary: [String : Any]) {
        id          = dictionary[UserKeyInDB.id.rawValue] as? String ?? "demoUser"
        username    = dictionary[UserKeyInDB.username.rawValue] as? String ?? ""
        password    = dictionary[UserKeyInDB.password.rawValue] as? String ?? "" //TODO: this will be a hash, can we save it and use ?????
        token       = dictionary[UserKeyInDB.token.rawValue] as? String ?? ""
        realName    = dictionary[UserKeyInDB.realName.rawValue] as? String ?? ""
        phone       = (dictionary[UserKeyInDB.phone.rawValue] as? String)?.components(separatedBy: "-").last ?? ""
        phoneCountryCode = (dictionary[UserKeyInDB.phone.rawValue] as? String)?.components(separatedBy: "-").first ?? ""
        email       = dictionary[UserKeyInDB.email.rawValue] as? String ?? ""
        imageUrl    = dictionary[UserKeyInDB.imageUrl.rawValue] as? String ?? ""
    }
    
    private func setupPhoneAndCountryCode(){
        if phone != nil, phone!.contains("-") {
            let arr = phone!.components(separatedBy: "-")
            phone = arr.last
            phoneCountryCode = arr.first
        }
    }
    
    open func printAllData(){
        print("id = \(id!)")
        print("username = \(username!)")
        print("password = \(password!)")
        print("token = \(token!)")
        print("realName = \(realName!)")
        print("phone = \(phone), countryCode = \(phoneCountryCode!)")
        print("email = \(email!)")
        print("imageUrl = \(imageUrl!)")
    }
    
    required init(unboxer: Unboxer) throws {
        self.id         = try? unboxer.unbox(key: UserKeyInDB.id.rawValue)
        self.username   = try? unboxer.unbox(key: UserKeyInDB.username.rawValue)
        self.password   = try? unboxer.unbox(key: UserKeyInDB.password.rawValue)
        self.token      = try? unboxer.unbox(key: UserKeyInDB.token.rawValue)
        self.realName   = try? unboxer.unbox(key: UserKeyInDB.realName.rawValue)
        self.phone      = try? unboxer.unbox(key: UserKeyInDB.phone.rawValue)
        self.email      = try? unboxer.unbox(key: UserKeyInDB.email.rawValue)
        self.imageUrl   = try? unboxer.unbox(key: UserKeyInDB.imageUrl.rawValue)
    }
}
