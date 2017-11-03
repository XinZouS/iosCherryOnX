//
//  ProfileManager.swift
//  carryonex
//
//  Created by Xin Zou on 10/18/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Unbox

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
    
    
    //MARK: - Login Methods
    
    func isLoggedIn() -> Bool {
        return UserDefaults.getUsername() != nil
    }
    
    func loadLocalUser() {
        if let username = UserDefaults.getUsername(), let userToken = readUserTokenFromKeychain() {
            ApiServers.shared.getUserInfo(username: username, userToken: userToken, completion: { (user, error) in
                if let error = error {
                    print("loadLocalUser Error: \(error.localizedDescription)")
                    return
                }
                self.currentUser = user
            })
        }
    }
    
    func register(username: String, phone: String, password: String, email: String, completion: @escaping(Bool) -> Swift.Void) {
        ApiServers.shared.postRegisterUser(username: username, phone: phone, password: password, email: email) { (userToken, error) in
            if let error = error {
                print("Register Error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let userToken = userToken else {
                print("Unable to retrieve token")
                return
            }
            
            ApiServers.shared.getUserInfo(username: username, userToken: userToken, completion: { (user, error) in
                if let error = error {
                    print("loadLocalUser Error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                
                if let user = user {
                    self.updateCurrentUser(user: user)
                    completion(true)
                } else {
                    print("return user info is nil")
                    completion(false)
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
                    self.updateCurrentUser(user: user)
                    completion(true)
                } else {
                    print("return user info is nil")
                    completion(false)
                }
            })
        }
    }
    
    private func updateCurrentUser(user: ProfileUser) {
        self.currentUser = user
        ServiceManager.shared.setupUDeskWithUser(user: user)
        
        if let username = user.username, let token = user.token {
            self.saveUserTokenToKeychain(username: username, userToken: token)
        }
    }
    
    func getCurrentUser() -> ProfileUser? {
        return currentUser
    }
    
    func updateUserToken(username: String, userToken: String) {
        deleteUserTokenFromKeychain()
        saveUserTokenToKeychain(username: username, userToken: userToken)
    }
    
    func logoutUser() {
        self.currentUser = nil
        deleteUserTokenFromKeychain()
        ServiceManager.shared.logoutUdesk()
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
                self.updateUserInfo(type, value: value)
            }
            completion?(success)
        }
    }
    
    private func updateUserInfo(_ type: UsersInfoUpdate, value: String) {
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
    }
    
    //MARK: - Token Management
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
