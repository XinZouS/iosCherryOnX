//
//  PhotoIDController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/15/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Photos

import AWSCognito
import AWSCore
import AWSS3
import Alamofire
import ALCameraViewController



extension PhotoIDController: UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// dismiss keyboard by tapping return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        setupUserRealNameFrom(textField)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        setupUserRealNameFrom(textField)
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count > 0 {
            nameTextField.resignFirstResponder()
        }
    }
    func textFieldDismiss(){
        nameTextField.resignFirstResponder()
    }
    
    private func setupUserRealNameFrom(_ textField: UITextField){
        if let newName = textField.text, newName != "" {
            DispatchQueue.main.async(execute: {
                ProfileManager.shared.updateUserInfo(.realName, value: newName, completion: nil)
            })
        }
    }
    /// response to 4 image button tapped
    func passportButtonTapped(){
        imagePickedType = ImageTypeOfID.passport
        imageIDsButtonTapped()
    }
    func idCardA_ButtonTapped(){
        imagePickedType = ImageTypeOfID.idCardA
        imageIDsButtonTapped()
    }
    func idCardB_ButtonTapped(){
        imagePickedType = ImageTypeOfID.idCardB
        imageIDsButtonTapped()
    }
    /// allow edit as square
    func profileButtonTapped(){
        imagePickedType = ImageTypeOfID.profile
        //imageIDsButtonTapped() // replaced by ALCamera
        openALCameraController()
    }
    
    
    /// open menu to select image source
    func imageIDsButtonTapped(){
        let attachmentMenu = UIAlertController(title: "选择图片来源", message: "选择证件清晰照或拍摄证件上传以验证身份", preferredStyle: .actionSheet)
        let openLibrary = UIAlertAction(title: "相册选择", style: .default) { (action) in
            self.openImagePickerWith(source: .photoLibrary, isAllowEditing: self.imagePickedType == ImageTypeOfID.profile)
        }
        let openCamera = UIAlertAction(title: "打开相机", style: .default) { (action) in
            //self.openImagePickerWith(source: .camera, isAllowEditing: self.imagePickedType == ImageTypeOfID.profile)
            // ------ replace above by customized cameraView: ------
            self.openALCameraController()
        }
        let cancelSelect = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        attachmentMenu.addAction(openLibrary)
        attachmentMenu.addAction(openCamera)
        attachmentMenu.addAction(cancelSelect)
        
        if UIDevice.current.userInterfaceIdiom == .pad { // iPad MUST setup to present alertViewController
            var referenceView = self.idTypeButton
            switch imagePickedType! {
                case ImageTypeOfID.passport:
                    referenceView = passportButton
                case ImageTypeOfID.idCardA:
                    referenceView = idCardA_Button
                case ImageTypeOfID.idCardB:
                    referenceView = idCardB_Button
                case ImageTypeOfID.profile:
                    referenceView = profileButton
                case ImageTypeOfID.requestImages: // not necessary, Xcode foce me to do this; - Xin
                    referenceView = profileButton // bcz this page will NEVER display for request imgs;
            }
            attachmentMenu.popoverPresentationController?.sourceView = referenceView
        }
        self.present(attachmentMenu, animated: true, completion: nil)
    }
    
    /// MARK: - Image Picker delegate
    func openImagePickerWith(source: UIImagePickerControllerSourceType, isAllowEditing: Bool){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.allowsEditing = isAllowEditing
        imagePicker.delegate = self
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.barTintColor = barColorGray // Background color
        imagePicker.navigationBar.tintColor = .white // Cancel button ~ any UITabBarButton items
        imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white] // Title color
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var getImg : UIImage = #imageLiteral(resourceName: "CarryonEx_Logo")
        if let editedImg = info[UIImagePickerControllerEditedImage] as? UIImage {
            getImg = editedImg
        }else if let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            getImg = originalImg
        }

        presentImageOnButtons(getImg)

        print("did finish selecting image, now have in set: ", imageUploadingSet)
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    /// MARK: - ALCameraView setup
    private func openALCameraController(){
        let corpingParms = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 160, height: 90))
        let cameraViewController = CameraViewController(croppingParameters: corpingParms, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { (getImg, phAsset) in
            if let image = getImg {
                self.presentImageOnButtons(image)
            }
            self.dismiss(animated: true, completion: nil)
        })
        self.present(cameraViewController, animated: true, completion: nil)
    }
    
    
    private func presentImageOnButtons(_ getImg : UIImage){
        guard let imagePickedType = self.imagePickedType else { return }
        
        imageUploadingSet.insert(imagePickedType.rawValue)
        let localFileUrl = saveImageToDocumentDirectory(img: getImg, idType: imagePickedType)
        imageUploadSequence[imagePickedType] = localFileUrl
        
        switch imagePickedType {
            case .passport:
                passportButton.setImage(getImg, for: .normal)
                passportReady = true
            
            case .idCardA:
                idCardA_Button.setImage(getImg, for: .normal)
                idCardAReady = true
            
            case .idCardB:
                idCardB_Button.setImage(getImg, for: .normal)
                idCardBReady = true
            
            case .profile:
                profileButton.setImage(getImg, for: .normal)
                profileReady = true
            
            case .requestImages:
                print("Error: should NOT set up requestImages in PhotoIDController++")
        }

    }
    
    
    
    /// - MARK: upload all images to aws
    
    func submitButtonTapped(){
    if idType == .passport && !passportReady {
            displayAlert(title: "您选好护照了吗？", message: "为保障您和他人的货物安全，请选择护照个人信息页作为实名验证信息，谢谢！", action: L("action.ok"))
            return
        
    } else if idType == .idCard && (!idCardAReady || !idCardBReady) {
            displayAlert(title: "身份证少了一面？", message: "别闹！都说了身份证要传两面才行，你故意的吗？", action: L("action.ok"))
            return
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.isHidden = false
        activityIndicator.animate() // start uploading image and show indicator
        
        if let realName = self.nameTextField.text, !realName.isEmpty {
            ProfileManager.shared.updateUserInfo(.realName, value: realName, completion: { (success) in
                if !success {
                    URLCache.shared.removeAllCachedResponses()
                    self.displayAlertForUploadFailed(error: nil)
                    return
                }
            })
        }
        
        uploadAllImagesToAws()
    }
    
    private func uploadAllImagesToAws(){
        for pair in imageUploadSequence {
            guard let locUrl = pair.value else { continue }
            let imgIdType : String = pair.key.rawValue
            let filename = imgIdType + ".JPG"
            
            AwsServerManager.shared.uploadFile(fileName: filename, imgIdType: pair.key, localUrl: locUrl, completion: { (error, url) in
                if let err = error {
                    self.displayAlertForUploadFailed(error: err)
                }
                if let publicUrl = url, publicUrl.absoluteString != "" {
                    print("PhotoIDController: uploadAllImages get publicUrl.absoluteStr = \(publicUrl.absoluteString)")
                    self.imageUploadingSet.removeFirst()
                    self.removeImageWithUrlInLocalFileDirectory(fileName: filename)
                    self.saveImageCloudUrl(url: publicUrl) // finily will end up here if all success
                }else{
                    print("errrorrr!!! uploadAllImagesToAws(): task.result is nil, !!!! did not upload")
                }
                
            }) // end of uploadFile()
        }
    }
    
    private func saveImageCloudUrl(url : URL){
        let fileName: String = url.lastPathComponent
        guard let fileType: String = fileName.components(separatedBy: ".").first else { return }
        print("saveImageCloudUrl: get fileType = \(fileType), save urlStr = \(url.absoluteString)")
        
        let urlStr = url.absoluteString
        switch fileType {
        case ImageTypeOfID.passport.rawValue:
            ProfileManager.shared.updateUserInfo(.passportUrl, value: urlStr, completion: { (success) in
                self.didFinishedUploadImagesToAws(allSuccess: success)
            })
            
        case ImageTypeOfID.idCardA.rawValue:
            ProfileManager.shared.updateUserInfo(.idAUrl, value: urlStr, completion: { (success) in
                self.didFinishedUploadImagesToAws(allSuccess: success)
            })
            
        case ImageTypeOfID.idCardB.rawValue:
            ProfileManager.shared.updateUserInfo(.idBUrl, value: urlStr, completion: { (success) in
                self.didFinishedUploadImagesToAws(allSuccess: success)
            })
            
        case ImageTypeOfID.profile.rawValue:
            ProfileManager.shared.updateUserInfo(.imageUrl, value: urlStr, completion: { (success) in
                if success {
                    URLCache.shared.removeAllCachedResponses()
                    //self.homePageController?.userInfoMenuView.userProfileView.setupProfileImageFromAws()
                    self.removeImageWithUrlInLocalFileDirectory(fileName: ImageTypeOfID.profile.rawValue + ".JPG")
                }
                self.didFinishedUploadImagesToAws(allSuccess: success)
            })
            
        default:
            print("saveImageCloudUrl: invalide fileType input: \(fileType)")
            self.didFinishedUploadImagesToAws(allSuccess: false)
            return
        }
    }

    private func didFinishedUploadImagesToAws(allSuccess: Bool){
        guard allSuccess else {
            activityIndicator.isHidden = true
            activityIndicator.stop()
            displayAlertForUploadFailed(error: nil)
            return
        }
        guard imageUploadingSet.count == 0 else { return }
        activityIndicator.isHidden = true
        activityIndicator.stop()
        UIApplication.shared.endIgnoringInteractionEvents()
        
        DispatchQueue.main.async {
            ProfileManager.shared.updateUserInfo(.isIdVerified, value: "1", completion: { (success) in
                if success {
                    self.confirmIdUpload()
                } else {
                    self.displayAlertForUploadFailed(error: nil)
                }
            })
        }
    }

    private func confirmIdUpload(){
        let layer = navigationController?.viewControllers.count ?? 1
        if layer == 1 {
            self.dismiss(animated: false, completion: nil)
            //homePageController?.showAlertFromPhotoIdController(isUploadSuccess: true)
        }else{
            displayGlobalAlert(title: "上传成功", message: "已成功上传您的证件照片", action: L("action.ok"), completion: { [weak self] _ in
                self?.navigationController?.popToRootViewController(animated: false)
            })
        }
    }
    
    private func displayAlertForUploadFailed(error: Error?){
        if let error = error {
            debugPrint("Upload failed: \(error.localizedDescription)")
        }
        displayGlobalAlert(title: "出错", message: "照片上传失败", action: "重新提交", completion: nil)
    }
    
    // MARK: - Image Saving and Loading to fileSystem
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // Store the completion handler.
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    private func saveImageToDocumentDirectory(img : UIImage, idType: ImageTypeOfID) -> URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(idType.rawValue).JPG" // UserDefaultKey.profileImageLocalName.rawValue
        let profileImgLocalUrl = documentUrl.appendingPathComponent(fileName)
        if let imgData = UIImageJPEGRepresentation(img, imageCompress) {
            try? imgData.write(to: profileImgLocalUrl, options: .atomic)
        }
        print("save image to DocumentDirectory: \(profileImgLocalUrl)")
        return profileImgLocalUrl
    }
    
    func removeImageWithUrlInLocalFileDirectory(fileName: String){
        let fileType = fileName.components(separatedBy: ".").first!
        if fileType == ImageTypeOfID.profile.rawValue { return }

        let fileManager = FileManager.default
        let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        if let filePath = documentUrl.path {
            print("try to remove file from path: \(filePath), fileExistsAtPath==\(fileManager.fileExists(atPath: filePath))")
            do {
                try fileManager.removeItem(atPath: "\(filePath)/\(fileName)")
                print("OK remove file at path: \(filePath), fileName = \(fileName)")
            } catch let err {
                print("error : when trying to move file: \(fileName), from path = \(filePath), get err = \(err)")
            }
        }
    }
    
    func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
}


