//
//  RegisterMainController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/13.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import Material

class RegisterMainController: UIViewController{
    var phoneNumberTextField : TextField!
    let textFieldH : CGFloat = 30
    lazy var flagButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.layer.borderColor = UIColor.lightGray.cgColor
        b.layer.borderWidth = 1
        b.layer.cornerRadius = 5
        b.setTitle("🇺🇸  +1", for: .normal)
        b.setTitleColor(.black, for: .normal)
        b.borderColor = .clear
//        b.addTarget(self, action: #selector(openFlagPicker), for: .touchUpInside)
        return b
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        setupImageView()
        setupPhoneNumTextField()
        setupFlagButton()
        setupNavigationBar()
    }
    
    private func setupImageView(){
        let imageView = UIImageView(image:UIImage(named:"background"))
        imageView.frame = CGRect(x:0, y:0, width:420, height:500)
        self.view.addSubview(imageView)
    }
    
    private func setupNavigationBar(){
        UINavigationBar.appearance().tintColor = buttonColorWhite
        navigationController?.navigationBar.tintColor = buttonColorWhite
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: buttonColorWhite]
    }
    private func setupFlagButton(){
        view.addSubview(flagButton)
        flagButton.addConstraints(left: nil, top: nil, right: phoneNumberTextField.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 76, height: textFieldH)
        flagButton.centerYAnchor.constraint(equalTo: phoneNumberTextField.centerYAnchor).isActive = true
    }
    private func setupPhoneNumTextField(){
        phoneNumberTextField = TextField()
        phoneNumberTextField.placeholder = "请输入手机号"
        phoneNumberTextField.detail = "手机号码"
        phoneNumberTextField.clearButtonMode = .whileEditing
        phoneNumberTextField.isEnabled = false
        view.layout(phoneNumberTextField).top(550).left(100).right(20)
    }
}
