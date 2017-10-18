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
        
        // titles: [[String]] = [["账号与安全", "语言"], ["用户指南", "给游箱评价", "法律条款与隐私政策", "关于游箱"]]
        
        if indexPath.section == 0 {
            switch indexPath.item {
            case 0:
                let phoneNumberCtl = PhoneNumberController()
                isModifyPhoneNumber = true
                self.navigationController?.pushViewController(phoneNumberCtl, animated: true)
            case 1:
                print("TODO: open 语言 page...")

            default:
                print("erororrroor UserSettingCtl++: undefined selection at section = \(indexPath.section), item = \(indexPath.item)")
            }
            
        }else{ // section == 1
            
            switch indexPath.item {
            case 0:
                print("TODO: open 用户指南 page...")
                let userGuide = UserGuideController(collectionViewLayout: UICollectionViewFlowLayout())
                userGuide.title = titles[indexPath.section][indexPath.item]
                navigationController?.pushViewController(userGuide, animated: true)
                
            case 1:
                print("TODO: open 给游箱评价 page...")
                
            case 2:
                print("TODO: open 法律条款与隐私政策 page...")
                // (1) http://192.168.0.119:5000/license (2)http://192.168.0.119:5000/privacy (3)http://192.168.0.119:5000/acknowledgements
                let lic = LicensesController()
                navigationController?.pushViewController(lic, animated: true)
                lic.title = titles[indexPath.section][indexPath.item]
                
            case 3:
                print("TODO: open 关于游箱 page...") // http://192.168.0.119:5000/about_us
                let webView = WebController()
                webView.url = URL(string: "http://192.168.0.119:5000/about_us")
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
        alreadyExist = false
        User.shared.clearCurrentData()
        User.shared.removeFromLocalDisk() // remove local user for new user to login
        userProfileView?.removeProfileImageFromLocalFile()
        
        let phoneNumNavCtl = UINavigationController(rootViewController: PhoneNumberController())
        present(phoneNumNavCtl, animated: true) {
            print("finish present phoneNumNavCtl.")
        }
        self.navigationController?.popToRootViewController(animated: false)
        print("logout user!!!!!!")
    }

    
}
