//
//  LoginViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import M13Checkbox

class LoginViewController: UIViewController {

    fileprivate let constant: CGFloat = 32
    var countryCode = "1"
    var wechatAuthorizationState: String = ""
    
    @IBOutlet weak var phoneField: ThemTextField!
    @IBOutlet weak var passwordField: ThemTextField!
    @IBOutlet weak var textFieldsContainerView: UIView!
    
    @IBOutlet weak var bottomImageView: UIImageView!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var wechatLoginButton: UIButton!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var hintLabel1: UILabel!
    @IBOutlet weak var hintLabel2: UILabel!
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var userAgreementButton: UIButton!
    @IBOutlet weak var appAgreementButton: UIButton!
    @IBOutlet weak var hintLabel3Button: UIButton!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    var checkBox: M13Checkbox!
    
    lazy var flagPicker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = pickerColorLightGray
        p.dataSource = self
        p.delegate = self
        p.isHidden = true
        return p
    }()
    
    let segueIdChangePw = "changePassword"
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addWeChatObservers()
        setupTextFields()
        setupFlagPicker()
        setupContentsText()
        setupGifImage()
        
        AnalyticsManager.shared.startTimeTrackingKey(.loginProcessTime)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        AnalyticsManager.shared.clearTimeTrackingKey(.loginProcessTime)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdChangePw {
            if let regVC = segue.destination as? PhoneNumViewController {
                regVC.loginStatus = .changePassword
            }
        }
    }
    //MARK: - View custom set up
    
    private func setupContentsText() {
        phoneField.setAttributedPlaceholder(L("login.ui.placeholder.phone"), color: nil)
        passwordField.setAttributedPlaceholder(L("login.ui.placeholder.password"), color: nil) 
        loginButton.setTitle(L("login.ui.button.login"), for: .normal)
        wechatLoginButton.setTitle(L("login.ui.button.wechat"), for: .normal)
        forgetButton.setTitle(L("login.ui.button.forgot-password"), for: .normal)
        registrationButton.setTitle(L("login.ui.button.register"), for: .normal)
        hintLabel1.text = L("login.ui.message.hint1")
        hintLabel2.text = L("login.ui.message.hint2")
        userAgreementButton.setTitle(L("login.ui.agreement.title"), for: .normal)
        appAgreementButton.setTitle(L("login.ui.license.title"), for: .normal)
        hintLabel3Button.setTitle(L("login.ui.message.hint3"), for: .normal)
        privacyPolicyButton.setTitle(L("login.ui.privacy.title"), for: .normal)
        
        let sz: CGFloat = 15
        checkBox = M13Checkbox(frame: CGRect(x: 0, y: 0, width: sz, height: sz))
        setupCheckBox(checkBox)
        checkBoxView.addSubview(checkBox)
    }
    
    private func setupCheckBox(_ b: M13Checkbox) {
        b.markType = .checkmark
        b.stateChangeAnimation = .fill
        b.boxType = .square
        b.checkmarkLineWidth = 2
        b.boxLineWidth = 1
        b.cornerRadius = 2
        b.tintColor = colorTheamRed
        b.secondaryTintColor = UIColor.lightGray
        b.checkState = .checked
    }

    private func setupGifImage(){
        let gifImg = UIImage.gifImageWithName("Login_animated_loop_png")
        bottomImageView.image = gifImg
    }
    
    private func setupFlagPicker(){
        view.addSubview(flagPicker)
        flagPicker.addConstraints(left: bottomImageView.leftAnchor, top: bottomImageView.topAnchor, right: bottomImageView.rightAnchor, bottom: bottomImageView.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    
    private func setupTextFields() {
        phoneField.delegate = self
        phoneField.keyboardType = .numberPad
        phoneField.defaultLineColor = colorTextFieldLoginLineLightGray
        phoneField.activeLineColor = colorTextFieldLoginLineLightGray

        passwordField.delegate = self
        passwordField.keyboardType = .asciiCapable
        passwordField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        passwordField.defaultLineColor = colorTextFieldLoginLineLightGray
        passwordField.activeLineColor = colorTextFieldLoginLineLightGray
    }
    
    //MARK: - Action Handler
    
    @IBAction func handleLoginButton(sender: UIButton) {
        guard let phone = phoneField.text, !phone.isEmpty else {
            displayAlert(title: L("login.error.title.phone"),
                         message: L("login.error.message.phone"),
                         action: L("action.ok")) {
                _ = self.phoneField.becomeFirstResponder()
            }
            return
        }
        
        guard let password = passwordField.text, password.count > 5 else {
            displayAlert(title: L("login.error.title.password"),
                         message: L("login.error.message.password"),
                         action: L("action.ok")) {
                _ = self.passwordField.becomeFirstResponder()
            }
            return
        }
        
        guard checkBox.checkState == .checked else {
            displayAlert(title: L("login.error.title.check-agreement"), message: L("login.error.message.check-agreement"), action: L("action.ok"))
            return
        }
        
        _ = passwordField.resignFirstResponder()
        
        ProfileManager.shared.login(phone: phone, password: password) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
                AnalyticsManager.shared.finishTimeTrackingKey(.loginProcessTime)
                AnalyticsManager.shared.trackCount(.loginByEmailCount)
            } else {
                self.displayAlert(title: L("login.error.title.failed"), message: L("login.error.message.failed"), action: L("action.ok"))
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
                AudioManager.shared.playSond(named: .failed)
            }
        }
    }
    
    @IBAction func handleForgetButton(sender: UIButton) {
        let status :String = "changePassword"
        performSegue(withIdentifier: "changePassword", sender: status)
        //        performSegue(withIdentifier: "phoneVerifySuccessSegue", sender: nil) // TODO: this line is for testing the phoneVerifySuccessVC;
    }
    
    @IBAction func countryCodeButtonTapped(_ sender: Any) {
        openFlagPicker()
    }
    
    
    //MARK - Helper Method
    
    func checkPassword() {
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)
        
        if let maybePassword = passwordField.text {
            let isMatch = matcher.match(input: maybePassword)
            loginButton.isEnabled = isMatch
            loginButton.setTitleColor((isMatch ? UIColor.white : colorTheamRed), for: .normal)
            loginButton.backgroundColor = isMatch ? colorTheamRed : UIColor.white
            let msg = isMatch ? "密码正确" : "密码错误"
            DLog(msg)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = colorErrGray
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

extension LoginViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        phoneField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.AuthenticationFailed, object: nil, queue: nil) { [weak self] notification in
            if let response = notification.object as? SendAuthResp {
                DLog("Wechat error: \(response.errCode): \(response.errStr)")
                self?.displayAlert(title: L("login.error.wechat.title"), message: L("login.error.wechat.message"), action: L("action.ok"))
            }
        }
    }
}


//MARK: - WeChar Authentication
extension LoginViewController {
    
    @IBAction func wechatButtonTapped(_ sender: Any) {
        
        guard checkBox.checkState == .checked else {
            displayAlert(title: L("login.error.title.check-agreement"), message: L("login.error.message.check-agreement"), action: L("action.ok"))
            return
        }
        
        wxloginStatus = "wxRegisteration"
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
                    self?.displayAlert(title: L("login.error.wechat.title"), message: L("login.error.wechat.message"), action: L("action.ok"))
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
    }

    
    @IBAction func handleRegistrationButton(_ sender: Any) {
        
    }
    
    @IBAction func handleUserAgreementButton(_ sender: Any) {
        gotoWebview(title: L("login.ui.agreement.title"), url: "\(ApiServers.shared.host)/doc_agreement")
    }
    
    @IBAction func handleAppAgreementButton(_ sender: Any) {
        gotoWebview(title: L("login.ui.license.title"), url: "\(ApiServers.shared.host)/doc_license")
    }
    
    @IBAction func handlePrivacyPolicyButton(_ sender: Any) {
        gotoWebview(title: L("login.ui.privacy.title"), url: "\(ApiServers.shared.host)/doc_privacy")
    }
    
    private func gotoWebview(title: String, url: String) {
        let webVC = WebController()
        self.navigationController?.pushViewController(webVC, animated: true)
        webVC.title = title
        webVC.url = URL(string: url)
    }
    
}



extension LoginViewController: UITextFieldDelegate {
    
     func registerWeChatUser(openId: String, accessToken: String) {
        
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(accessToken)&openid=\(openId)"
        
        AppDelegate.shared().startLoading()
        
        self.quickDataFromUrl(url: requestUrl) { [weak self] jsonResult in
            
            guard let jsonResult = jsonResult else { return }
            
            if let username = jsonResult["openid"] as? String,
                let imgUrl = jsonResult["headimgurl"] as? String,
                let realName = jsonResult["nickname"] as? String {
                
                ApiServers.shared.getIsUserExisted(phoneInput: username, completion: { (success, err) in
                    
                    if success {
                        ProfileManager.shared.login(username: username, password: username.quickTossPassword(), completion: { (success) in
                            
                            AppDelegate.shared().stopLoading()
                            
                            if success {
                                //if update success close
                                self?.dismiss(animated: true, completion: nil)
                                AnalyticsManager.shared.trackCount(.loginByWeChatCount)
                                AnalyticsManager.shared.finishTimeTrackingKey(.loginProcessTime)
                            
                            } else {
                                DLog("User exists login failed")
                            }
                        })
                        
                    } else {
                        let password = username.quickTossPassword()
                        ProfileManager.shared.register(username: username, password: password, name: realName, completion: { (success, err, errType) in
                            
                            
                            if success {
                                ProfileManager.shared.login(username: username, password: password, completion: { (success) in
                                    
                                    AppDelegate.shared().stopLoading()
                                    
                                    ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (updateSuccess) in
                                        if updateSuccess {
                                            self?.dismiss(animated: true, completion: nil)
                                            AnalyticsManager.shared.trackCount(.registerByWeChatCount)
                                            AnalyticsManager.shared.clearTimeTrackingKey(.loginProcessTime)
                                        } else {
                                            DLog("Wechat registration update user info failed at new registration")
                                        }
                                    })
                                })
                            } else {
                                AppDelegate.shared().stopLoading()
                                if let error = err {
                                    DLog("Wechat registration error: \(error.localizedDescription). Error Type: \(errType)")
                                } else {
                                    DLog("Wechat registration error")
                                }
                            }
                        })
                    }
                })
                
            } else {
                AppDelegate.shared().stopLoading()
                DLog("Invalid JSON result: \(jsonResult)")
            }
        }
    }
}


extension LoginViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func openFlagPicker(){
        flagPicker.isHidden = !flagPicker.isHidden
        // will hide when begin to set phoneNum
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return flagsTitle.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return flagsTitle[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countryCode = codeOfFlag[flagsTitle[row]]!
        countryCodeButton.setTitle("+" + countryCode, for: .normal)
    }
}
