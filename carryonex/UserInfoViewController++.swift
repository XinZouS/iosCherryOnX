//
//  UserInfoViewController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Photos

import AWSCognito
import AWSCore
import AWSS3



extension UserInfoViewController {
    
    
    func dismissSelfToLeft(){
//        navigationController?.popToRootViewController(animated: true)
//        return
        
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)

    }
    
    func logoutButtonTapped(){
        User.shared.clearCurrentData()
        User.shared.removeFromLocalDisk() // remove local user for new user to login
        userProfileView.removeProfileImageFromLocalFile()

        let phoneNumNavCtl = UINavigationController(rootViewController: PhoneNumberController())
        present(phoneNumNavCtl, animated: true) {
            print("finish present phoneNumNavCtl.")
        }
        self.navigationController?.popToRootViewController(animated: false)
        print("logout user!!!!!!")
    }

    
    /// - MARK: selection on menu cell
    //FYI: private let contents: [String] = ["订单记录","我的钱包","邀请好友","计费标准","需要帮助"]

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            print("open OrdersLogController")
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            let ordersLogCtl = OrdersLogController(collectionViewLayout: layout)
            self.navigationController?.pushViewController(ordersLogCtl, animated: true)
            
        case 1:
            print("open MyWalletController")
            let walletCtl = WalletController()
            self.navigationController?.pushViewController(walletCtl, animated: true)
            
        case 2:
            print("open InviteFriendsController")
            let inviteFriendCtl = InviteFriendController()
            self.navigationController?.pushViewController(inviteFriendCtl, animated: true)
            
        case 3:
            print("open CostRules")
            
        case 4:
            print("open NeedHelp")
            
        default:
            print("Error!!! undefined item selected at row: \(indexPath.item)")
        }
    }
    

    
}


extension UserInfoViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func profileImageButtonTapped(){
        let attachmentMenu = UIAlertController(title: "选择图片来源", message: "从相册选择头像或现在拍一张吧", preferredStyle: .actionSheet)
        let openLibrary = UIAlertAction(title: "相册选择", style: .default) { (action) in
            self.openImagePickerWith(source: .photoLibrary, isAllowEditing: true)
        }
        let openCamera = UIAlertAction(title: "打开相机", style: .default) { (action) in
            self.openImagePickerWith(source: .camera, isAllowEditing: true)
        }
        let cancelSelect = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        attachmentMenu.addAction(openLibrary)
        attachmentMenu.addAction(openCamera)
        attachmentMenu.addAction(cancelSelect)
        
        present(attachmentMenu, animated: true, completion: nil)
    }
    
    internal func openImagePickerWith(source: UIImagePickerControllerSourceType, isAllowEditing: Bool){
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
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            //activityIndicator.startAnimating()
            userProfileView.setupProfileImage(editedImage)
            if let localUrl = info[UIImagePickerControllerReferenceURL] as? URL {
                uploadProfileImageToAws(assetUrl: localUrl, image: editedImage)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - AWS S3 storage for profile image
    
    private func uploadProfileImageToAws(assetUrl: URL, image: UIImage){
        let assets = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
        let fileName = PHAssetResource.assetResources(for: assets.firstObject!).first!.originalFilename
        
        // Configure aws cognito credentials:
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2, identityPoolId:"us-west-2:08a19db5-a7cc-4e82-b3e1-6d0898e6f2b7")
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // setup AWS Transfer Manager Request:
        guard let uploadRequest = AWSS3TransferManagerUploadRequest() else { return }
        uploadRequest.acl = .private
        uploadRequest.key = fileName // MUST NOT change this!!
        uploadRequest.body = userProfileView.saveProfileImageToLocalFile(image: image)
        uploadRequest.bucket = "\(awsBucketName)/userIdPhotos/\(User.shared.id!)" // no / at the end of bucket
        uploadRequest.contentType = "image/jpeg"
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith { (task: AWSTask) -> Any? in
            
            if let err = task.error {
                print("performFileUpload(): task.error = \(err)")
                //self.activityIndicator.stopAnimating()
                //self.displayAlert(title: "⛔️上传失败", message: "出现错误：\(err)， 请稍后重试。", action: "换个姿势再来一次")
                return nil
            }
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                if let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!) {
                    User.shared.imageUrl = publicURL.absoluteString
                }
            }else{
                print("errrorrr!!! task.result is nil, !!!! did not upload")
            }
            
            //DispatchQueue.main.async {
                //self.activityIndicator.stopAnimating()
                //let msg = "已成功上传您的证件照片，我们将尽快审核，谢谢！若有问题我们将会短信通知您。现在继续发现旅程吧😊"
                //self.displayAlert(title: "✅上传完成", message: msg, action: "朕知道了")
            //}
            return nil
        }

        
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

