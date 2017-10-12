//
//  UserProfileView++.swift
//  carryonex
//
//  Created by Xin Zou on 8/29/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension UserProfileView {
    
    
    internal func changeUserCarrierState(){
        print("selecting at: \(isCarrierSegmentControl.selectedSegmentIndex)")
        User.shared.isShipper = isCarrierSegmentControl.selectedSegmentIndex == 1
    }
    
    internal func profileButtonTapped(){
        userInfoViewCtl?.profileImageButtonTapped()
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
    
    internal func loadProfileImageFromLocalFile(){
        let documentUrl = getDocumentUrl()
        let fileUrl = documentUrl.appendingPathComponent(UserDefaultKey.profileImageLocalName.rawValue)
        do {
            let data = try Data(contentsOf: fileUrl)
            let newProfileImg = UIImage(data: data)
            profileImgButton.setImage(newProfileImg, for: .normal)
        }catch let err {
            print("get errorrrr when loadProfileImageFromLocalFile(), err = \(err)")
        }
    }
    
    internal func setupProfileImage(_ img: UIImage){
        profileImgButton.setImage(img, for: .normal)
    }
    
    public func removeProfileImageFromLocalFile(){
        let documentUrl = getDocumentUrl()
        let fileUrl = documentUrl.appendingPathComponent(UserDefaultKey.profileImageLocalName.rawValue)
        try? FileManager.default.removeItem(at: fileUrl)
    }
    
}
