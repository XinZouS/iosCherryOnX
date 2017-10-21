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
    
    private override init() {
        super.init()
    }
    
    func isLoggedIn() -> Bool {
        return currentUser != nil
    }
    
    func saveUser() {
        guard let user = self.currentUser else {
            print("Errorro: current user is nil, can not be save!!!!!!")
            return
        }
        user.saveIntoLocalDisk()
        print("OKKK! save user into LocalDisk: user = \(user.printAllData())")
    }
    
    func loadUser() {
        //Xin - when app just open up, the currentUser == nil, this will fail when try to login, bcz need to load user from disk and get username, token
        //guard let curruser = self.currentUser else { return }
        //curruser.loadFromLocalDisk()
        
        //Xin - loadUser will always replace currentuser(may be nil) in RAM by the user saved in disk(if not nil)
        self.currentUser = ProfileUser().loadFromLocalDisk() ?? ProfileUser()
        print("loadUser, now currentUser = \(self.currentUser!.printAllData())")
    }
    
    func removeUser() {
        guard let user = self.currentUser else { return }
        user.removeFromLocalDisk()
        self.currentUser = nil
    }
    
// Xin - I think login operation should do it in ApiServers for DB connection, here just do [ADD,DEL,REQ,MDF] for local user
//    func loginUser(user: ProfileUser) {
////        if currentUser != nil { Xin - currUser will never nil, bcz we need it to keep it sync to disk for username and token
////            print("Must log out before relogin a new user")
////            return
////        }
//        currentUser = user
//        saveUser()
//    }
    
    func logoutUser() {
        removeUser()
    }
}
