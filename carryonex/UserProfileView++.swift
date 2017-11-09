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
        let mdfPhoneCtl = PhoneNumberController()
        mdfPhoneCtl.isModifyPhoneNumber = true
        let navPhone = UINavigationController(rootViewController: mdfPhoneCtl)
        homePageCtl?.present(navPhone, animated: true, completion: nil)
    }
    
    private func getDocumentUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public func saveProfileImageToDocumentDirectory(image: UIImage) -> URL {
            let fileName = "\(ImageTypeOfID.profile.rawValue).JPG"
            let profileImgLocalUrl = getDocumentUrl().appendingPathComponent(fileName)
            if let imgData = UIImageJPEGRepresentation(image, imageCompress) {
                try? imgData.write(to: profileImgLocalUrl, options: .atomic)
            }
            print("saveProfileImageToDocumentDirectory: \(profileImgLocalUrl)")
            return profileImgLocalUrl
    }
    
    public func loadNamePhoneImage(){ // also do this in HomePageController
        guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
        
        if let currName = currUser.realName, currName != "" {
            let attStr = NSAttributedString(string: currName, attributes: buttonAttributes)
            nameButton.setAttributedTitle(attStr, for: .normal)
            nameButton.isEnabled = false
        }else{
            let attStr = NSAttributedString(string: "请提交您的身份验证信息", attributes: buttonAttributes)
            nameButton.setAttributedTitle(attStr, for: .normal)
            nameButton.isEnabled = true
        }

        if let currPhone = currUser.phone, currPhone != "" {
            let cc = currUser.phoneCountryCode ?? ""
            let phoneStr = currPhone.formatToPhoneNum(countryCode: cc)
            let attStr = NSAttributedString(string: phoneStr, attributes: buttonAttributes)
            phoneButton.setAttributedTitle(attStr, for: .normal)
            phoneButton.isEnabled = false
        }else{
            let attStr = NSAttributedString(string: "请验证您的手机号", attributes: buttonAttributes)
            phoneButton.setAttributedTitle(attStr, for: .normal)
            phoneButton.isEnabled = true
        }
        
        let imgUrl = URL(string: currUser.imageUrl ?? "")
        profileImgButton.kf.setImage(with:imgUrl, for: .normal, placeholder: #imageLiteral(resourceName: "CarryonEx_User"), options: nil, progressBlock: nil, completionHandler: nil)
        
        if !nameButton.isEnabled && !phoneButton.isEnabled {
            verifiedMarkerImage.image = #imageLiteral(resourceName: "carryonex_verifiedTrue")
        }else{
            verifiedMarkerImage.image = #imageLiteral(resourceName: "carryonex_verifiedFalse")
        }
    }
    
    public func removeProfileImageFromLocalFile(){
        let documentUrl = getDocumentUrl()
        let fileUrl = documentUrl.appendingPathComponent(ImageTypeOfID.profile.rawValue + ".JPG")
        do {
            try FileManager.default.removeItem(at: fileUrl)
        }catch let err {
            print("[ERROR]: removeProfileImageFromLocalFile() \(err.localizedDescription) | File: \(fileUrl)")
        }
    }
    
    internal func setupProfileImageFromAws(){
        let imgUrl = ProfileManager.shared.getCurrentUser()?.imageUrl ?? ""
        print("setup profile image from aws url = \(imgUrl)")
        profileImgButton.kf.setImage(with: URL(string: imgUrl), for: .normal, placeholder: #imageLiteral(resourceName: "CarryonEx_User"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    internal func setupProfileImage(_ img: UIImage){
        profileImgButton.setImage(img, for: .normal)
    }
    
    internal func setupWechatImg(){
        let imgUrl = ProfileManager.shared.getCurrentUser()?.imageUrl ?? ""
        profileImgButton.kf.setImage(with: URL(string: imgUrl), for: .normal, placeholder: #imageLiteral(resourceName: "CarryonEx_User"), options: nil, progressBlock: nil, completionHandler: nil)
    }
    
    internal func setupWechatRealName(){
        let attStr = NSAttributedString(string: (ProfileManager.shared.getCurrentUser()?.realName)!, attributes: buttonAttributes)
        nameButton.setAttributedTitle(attStr, for: .normal)
        
    }
    
}
