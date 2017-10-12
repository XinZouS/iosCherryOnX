//
//  RegisterEmailController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit


class RegisterEmailController: UIViewController {
    
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
    lazy var emailLabel: UILabel = {
        let b = UILabel()
        b.text =  "邮箱:"
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
        
        setupEmailTextField()
        
        setupEmailLabel()
        
        setupOkButton()
    }
    private func setupEmailTextField(){
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 45).isActive = true
        emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -120).isActive = true
        emailTextField.widthAnchor.constraint(equalToConstant: 178).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: textFieldH).isActive = true
        let re = CGRect(x: 10, y: 0, width: 7, height: 20)
        let leftView = UILabel(frame: re)
        leftView.backgroundColor = .clear
        emailTextField.leftView = leftView
        emailTextField.leftViewMode = .always
        emailTextField.contentVerticalAlignment = .center
    }
    
    
    private func setupEmailLabel(){
        view.addSubview(emailLabel)
        emailLabel.addConstraints(left: nil, top: nil, right: emailTextField.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 76, height: textFieldH)
        emailLabel.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor).isActive = true
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

