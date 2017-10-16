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
                print("TODO: open 账号与安全 page...")
                
            case 1:
                print("TODO: open 语言 page...")

            default:
                print("erororrroor UserSettingCtl++: undefined selection at section = \(indexPath.section), item = \(indexPath.item)")
            }
            
        }else{ // section == 1
            
            switch indexPath.item {
            case 0:
                print("TODO: open 用户指南 page...")
                
            case 1:
                print("TODO: open 给游箱评价 page...")
                
            case 2:
                print("TODO: open 法律条款与隐私政策 page...")
                
            case 3:
                print("TODO: open 关于游箱 page...")
                
            default:
                print("erororrroor UserSettingCtl++: undefined selection at section = \(indexPath.section), item = \(indexPath.item)")
            }
            

        }
        

    }
    
    func logoutButtonTapped(){
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
