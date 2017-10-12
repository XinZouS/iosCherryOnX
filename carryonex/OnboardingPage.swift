//
//  OnboardingPage.swift
//  carryonex
//
//  Created by Xin Zou on 9/10/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import paper_onboarding



// https://github.com/Ramotion/paper-onboarding

class OnboardingController : UIViewController {
    
    let onboardingBackgroundImages: [String] = ["CarryonEx_OnBoarding-01-1", "CarryonEx_OnBoarding-02-1", "CarryonEx_OnBoarding-03-1"]
        
    lazy var onboardingView : PaperOnboarding = {
        let v = PaperOnboarding()
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    lazy var finishButton : UIButton = {
        let atts = [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 20),
            NSForegroundColorAttributeName: buttonColorPurple
        ]
        let attStr = NSAttributedString(string: "开始旅程", attributes: atts)
        let b = UIButton()
        b.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        b.setAttributedTitle(attStr, for: .normal)
        b.layer.borderColor = buttonColorPurple.cgColor
        b.layer.borderWidth = 2
        b.layer.masksToBounds = true
        b.layer.cornerRadius = 10
        b.isEnabled = false
        b.isHidden = true
        b.alpha = 0
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupOnboardingView()
        setupFinishButton()
    }
    override func viewDidAppear(_ animated: Bool) {
        UIApplication.shared.statusBarStyle = .default
    }
    
    
    private func setupOnboardingView(){
        view.addSubview(onboardingView)
        onboardingView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupFinishButton(){
        let bottomMargin : CGFloat = view.bounds.height * 0.11
        view.addSubview(finishButton)
        finishButton.addConstraints(left: nil, top: nil, right: nil, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: bottomMargin, width: 230, height: 50)
        finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
}

