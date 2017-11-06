//
//  UserSettingController++.swift
//  carryonex
//
//  Created by Xin Zou on 10/15/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


extension UserSettingController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                let phoneNumberCtl = PhoneNumberController()
                isModifyPhoneNumber = true
                navigationController?.pushViewController(phoneNumberCtl, animated: true)
                
            case 1:
                let p = PhotoIDController()
                p.homePageController = self.homePageCtl
                navigationController?.pushViewController(p, animated: true) // for navigation page

            case 2:
                print("TODO: open 语言 page...")
                
            default:
                print("error: UserSettingCtl++: undefined selection at section = \(indexPath.section), item = \(indexPath.item)")
            }
            
        }else{ // section == 1
            
            switch indexPath.item {
            case 0:
                let userGuide = UserGuideController()
                userGuide.title = titles[indexPath.section][indexPath.item]
                navigationController?.pushViewController(userGuide, animated: true)
                
            case 1:
                print("TODO: open 给游箱评价 page...")
                
            case 2:
                let lic = LicensesController()
                navigationController?.pushViewController(lic, animated: true)
                lic.title = titles[indexPath.section][indexPath.item]
                
            case 3: // open 关于游箱 page: http://192.168.0.119:5000/about_us
                let webView = WebController()
                webView.url = URL(string: "\(userGuideWebHoster)/doc_about_us")
                webView.webView.scrollView.isScrollEnabled = false
                navigationController?.pushViewController(webView, animated: true)
                webView.title = titles[indexPath.section][indexPath.item]
                
            default:
                print("erororrroor UserSettingCtl++: undefined selection at section = \(indexPath.section), item = \(indexPath.item)")
            }
        }
    }
    
    func backButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func logoutButtonTapped(){
        isModifyPhoneNumber = false
        isRegister = false
        ProfileManager.shared.logoutUser()
        userProfileView?.removeProfileImageFromLocalFile()
        dismiss(animated: true, completion: nil)
    }
}
