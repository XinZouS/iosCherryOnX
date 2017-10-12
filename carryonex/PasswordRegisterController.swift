//
//  PasswordRegisterController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/5.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//
struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                                options: [],
                                                range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
import UIKit
import M13Checkbox

class PasswordRegisterController: UIViewController{
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    
    let textFieldH : CGFloat = 30
    
    lazy var passwordLable:UILabel = {
        let l = UILabel()
        l.text = "密码:"
        return l
    }()
    lazy var passwordTextField: UITextField = {
        let t = UITextField()
        t.backgroundColor = .white
        t.layer.cornerRadius = 5
        t.layer.borderWidth = 1
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.keyboardType = .default
        t.placeholder = " 请输入密码"
        t.font = UIFont.systemFont(ofSize: 16)
        t.isSecureTextEntry = true
        t.addTarget(self, action: #selector(checkPassword), for: .editingChanged )
        return t
    }()
    lazy var passwordConfirmLable:UILabel = {
        let l = UILabel()
        l.text = "确认:"
        return l
    }()
    lazy var passwordConfirmTextField: UITextField = {
        let t = UITextField()
        t.backgroundColor = .white
        t.layer.cornerRadius = 5
        t.layer.borderWidth = 1
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.keyboardType = .default
        t.placeholder = " 请再次输入密码"
        t.font = UIFont.systemFont(ofSize: 16)
        t.isSecureTextEntry = true
        return t
    }()
    lazy var nextCheckbox : M13Checkbox = {
        let b = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
        b.addTarget(self, action: #selector(agreeCheckboxChanged), for: .valueChanged)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        passwordTextField.delegate = self
        
        setupPasswordTextField()
        
        setupPasswordLable()
        
        setupPasswordConfirmTextField()
        
        setupPasswordConfirmLable()
        
        setUpNextCheckbox()
    }
    // for keyboard notification:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //        setupKeyboardObserver()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    private func setupPasswordLable(){
        view.addSubview(passwordLable)
        passwordLable.addConstraints(left: nil, top: nil, right: passwordTextField.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 76, height: textFieldH)
        passwordLable.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
    }
    private func setupPasswordTextField(){
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 45).isActive = true
        passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 178).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: textFieldH).isActive = true
        let re = CGRect(x: 10, y: 0, width: 7, height: 20)
        let leftView = UILabel(frame: re)
        leftView.backgroundColor = .clear
        passwordTextField.leftView = leftView
        passwordTextField.leftViewMode = .always
        passwordTextField.contentVerticalAlignment = .center
    }
    private func setupPasswordConfirmTextField(){
        view.addSubview(passwordConfirmTextField)
        passwordConfirmTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordConfirmTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 45).isActive = true
        passwordConfirmTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        passwordConfirmTextField.widthAnchor.constraint(equalToConstant: 178).isActive = true
        passwordConfirmTextField.heightAnchor.constraint(equalToConstant: textFieldH).isActive = true
        let re = CGRect(x: 10, y: 0, width: 7, height: 20)
        let leftView = UILabel(frame: re)
        leftView.backgroundColor = .clear
        passwordConfirmTextField.leftView = leftView
        passwordConfirmTextField.leftViewMode = .always
        passwordConfirmTextField.contentVerticalAlignment = .center
    }
    
    private func setupPasswordConfirmLable(){
        view.addSubview(passwordConfirmLable)
        passwordConfirmLable.addConstraints(left: nil, top: nil, right: passwordConfirmTextField.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 76, height: textFieldH)
        passwordConfirmLable.centerYAnchor.constraint(equalTo: passwordConfirmTextField.centerYAnchor).isActive = true
    }
    
    private func setUpNextCheckbox(){
        view.addSubview(nextCheckbox)
        nextCheckbox.translatesAutoresizingMaskIntoConstraints = false
        nextCheckbox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        nextCheckbox.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        nextCheckbox.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextCheckbox.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}
