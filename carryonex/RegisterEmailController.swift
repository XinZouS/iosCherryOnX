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

    var zoneCodeInput = ""
    var phoneInput = ""

    var emailField: TextField!
    fileprivate let constant: CGFloat = 32
    
    let textFieldH : CGFloat = 30
    
    lazy var  okButton : UIButton = {
        let b = UIButton()
        b.setTitle("→", for: .normal)
        b.layer.cornerRadius = 30
        b.backgroundColor = .lightGray
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        b.isEnabled = false
        return b
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = emailField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupEmailTextField()
        
        setupOkButton()
    }

    fileprivate func prepareResignResponderButton() {
        let btn = RaisedButton(title: "Resign", titleColor: Color.blue.base)
        btn.addTarget(self, action: #selector(handleResignResponderButton(button:)), for: .touchUpInside)
        
        view.layout(btn).width(100).height(constant).top(40).right(20)
    }
    
    @objc
    internal func handleResignResponderButton(button: UIButton) {
        emailField?.resignFirstResponder()
    }
    fileprivate func setupEmailTextField(){
        emailField = TextField()
        emailField.placeholder = "电子邮箱"
        emailField.detail = "请输入邮箱"
        emailField.isClearIconButtonEnabled = true
        emailField.delegate = self
        emailField.keyboardAppearance = .dark
        emailField.isPlaceholderUppercasedWhenEditing = true
        emailField.addTarget(self, action: #selector(checkEmail), for: .editingChanged)
        emailField.keyboardType = .emailAddress
        let leftView = UIImageView()
        leftView.image = Icon.email
        emailField.leftView = leftView
        emailField.placeholderLabel.font = UIFont.systemFont(ofSize: 20)
        view.layout(emailField).center(offsetY: -80).left(60).right(60)
    }
    
    
    private func setupOkButton(){
        var h = 0,w = 0
        switch UIScreen.main.bounds.width {
        case 320:
            h = 0
            w = 120
        case 375:
            h = 40
            w = 150
        case 414:
            h = 60
            w = 170
        default:
            h = 60
            w = 170
        }
        view.addSubview(okButton)
        okButton.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 30, width: 60, height: 60)
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: CGFloat(w)).isActive = true
        okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: CGFloat(h)).isActive = true
    }
}



