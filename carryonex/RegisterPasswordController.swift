//
//  RegisterPasswordController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import Material

class RegisterPasswordController: UIViewController {
    var passwordField: TextField!
    var passwordConfirmField: TextField!
    fileprivate let constant: CGFloat = 32
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    
    lazy var okButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray // buttonColorBlue
        b.setTitle("确认", for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        b.isEnabled = false
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupPasswordTextField()
        
        
        setupPasswordConfirmTextField()
        
        
        setupOkButton()
        
    }
    private func setupPasswordTextField(){
        passwordField = TextField()
        passwordField.placeholder = "Password"
        passwordField.detail = "At least 6 characters"
        passwordField.clearButtonMode = .whileEditing
        passwordField.isVisibilityIconButtonEnabled = true
        // Setting the visibilityIconButton color.
        passwordField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        let leftView = UIImageView()
        leftView.image = Icon.settings
        passwordField.leftView = leftView
        passwordField.addTarget(self, action: #selector(checkPassword), for: .editingChanged)
        view.layout(passwordField).top(200).left(60).right(60)
    }
    
    
    private func setupPasswordConfirmTextField(){
        passwordConfirmField = TextField()
        passwordConfirmField.placeholder = "confirm"
        passwordConfirmField.detail = "Confirm your password"
        passwordConfirmField.clearButtonMode = .whileEditing
        passwordConfirmField.isVisibilityIconButtonEnabled = true
        // Setting the visibilityIconButton color.
        passwordConfirmField.visibilityIconButton?.tintColor = Color.green.base.withAlphaComponent(passwordField.isSecureTextEntry ? 0.38 : 0.54)
        passwordConfirmField.addTarget(self, action: #selector(checkConfirmPassword), for: .editingChanged)
        let leftView = UIImageView()
        leftView.image = Icon.settings
        passwordConfirmField.leftView = leftView
        
        view.layout(passwordConfirmField).center().left(60).right(60)
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
