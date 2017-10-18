//
//  User.swift
//  carryonex
//
//  Created by Xin Zou on 8/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation


class User : BaseUser, NSCoding {
    
    //    var id:         String?
    //    var username:   String?
    //    var password:   String?
    //
    //    var token:      Int?
    //
    //    var nickName:   String? // username is for login, nickName is for display
    //    var phone:      String?
    //    var phoneCountryCode: String?
    //    var email:      String?
    //
    //    var imageUrl   : String?
    var idCardA_Url: String?
    var idCardB_Url: String?
    var passportUrl: String?
    var isVerified : Bool!
    var walletId :  String?
    
    var requestIdList : [String]? // all my requestId
    var tripIdList    : [String]? // all my tripId
    
    var ordersIdLogAsShipper: [String]? // IDs of request I take in
    
    var isShipper: Bool!
    
    
    // use: User.shared.xxx
    static var shared = User()  // This is singleton
    
    
    private override init() {
        super.init()
        
        resetAllData()
    }
    
    private func resetAllData(){
        id          = "demoUser"
        username    = ""
        password    = ""
        token       = ""
        
        nickName    = ""
        phone       = ""
        phoneCountryCode = ""
        email       = ""
        
        imageUrl    = ""
        idCardA_Url = ""
        idCardB_Url = ""
        passportUrl = ""
        isVerified  = false
        
        walletId    = ""
        
        requestIdList = []
        tripIdList  = []
        
        ordersIdLogAsShipper = [] // IDs of request I take in
        
        isShipper = false
    }
    
    
    override func setupUserByLocal(dictionary: [String : Any]) {
        
        id          = dictionary["id"] as? String ?? "demoUser"
        username    = dictionary["username"] as? String ?? ""
        password    = dictionary["password"] as? String ?? ""
        
        token       = dictionary["token"] as? String ?? ""
        
        nickName    = dictionary["nickName"] as? String ?? ""
        phone       = dictionary["phone"] as? String ?? ""
        phoneCountryCode = dictionary["phoneCountryCode"] as? String ?? ""
        email       = dictionary["email"] as? String ?? ""
        
        imageUrl    = dictionary["imageUrl"] as? String ?? ""
        idCardA_Url = dictionary["idCardA_Url"] as? String ?? ""
        idCardB_Url = dictionary["idCardB_Url"] as? String ?? ""
        passportUrl = dictionary["passportUrl"] as? String ?? ""
        isVerified  = dictionary["isVerified"]  as? Bool ?? false
        
        requestIdList = dictionary["requestIdList"] as? [String]
        tripIdList    = dictionary["tripIdList"] as? [String]
        
        ordersIdLogAsShipper = dictionary["ordersIdLogAsShipper"] as? [String] // IDs of request I take in
        
        isShipper = dictionary["isShipper"] as! Bool
        
    }
    
    override func setupByDictionaryFromDB(_ dictionary: [String : Any]) {
        
        id          = dictionary[PropInDB.id.rawValue] as? String ?? "demoUser"
        username    = dictionary[PropInDB.username.rawValue] as? String ?? ""
        password    = dictionary[PropInDB.password.rawValue] as? String ?? "" //TODO: this will be a hash, can we save it and use ?????
        
        token       = dictionary[PropInDB.token.rawValue] as? String ?? ""
        
        nickName    = dictionary[PropInDB.nickName.rawValue] as? String ?? ""
        phone       = (dictionary[PropInDB.phone.rawValue] as? String)?.components(separatedBy: "-").last ?? ""
        phoneCountryCode = (dictionary[PropInDB.phone.rawValue] as? String)?.components(separatedBy: "-").first ?? ""
        email       = dictionary[PropInDB.email.rawValue] as? String ?? ""
        
        imageUrl    = dictionary[PropInDB.imageUrl.rawValue] as? String ?? ""
        idCardA_Url = dictionary[PropInDB.idCardA_Url.rawValue] as? String ?? ""
        idCardB_Url = dictionary[PropInDB.idCardB_Url.rawValue] as? String ?? ""
        passportUrl = dictionary[PropInDB.passportUrl.rawValue] as? String ?? ""
        isVerified  = dictionary[PropInDB.isVerified.rawValue]  as? Bool ?? false
    }
    
    // for save in local disk:
    
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
        
        dictionary["isShipper"]  = aDecoder.decodeObject(forKey: "isShipper") as? Bool
        
        self.init()
        self.setupUserByLocal(dictionary: dictionary)
    }
    
    // should encode use internal?? or public??
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
        
        aCoder.encode(isShipper, forKey: "isShipper")
    }
    
    
    
    func saveIntoLocalDisk(){
        print("Trying to save into local disk ...")
        DispatchQueue.main.async {
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: self)
            UserDefaults.standard.set(encodedData, forKey: "User")
            UserDefaults.standard.synchronize()
            print("OK, save into local disk success!!!")
        }
    }
    
    func loadFromLocalDisk(){
        print("\n\rtrying to fetchUserFromLocalDiskAndSetup() ...... ")
        guard let savedUser = UserDefaults.standard.object(forKey: "User") as? Data else { return }
        User.shared = NSKeyedUnarchiver.unarchiveObject(with: savedUser) as! User
        print("OK, fetch User form local disk and setup success! getUser = \(User.shared.printAllData())")
    }
    
    func removeFromLocalDisk(){
        UserDefaults.standard.removeObject(forKey: "User")
        print("OK, removed user from local disk.")
    }
    
    func packAllPropertiesAsDictionary() -> [String:Any] {
        var json = [String:Any]()
        json[PropInDB.id.rawValue]          = id!
        json[PropInDB.username.rawValue]    = username! // value is "phone" to DB
        json[PropInDB.password.rawValue]    = password!
        json[PropInDB.token.rawValue]       = token!
        json[PropInDB.nickName.rawValue]    = nickName!
        json[PropInDB.phone.rawValue]       = "\(phoneCountryCode!)-\(phone!)"
        json[PropInDB.email.rawValue]       = email!
        json[PropInDB.imageUrl.rawValue]    = imageUrl!
        json[PropInDB.idCardA_Url.rawValue] = idCardA_Url!
        json[PropInDB.idCardB_Url.rawValue] = idCardB_Url!
        json[PropInDB.passportUrl.rawValue] = passportUrl!
        json[PropInDB.isVerified.rawValue]  = isVerified!
        json[PropInDB.walletId.rawValue]    = walletId!
        return json
    }
    func packAllPropertiesAsData() -> Data? {
        var json = [String:Any]()
        json[PropInDB.id.rawValue]          = id!
        json[PropInDB.username.rawValue]    = username! // value is "phone" to DB
        json[PropInDB.password.rawValue]    = password!
        json[PropInDB.token.rawValue]       = token!
        json[PropInDB.nickName.rawValue]    = nickName!
        json[PropInDB.phone.rawValue]       = "\(phoneCountryCode!)-\(phone!)"
        json[PropInDB.email.rawValue]       = email!
        json[PropInDB.imageUrl.rawValue]    = imageUrl!
        json[PropInDB.idCardA_Url.rawValue] = idCardA_Url!
        json[PropInDB.idCardB_Url.rawValue] = idCardB_Url!
        json[PropInDB.passportUrl.rawValue] = passportUrl!
        json[PropInDB.isVerified.rawValue]  = isVerified!
        json[PropInDB.walletId.rawValue]    = walletId!
        do{
            if let dt = try JSONSerialization.data(withJSONObject: json, options: []) as Data? {
                return dt
            }
        }catch let err {
            print("get errorroror when JSONSerialization for User object: \(err)")
        }
        return nil
    }
    
    func clearCurrentData(){
        resetAllData()
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
        print("idcardA_Url = \(idCardA_Url)")
        print("idcardB_Url = \(idCardB_Url)")
        print("passportUrl = \(passportUrl)")
        print("isVerified = \(isVerified)")
        print("walletId = \(walletId)")
        print("requestIdList = \(requestIdList)")
        print("tripIdList = \(tripIdList)")
        print("ordersIdLogAsShipper = \(ordersIdLogAsShipper)")
        print("isShipper = \(isShipper)")
    }
    
    
    
    
}

