//
//  BaseUser.swift
//  carryonex
//
//  Created by Xin Zou on 10/7/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

 
class BaseUser : NSObject {
    
    var id:         String?
    var username:   String?
    var password:   String?
    
    var token:      Int?
    
    var nickName:   String? // username is for login, nickName is for display
    var phone:      String?
    var phoneCountryCode: String?
    var email:      String?
    
    var imageUrl   : String?
    
    enum PropInDB: String {
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
    
    
    
    override init() {
        super.init()
        
        resetAllData()
    }
    
    private func resetAllData(){
        id          = "demoUser"
        username    = ""
        password    = ""
        
        token       = 0
        
        nickName    = ""
        phone       = ""
        phoneCountryCode = ""
        email       = ""
        
        imageUrl    = ""
    }
    
    
    init(dictionary: [String : Any]) {
        super.init()
        setupUserByLocal(dictionary: dictionary)
    }
    
    func setupUserByLocal(dictionary: [String : Any]) {
        
        id          = dictionary["id"] as? String ?? ""
        username    = dictionary["username"] as? String ?? ""
        password    = dictionary["password"] as? String ?? ""
        
        token       = dictionary["token"] as? Int ?? 0
        
        nickName    = dictionary["nickName"] as? String ?? ""
        phone       = dictionary["phone"] as? String ?? ""
        phoneCountryCode = dictionary["phoneCountryCode"] as? String ?? ""
        email       = dictionary["email"] as? String ?? ""
        
        imageUrl    = dictionary["imageUrl"] as? String ?? ""
    }
    
    func setupByDictionaryFromDB(_ dictionary: [String : Any]) {
        
        id          = dictionary[PropInDB.id.rawValue] as? String ?? "demoUser"
        username    = dictionary[PropInDB.username.rawValue] as? String ?? ""
        //password    = dictionary[PropInDB.password.rawValue] as? String ?? "" // this will be a hash, can we save it and use ?????
        
        token       = dictionary[PropInDB.token.rawValue] as? Int ?? 0
        
        nickName    = dictionary[PropInDB.nickName.rawValue] as? String ?? ""
        phone       = (dictionary[PropInDB.phone.rawValue] as? String)?.components(separatedBy: "-").last ?? ""
        phoneCountryCode = (dictionary[PropInDB.phone.rawValue] as? String)?.components(separatedBy: "-").first ?? ""
        email       = dictionary[PropInDB.email.rawValue] as? String ?? ""
        
        imageUrl    = dictionary[PropInDB.imageUrl.rawValue] as? String ?? ""
    }
    
    
}

