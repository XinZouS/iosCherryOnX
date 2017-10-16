//
//  RegisterEmailController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import Material

class RegisterEmailController: UIViewController {
    var emailField: ErrorTextField!
    fileprivate let constant: CGFloat = 32
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    
    let textFieldH : CGFloat = 30
    lazy var emailTextField: UITextField = {
        let t = UITextField()
        t.backgroundColor = .white
        t.layer.cornerRadius = 5
        t.layer.borderWidth = 1
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.keyboardType = .phonePad
        t.placeholder = " 请输入您的邮箱号"
        t.font = UIFont.systemFont(ofSize: 16)
        //        t.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return t
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
        
        setupEmailTextField()
        
        setupOkButton()
    }
    /// Prepares the resign responder button.
    fileprivate func prepareResignResponderButton() {
        let btn = RaisedButton(title: "Resign", titleColor: Color.blue.base)
        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        
        view.layout(btn).width(100).height(constant).top(40).right(20)
    }
    
    /// Handle the resign responder button.
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        emailField?.resignFirstResponder()
    }
    fileprivate func setupEmailTextField(){
        emailField = ErrorTextField()
        emailField.placeholder = "Email"
        emailField.detail = "Error, incorrect email"
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self
        emailField.isPlaceholderUppercasedWhenEditing = true
//        emailField.translatesAutoresizingMaskIntoConstraints = false
//        emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 45).isActive = true
//        emailField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
//        emailField.widthAnchor.constraint(equalToConstant: 178).isActive = true
//        emailField.heightAnchor.constraint(equalToConstant: textFieldH).isActive = true
        let leftView = UIImageView()
        leftView.image = Icon.email
        emailField.leftView = leftView
        
        view.layout(emailField).center(offsetX: 60).left(60).right(60)
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



