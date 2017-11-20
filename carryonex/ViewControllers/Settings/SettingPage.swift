//
//  SettingPage.swift
//  carryonex
//
//  Created by Xin Zou on 11/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import MapKit


class SettingPageViewController: UIViewController {
    
    
    
    
    private func openSystemSetting(){
        if let sysUrl = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(sysUrl, options: [:], completionHandler: nil)
        } else {
            print("unable to openSystemSetting")
        }
    }
    
    private func openSystemGpsSetting(){
        if !CLLocationManager.locationServicesEnabled() {
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                // If general location settings are disabled then open general location settings
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            openSystemSetting()
        }
    }
    
    @IBAction func notificationButtonTapped(_ sender: Any) {
        openSystemSetting()
    }
    
    @IBAction func gpsAccessButtonTapped(_ sender: Any) {
        openSystemGpsSetting()
    }
    
    @IBAction func accountInfoButtonTapped(_ sender: Any) {
        //WalletManager.shared.pay(price: 100, hostViewController: self)
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
