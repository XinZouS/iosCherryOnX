//
//  PersonalPage.swift
//  carryonex
//
//  Created by Xin Zou on 11/15/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import ZendeskSDK

class PersonalPageViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func paymentButtonTapped(_ sender: Any) {
    }
    
    @IBAction func getPayButtonTapped(_ sender: Any) {
    }
    
    @IBAction func walletButtonTapped(_ sender: Any) {
    }
    
    @IBAction func helpMeButtonTapped(_ sender: Any) {
        navigationController?.isNavigationBarHidden = false
        let helpCenterContentModel = ZDKHelpCenterOverviewContentModel.defaultContent()
        ZDKHelpCenter.pushOverview(self.navigationController, with:helpCenterContentModel)
    }
    
    @IBAction func settingButtonTapped(_ sender: Any) {
        if let settingVC = UIStoryboard(name: "SettingPage", bundle: nil).instantiateViewController(withIdentifier: "SettingPageVCID") as? SettingPageViewController {
            navigationController?.isNavigationBarHidden = false
            navigationController?.pushViewController(settingVC, animated: true)
        }
    }

    
    @IBAction func feedbackButtonTapped(_ sender: Any) {
    }
    
    
    
    
    
    
    
}

