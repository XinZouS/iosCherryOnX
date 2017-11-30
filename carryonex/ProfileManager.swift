//
//  ProfileManager.swift
//  carryonex
//
//  Created by Xin Zou on 10/18/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Unbox
import Crashlytics

public extension Notification.Name {
    public static let UserLoggedOut = Notification.Name(rawValue: "com.carryon.user.logout")
    public static let UserDidUpdate = Notification.Name(rawValue: "com.carryon.user.didUpdate")
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
//    completion: (() -> Swift.Void)? = nil
    func loadLocalUser(completion: ((Bool) -> Void)?) {
        if let username = UserDefaults.getUsername(), let userToken = readUserTokenFromKeychain() {
            ApiServers.shared.getUserInfo(username: username, userToken: userToken, completion: { (homeProfileInfo, error) in
                if let error = error {
                    print("loadLocalUser Error: \(error.localizedDescription)")
                    completion?(false)
                    return
                }
                
                if let profileInfo = homeProfileInfo {
                    self.updateHomeProfileInfo(profileInfo, writeToKeychain: false)
                    completion?(true)
                } else {
                    print("error: loadLocalUser: return user info is nil")
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
                print(msg)
                completion(false, error, .userRegisterErr)
                return
            }
            
            guard let userToken = userToken else {
                let msg = "Unable to retrieve token"
                print(msg)
                completion(false, error, .userAlreadyExist)
                return
            }
            
            ApiServers.shared.getUserInfo(username: username, userToken: userToken, completion: { (homeProfileInfo, error) in
                if let error = error {
                    let msg = "loadLocalUser Error: \(error.localizedDescription)"
                    print(msg)
                    completion(false, error, .userLoadLocalFail)
                    return
                }
                
                if let profileInfo = homeProfileInfo {
                    self.updateHomeProfileInfo(profileInfo, writeToKeychain: true)
                    completion(true, error, .noError)
                } else {
                    let msg = "return user info is nil"
                    print(msg)
                    completion(false, error, .userInfoNull)
                }
            })
        }
    }
    
    func login(username: String, password: String, completion: @escaping(Bool) -> Swift.Void) {
        
        ApiServers.shared.postLoginUser(username: username, password: password) { (userToken, error) in
            if let error = error {
                print("Login Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let userToken = userToken else {
                print("Unable to retrieve token")
                completion(false)
                return
            }
            
            ApiServers.shared.getUserInfo(username: username, userToken: userToken, completion: { (homeProfileInfo, error) in
                if let error = error {
                    print("loadLocalUser Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if let profileInfo = homeProfileInfo {
                    self.updateHomeProfileInfo(profileInfo, writeToKeychain: true)
                    completion(true)
                } else {
                    print("return user info is nil")
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
            debugPrint("User is not logged in, unable to get user info (single)")
            completion(nil, nil)
            return
        }
        
        ApiServers.shared.getUserInfo(infoType, completion: completion)
    }
    
    //PACKAGE UPDATE
    func updateUserInfo(info: [String: Any], completion: ((Bool) -> Void)?) {
        guard isLoggedIn() else {
            debugPrint("User is not logged in, unable to update user info")
            completion?(false)
            return
        }
        
        guard let userId = currentUser?.id else {
            debugPrint("Unable to find user id")
            completion?(false)
            return
        }
        
        var userInfo = info
        userInfo[ProfileUserKey.userId.rawValue] = userId
        ApiServers.shared.postUserUpdateInfo(info: userInfo) { (user, error) in
            if let error = error {
                print("User update error: \(error.localizedDescription)")
            }
            
            if let user = user {
                self.updateCurrentUser(user, writeToKeychain: false)
                completion?(true)
            } else {
                print("return user info is nil")
                completion?(false)
            }
        }
    }
    
    //SINGLE ITEM UPDATE
    func updateUserInfo(_ type: UsersInfoUpdate, value: Any, completion: ((Bool) -> Void)?) {
        
        guard isLoggedIn() else {
            print("User is not logged in, unable to update \(type.rawValue) value")
            completion?(false)
            return
        }
        
        ApiServers.shared.postUpdateUserInfo(type, value: value) { (success, error) in
            if let error = error {
                print("updateImageUrl Error: \(error.localizedDescription)")
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
            print("Not handling update type \(type.rawValue) yet.")
        }
        
        NotificationCenter.default.post(name: .UserDidUpdate, object: nil)
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
                fatalError("Error reading password from keychain - \(error)")
            }
            
        } else {
            print("Username not found")
        }
        
        if token == nil {
            print("User token not found")
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
