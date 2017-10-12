//
//  RegisterPasswordController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit


class RegisterPasswordController: UIViewController {
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    let textFieldH : CGFloat = 30
    lazy var passwordTextField: UITextField = {
        let t = UITextField()
        t.backgroundColor = .white
        t.layer.cornerRadius = 5
        t.layer.borderWidth = 1
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.keyboardType = .phonePad
        t.placeholder = " 请输入密码"
        t.font = UIFont.systemFont(ofSize: 16)
        //        t.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return t
    }()
    lazy var passwordLabel: UILabel = {
        let b = UILabel()
        b.text =  "密码:"
        return b
    }()
    lazy var passwordConfirmTextField: UITextField = {
        let t = UITextField()
        t.backgroundColor = .white
        t.layer.cornerRadius = 5
        t.layer.borderWidth = 1
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.keyboardType = .phonePad
        t.placeholder = " 请再次输入密码"
        t.font = UIFont.systemFont(ofSize: 16)
        //        t.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return t
    }()
    lazy var passwordConfirmLabel: UILabel = {
        let b = UILabel()
        b.text =  "确认:"
        return b
    }()
    lazy var okButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray // buttonColorBlue
        b.setTitle("确认", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPasswordTextField()
        
        setupPasswordLabel()
        
        setupPasswordConfirmTextField()
        
        setupPasswordConfirmLabel()
        
        setupOkButton()
        
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
    
    
    private func setupPasswordLabel(){
        view.addSubview(passwordLabel)
        passwordLabel.addConstraints(left: nil, top: nil, right: passwordTextField.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 76, height: textFieldH)
        passwordLabel.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor).isActive = true
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
    
    
    private func setupPasswordConfirmLabel(){
        view.addSubview(passwordConfirmLabel)
        passwordConfirmLabel.addConstraints(left: nil, top: nil, right: passwordConfirmTextField.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 76, height: textFieldH)
        passwordConfirmLabel.centerYAnchor.constraint(equalTo: passwordConfirmTextField.centerYAnchor).isActive = true
    }
    
    private func setupOkButton(){
        view.addSubview(okButton)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        okButton.widthAnchor.constraint(equalToConstant: 148).isActive = true
        okButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
