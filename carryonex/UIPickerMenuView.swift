//
//  UIPickerMenuView.swift
//  carryonex
//
//  Created by Xin Zou on 8/23/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

/// the open menbers for outside useage in protocol



class UIPickerMenuView: UIView, PickerMenuViewDelegate {
    
    private var hostView: UIView!
    
    private var pickerView : UIPickerView!
    
    private var leftButton : UIButton!
    private var rightButton: UIButton!
    private var buttonWidth: CGFloat = 80
    
    private var titleHeight: CGFloat = 25 
    
    private let menuViewHeigh = (UIApplication.shared.keyWindow?.frame.height)! / 3 + 20

    private lazy var backgroundTransparentView : UIView = {
        let v = UIView()
        let s = UISwipeGestureRecognizer(target: self, action: #selector(dismissAnimation))
        s.direction = .down
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissAnimation)))
        v.addGestureRecognizer(s)
        return v
    }()
    
    private var backgroundMenuViewHeighConstraint: NSLayoutConstraint!
    
    private let menuView : UIView = {
        let v = UIView()
        v.backgroundColor = pickerColorLightGray
        return v
    }()
    
    
    private let titleLabel : UILabel = {
        let b = UILabel()
        b.text = "title to set?"
        b.backgroundColor = .clear
        b.textAlignment = .center
        b.font = UIFont.boldSystemFont(ofSize: 16)
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    
    // UIPickerMenuViewDelegate: 
    
    func setupMenuWith(hostView: UIView, targetPickerView: UIPickerView, leftBtn: UIButton, rightBtn: UIButton) {
        self.hostView = hostView
        self.pickerView = targetPickerView
        self.leftButton = leftBtn
        self.rightButton = rightBtn
        
        setupBackgroundTranspraentView()
        setupBackgroundMenuView()
        setupTitleView()
        setupButtons()
        setupPickerView()
    }
    
    func setupTitle(text: String) {
        self.titleLabel.text = text
    }
    
    private func setupBackgroundTranspraentView(){
        hostView.addSubview(backgroundTransparentView)
        backgroundTransparentView.addConstraints(left: hostView.leftAnchor, top: hostView.topAnchor, right: hostView.rightAnchor, bottom: hostView.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        backgroundTransparentView.isHidden = true
    }
    private func setupBackgroundMenuView(){
        hostView.addSubview(menuView)
        menuView.addConstraints(left: hostView.leftAnchor, top: nil, right: hostView.rightAnchor, bottom: hostView.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        backgroundMenuViewHeighConstraint = menuView.heightAnchor.constraint(equalToConstant: menuViewHeigh)
        backgroundMenuViewHeighConstraint.isActive = false
        menuView.isHidden = true
    }
    private func setupTitleView(){
        menuView.addSubview(titleLabel)
        titleLabel.addConstraints(left: menuView.leftAnchor, top: menuView.topAnchor, right: menuView.rightAnchor, bottom: nil, leftConstent: buttonWidth, topConstent: 10, rightConstent: buttonWidth, bottomConstent: 0, width: 0, height: titleHeight)
    }
    private func setupButtons(){
        menuView.addSubview(leftButton)
        leftButton.addConstraints(left: menuView.leftAnchor, top: menuView.topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: buttonWidth, height: titleHeight + 10)
        
        menuView.addSubview(rightButton)
        rightButton.addConstraints(left: nil, top: menuView.topAnchor, right: menuView.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: buttonWidth, height: titleHeight + 10)
    }
    private func setupPickerView(){
        pickerView.backgroundColor = buttonColorWhite
        menuView.addSubview(pickerView)
        pickerView.addConstraints(left: menuView.leftAnchor, top: titleLabel.bottomAnchor, right: menuView.rightAnchor, bottom: menuView.bottomAnchor, leftConstent: 7, topConstent: 10, rightConstent: 7, bottomConstent: 0, width: 0, height: 0)
    }
    
    
    func showUpAnimation(withTitle: String){
        titleLabel.text = withTitle
        backgroundTransparentView.isHidden = false
        menuView.isHidden = false
        backgroundMenuViewHeighConstraint.isActive = false
        backgroundMenuViewHeighConstraint = menuView.heightAnchor.constraint(equalToConstant: menuViewHeigh)
        backgroundMenuViewHeighConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.6, options: .curveEaseOut, animations: {
            
            self.hostView.layoutIfNeeded()
        }, completion: nil)
    }
    
    func dismissAnimation(){
        backgroundMenuViewHeighConstraint.isActive = false
        backgroundMenuViewHeighConstraint = menuView.heightAnchor.constraint(equalToConstant: 0)
        backgroundMenuViewHeighConstraint.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.hostView.layoutIfNeeded()
        }) { (complete) in
            self.backgroundTransparentView.isHidden = true
            self.menuView.isHidden = true
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
