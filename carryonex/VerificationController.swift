//
//  VerificationViewController.swift
//  carryonex
//
//  Created by Xin Zou on 8/10/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class VerificationController: UIViewController {
    
    var verificationCode = "1234"
    
    var resetTime: Int = 0

    var resetTimer : Timer?
    
    weak var phoneNumberCtrlDelegate : PhoneNumberDelegate?
    
    
    let hintLabel: UILabel = {
        let b = UILabel()
        b.text = "请输入您的验证码"
        b.textColor = .black
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .center
        return b
    }()
    
    let hintLabel2: UILabel = {
        let b = UILabel()
        b.text = "验证码已发送到"
        b.textColor = .darkGray
        b.font = UIFont.systemFont(ofSize: 10)
        b.textAlignment = .center
        return b
    }()

    var verifiCodeContainer: UIStackView?
    var verifiCodeLabel1: UILabel?
    var verifiCodeLabel2: UILabel?
    var verifiCodeLabel3: UILabel?
    var verifiCodeLabel4: UILabel?
    var verifiCodeLabel5: UILabel? // in case of code.len > 4
    var verifiCodeLabel6: UILabel?
    
    lazy var verifiTextField: UITextField = {
        let f = UITextField()
        f.delegate = self
        //f.backgroundColor = .green
        //f.alpha = 0.5
        //f.textColor = .clear
        f.layer.borderWidth = 0
        f.keyboardType = .numberPad
        f.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return f
    }()
    
    lazy var resendButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray // buttonColorBlue
        b.setTitle("重新发送", for: .normal)
        b.layer.cornerRadius = 5
        b.layer.masksToBounds = true
        b.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)
        b.isEnabled = false
        return b
    }()
    
    lazy var goNxPageButton: UIButton = {
        let b = UIButton()
        b.setTitle("go next page", for: .normal)
        b.backgroundColor = .cyan
//        b.addTarget(self, action: #selector(goNextPage), for: .touchUpInside)
        return b
    }()
        

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        verifiTextField.becomeFirstResponder()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        // the order of these setups are NOT allow to change
        setupResendButton()
        setupVerifiCodeViews()
        setupHintLabels()

    }
    
    private func setupResendButton(){
        view.addSubview(resendButton)
        resendButton.translatesAutoresizingMaskIntoConstraints = false
        resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        resendButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 20).isActive = true
        resendButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        resendButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupVerifiCodeViews(){
        let w : CGFloat = 46, h : CGFloat = 46, l : CGFloat = 0
        let v1 = UIView(), v2 = UIView(), v3 = UIView(), v4 = UIView()
        //v1.backgroundColor = .green
        //v2.backgroundColor = .yellow
        verifiCodeLabel1 = UILabel()
        verifiCodeLabel2 = UILabel()
        verifiCodeLabel3 = UILabel()
        verifiCodeLabel4 = UILabel()
        let labels = [verifiCodeLabel1, verifiCodeLabel2, verifiCodeLabel3, verifiCodeLabel4]
        
        for labe in labels {
            labe?.textAlignment = .center
            labe?.font = UIFont.boldSystemFont(ofSize: 30)
            labe?.layer.borderColor = UIColor.lightGray.cgColor
            labe?.layer.borderWidth = 1
            labe?.layer.cornerRadius = 2
        }
//        verifiCodeLabel1?.backgroundColor = .yellow
//        verifiCodeLabel2?.backgroundColor = .cyan
//        verifiCodeLabel3?.backgroundColor = .green
//        verifiCodeLabel4?.backgroundColor = .yellow
        v1.addSubview(verifiCodeLabel1!)
        v2.addSubview(verifiCodeLabel2!)
        v3.addSubview(verifiCodeLabel3!)
        v4.addSubview(verifiCodeLabel4!)
        verifiCodeLabel1?.addConstraints(left: nil, top: v1.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        verifiCodeLabel2?.addConstraints(left: nil, top: v2.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        verifiCodeLabel3?.addConstraints(left: nil, top: v3.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        verifiCodeLabel4?.addConstraints(left: nil, top: v4.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        verifiCodeLabel1?.centerXAnchor.constraint(equalTo: v1.centerXAnchor).isActive = true
        verifiCodeLabel2?.centerXAnchor.constraint(equalTo: v2.centerXAnchor).isActive = true
        verifiCodeLabel3?.centerXAnchor.constraint(equalTo: v3.centerXAnchor).isActive = true
        verifiCodeLabel4?.centerXAnchor.constraint(equalTo: v4.centerXAnchor).isActive = true
        
        verifiCodeContainer = UIStackView(arrangedSubviews: [v1, v2, v3, v4])
        verifiCodeContainer?.axis = .horizontal
        verifiCodeContainer?.distribution = .fillEqually
        
        view.addSubview(verifiCodeContainer!)
        verifiCodeContainer?.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: resendButton.topAnchor, leftConstent: 20, topConstent: 0, rightConstent: 20, bottomConstent: 40, width: 0, height: h)
        
        view.addSubview(verifiTextField)
        verifiTextField.addConstraints(left: verifiCodeContainer?.leftAnchor, top: verifiCodeContainer?.topAnchor, right: verifiCodeContainer?.rightAnchor, bottom: verifiCodeContainer?.bottomAnchor, leftConstent: -90, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupHintLabels(){
        view.addSubview(hintLabel2)
        hintLabel2.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: verifiCodeContainer?.topAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 20, width: 0, height: 15)
        var zoneCode = "0"
        var phone = "000"
        if (isModifyPhoneNumber) {
            if let profileUser = ProfileManager.shared.getCurrentUser() {
                zoneCode = profileUser.phoneCountryCode ?? "0"
                phone = profileUser.phone ?? "000"
            }
        } else {
            zoneCode = zoneCodeInput
            phone = phoneInput
        }
        
        hintLabel2.text = "验证码已发送到 \(zoneCode) \(phone)"
        
        view.addSubview(hintLabel)
        hintLabel.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: verifiCodeContainer?.topAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 40, width: 0, height: 26)
    }
}


