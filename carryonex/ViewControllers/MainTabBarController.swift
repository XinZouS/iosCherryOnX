//
//  MainTabBarController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    var appDidLaunch = false
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        
        debugLog("Tab Bar is loaded!!!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isItHaveLogIn()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: - Helpers
    
    private func isItHaveLogIn(){
        if (!ProfileManager.shared.isLoggedIn()){
            showLogin()
            
        } else {
            if !appDidLaunch {
                //self.activityIndicator.startAnimating()
                ProfileManager.shared.loadLocalUser(completion: { (isSuccess) in
                    //self.activityIndicator.stopAnimating()
                    if isSuccess {
                        //self.userInfoMenuView.userProfileView.loadNamePhoneImage()
                    } else {
                        debugLog("LoadLocalUser failed...")
                    }
                })
                appDidLaunch = true
            }
        }
    }
    
    private func showLogin() {
        if let loginViewContainer = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() {
            self.present(loginViewContainer, animated: true) { [weak self]_ in
                self?.selectedIndex = 0
                self?.appDidLaunch = false
            }
        } else {
            debugLog("Something is wrong with the Login storyboard, please check.")
        }
    }
    
    //MARK: - Notification
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .UserLoggedOut, object: nil, queue: nil) { [weak self] _ in
            self?.showLogin()
        }
    }
}
