//
//  PersonalPage.swift
//  carryonex
//
//  Created by Xin Zou on 11/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class PersonalPageViewController: UIViewController {
    

    
    @IBAction func paymentButtonTapped(_ sender: Any) {
    }
    
    @IBAction func getPayButtonTapped(_ sender: Any) {
    }
    
    @IBAction func walletButtonTapped(_ sender: Any) {
    }
    
    @IBAction func helpMeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
//        let settingVC = SettingPageViewController()
//        navigationController?.pushViewController(settingVC, animated: true)
        
        if let settingVC = UIStoryboard(name: "SettingPage", bundle: nil).instantiateViewController(withIdentifier: "SettingPageVCID") as? SettingPageViewController {
            settingVC.navigationController?.navigationBar.isHidden = false
            navigationController?.pushViewController(settingVC, animated: true)
        }
    }

    
    @IBAction func feedbackButtonTapped(_ sender: Any) {
    }
    
    
    
    
    
    
    
}

