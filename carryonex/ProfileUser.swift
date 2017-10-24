//
//  ProfileUser.swift
//  carryonex
//
//  Created by Chen, Zian on 10/18/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import Unbox

class ProfileUser: NSObject, NSCoding, Unboxable { // need NSObject and NSCoding for saving to disk
    var id:         String? = "demo user"
    var username:   String? = ""
    var token:      String? = ""
    
    var realName:   String? = ""
    var phone:      String? = "" { didSet{ setupPhoneAndCountryCode() }}
    var phoneCountryCode: String? = ""
    var email:      String? = ""
    
    var imageUrl:   String? = ""
    var idCardA_Url: String? = ""
    var idCardB_Url: String? = ""
    var passportUrl: String? = ""
    var isVerified : Bool = false
    
    var requestIdList : [String]? = []
    var tripIdList    : [String]? = []
    var ordersIdLogAsShipper: [String]? = []
    
    /// for save in local disk:
    
    required override init() {
        super.init()
    }
    
    internal required convenience init(coder aDecoder: NSCoder) {
        var dictionary = [String : Any]()
        
        dictionary["id"]        = aDecoder.decodeObject(forKey: "id")       as? String
        dictionary["username"]  = aDecoder.decodeObject(forKey: "username") as? String
        dictionary["token"]     = aDecoder.decodeObject(forKey: "token")    as? String
        
        dictionary["realName"]  = aDecoder.decodeObject(forKey: "realName") as? String
        dictionary["phone"]     = aDecoder.decodeObject(forKey: "phone")    as? String
        dictionary["phoneCountryCode"]  = aDecoder.decodeObject(forKey: "phoneCountryCode") as? String
        dictionary["email"]     = aDecoder.decodeObject(forKey: "email")    as? String
        
        dictionary["imageUrl"]     = aDecoder.decodeObject(forKey: "imageUrl")    as? String
        dictionary["idCardA_Url"]  = aDecoder.decodeObject(forKey: "idCardA_Url") as? String
        dictionary["idCardB_Url"]  = aDecoder.decodeObject(forKey: "idCardB_Url") as? String
        dictionary["passportUrl"]  = aDecoder.decodeObject(forKey: "passportUrl") as? String
        dictionary["isVerified"]   = aDecoder.decodeObject(forKey: "isVerified")  as? Bool

        // these should save into DB, not local
//        dictionary["requestIdList"]  = aDecoder.decodeObject(forKey: "requestIdList") as? [String]
//        dictionary["tripIdList"]     = aDecoder.decodeObject(forKey: "tripIdList")    as? [String]
//        dictionary["ordersIdLogAsShipper"]  = aDecoder.decodeObject(forKey: "ordersIdLogAsShipper") as? [String]
        
        self.init()
        setupByLocal(dictionary)
    }
    
    // should encode use internal for local disk saving
    internal func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")
        aCoder.encode(token, forKey: "token")
        
        aCoder.encode(realName, forKey: "realName")
        aCoder.encode(phone, forKey: "phone")
        aCoder.encode(phoneCountryCode, forKey: "phoneCountryCode")
        aCoder.encode(email, forKey: "email")
        
        aCoder.encode(imageUrl, forKey: "imageUrl")
        aCoder.encode(idCardA_Url, forKey: "idCardA_Url")
        aCoder.encode(idCardB_Url, forKey: "idCardB_Url")
        aCoder.encode(passportUrl, forKey: "passportUrl")
        aCoder.encode(isVerified, forKey: "isVerified")
        
        // these should save into DB, not local
//        aCoder.encode(requestIdList, forKey: "requestIdList")
//        aCoder.encode(tripIdList, forKey: "tripIdList")
//        aCoder.encode(ordersIdLogAsShipper, forKey: "ordersIdLogAsShipper")
    }
    
    func packAllPropertiesAsDictionary() -> [String:Any] {
        var json = [String:Any]()
        json[UserKeyInDB.id.rawValue]          = id
        json[UserKeyInDB.username.rawValue]    = username // value is "phone" to DB
        json[UserKeyInDB.token.rawValue]       = token
        
        json[UserKeyInDB.realName.rawValue]    = realName
        json[UserKeyInDB.phone.rawValue]       = "\(phoneCountryCode)-\(phone)"
        json[UserKeyInDB.email.rawValue]       = email
        
        json[UserKeyInDB.imageUrl.rawValue]    = imageUrl
        json[UserKeyInDB.idCardA_Url.rawValue] = idCardA_Url
        json[UserKeyInDB.idCardB_Url.rawValue] = idCardB_Url
        json[UserKeyInDB.passportUrl.rawValue] = passportUrl
        json[UserKeyInDB.isVerified.rawValue]  = isVerified
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
    func setupByLocal(_ dictionary: [String : Any]) {
        print("will setup by dict = \(dictionary)")
        // should NOT modify other values if the dictionary didnot contains them!!!
        self.id          = dictionary["id"]       as? String ?? self.id
        self.username    = dictionary["username"] as? String ?? self.username
        self.token       = dictionary["token"]    as? String ?? self.token
        
        self.realName    = dictionary["realName"] as? String ?? self.realName
        self.phone       = dictionary["phone"]    as? String ?? self.phone
        self.phoneCountryCode = dictionary["phoneCountryCode"] as? String ?? self.phoneCountryCode
        self.email       = dictionary["email"]    as? String ?? self.email
        
        self.imageUrl    = dictionary["imageUrl"] as? String ?? self.imageUrl
        self.idCardA_Url = dictionary["idCardA_Url"] as? String ?? self.idCardA_Url
        self.idCardB_Url = dictionary["idCardB_Url"] as? String ?? self.idCardB_Url
        self.passportUrl = dictionary["passportUrl"] as? String ?? self.passportUrl
        self.isVerified  = dictionary["isVerified"] as? Bool ?? self.isVerified
    }
    
    func setupByDictionaryFromDB(_ dictionary: [String : Any]) {
        // should NOT modify other values if the dictionary didnot contains them!!!
        id          = dictionary[UserKeyInDB.id.rawValue]       as? String ?? self.id
        username    = dictionary[UserKeyInDB.username.rawValue] as? String ?? self.username
        token       = dictionary[UserKeyInDB.token.rawValue]    as? String ?? self.token
        
        realName    = dictionary[UserKeyInDB.realName.rawValue]     as? String ?? self.realName
        phone       = dictionary[UserKeyInDB.phone.rawValue]        as? String ?? self.phone
        //phoneCountryCode = dictionary[UserKeyInDB.phone.rawValue]   as? String ?? self.phoneCountryCode , there is NO countrycode in DB!!
        email       = dictionary[UserKeyInDB.email.rawValue]        as? String ?? self.email
        
        imageUrl    = dictionary[UserKeyInDB.imageUrl.rawValue]     as? String ?? self.imageUrl
        idCardA_Url = dictionary[UserKeyInDB.idCardA_Url.rawValue]  as? String ?? self.idCardA_Url
        idCardB_Url = dictionary[UserKeyInDB.idCardB_Url.rawValue]  as? String ?? self.idCardB_Url
        passportUrl = dictionary[UserKeyInDB.passportUrl.rawValue]  as? String ?? self.passportUrl
        isVerified  = dictionary[UserKeyInDB.isVerified.rawValue]   as? Bool   ?? self.isVerified
    }
    
    //MARK:- Disk Save
    
    func saveIntoLocalDisk(){
        print("Trying to save ProfileManager into local disk ...")
        DispatchQueue.main.async {
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKey.ProfileUser.rawValue)
            UserDefaults.standard.synchronize()
            print("OK, save ProfileManager into local disk success!!! user = \(self.printAllData())")
        }
    }
    
    func loadFromLocalDisk() -> ProfileUser? {
        print("\n\rtrying to loadFromLocalDisk() ...... ")
        if let savedUser = UserDefaults.standard.object(forKey: UserDefaultKey.ProfileUser.rawValue) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: savedUser) as! ProfileUser // Xin - here MUST return as! ProfileUser, NOT [String:Any], otherwize local user unable to get value form disk.
        }else{
            print("errorr in ProfileUser.swift: loadFromLocalDisk(): can not get Data, will return nil instead...")
        }
        return nil as ProfileUser?
    }
    
    func removeFromLocalDisk(){
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.ProfileUser.rawValue)
        print("OK, removed user from local disk.")
    }
    
    private func setupPhoneAndCountryCode(){
        if phone != nil, phone!.contains("-") {
            let arr = phone!.components(separatedBy: "-")
            phone = arr.last
            phoneCountryCode = (arr.first!.characters.count < 5) ? arr.first! : self.phoneCountryCode
        }
    }
    
    func printAllData(){
        print("id = \(id)")
        print("username = \(username)")
        print("token = \(token)")
        
        print("realName = \(realName)")
        print("phone = \(phone), countryCode = \(phoneCountryCode)")
        print("email = \(email)")
        
        print("imageUrl = \(imageUrl)")
        print("idcardA_Url = \(idCardA_Url)")
        print("idcardB_Url = \(idCardB_Url)")
        print("passportUrl = \(passportUrl)")
        print("isVerified = \(isVerified)")
        
        print("requestIdList = \(requestIdList)")
        print("tripIdList = \(tripIdList)")
        print("ordersIdLogAsShipper = \(ordersIdLogAsShipper)")
    }
    
    required init(unboxer: Unboxer) throws {
        self.id         = try? unboxer.unbox(key: UserKeyInDB.id.rawValue)
        self.username   = try? unboxer.unbox(key: UserKeyInDB.username.rawValue)
        self.token      = try? unboxer.unbox(key: UserKeyInDB.token.rawValue)
        
        self.realName   = try? unboxer.unbox(key: UserKeyInDB.realName.rawValue)
        self.phone      = try? unboxer.unbox(key: UserKeyInDB.phone.rawValue)
        self.email      = try? unboxer.unbox(key: UserKeyInDB.email.rawValue)
        
        self.imageUrl   = try? unboxer.unbox(key: UserKeyInDB.imageUrl.rawValue)
        self.idCardA_Url = try? unboxer.unbox(key: UserKeyInDB.idCardA_Url.rawValue)
        self.idCardB_Url = try? unboxer.unbox(key: UserKeyInDB.idCardB_Url.rawValue)
        self.passportUrl = try? unboxer.unbox(key: UserKeyInDB.passportUrl.rawValue)
        self.isVerified  = (try? unboxer.unbox(key: UserKeyInDB.isVerified.rawValue)) ?? false
    }
}

