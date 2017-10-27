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
        guard let user = currentUser else { return }
        saveProfileUserIntoLocalDisk(user)
    }
    
    func loadUser() {
        //Xin - when app just open up, the currentUser == nil, this will fail when try to login, bcz need to load user from disk and get username, token
        //guard let curruser = self.currentUser else { return }
        //curruser.loadFromLocalDisk()
        
        //Xin - loadUser will always replace currentuser(may be nil) in RAM by the user saved in disk(if not nil)
        self.currentUser = loadProfileUserFromLocalDisk()
    }
    
    func removeUser() {
        removeProfileUserFromLocalDisk()
        self.currentUser = nil
    }
    
    func logoutUser() {
        removeUser()
        currentUser = ProfileUser()
    }
    
    
    //MARK: - Local Disk Save
    private func saveProfileUserIntoLocalDisk(_ user: ProfileUser){
        print("Trying to save ProfileManager into local disk ...")
        DispatchQueue.main.async {
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: user)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKey.ProfileUser.rawValue)
            UserDefaults.standard.synchronize()
            print("OK, save ProfileManager into local disk success!!! user = \(user.printAllData())")
        }
    }
    
    private func loadProfileUserFromLocalDisk() -> ProfileUser? {
        print("\n\rtrying to loadFromLocalDisk() ...... ")
        if let savedUser = UserDefaults.standard.object(forKey: UserDefaultKey.ProfileUser.rawValue) as? Data,
            let profileUser = NSKeyedUnarchiver.unarchiveObject(with: savedUser) as? ProfileUser {
            profileUser.token = "e33bbe34ed137ca196f9a8c2731d1575377c8c1cffe30335cd1cae30800dee4f"
            return profileUser
        }
        print("error in ProfileUser.swift: loadFromLocalDisk(): can not get Data, will return nil instead...")
        return nil
    }
    
    private func removeProfileUserFromLocalDisk(){
        UserDefaults.standard.removeObject(forKey: UserDefaultKey.ProfileUser.rawValue)
        print("OK, removed user from local disk.")
    }
}
