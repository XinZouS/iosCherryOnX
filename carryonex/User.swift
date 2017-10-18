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
    case nickName    = "real_name"
    case phone       = "phone"
    //case phoneCountryCode = ""  put into phonNumber, seprator: -
    case email       = "email"
    case imageUrl    = "image_url"
    case idCardA_Url = "ida_url"
    case idCardB_Url = "idb_url"
    case passportUrl = "passport_url"
    case isVerified  = "status_id"
    case walletId    = "wallet_id"
}


class User : NSObject, Unboxable {
    
    var id:         String?
    var username:   String?
    var password:   String?
    
    var token:      String?
    
    var nickName:   String? // username is for login, nickName is for display
    var phone:      String? {
        didSet{
            setupPhoneAndCountryCode()
        }
    }
    var phoneCountryCode: String?
    var email:      String?
    
    var imageUrl:   String?
    
    
    // use: User.shared.xxx
    //static var shared = User()  This is singleton ---> change it to ProfileManager:User{}
    
    
    override init() {
        super.init()
        
        resetAllData()
    }
    
    required init(unboxer: Unboxer) {
        self.id         = try? unboxer.unbox(key: UserKeyInDB.id.rawValue)
        self.username   = try? unboxer.unbox(key: UserKeyInDB.username.rawValue)
        self.password   = try? unboxer.unbox(key: UserKeyInDB.password.rawValue)
        
        self.token      = try? unboxer.unbox(key: UserKeyInDB.token.rawValue)
        
        self.nickName   = try? unboxer.unbox(key: UserKeyInDB.nickName.rawValue)
        self.phone      = try? unboxer.unbox(key: UserKeyInDB.phone.rawValue)
        self.email      = try? unboxer.unbox(key: UserKeyInDB.email.rawValue)
        
        self.imageUrl   = try? unboxer.unbox(key: UserKeyInDB.imageUrl.rawValue)
    }

    
    func resetAllData(){
        id          = "demoUser"
        username    = ""
        password    = ""
        token       = ""
        
        nickName    = ""

        phone       = ""
        phoneCountryCode = ""
        email       = ""
        
        imageUrl    = ""
    }
    
    
    func setupUserByLocal(dictionary: [String : Any]) {
        
        id          = dictionary["id"] as? String ?? "demoUser"
        username    = dictionary["username"] as? String ?? ""
        password    = dictionary["password"] as? String ?? ""
        
        token       = dictionary["token"] as? String ?? ""
        
        nickName    = dictionary["nickName"] as? String ?? ""
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
        
        nickName    = dictionary[UserKeyInDB.nickName.rawValue] as? String ?? ""
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
        print("nickName = \(nickName!)")
        print("phone = \(phone), countryCode = \(phoneCountryCode!)")
        print("email = \(email!)")
        print("imageUrl = \(imageUrl!)")
    }
    
    
}


