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
        get { return UserDefaults.getUserName() }
    }
    
    var userToken: String? {
        get { return readUserTokenFromKeychain() }
    }
    
    //MARK: - Methods
    
    func isLoggedIn() -> Bool {
        return currentUser != nil
    }
    
    func login(user: ProfileUser) {
        updateCurrentUser(user)
        ServiceManager.shared.setupUDeskWithUser(user: user)
        
        if let username = user.username, let token = user.token {
            saveUserTokenToKeychain(username: username, userToken: token)
        }
    }
    
    func getCurrentUser() -> ProfileUser? {
        return currentUser
    }
    
    func updateCurrentUser(_ user: ProfileUser) {
        currentUser = user
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
    
    //MARK: - Token Management
    private func saveUserTokenToKeychain(username: String, userToken: String) {
        do {
            let userTokenItem = tokenItem(account: username)
            try userTokenItem.savePassword(userToken)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    private func deleteUserTokenFromKeychain() {
        if let username = UserDefaults.getUserName() {
            do {
                let userTokenItem = tokenItem(account: username)
                try userTokenItem.deleteItem()
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
        }
    }
    
    private func readUserTokenFromKeychain() -> String? {
        
        var token: String?
        
        if let username = UserDefaults.getUserName() {
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
