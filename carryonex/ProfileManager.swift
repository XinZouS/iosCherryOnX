//
//  ProfileManager.swift
//  carryonex
//
//  Created by Xin Zou on 10/18/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class ProfileManager: NSObject {
    
    let user = User()
    
    static var shared = ProfileManager() // This is singleton
    
    private override init(){
        
    }
    
}
