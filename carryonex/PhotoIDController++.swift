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

import ALCameraViewController



extension PhotoIDController: UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    /// dismiss keyboard by tapping return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            nameTextField.resignFirstResponder()
        }
    }
    func textFieldDismiss(){
        nameTextField.resignFirstResponder()
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
            default:
                referenceView = self.idTypeButton
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
        }else
        if let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
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
            if let img = getImg as? UIImage {
                self.presentImageOnButtons(getImg!)
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
            
        default:
            print("\n \n --- Warning: PhotoIDController++: unknow type of image selected.")
            break
        }

    }
    
    
    
    /// - MARK: upload all images to aws
    
    func submitButtonTapped(){
        
        if nameTextField.text == nil || nameTextField.text == "" {
            displayAlert(title: "您还没写名字呢", message: "启禀皇上，请在姓名栏里输入您的昵称！", action: "朕知道了")
            return
        }else
        if !profileReady {
            displayAlert(title: "您还没有头像哦", message: "请拍摄正面清晰照作为您的真人头像以保障您的账户信息完整，谢谢！", action: "嗯，平身吧")
            return
        }else if idType == .passport && !passportReady {
            displayAlert(title: "您选好护照了吗？", message: "为保障您和他人的货物安全，请选择护照个人信息页作为实名验证信息，谢谢！", action: "这就选")
            return
        }else if idType == .idCard && (!idCardAReady || !idCardBReady) {
            displayAlert(title: "身份证少了一面？", message: "别闹！都说了身份证要传两面才行，你故意的吗？", action: "是啊，来打我呀")
            return
        }
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.startAnimating() // start uploading image and show indicator
        ProfileManager.shared.currentUser?.realName = self.nameTextField.text!

        for pair in imageUploadSequence {
            let imgIdType : String = pair.key.rawValue
            prepareUploadFile(fileName: "\(imgIdType).JPG", imgIdType: pair.key)
        }
    }
    
    private func prepareUploadFile(fileName: String, imgIdType: ImageTypeOfID) {
        print("prepareUploadFile: \(fileName), imgIdType: \(imgIdType.rawValue)")
        
        // Configure aws cognito credentials:
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2, identityPoolId:"us-west-2:08a19db5-a7cc-4e82-b3e1-6d0898e6f2b7")
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // setup AWS Transfer Manager Request:
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.acl = .private
        uploadRequest?.key = fileName // MUST NOT change this!!
        uploadRequest?.body = imageUploadSequence[imgIdType]!! //generateImageUrlInLocalTemporaryDirectory(fileName: fileName, idImg: imageToUpload)
        uploadRequest?.bucket = "\(awsBucketName)/userIdPhotos/\(ProfileManager.shared.currentUser?.id!)" // no / at the end of bucket
        uploadRequest?.contentType = "image/jpeg"
        
        performFileUpload(request: uploadRequest)
    }
    
    
    private func performFileUpload(request: AWSS3TransferManagerUploadRequest?){
        
        guard let request = request else {
            print("get nil in AWSS3TransferManagerUploadRequest.....")
            return
        }
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueWith { (task: AWSTask) -> Any? in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if let err = task.error {
                print("performFileUpload(): task.error = \(err)")
                self.activityIndicator.stopAnimating()
                self.displayAlert(title: "⛔️上传失败", message: "出现错误：\(err)， 请稍后重试。", action: "换个姿势再来一次")
                return nil
            }
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                if let publicURL = url?.appendingPathComponent(request.bucket!).appendingPathComponent(request.key!) {
                    self.saveImageCloudUrl(url: publicURL)
                }
            }else{
                print("errrorrr!!! task.result is nil, !!!! did not upload")
            }
            
            self.removeImageWithUrlInLocalFileDirectory(fileName: request.key!)
            
            print("number of images to be upload: ", self.imageUploadingSet.count)
            if self.imageUploadingSet.count == 1 {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    ProfileManager.shared.currentUser?.isVerified = true
                    ProfileManager.shared.saveUser()
                    self.dismiss(animated: true, completion: nil)
                    self.homePageController?.showAlertFromPhotoIdController()
                }
            }else{
                self.imageUploadingSet.removeFirst()
            }
            return nil
        }
    }
    
    private func saveImageCloudUrl(url : URL){
        let fileName: String = url.lastPathComponent
        guard let fileType: String = fileName.components(separatedBy: ".").first else { return }
        print("get fileType = \(fileType), save urlStr = \(url.absoluteString)")
        
        switch fileType {
        case ImageTypeOfID.passport.rawValue:
            ProfileManager.shared.currentUser?.passportUrl = url.absoluteString
            passportImgUrlCloud = url.absoluteString
            
        case ImageTypeOfID.idCardA.rawValue:
            ProfileManager.shared.currentUser?.idCardA_Url = url.absoluteString
            idCardAImgUrlCloud = url.absoluteString
            
        case ImageTypeOfID.idCardB.rawValue:
            ProfileManager.shared.currentUser?.idCardB_Url = url.absoluteString
            idCardBImgUrlCloud = url.absoluteString
            
        case ImageTypeOfID.profile.rawValue:
            ProfileManager.shared.currentUser?.imageUrl = url.absoluteString
            profileImgUrlCloud = url.absoluteString
            
        default:
            print("invalide fileType input: \(fileType)")
            return
        }
        print("OK!!! saveImageCloudUrl, Uploaded to url:\(url)")
        
    }
    
    
    // MARK: - Image Saving and Loading to fileSystem
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        // Store the completion handler.
        AWSS3TransferUtility.interceptApplication(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
    }
    
    /// save image to temporary directory
    func generateImageUrlInLocalTemporaryDirectory(fileName: String, idImg: UIImage) -> URL? {
        let fileUrl = URL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        let data = UIImageJPEGRepresentation(idImg, imageCompress)
        do {
            try data?.write(to: fileUrl, options: .atomicWrite)
        }catch let err {
            print("\n\r err in generateImageUrlInLocalTemporaryDirectory() data?.write: ", err)
            return nil
        }
        return fileUrl
    }
    
    func removeImageWithUrlInLocalTemporaryDirectory(fileName: String){
        let fileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory().appending(fileName))
        do {
            try FileManager.default.removeItem(at: fileUrl as URL)
            print("OK, remove image with url local for file: \(fileName)")
        }catch let err {
            print("err in removeImageWithUrlInLocalTemporaryDirectory: ", err)
        }
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
        let filePath = documentUrl.path
        print("try to remove file from path: \(filePath), fileExistsAtPath==\(fileManager.fileExists(atPath: filePath!))")
        do {
            try fileManager.removeItem(atPath: "\(filePath!)/\(fileName)")
            print("OK remove file at path: \(filePath), fileName = \(fileName)")
        }catch let err {
            print("error : when trying to move file: \(fileName), from path = \(filePath!), get err = \(err)")
        }
    }
    
    
    func cancelButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - AlertViewController pop up
    func displayAlert(title: String, message: String, action: String) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        v.addAction(action)
        present(v, animated: true, completion: nil)
    }
    
}


