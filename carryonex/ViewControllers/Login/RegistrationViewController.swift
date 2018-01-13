//
//  RegistrationViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import M13Checkbox

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameField: ThemTextField!
    @IBOutlet weak var passwordField: ThemTextField!
    @IBOutlet weak var confirmPasswordField: ThemTextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var agreeButton: UIButton!
    @IBOutlet weak var checkBoxView: UIView!
    @IBOutlet weak var bottomImageView: UIImageView!
    
    var registerUserInfo : [String:String]?
    let registerSuccessSegueId = "registerSuccessSegue"
    
    var checkBox: M13Checkbox!

    var isPasswordValid = false {
        didSet{
            checkRegistrationButtonReady()
        }
    }
    
    var isLoading: Bool = false {
        didSet{
            registerButton.isEnabled = !isLoading
            registerButton.layer.borderColor = isLoading ? colorTheamRed.cgColor : UIColor.white.cgColor
            registerButton.layer.borderWidth = isLoading ? 2 : 0
            registerButton.setTitleColor(isLoading ? colorTheamRed : UIColor.white , for: .normal)
            registerButton.backgroundColor = isLoading ? UIColor.white : colorTheamRed
            loadingIndicator.isHidden = !isLoading
            if isLoading {
                loadingIndicator.animate()
            }else{
                loadingIndicator.stop()
            }
        }
    }
    
    var loadingIndicator: BPCircleActivityIndicator!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default

        setupActivityIndicator()
        setupTextFields()

        let sz: CGFloat = 15
        checkBox = M13Checkbox(frame: CGRect(x: 0, y: 0, width: sz, height: sz))
        setupCheckBox(checkBox)
        checkBoxView.addSubview(checkBox)

        bottomImageView.image = UIImage.gifImageWithName("Login_animated_loop_png")
        
        AnalyticsManager.shared.startTimeTrackingKey(.registrationProcessTime)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsManager.shared.clearTimeTrackingKey(.registrationProcessTime)
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
    
    private func setupActivityIndicator(){
        loadingIndicator = BPCircleActivityIndicator()
        loadingIndicator.frame = CGRect(x: view.center.x - 15,y:view.center.y - 105, width: 0, height: 0)
        loadingIndicator.isHidden = true
        view.addSubview(loadingIndicator)
    }
    
    private func setupTextFields() {
        nameField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        nameField.keyboardType = .default
        passwordField.keyboardType = .default
        confirmPasswordField.keyboardType = .default
        
        nameField.addTarget(self, action: #selector(checkRegistrationButtonReady), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(isPasswordValidate), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(isPasswordValidate), for: .editingChanged)
        
        nameField.defaultLineColor = colorTextFieldLoginLineLightGray
        nameField.activeLineColor = colorTextFieldLoginLineLightGray
        nameField.becomeFirstResponder()
        
        passwordField.defaultLineColor = colorTextFieldLoginLineLightGray
        passwordField.activeLineColor = colorTextFieldLoginLineLightGray
        passwordField.editingDidBegin()
        confirmPasswordField.defaultLineColor = colorTextFieldLoginLineLightGray
        confirmPasswordField.activeLineColor = colorTextFieldLoginLineLightGray
    }

    
    //MARK: Action Handler
    
    @IBAction func handleRegisterButton(sender: UIButton) {

        guard let userName = nameField.text, !userName.isEmpty else {
            AudioManager.shared.playSond(named: .failed)
            return
        }
        
        guard isPasswordValid else {
            AudioManager.shared.playSond(named: .failed)
            return 
        }
        
        guard let password = passwordField.text else { 
            AudioManager.shared.playSond(named: .failed)
            return 
        }
        
        guard let phone = registerUserInfo?["phone"], let countryCode = registerUserInfo?["countryCode"] else {
            AudioManager.shared.playSond(named: .failed)
            return
        }
        
        guard checkBox.checkState == .checked else {
            displayAlert(title: L("login.error.title.check-agreement"), message: L("login.error.message.check-agreement"), action: L("action.ok"))
            return
        }

        registerUser(name: userName, password: password, phone: phone, countryCode: countryCode)
    }
    
    
    //MARK: Helper
    
    private func registerUser(name: String, password: String, phone: String, countryCode: String){
        
        isLoading = true
        ProfileManager.shared.register(username: phone,
                                       countryCode: countryCode,
                                       phone: phone,
                                       password: password,
                                       name: name,
                                       completion: { (success, err, errType) in

                                        if success {
                                            DLog("注册成功, 登入...")
                                            ProfileManager.shared.login(username: phone, password: password, completion: { (success) in
                                                if success {
                                                    DLog("注册后登入成功, updateUserInfo...")
                                                    ProfileManager.shared.updateUserInfo(.isPhoneVerified, value: 1) { (success) in
                                                        if success {
                                                            self.performSegue(withIdentifier: self.registerSuccessSegueId, sender: self)
                                                            AnalyticsManager.shared.finishTimeTrackingKey(.registrationProcessTime)
                                                        } else {
                                                            self.displayGlobalAlert(title: L("register.error.title.verify"),
                                                                                    message: L("register.error.message.verify-phone"),
                                                                                    action: L("register.error.action.verify"), completion: nil)
                                                        }
                                                    }
                                                } else {
                                                    DLog("登入失败")
                                                    self.isLoading = false
                                                    self.displayGlobalAlert(title: "登入失败",
                                                                            message: "注册成功但登入失败，请检查你的网络。",
                                                                            action: L("action.ok"), completion: nil)
                                                }
                                            })
                                        } else {
                                            DLog("注册失败")
                                            self.isLoading = false
                                            self.displayGlobalAlert(title: L("register.error.title.failed"), message: L("register.error.message.failed") + ": \(err?.localizedDescription ?? L("register.error.title.failed"))", action: L("action.ok"), completion: { [weak self] _ in
                                                self?.navigationController?.popToRootViewController(animated: true)
                                            })
                                        }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? PhoneValidationViewController {
            if let info = sender as? [String:String] {
                destVC.registerUserInfo = info
            }
        } else {
            DLog("get error: RegistrationVC: prepare for segue get nil at destVC...")
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboards()
    }
    
    fileprivate func dismissKeyboards(){
        nameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        confirmPasswordField.resignFirstResponder()
    }
    
    private func isPasswordPatternValidate(textField: UITextField) -> Bool {
        guard let pw = textField.text, pw != "" else { return false }
        let passwordPattern = "^[a-zA-Z0-9]{6,20}+$"
        let matcher = MyRegex(passwordPattern)

        return matcher.match(input: pw)
    }
    
    func isPasswordValidate() -> Bool {
        guard let password = passwordField.text, let confirm = confirmPasswordField.text, password != "", confirm != "" else {
            isPasswordValid = false
            checkRegistrationButtonReady()
            return false
        }
        checkRegistrationButtonReady()
        isPasswordValid = isPasswordPatternValidate(textField: passwordField) && password == confirm
        
        return isPasswordValid
    }
    
    func checkRegistrationButtonReady() {
        let nameOk = (nameField.text != nil && nameField.text != "")
        let ok = isPasswordValid && nameOk
        registerButton.isEnabled = ok
        registerButton.backgroundColor = ok ? colorTheamRed : UIColor.lightGray
        registerButton.setTitleColor(.white, for: .normal)
    }
    
    
    @IBAction func agreepped(_ sender: Any) {
        gotoWebview(title: L("login.ui.agreement.title"), url: "\(ApiServers.shared.host)/doc_agreement")
    }
    
    private func gotoWebview(title: String, url: String) {
        let webVC = WebController()
        self.navigationController?.pushViewController(webVC, animated: true)
        webVC.title = title
        webVC.url = URL(string: url)
    }

}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboards()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        dismissKeyboards()
        return true
    }
    
}
