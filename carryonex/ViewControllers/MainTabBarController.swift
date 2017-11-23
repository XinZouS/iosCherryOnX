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
        addNotificationObservers()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addNotificationObservers() {
        
        /**  微信通知  */
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue:"WXLoginSuccessNotification"), object: nil, queue: nil) { [weak self] notification in
            
            let code = notification.object as! String
            let requestUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(WX_APPID)&secret=\(WX_APPSecret)&code=\(code)&grant_type=authorization_code"
            
            DispatchQueue.global().async {
                let requestURL: URL = URL.init(string: requestUrl)!
                let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
                DispatchQueue.main.async {
                    let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                    let openid: String = jsonResult["openid"] as! String
                    let access_token: String = jsonResult["access_token"] as! String
                    switch wxloginStatus{
                    case "WXregister":
                        self?.makeUserRegister(openid: openid, access_token: access_token)
                    default:
                        self?.personInfoController?.getUserInfo(openid: openid, access_token: access_token)
                    }
                }
            }
        }
    }
    
    func makeUserRegister(openid:String,access_token:String){
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openid)"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                print(jsonResult)
                if let username = jsonResult["openid"] as? String,let imgUrl = jsonResult["headimgurl"] as? String,let realName = jsonResult["nickname"] as? String{
                    // check wechat account existed?
                    ApiServers.shared.getIsUserExisted(phoneInput: username,completion: { (success, err) in
                        if success{
                            // if exist log in
                            ProfileManager.shared.login(username: username, password: username,completion: { (success) in
                                if success{
                                    // if log in success update image
                                    ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (success) in
                                        if success {
                                            //if update success close
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    })
                                }else{
                                    print("errorelse")
                                }
                            })
                        }else{
                            //if doesn't exist then register
                            ProfileManager.shared.register(username: username, countryCode: "86", phone: "no_phone", password:username,email: "",name: realName,completion: { (success, err, errType) in
                                if success{
                                    //if register success update image
                                    ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (success) in
                                        if success {
                                            //if update success close
                                            self.dismiss(animated: true, completion: nil)
                                        }
                                    })
                                }else{
                                    print(errType)
                                }
                            })
                        }
                    })
                }
            }
        }
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
    
    
    //MARK: - Notification
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .UserLoggedOut, object: nil, queue: nil) { [weak self] _ in
            self?.showLogin()
        }
        
        //登录异常（如改变设备）
        NotificationCenter.default.addObserver(forName: Notification.Name.Network.Invalid, object: nil, queue: nil) { [weak self] notification in
            self?.displayAlert(title: "账号异常", message: "登入账号出现异常，请重新登入。", action: "好") {
                self?.showLogin()
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
