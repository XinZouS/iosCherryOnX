//
//  InputPasswordLoginController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/16.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import Material

class InputPasswordLoginController: UIViewController {
    
    var passwordField: TextField!
    fileprivate let constant: CGFloat = 32
    
    lazy var okButton: UIButton = {
        let b = UIButton()
        b.setTitle("→", for: .normal)
        b.layer.cornerRadius = 30
        b.backgroundColor = .lightGray
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        b.isEnabled = false
        return b
    }()
    lazy var forgetButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .clear // buttonColorBlue
        b.setTitle("忘记密码？", for: .normal)
        b.setTitleColor(UIColor.blue, for: UIControlState.normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.addTarget(self, action: #selector(forgetButtonTapped), for: .touchUpInside)
        return b
    }()
    
    fileprivate func prepareResignResponderButton() {
        let btn = RaisedButton(title: "Resign", titleColor: Color.blue.base)
        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        
        view.layout(btn).width(100).height(constant).top(40).right(20)
    }
    
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        passwordField?.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPasswordTextField()
        
        setupOkButton()
        
        setupForgetButton()
    }
    private func setupPasswordTextField(){
        passwordField = TextField()
        passwordField.placeholder = "密码"
        passwordField.detail = "请输入6位以上密码"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        passwordField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        passwordField.keyboardAppearance = .dark
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        passwordField.becomeFirstResponder()
        let leftView = UIImageView()
        leftView.image = Icon.settings
        passwordField.leftView = leftView
        view.layout(passwordField).center(offsetY: -100).left(60).right(60)
    }
    
    private func setupForgetButton(){
        view.addSubview(forgetButton)
        forgetButton.translatesAutoresizingMaskIntoConstraints = false
        forgetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        forgetButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        forgetButton.widthAnchor.constraint(equalToConstant: 148).isActive = true
        forgetButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupOkButton(){
        view.addSubview(okButton)
        okButton.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 30, width: 60, height: 60)
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
    }
}
