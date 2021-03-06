//
//  ProfileManager.swift
//  carryonex
//
//  Created by Xin Zou on 10/18/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox
import Crashlytics

public extension Notification.Name {
    public static let UserLoggedOut = Notification.Name(rawValue: "com.carryon.user.logout")
    public static let UserDidUpdate = Notification.Name(rawValue: "com.carryon.user.didUpdate")
    public static let WalletDidUpdate = Notification.Name(rawValue: "com.carryon.wallet.didUpdate")
}

struct KeychainConfiguration {
    static let serviceName = "CarryonEx"
    static let accessGroup: String? = nil
}

class ProfileManager: NSObject {

    //MARK: - Variables
    
    static var shared = ProfileManager()
    private var currentUser: ProfileUser?
    var homeProfileInfo: HomeProfileInfo?
    
    var wallet: Wallet? {
        didSet {
            if wallet != nil {
                NotificationCenter.default.post(name: .WalletDidUpdate, object: nil)
            }
        }
    }
    
    var username: String? {
        get { return UserDefaults.getUsername() }
    }
    
    var userToken: String? {
        get { return readUserTokenFromKeychain() }
    }
    
    //MARK: - Convenience Methods
    
    func isLoggedIn() -> Bool {
        return UserDefaults.getUsername() != nil
    }
    
    func getCurrentUser() -> ProfileUser? {
        return currentUser
    }
    
    //MARK: - Login Methods
    func loadLocalUser(completion: ((Bool) -> Void)?) {
        if let username = UserDefaults.getUsername(), let userToken = readUserTokenFromKeychain() {
            ApiServers.shared.getUserInfo(username: username, userToken: userToken, completion: { (homeProfileInfo, error) in
                if let error = error {
                    DLog("loadLocalUser Error: \(error.localizedDescription)")
                    completion?(false)
                    return
                }
                
                if let profileInfo = homeProfileInfo {
                    self.updateHomeProfileInfo(profileInfo, writeToKeychain: false)
                    completion?(true)
                } else {
                    DLog("error: loadLocalUser: return user info is nil")
                    completion?(false)
                }
            })
        }
    }
    
    /**
     completion(isSuccess:Bool, msg:String, type:ErrorType),
     */
    func register(username: String,
                  countryCode: String = "1",
                  phone: String = "",
                  password: String,
                  email: String = "",
                  name: String = "",
                  completion: @escaping(Bool, Error?, ErrorType) -> Swift.Void) {
        
        ApiServers.shared.postRegisterUser(username: username, countryCode: countryCode, phone: phone, password: password, email: email, name: name) { (userToken, error) in
            if let error = error {
                let msg = "Register Error: \(error.localizedDescription)"
                DLog(msg)
                completion(false, error, .userRegisterErr)
                return
            }
            
            if userToken == nil {
                DLog("Unable to retrieve token")
                completion(false, error, .userAlreadyExist)
                return
            }
            
            completion(true, nil, .noError)
        }
    }
    
    func login(username: String? = nil, phone: String? = nil, password: String, completion: @escaping(Bool) -> Swift.Void) {
        
        ApiServers.shared.postLoginUser(username: username, phone: phone, password: password) { (credential, error) in
            if let error = error {
                DLog("Login Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let (userToken, aUsername) = credential else {
                DLog("Unable to retrieve token")
                completion(false)
                return
            }
            
            ApiServers.shared.getUserInfo(username: aUsername, userToken: userToken, completion: { (homeProfileInfo, error) in
                if let error = error {
                    DLog("loadLocalUser Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if let profileInfo = homeProfileInfo {
                    self.updateHomeProfileInfo(profileInfo, writeToKeychain: true)
                    completion(true)
                } else {
                    DLog("return user info is nil")
                    completion(false)
                }
            })
        }
    }
    
    func logoutUser() {
        ApiServers.shared.postLogoutUser { (success, error) in
            debugLog("Remote logged out: \(success)")
        }
        self.currentUser = nil
        TripOrderDataStore.shared.clearStore()
        deleteUserTokenFromKeychain()
        NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
    }
    
    //MARK: - Forget Password (Simple Wrapper for the sake of consistency. Send user the to login page if success)
    func forgetPassword(phone: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        ApiServers.shared.postUserForgetPassword(phone: phone, password: password) { (success, error) in
            completion(success, error)
        }
    }
    
    //MARK: - User Info Method
    func getUserInfo(_ infoType: UsersInfoUpdate, completion: @escaping (Any?, Error?) -> Void) {
        guard isLoggedIn() else {
            DLog("User is not logged in, unable to get user info (single)")
            completion(nil, nil)
            return
        }
        
        ApiServers.shared.getUserInfo(infoType, completion: completion)
    }
    
    //PACKAGE UPDATE
    func updateUserInfo(info: [String: Any], completion: ((Bool) -> Void)?) {
        guard isLoggedIn() else {
            DLog("User is not logged in, unable to update user info")
            completion?(false)
            return
        }
        
        guard let userId = currentUser?.id else {
            DLog("Unable to find user id")
            completion?(false)
            return
        }
        
        var userInfo = info
        userInfo[ProfileUserKey.userId.rawValue] = userId
        ApiServers.shared.postUserUpdateInfo(info: userInfo) { (user, error) in
            if let error = error {
                DLog("User update error: \(error.localizedDescription)")
            }
            
            if let user = user {
                self.updateCurrentUser(user, writeToKeychain: false)
                completion?(true)
            } else {
                DLog("return user info is nil")
                completion?(false)
            }
        }
    }
    
    //SINGLE ITEM UPDATE
    func updateUserInfo(_ type: UsersInfoUpdate, value: Any, completion: ((Bool) -> Void)?) {
        
        guard isLoggedIn() else {
            DLog("User is not logged in, unable to update \(type.rawValue) value")
            completion?(false)
            return
        }
        
        ApiServers.shared.postUpdateUserInfo(type, value: value) { (success, error) in
            if let error = error {
                DLog("updateUserInfo Error: \(error.localizedDescription)")
                return
            }
            
            if success {
                self.updateUserParams(type, value: value)
            }
            completion?(success)
        }
    }
    
    private func updateUserParams(_ type: UsersInfoUpdate, value: Any) {
        switch (type) {
        case .imageUrl:
            currentUser?.imageUrl = value as? String
        case .realName:
            currentUser?.realName = value as? String
        case .passportUrl:
            currentUser?.passportUrl = value as? String
        case .email:
            currentUser?.email = value as? String
        case .idAUrl:
            currentUser?.idAUrl = value as? String
        case .idBUrl:
            currentUser?.idBUrl = value as? String
        case .isIdVerified:
            if let isVerified = value as? Int {
                currentUser?.isIdVerified = isVerified.boolValue
            }
        case .isPhoneVerified:
            if let isVerified = value as? Int {
                currentUser?.isPhoneVerified = isVerified.boolValue
            }
        case .phone:
            currentUser?.phone = value as? String
        default:
            DLog("Not handling update type \(type.rawValue) yet.")
        }
        
        NotificationCenter.default.post(name: .UserDidUpdate, object: nil)
    }
    
    //MARK: Wallet Methods
    public func updateWallet(completion: ((Bool) -> Void)?) {
        ApiServers.shared.getWallet { (wallet, error) in
            if wallet != nil {
                self.wallet = wallet
                completion?(true)
                return
            }
            completion?(false)
        }
    }
    
    //MARK: - Keychain Management
    
    private func updateHomeProfileInfo(_ profileInfo: HomeProfileInfo, writeToKeychain: Bool) {
        homeProfileInfo = profileInfo
        updateCurrentUser(profileInfo.user, writeToKeychain: writeToKeychain)
    }
    
    private func updateCurrentUser(_ user: ProfileUser, writeToKeychain: Bool) {
        self.currentUser = user
        
        Crashlytics.sharedInstance().setUserEmail(user.email)
        Crashlytics.sharedInstance().setUserIdentifier("\(user.id ?? -999)")
        Crashlytics.sharedInstance().setUserName(user.username)
        
        if writeToKeychain, let username = user.username, let token = user.token {
            self.saveUserTokenToKeychain(username: username, userToken: token)
        }
        
        NotificationCenter.default.post(name: .UserDidUpdate, object: nil)
        TripOrderDataStore.shared.pullAll(completion: nil)
    }
    
    private func saveUserTokenToKeychain(username: String, userToken: String) {
        do {
            let userTokenItem = tokenItem(account: username)
            try userTokenItem.savePassword(userToken)
            UserDefaults.setUsername(username)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    private func deleteUserTokenFromKeychain() {
        if let username = UserDefaults.getUsername() {
            do {
                let userTokenItem = tokenItem(account: username)
                try userTokenItem.deleteItem()
                UserDefaults.removeUsername()
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
        }
    }
    
    private func readUserTokenFromKeychain() -> String? {
        
        var token: String?
        
        if let username = UserDefaults.getUsername() {
            do {
                let userTokenItem = tokenItem(account: username)
                try token = userTokenItem.readPassword()
            } catch {
                //Unable to read proper password from keychain, allow user to relogin
                NotificationCenter.default.post(name: NSNotification.Name.User.Invalid, object: nil)
            }
            
        } else {
            DLog("Username not found")
        }
        
        if token == nil {
            DLog("User token not found")
        }
        
        return token
    }
    
    private func tokenItem(account: String) -> KeychainPasswordItem {
        let userTokenItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                 account: account,
                                                 accessGroup: KeychainConfiguration.accessGroup)
        return userTokenItem
    }
}
