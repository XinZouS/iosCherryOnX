//
//  SettingPage.swift
//  carryonex
//
//  Created by Xin Zou on 11/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class SettingPageViewController: UIViewController {
    
    
    
    
    
    
    @IBAction func notificationButtonTapped(_ sender: Any) {
    }
    
    @IBAction func gpsAccessButtonTapped(_ sender: Any) {
    }
    
    @IBAction func accountInfoButtonTapped(_ sender: Any) {
    }
    
    @IBAction func versionButtonTapped(_ sender: Any) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        ProfileManager.shared.logoutUser()
        // TODO: after homepage done, get reference and do this:
        //userProfileView?.removeProfileImageFromLocalFile()
        navigationController?.popToRootViewController(animated: false)
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    
    
}
