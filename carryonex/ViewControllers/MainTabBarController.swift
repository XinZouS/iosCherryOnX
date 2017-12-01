//
//  MainTabBarController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Reachability

class MainTabBarController: UITabBarController {
    
    var activityIndicator: UIActivityIndicatorCustomizeView! // UIActivityIndicatorView!
    var homeViewController: NewHomePageController?
    var personInfoController: PersonalPageViewController?
    var loginViewController: LoginViewController?
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        setupActivityIndicator()
        if let viewControllers = self.viewControllers as? [UINavigationController] {
            for navigationController in viewControllers {
                if let homeController = navigationController.childViewControllers.first as? NewHomePageController {
                    homeViewController = homeController
                }
                if let personController = navigationController.childViewControllers.last as? PersonalPageViewController {
                    personInfoController = personController
                }
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isItHaveLogIn()
        loadingDisplay()
    }
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
                    APIServerChecker.testAPIServers()
                    TripOrderDataStore.shared.pull(category: .carrier, completion: nil)
                    TripOrderDataStore.shared.pull(category: .sender, completion: nil)
                }
            })
            appDidLaunch = true
        }
    }
    
    private func showLogin() {
        if let loginViewContainer = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() {
            loginViewController = loginViewContainer as? LoginViewController
            self.present(loginViewContainer, animated: true) { [weak self]_ in
                self?.selectedIndex = 0
                self?.activityIndicator.stopAnimating()
            }
        } else {
            debugLog("Something is wrong with the Login storyboard, please check.")
        }
    }
    
    func dismissLogin(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Notification
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .UserLoggedOut, object: nil, queue: nil) { [weak self] _ in
            self?.showLogin()
        }
        
        //登录异常（如改变设备）
        NotificationCenter.default.addObserver(forName: Notification.Name.Network.Invalid, object: nil, queue: nil) { [weak self] notification in
            self?.displayAlert(title: "账号异常", message: "登入账号出现异常，请重新登入。", action: "好") {
                ProfileManager.shared.logoutUser()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: nil, queue: nil) { [weak self] notification in
            guard let reachabilityObject = notification.object as? Reachability, let strongSelf = self else { return }
            if !reachabilityObject.isReachable {
                let msg = "⚠️您的网络不可用，为了更准确即时地更新您的数据信息，请确保手机能使用WiFi或流量数据。对此给您带来的不便只好忍忍了，反正您也不能来打我。"
                strongSelf.displayAlert(title: "无法链接到服务器", message: msg, action: "来人！给我拿下！")
            } else {
                appDidLaunch = false
                strongSelf.isItHaveLogIn()
            }
        }
    }
}
