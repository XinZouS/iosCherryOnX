//
//  LoginViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    fileprivate let constant: CGFloat = 32
    var countryCode = "1"
    var wechatAuthorizationState: String = ""
    
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var textFieldsContainerView: UIView!
    
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var wechatLoginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addWeChatObservers()
        setupPhoneTextField()
        setupPasswordTextField()
    }
    
    //MARK: - View custom set up
    
    private func setupPhoneTextField(){
        phoneField.keyboardType = .numberPad
        phoneField.delegate = self
    }

    private func setupPasswordTextField(){
        passwordField.keyboardType = .asciiCapable
        passwordField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        passwordField.delegate = self
    }
    
    //MARK: - Action Handler
    
    @IBAction func handleLoginButton(sender: UIButton) {
        guard let phone = phoneField.text else {
            displayAlert(title: L("login.error.title.phone"),
                         message: L("login.error.message.phone"),
                         action: L("action.ok")) {
                _ = self.phoneField.becomeFirstResponder()
            }
            AudioManager.shared.playSond(named: .failed)
            return
        }
        
        guard let password = passwordField.text else {
            displayAlert(title: L("login.error.title.password"),
                         message: L("login.error.message.password"),
                         action: L("action.ok")) {
                _ = self.passwordField.becomeFirstResponder()
            }
            AudioManager.shared.playSond(named: .failed)
            return
        }
        
        _ = passwordField.resignFirstResponder()
        
        ProfileManager.shared.login(username: phone, password: password) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)

            } else {
                AudioManager.shared.playSond(named: .failed)
            }
        }
    }
    
    @IBAction func handleForgetButton(sender: UIButton) {
        if let profileUser = ProfileManager.shared.getCurrentUser() {
            if let phone = profileUser.phone {
                let countryCode = profileUser.phoneCountryCode ?? "1"
                print("get : okButtonTapped, api send text msg and go to next page!!!")
                SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: phone, zone: countryCode, result: { (err) in
                    if err == nil {
                        print("PhoneNumberController: 获取验证码成功, go next page!!!")
                        self.goToVerificationPage(isModifyPhone: true)
                    } else {
                        print("PhoneNumberController: 有错误: \(String(describing: err))")
                        let msg = "未能发送验证码，请确认手机号与地区码输入正确，换个姿势稍后重试。错误信息：\(String(describing: err))"
                        self.displayAlert(title: "验证失败", message: msg, action: "好")
                    }
                })
            }
        }
    }
    
    func goToVerificationPage(isModifyPhone: Bool) {
        if let phone = phoneField.text {
            let verifiCtl = VerificationController()
            verifiCtl.isModifyPhoneNumber = isModifyPhone
            verifiCtl.zoneCodeInput = self.countryCode
            verifiCtl.phoneInput = phone
            self.navigationController?.pushViewController(verifiCtl, animated: true)
        }
    }
    
    
    //MARK - Helper Method
    
    func checkPassword() {
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)
        
        if let maybePassword = passwordField.text {
            let isMatch = matcher.match(input: maybePassword)
            loginButton.isEnabled = isMatch
            loginButton.backgroundColor = isMatch ? #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            let msg = isMatch ? "密码正确" : "密码错误"
            print(msg)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    
    func quickDataFromUrl(url: String, completion: @escaping(([String : Any]?) -> Void)) {
        guard let requestURL: URL = URL.init(string: url) else {
            completion(nil)
            return
        }
        let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
        let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
        completion(jsonResult)
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismissKeyboard()
    }
    
    private func dismissKeyboard(){
        phoneField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}


//MARK: - WeChar Authentication
extension LoginViewController {
    
    @IBAction func wechatButtonTapped(_ sender: Any) {
        let urlStr = "weixin://"
        if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
            let req = SendAuthReq.init()
            req.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
            
            wechatAuthorizationState = "\((Int(arc4random()) + Date.getTimestampNow()) % 1000)"
            req.state = wechatAuthorizationState
            
            WXApi.send(req)
            
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
            }
        }
    }
    
    fileprivate func addWeChatObservers() {
        /**  微信通知  */
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.Authenticated, object: nil, queue: nil) { [weak self] notification in
            
            if let response = notification.object as? SendAuthResp {
                guard let state = response.state, state == self?.wechatAuthorizationState else {
                    self?.displayAlert(title: "Error", message: "Invalid response state, please try to relogin with WeChat.", action: "OK")
                    return
                }
                
                guard let code = response.code else { return }
                
                let request = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(WX_APPID)&secret=\(WX_APPSecret)&code=\(code)&grant_type=authorization_code"
                self?.quickDataFromUrl(url: request, completion: { [weak self] jsonResult in
                    guard let jsonResult = jsonResult else { return }
                    if let openId = jsonResult["openid"] as? String, let acccessToken = jsonResult["access_token"] as? String {
                        self?.registerWeChatUser(openId: openId, accessToken: acccessToken)
                    }
                })
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.AuthenticationFailed, object: nil, queue: nil) { [weak self] notification in
            if let response = notification.object as? SendAuthResp {
                self?.displayAlert(title: "WeChat 登入失败", message: "错误号码：\(response.errCode)\n，错误信息：\(response.errStr)", action: "好")
            }
        }
    }
    
    private func registerWeChatUser(openId: String, accessToken: String) {
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openId)"
        self.quickDataFromUrl(url: requestUrl) { [weak self] jsonResult in
            guard let jsonResult = jsonResult else { return }
            if let username = jsonResult["openid"] as? String,
                let imgUrl = jsonResult["headimgurl"] as? String,
                let realName = jsonResult["nickname"] as? String {
                ApiServers.shared.getIsUserExisted(phoneInput: username, completion: { (success, err) in
                    if success {
                        ProfileManager.shared.login(username: username, password: username.quickTossPassword(), completion: { (success) in
                            if success {
                                ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (success) in
                                    if success {
                                        //if update success close
                                        self?.dismiss(animated: true, completion: nil)
                                    } else {
                                        debugPrint("Wechat registration update user info failed at user exists")
                                    }
                                })
                            } else {
                                debugPrint("User exists login failed")
                            }
                        })
                    } else {
                        ProfileManager.shared.register(username: username, password: username.quickTossPassword(), name: realName, completion: { (success, err, errType) in
                            if success {
                                ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (updateSuccess) in
                                    if updateSuccess {
                                        self?.dismiss(animated: true, completion: nil)
                                    } else {
                                        debugPrint("Wechat registration update user info failed at new registration")
                                    }
                                })
                            } else {
                                if let error = err {
                                    debugPrint("Wechat registration error: \(error.localizedDescription). Error Type: \(errType)")
                                } else {
                                    debugPrint("Wechat registration error")
                                }
                            }
                        })
                    }
                })
            } else {
                debugPrint("Invalid JSON result: \(jsonResult)")
            }
        }
    }
}
