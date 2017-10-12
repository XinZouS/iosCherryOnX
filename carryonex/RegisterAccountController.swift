//
//  RegisterAccountController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/5.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import M13Checkbox

class RegisterAccountController: UIViewController{
    
    let textFieldH : CGFloat = 30
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    
    lazy var emailLable:UILabel = {
        let l = UILabel()
        l.text = "邮箱:"
        return l
    }()
    lazy var emailTextField: UITextField = {
        let t = UITextField()
        t.backgroundColor = .white
        t.layer.cornerRadius = 5
        t.layer.borderWidth = 1
        t.layer.borderColor = UIColor.lightGray.cgColor
        t.keyboardType = .emailAddress
        t.placeholder = " 请输入邮箱号"
        t.font = UIFont.systemFont(ofSize: 16)
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
        
        setupEmailTextField()
        setupEmailLable()
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
    private func setupEmailLable(){
        view.addSubview(emailLable)
        emailLable.addConstraints(left: nil, top: nil, right: emailTextField.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 76, height: textFieldH)
        emailLable.centerYAnchor.constraint(equalTo: emailTextField.centerYAnchor).isActive = true
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
    private func setUpNextCheckbox(){
        view.addSubview(nextCheckbox)
        nextCheckbox.translatesAutoresizingMaskIntoConstraints = false
        nextCheckbox.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        nextCheckbox.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 200).isActive = true
        nextCheckbox.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nextCheckbox.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
}
