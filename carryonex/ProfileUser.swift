//
//  ProfileUser.swift
//  carryonex
//
//  Created by Chen, Zian on 10/18/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import Unbox

class ProfileUser: Unboxable  {
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
    }
    
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
    var isVerified: Bool = false
    
    init() {
        //Initialization
    }
    
//    private func setupPhoneAndCountryCode() {
//        guard let phone = phone else { return }
//        if phone.contains("-") {
//            let arr = phone.components(separatedBy: "-")
//            self.phone = arr.last
//            if let characterCount = arr.first?.characters.count, characterCount < 5 {
//                self.phoneCountryCode = arr.first
//            }
//        }
//    }
//
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
        isVerified = \(isVerified)
        """
        print(allData)
    }
 
    required init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: ProfileUserKey.id.rawValue)
        self.username = try? unboxer.unbox(key: ProfileUserKey.username.rawValue)
        self.token = try? unboxer.unbox(key: ProfileUserKey.token.rawValue)
        
        self.realName = try? unboxer.unbox(key: ProfileUserKey.realName.rawValue)
        self.phone = try? unboxer.unbox(key: ProfileUserKey.phone.rawValue)
        self.email = try? unboxer.unbox(key: ProfileUserKey.email.rawValue)
        
        self.imageUrl = try? unboxer.unbox(key: ProfileUserKey.imageUrl.rawValue)
        self.idAUrl = try? unboxer.unbox(key: ProfileUserKey.idAUrl.rawValue)
        self.idBUrl = try? unboxer.unbox(key: ProfileUserKey.idBUrl.rawValue)
        self.passportUrl = try? unboxer.unbox(key: ProfileUserKey.passportUrl.rawValue)
    }
}
