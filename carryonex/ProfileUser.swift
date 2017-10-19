//
//  ProfileUser.swift
//  carryonex
//
//  Created by Chen, Zian on 10/18/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import Unbox

class ProfileUser: Unboxable {
    var id:         String? = "demo user"
    var username:   String? = ""
    var password:   String? = ""
    var token:      String? = ""
    var nickName:   String? = ""
    var phone:      String? = ""
    var phoneCountryCode: String? = ""
    var email:      String? = ""
    var imageUrl:   String? = ""
    var idCardA_Url: String? = ""
    var idCardB_Url: String? = ""
    var passportUrl: String? = ""
    var isVerified : Bool = false
    var walletId :  String? = ""
    var requestIdList : [String]? = []
    var tripIdList    : [String]? = []
    var ordersIdLogAsShipper: [String]? = []
    
    /// for save in local disk:
    
    required init() {
        
    }
    
    internal required convenience init(coder aDecoder: NSCoder) {
        var dictionary = [String : Any]()
        
        dictionary["id"]        = aDecoder.decodeObject(forKey: "id") as? String
        dictionary["username"]  = aDecoder.decodeObject(forKey: "username") as? String
        dictionary["password"]  = aDecoder.decodeObject(forKey: "password") as? String
        
        dictionary["token"]     = aDecoder.decodeObject(forKey: "token") as? String
        
        dictionary["nickName"]  = aDecoder.decodeObject(forKey: "nickName") as? String
        dictionary["phone"]     = aDecoder.decodeObject(forKey: "phone") as? String
        dictionary["phoneCountryCode"]  = aDecoder.decodeObject(forKey: "phoneCountryCode") as? String
        dictionary["email"]     = aDecoder.decodeObject(forKey: "email") as? String
        
        dictionary["imageUrl"]     = aDecoder.decodeObject(forKey: "imageUrl") as? String
        dictionary["idCardA_Url"]  = aDecoder.decodeObject(forKey: "idCardA_Url") as? String
        dictionary["idCardB_Url"]  = aDecoder.decodeObject(forKey: "idCardB_Url") as? String
        dictionary["passportUrl"]  = aDecoder.decodeObject(forKey: "passportUrl") as? String
        dictionary["isVerified"]   = aDecoder.decodeObject(forKey: "isVerified") as? Bool
        
        dictionary["requestIdList"]  = aDecoder.decodeObject(forKey: "requestIdList") as? [String]
        dictionary["tripIdList"]     = aDecoder.decodeObject(forKey: "tripIdList") as? [String]
        
        dictionary["ordersIdLogAsShipper"]  = aDecoder.decodeObject(forKey: "ordersIdLogAsShipper") as? [String]
        
        self.init()
        setupUserByLocal(dictionary: dictionary)
    }
    
    // should encode use internal for local disk saving
    internal func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(password, forKey: "password")
        
        aCoder.encode(token, forKey: "token")
        
        aCoder.encode(nickName, forKey: "nickName")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(phoneCountryCode, forKey: "phoneCountryCode")
        aCoder.encode(email, forKey: "email")
        
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(idCardA_Url, forKey: "idCardA_Url")
        aCoder.encode(idCardB_Url, forKey: "idCardB_Url")
        aCoder.encode(passportUrl, forKey: "passportUrl")
        aCoder.encode(isVerified, forKey: "isVerified")
        
        aCoder.encode(requestIdList, forKey: "requestIdList")
        aCoder.encode(tripIdList, forKey: "tripIdList")
        
        aCoder.encode(ordersIdLogAsShipper, forKey: "ordersIdLogAsShipper")
    }
    
    func packAllPropertiesAsDictionary() -> [String:Any] {
        var json = [String:Any]()
        json[UserKeyInDB.id.rawValue]          = id!
        json[UserKeyInDB.username.rawValue]    = username! // value is "phone" to DB
        json[UserKeyInDB.password.rawValue]    = password!
        json[UserKeyInDB.token.rawValue]       = token!
        json[UserKeyInDB.nickName.rawValue]    = nickName!
        json[UserKeyInDB.phone.rawValue]       = "\(phoneCountryCode!)-\(phone!)"
        json[UserKeyInDB.email.rawValue]       = email!
        json[UserKeyInDB.imageUrl.rawValue]    = imageUrl!
        json[UserKeyInDB.idCardA_Url.rawValue] = idCardA_Url!
        json[UserKeyInDB.idCardB_Url.rawValue] = idCardB_Url!
        json[UserKeyInDB.passportUrl.rawValue] = passportUrl!
        json[UserKeyInDB.isVerified.rawValue]  = isVerified
        json[UserKeyInDB.walletId.rawValue]    = walletId!
        return json
    }
    
    func packAllPropertiesAsData() -> Data? {
        let json = packAllPropertiesAsDictionary
        do {
            if let dt = try JSONSerialization.data(withJSONObject: json, options: []) as Data? {
                return dt
            }
        } catch let err {
            print("get errorroror when JSONSerialization for User object: \(err)")
        }
        return nil
    }
    
    //MARK: - Data Mapping
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
    
    //MARK:- Disk Save
    
    func saveIntoLocalDisk(){
        print("Trying to save ProfileManager into local disk ...")
        DispatchQueue.main.async {
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self)
            UserDefaults.standard.set(encodedData, forKey: "ProfileManager")
            UserDefaults.standard.synchronize()
            print("OK, save ProfileManager into local disk success!!!")
        }
    }
    
    func loadFromLocalDisk(){
        print("\n\rtrying to fetchUserFromLocalDiskAndSetup() ...... ")
        guard let savedUser = UserDefaults.standard.object(forKey: "ProfileManager") as? Data else { return }
        if let dictionary = NSKeyedUnarchiver.unarchiveObject(with: savedUser) as? [String:Any] {
            print("get saved dictionary(user) = \(dictionary)")
            setupUserByLocal(dictionary: dictionary)
            print("OK, fetch User form local disk and setup success! getUser = \(self.printAllData())")
        }
    }
    
    func removeFromLocalDisk(){
        UserDefaults.standard.removeObject(forKey: "ProfileManager")
        print("OK, removed user from local disk.")
    }
    
    func printAllData(){
        print("id = \(id!)")
        print("username = \(username!)")
        print("password = \(password!)")
        print("token = \(token!)")
        print("nickName = \(nickName!)")
        print("phone = \(phone), countryCode = \(phoneCountryCode!)")
        print("email = \(email!)")
        print("imageUrl = \(imageUrl!)")
        print("idcardA_Url = \(idCardA_Url)")
        print("idcardB_Url = \(idCardB_Url)")
        print("passportUrl = \(passportUrl)")
        print("isVerified = \(isVerified)")
        print("walletId = \(walletId)")
        print("requestIdList = \(requestIdList)")
        print("tripIdList = \(tripIdList)")
        print("ordersIdLogAsShipper = \(ordersIdLogAsShipper)")
    }
    
    required init(unboxer: Unboxer) throws {
        self.id         = try? unboxer.unbox(key: UserKeyInDB.id.rawValue)
        self.username   = try? unboxer.unbox(key: UserKeyInDB.username.rawValue)
        self.password   = try? unboxer.unbox(key: UserKeyInDB.password.rawValue)
        self.token      = try? unboxer.unbox(key: UserKeyInDB.token.rawValue)
        self.nickName   = try? unboxer.unbox(key: UserKeyInDB.nickName.rawValue)
        self.phone      = try? unboxer.unbox(key: UserKeyInDB.phone.rawValue)
        self.email      = try? unboxer.unbox(key: UserKeyInDB.email.rawValue)
        self.imageUrl   = try? unboxer.unbox(key: UserKeyInDB.imageUrl.rawValue)
        self.idCardA_Url = try? unboxer.unbox(key: UserKeyInDB.idCardA_Url.rawValue)
        self.idCardB_Url = try? unboxer.unbox(key: UserKeyInDB.idCardB_Url.rawValue)
        self.passportUrl = try? unboxer.unbox(key: UserKeyInDB.passportUrl.rawValue)
        self.isVerified  = (try? unboxer.unbox(key: UserKeyInDB.isVerified.rawValue)) ?? false
        self.walletId    = try? unboxer.unbox(key: UserKeyInDB.walletId.rawValue)
    }
}

