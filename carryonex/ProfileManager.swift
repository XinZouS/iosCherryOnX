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
    
    func loadLocalUser(completion: @escaping(Bool) -> Void) {
        if let username = UserDefaults.getUsername(), let userToken = readUserTokenFromKeychain() {
            ApiServers.shared.getUserInfo(username: username, userToken: userToken, completion: { (user, error) in
                if let error = error {
                    print("loadLocalUser Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if let user = user {
                    self.updateCurrentUser(user, writeToKeychain: false)
                    completion(true)
                } else {
                    print("error: loadLocalUser: return user info is nil")
                    completion(false)
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
            
            ApiServers.shared.getUserInfo(username: username, userToken: userToken, completion: { (user, error) in
                if let error = error {
                    let msg = "loadLocalUser Error: \(error.localizedDescription)"
                    print(msg)
                    completion(false, error, .userLoadLocalFail)
                    return
                }
                
                if let user = user {
                    self.updateCurrentUser(user, writeToKeychain: true)
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
                print("Register Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let userToken = userToken else {
                print("Unable to retrieve token")
                completion(false)
                return
            }
            
            ApiServers.shared.getUserInfo(username: username, userToken: userToken, completion: { (user, error) in
                if let error = error {
                    print("loadLocalUser Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if let user = user {
                    self.updateCurrentUser(user, writeToKeychain: true)
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
    
    
    //MARK: - Update Methods
    
    func updateUserInfo(_ type: UsersInfoUpdate, value: String, completion: ((Bool) -> Void)?) {
        
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
    
    private func updateUserParams(_ type: UsersInfoUpdate, value: String) {
        switch (type) {
        case .imageUrl:
            currentUser?.imageUrl = value
        case .realName:
            currentUser?.realName = value
        case .passportUrl:
            currentUser?.passportUrl = value
        case .email:
            currentUser?.email = value
        case .idAUrl:
            currentUser?.idAUrl = value
        case .idBUrl:
            currentUser?.idBUrl = value
        case .isIdVerified:
            currentUser?.isIdVerified = value.toBool()
        case .isPhoneVerified:
            currentUser?.isPhoneVerified = value.toBool()
        case .phone:
            currentUser?.phone = value
        default:
            print("Not handling update type \(type.rawValue) yet.")
        }
        
        NotificationCenter.default.post(name: .UserDidUpdate, object: nil)
    }
    
    //MARK: - Keychain Management
    
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
