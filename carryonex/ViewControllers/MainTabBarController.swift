//
//  MainTabBarController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var activityIndicator: UIActivityIndicatorCustomizeView! // UIActivityIndicatorView!
    var homeViewController: NewHomePageController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        setupActivityIndicator()
        debugLog("Tab Bar is loaded!!!")
        
        if let viewControllers = self.viewControllers as? [UINavigationController] {
            for navigationController in viewControllers {
                if let homeController = navigationController.childViewControllers.first as? NewHomePageController {
                    homeViewController = homeController
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isItHaveLogIn()
        loadingDisplay()
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
    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorCustomizeView() // UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
    }
    
    private func isItHaveLogIn(){
        if (!ProfileManager.shared.isLoggedIn()){
            showLogin()
        }
    }
    
    private func loadingDisplay(){
        if !appDidLaunch {
            self.activityIndicator.startAnimating()
            ProfileManager.shared.loadLocalUser(completion: { (isSuccess) in
                if isSuccess {
                    self.activityIndicator.stopAnimating()
                }
            })
            appDidLaunch = true
        }
    }
    
    private func showLogin() {
        if let loginViewContainer = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() {
            self.present(loginViewContainer, animated: true) { [weak self]_ in
                self?.selectedIndex = 0
                self?.activityIndicator.stopAnimating()
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

