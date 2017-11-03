//
//  UserProfileView++.swift
//  carryonex
//
//  Created by Xin Zou on 8/29/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Kingfisher


extension UserProfileView {
    
        
    internal func profileButtonTapped(){
        homePageCtl?.profileImageButtonTapped()
    }
    
    internal func nameButtonTapped(){
        let navPhoto = UINavigationController(rootViewController: PhotoIDController())
        homePageCtl?.present(navPhoto, animated: true, completion: nil)
    }
    internal func phoneButtonTapped(){
        isModifyPhoneNumber = true // this is a Global var ??? should be a propity in PhoneNumController is better;
        let navPhone = UINavigationController(rootViewController: PhoneNumberController())
        homePageCtl?.present(navPhone, animated: true, completion: nil)
    }
    
    private func getDocumentUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public func saveProfileImageToLocalFile(image: UIImage) -> URL {
        let fileName = UserDefaultKey.profileImageLocalName.rawValue
        let fileUrl = getDocumentUrl().appendingPathComponent(fileName)
        if let imgData = UIImageJPEGRepresentation(image, 0.3) {
            try? imgData.write(to: fileUrl, options: .atomic)
        }
        return fileUrl
    }
    
    public func loadNameAndPhoneInfo(){ // also do this in HomePageController
        if let currName = ProfileManager.shared.getCurrentUser()?.realName, currName != "" {
            let attStr = NSAttributedString(string: currName, attributes: buttonAttributes)
            nameButton.setAttributedTitle(attStr, for: .normal)
            nameButton.isEnabled = false
        
        } else {
            let attStr = NSAttributedString(string: "请提交您的身份验证信息", attributes: buttonAttributes)
            nameButton.setAttributedTitle(attStr, for: .normal)
            nameButton.isEnabled = true
        }

        if let currPhone = ProfileManager.shared.getCurrentUser()?.phone, currPhone != "" {
            let cc = ProfileManager.shared.getCurrentUser()?.phoneCountryCode ?? ""
            let phoneStr = currPhone.formatToPhoneNum(countryCode: cc)
            let attStr = NSAttributedString(string: phoneStr, attributes: buttonAttributes)
            phoneButton.setAttributedTitle(attStr, for: .normal)
            phoneButton.isEnabled = false
        }else{
            let attStr = NSAttributedString(string: "请验证您的手机号", attributes: buttonAttributes)
            phoneButton.setAttributedTitle(attStr, for: .normal)
            phoneButton.isEnabled = true
        }
        if let imgPhoto = ProfileManager.shared.getCurrentUser()?.imageUrl{
            if (imgPhoto != ""){
                print(ProfileManager.shared.getCurrentUser()?.imageUrl ?? "")
                profileImgButton.kf.setImage(with:URL(string:imgPhoto), for: .normal)
            }else{
                profileImgButton.setImage(#imageLiteral(resourceName: "CarryonEx_User"), for: .normal)
            }
        }else{
            profileImgButton.setImage(#imageLiteral(resourceName: "CarryonEx_User"), for: .normal)
        }
        
        if !nameButton.isEnabled && !phoneButton.isEnabled {
            verifiedMarkerImage.image = #imageLiteral(resourceName: "carryonex_verifiedTrue")
        }else{
            verifiedMarkerImage.image = #imageLiteral(resourceName: "carryonex_verifiedFalse")
        }
    }
    
    internal func loadProfileImageFromLocalFile(){
        let documentUrl = getDocumentUrl()
        let fileUrl = documentUrl.appendingPathComponent(UserDefaultKey.profileImageLocalName.rawValue)
        do {
            let data = try Data(contentsOf: fileUrl)
            let newProfileImg = UIImage(data: data)
            profileImgButton.setImage(newProfileImg, for: .normal)
            
        } catch let err {
            print("[ERROR]: loadProfileImageFromLocalFile() \(err.localizedDescription) | File: \(fileUrl)")
        }
    }
    
    internal func setupProfileImage(_ img: UIImage){
        profileImgButton.setImage(img, for: .normal)
    }
    
    internal func setupWechatImg(){
        let imgUrl = ProfileManager.shared.getCurrentUser()?.imageUrl
        profileImgButton.kf.setImage(with:URL(string:imgUrl!), for: .normal)
    }
    
    internal func setupWechatRealName(){
        let attStr = NSAttributedString(string: (ProfileManager.shared.getCurrentUser()?.realName)!, attributes: buttonAttributes)
        nameButton.setAttributedTitle(attStr, for: .normal)
        
    }
    
    public func removeProfileImageFromLocalFile(){
        let documentUrl = getDocumentUrl()
        let fileUrl = documentUrl.appendingPathComponent(UserDefaultKey.profileImageLocalName.rawValue)
        try? FileManager.default.removeItem(at: fileUrl)
    }
    
}
