//
//  OnboardingPage++.swift
//  carryonex
//
//  Created by Xin Zou on 9/10/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import paper_onboarding



extension OnboardingController: PaperOnboardingDelegate, PaperOnboardingDataSource {
    
    func finishButtonTapped(){
        UserDefaults.standard.set(true, forKey: UserDefaultKey.OnboardingFinished.rawValue)
        UserDefaults.standard.synchronize()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        // OnboardingItemInfo = (imageName: String, title: String, description: String, iconName: String, color: UIColor, titleColor: UIColor, descriptionColor: UIColor, titleFont: UIFont, descriptionFont: UIFont)
        
        let bgImgString = onboardingBackgroundImages[index]
        let bgColor = UIColor.white
        let textColor = UIColor.black
        let descriptionColor = UIColor.blue
        let textFont = UIFont.systemFont(ofSize: 16)
        let descriptionFont = UIFont.systemFont(ofSize: 14)

//        return [
//            ("CarryonEx_Moment_Icon", "", " ", " ", "CarryonEx_Food", bgColor, textColor, descriptionColor, textFont, descriptionFont),
//            ("CarryonEx_Wechat_Icon", "", " ", " ", "CarryonEx_Handbags", bgColor, textColor, descriptionColor, textFont, descriptionFont),
//            ("CarryonEx_Weibo_Icon", "", " ", " ", "CarryonEx_Mail", bgColor, textColor, descriptionColor, textFont, descriptionFont)
//        ][index]
        return (bgImgString, "", " ", " ", "", bgColor, textColor, descriptionColor, textFont, descriptionFont)
        
    }
    
    
    /// - MARK: paperOnboardingDelegate:
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
//        let backgroundImageView = UIImageView(image: onboardingBackgroundImages[index])
//        backgroundImageView.contentMode = .scaleAspectFill
//        
//        item.addSubview(backgroundImageView)
//        backgroundImageView.addConstraints(left: item.leftAnchor, top: item.topAnchor, right: item.rightAnchor, bottom: item.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 { // on the 2nd page
            UIView.animate(withDuration: 0.4, animations: { 
                self.finishButton.alpha = 0
            }, completion: nil)
            self.finishButton.isEnabled = false
            self.finishButton.isHidden = true
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 { // on the last page
            UIView.animate(withDuration: 0.4, animations: {
                self.finishButton.alpha = 1
            }, completion: nil)
            self.finishButton.isEnabled = true
            self.finishButton.isHidden = false
        }
    }
    
}

