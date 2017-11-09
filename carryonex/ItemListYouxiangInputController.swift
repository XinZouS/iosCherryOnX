//
//  ItemListYouxiangInputController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/27.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import Material

class ItemListYouxiangInputController: UIViewController, UICollectionViewDelegateFlowLayout{
    var youxiangField: ErrorTextField!
    fileprivate let constant: CGFloat = 32
    
    let textFieldH : CGFloat = 30

    lazy var  okButton : UIButton = {
        let b = UIButton()
        b.setTitle("→", for: .normal)
        b.layer.cornerRadius = 30
        b.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        b.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        b.isEnabled = true
        return b
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = youxiangField.becomeFirstResponder()
        okButton.isEnabled = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupEmailTextField()
        
        setupOkButton()
        
        setupNavigationBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        youxiangField.resignFirstResponder()
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
        youxiangField?.resignFirstResponder()
    }
    
    fileprivate func setupEmailTextField(){
        youxiangField = ErrorTextField()
        youxiangField.placeholder = "游箱号码"
        youxiangField.detail = "Error, incorrect email"
        youxiangField.isClearIconButtonEnabled = true
        youxiangField.keyboardType = .phonePad
        youxiangField.isPlaceholderUppercasedWhenEditing = true
        youxiangField.delegate = self
        _ = youxiangField.becomeFirstResponder()
        youxiangField.keyboardAppearance = .dark
        let leftView = UIImageView()
        leftView.image = Icon.bell
        youxiangField.leftView = leftView
        
        view.layout(youxiangField).center(offsetY: -80).left(60).right(60)
    }
    
    private func setupNavigationBar(){
        title = "寄件"
        UINavigationBar.appearance().tintColor = buttonColorWhite
        navigationController?.navigationBar.tintColor = buttonColorWhite
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: buttonColorWhite]
        
        let cancel = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancel
    }
    
    private func setupOkButton(){
        view.addSubview(okButton)
        okButton.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 30, width: 60, height: 60)
        okButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 150).isActive = true
        okButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 80).isActive = true
    }
}

extension ItemListYouxiangInputController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == true {
            textField.resignFirstResponder()
        }
        return true
    }
}
