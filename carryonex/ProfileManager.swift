//
//  ProfileManager.swift
//  carryonex
//
//  Created by Xin Zou on 10/18/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Unbox

class ProfileManager: NSObject {
    static var shared = ProfileManager()
    var currentUser: ProfileUser?
    
    func isLoggedIn() -> Bool {
        return currentUser != nil
    }
    
    func saveUser() {
        guard let user = self.currentUser else { return }
        user.saveIntoLocalDisk()
    }
    
    func loadUser() {
        guard let user = self.currentUser else { return }
        user.loadFromLocalDisk()
    }
    
    func removeUser() {
        guard let user = self.currentUser else { return }
        user.removeFromLocalDisk()
        self.currentUser = nil
    }
}
