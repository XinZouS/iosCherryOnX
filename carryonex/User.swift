//
//  User.swift
//  carryonex
//
//  Created by Xin Zou on 8/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
 
class User : NSObject, NSCoding {
    
    var id:         String?
    var username:   String?
    var password:   String?
    
    var token:      Int?
    
    var nickName:   String? // username is for login, nickName is for display
    var phone:      String?
    var phoneCountryCode: String?
    var email:      String?
    
    var imageUrl   : String?    
    var idCardA_Url: String?
    var idCardB_Url: String?
    var passportUrl: String?
    var isVerified : Bool!
    
    var walletId :  String?
    
    var requestIdList : [String]? // all my requestId
    var tripIdList    : [String]? // all my tripId
    
    var ordersIdLogAsShipper: [String]? // IDs of request I take in
    
    var isShipper: Bool!
    
    
    // use: User.sharedInstance.xxx
    static var shared = User()  // This is singleton
    
    
    private override init() {
        super.init()
        
        resetAllData()
    }
    
    private func resetAllData(){
        id          = "userIdString123"
        username    = ""
        password    = ""
        token       = 0
        
        nickName    = ""
        phone       = ""
        phoneCountryCode = "086"
        email       = ""
        
        imageUrl    = ""
        idCardA_Url = ""
        idCardB_Url = ""
        passportUrl = ""
        isVerified  = false
        
        walletId    = "123456789"
        
        requestIdList = []
        tripIdList  = []
        
        ordersIdLogAsShipper = [] // IDs of request I take in
        
        isShipper = false
    }
    
    
    private init(dictionary: [String : Any]) {
        super.init()
        setupUserBy(dictionary: dictionary)
    }
    
    func setupUserBy(dictionary: [String : Any]) {
        
        id          = dictionary["id"] as? String ?? "nilId"
        username    = dictionary["username"] as? String ?? "nilUsername"
        password    = dictionary["password"] as? String ?? "nilPassword"
        
        token       = dictionary["token"] as? Int ?? 0
        
        nickName    = dictionary["nickName"] as? String ?? ""
        phone       = dictionary["phone"] as? String ?? ""
        phoneCountryCode = dictionary["phoneCountryCode"] as? String ?? "086"
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
    
    // for save in local disk:
    
    internal required convenience init(coder aDecoder: NSCoder) {
        var dictionary = [String : Any]()
        
        dictionary["id"]        = aDecoder.decodeObject(forKey: "id") as? String
        dictionary["username"]  = aDecoder.decodeObject(forKey: "username") as? String
        dictionary["password"]  = aDecoder.decodeObject(forKey: "") as? String
        
        dictionary["token"]     = aDecoder.decodeObject(forKey: "token") as? Int
        
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
        
        self.init(dictionary: dictionary)
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
        print("OK, fetch User form local disk and setup success! getUser.id = \(User.shared.id)")
        print("    and user image url = \(User.shared.imageUrl)")
    }
    
    func removeFromLocalDisk(){
        UserDefaults.standard.removeObject(forKey: "User")
        print("OK, removed user from local disk.")
    }

    func clearCurrentData(){
        resetAllData()
    }
    
    
}

