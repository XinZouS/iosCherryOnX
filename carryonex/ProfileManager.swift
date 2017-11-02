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

    static var shared = ProfileManager()
    
    private var currentUser: ProfileUser?
    
    private override init() {
        super.init()
    }
    
    func isLoggedIn() -> Bool {
        return currentUser != nil
    }
    
    func login(user: ProfileUser) {
        updateCurrentUser(user)
        guard let currentUser = currentUser else { return }
        ServiceManager.shared.setupUDeskWithUser(user: currentUser)
    }
    
    func getCurrentUser() -> ProfileUser? {
        return currentUser
    }
    
    func updateCurrentUser(_ user: ProfileUser) {
        currentUser = user
    }
    
    func logoutUser() {
        deleteUser()
        ServiceManager.shared.logoutUdesk()
    }
    
    //Token Management
    private func saveUser(username: String, userToken: String) {
        do {
            let userTokenItem = tokenItem(account: username)
            try userTokenItem.savePassword(userToken)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    private func deleteUser() {
        self.currentUser = nil
        
        if let username = UserDefaults.getUserName() {
            do {
                let userTokenItem = tokenItem(account: username)
                try userTokenItem.deleteItem()
            } catch {
                fatalError("Error updating keychain - \(error)")
            }
        }
    }
    
    private func tokenItem(account: String) -> KeychainPasswordItem {
        let userTokenItem = KeychainPasswordItem(service: KeychainConfiguration.serviceName,
                                                 account: account,
                                                 accessGroup: KeychainConfiguration.accessGroup)
        return userTokenItem
    }
}
