//
//  PersonalInfoEditingViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/21/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import AlamofireImage
import AWSCognito
import AWSCore
import AWSS3
import ALCameraViewController
import Photos

class PersonalInfoEditingViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    var user: ProfileUser?
    var activityIndicator: BPCircleActivityIndicator! // UIActivityIndicatorView!
    var wechatAuthorizationState: String = ""
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator = BPCircleActivityIndicator() // UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.isHidden = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        setupUser()
        addObservers()
        setupTextField()
    }
    
    private func setupTextField(){
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        self.nameTextField.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction(){
        nameTextField.resignFirstResponder()
    }
    
    fileprivate func addObservers() {
        /**  微信通知  */
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.ChangeProfileImg, object: nil, queue: nil) { [weak self] notification in
            
            if let response = notification.object as? SendAuthResp {
                guard let state = response.state, state == self?.wechatAuthorizationState else {
                    self?.displayAlert(title: L("personal.error.title.wechat"), message: L("personal.error.message.wechat"), action: L("action.ok"))
                    return
                }
                
                guard let code = response.code else { return }
                
                let request = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(WX_APPID)&secret=\(WX_APPSecret)&code=\(code)&grant_type=authorization_code"
                self?.quickDataFromUrl(url: request, completion: { [weak self] jsonResult in
                    guard let jsonResult = jsonResult else { return }
                    if let openId = jsonResult["openid"] as? String, let acccessToken = jsonResult["access_token"] as? String {
                        self?.getUserInfo(openid: openId, access_token: acccessToken)
                    }
                })
            }
        }
    }
    
    func quickDataFromUrl(url: String, completion: @escaping(([String : Any]?) -> Void)) {
        guard let requestURL: URL = URL.init(string: url) else {
            completion(nil)
            return
        }
        let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
        let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any]
        completion(jsonResult)
    }
    
    private func setupUser(){
        if let currentUser = ProfileManager.shared.getCurrentUser() {
            user = currentUser
            if let imageUrlString =  currentUser.imageUrl, let imageUrl = URL(string: imageUrlString) {
                imageButton.af_setImage(for: .normal, url: imageUrl, placeholderImage:#imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, completion: nil)
            }
            
            nameTextField.text = currentUser.realName
            if let childVC = self.childViewControllers.first as? PersonalTable {
                childVC.emailTextField.text = currentUser.email
                if let genderString = currentUser.gender {
                    switch genderString{
                    case ProfileGender.male.rawValue:
                        childVC.genderTextField.text = ProfileGender.male.displayString()
                    case ProfileGender.female.rawValue:
                        childVC.genderTextField.text = ProfileGender.female.displayString()
                    case ProfileGender.other.rawValue:
                        childVC.genderTextField.text = ProfileGender.other.displayString()
                    default:
                        childVC.genderTextField.text = ProfileGender.undefined.displayString()
                    }
                }
            }
        } else {
            displayGlobalAlert(title: L("personal.error.title.network"), message: L("personal.error.message.network"), action: L("action.ok"), completion: nil)
            //TODO: handle error when GET user failed in PersonalInfoEditingViewController
        }
    }
    
    @objc private func saveButtonTapped(){
        if let childVC = self.childViewControllers.first as? PersonalTable {
            let genderString = childVC.genderTextField.text ?? ProfileGender.undefined.rawValue
            let emailString = childVC.emailTextField.text
            let emailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            let matcher = MyRegex(emailPattern)
            if let maybeEmail = emailString, matcher.match(input: maybeEmail) {
                let profile :[String:Any] = ["real_name":nameTextField.text ?? "",
                                             "email": emailString ?? "",
                                             "gender": genderString ]
                activityIndicator.isHidden = false
                activityIndicator.animate()
                ProfileManager.shared.updateUserInfo(info:profile, completion: { (success) in
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stop()
                    if success{
                        //self.navigationController?.popViewController(animated: true)
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        debugPrint("change profile error")
                    }
                })
            } else {
                displayGlobalAlert(title: L("personal.error.message.network"),
                                   message: L("personal.error.message.upload-email"),
                                   action: L("action.ok"),
                                   completion: { [weak self] _ in
                                    if let childVC = self?.childViewControllers.first as? PersonalTable {
                                        childVC.emailTextField.becomeFirstResponder()
                                    }
                })
            }
        }
    }
    
    @IBAction func PenTapped(_ sender: Any) {
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        let attachmentMenu = UIAlertController(title: L("personal.confirm.title.select-image"),
                                               message: L("personal.confirm.message.select-image"),
                                               preferredStyle: .actionSheet)
        
        let openLibrary = UIAlertAction(title: L("personal.confirm.action.galary"), style: .default) { (action) in
            self.openImagePickerWith(source: .photoLibrary, isAllowEditing: true)
        }
        
        let openCamera = UIAlertAction(title: L("personal.confirm.action.camera"), style: .default) { (action) in
            self.openALCameraController()
        }
        
        let wechatLogin = UIAlertAction(title: L("personal.confirm.action.wechat"), style: .default) { (action) in
            self.wechatButtonTapped()
        }
        
        let cancelSelect = UIAlertAction(title: L("action.cancel"), style: .cancel, handler: nil)
        
        attachmentMenu.addAction(openLibrary)
        attachmentMenu.addAction(openCamera)
        attachmentMenu.addAction(wechatLogin)
        attachmentMenu.addAction(cancelSelect)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            attachmentMenu.popoverPresentationController?.sourceView = self.nameTextField
        }
        
        present(attachmentMenu, animated: true, completion: nil)
        AnalyticsManager.shared.startTimeTrackingKey(.profileImageSettingTime)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        saveButtonTapped()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
/// MARK: - ALCameraView or ImagePicker setup
extension PersonalInfoEditingViewController{
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
        var getImg : UIImage = #imageLiteral(resourceName: "blankUserHeadImage")
        if let editedImg = info[UIImagePickerControllerEditedImage] as? UIImage {
            getImg = editedImg
        }else if let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            getImg = originalImg
        }
        uploadImageToAws(getImg: getImg)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        AnalyticsManager.shared.clearTimeTrackingKey(.profileImageSettingTime)
        dismiss(animated: true, completion: nil)
    }
    
    func openALCameraController(){
        let corpingParms = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 160, height: 160))
        let cameraViewController = CameraViewController(croppingParameters: corpingParms, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { (getImg, phAsset) in
            
            if let image = getImg {
                self.setupProfileImage(image)
                self.uploadImageToAws(getImg: image)
                
            } else { // unable to set image, then reset timer;
                AnalyticsManager.shared.clearTimeTrackingKey(.profileImageSettingTime)
            }
            self.dismiss(animated: true, completion: nil)
        })
        self.present(cameraViewController, animated: true, completion: nil)
    }
}

// MARK: - Image upload to AWS

extension PersonalInfoEditingViewController{
    
    func uploadImageToAws(getImg: UIImage){
        activityIndicator.isHidden = false
        activityIndicator.animate()
        UIApplication.shared.beginIgnoringInteractionEvents()
        let localUrl = self.saveImageToDocumentDirectory(img: getImg, idType: .profile)
        let n = ImageTypeOfID.profile.rawValue + ".JPG"
        AwsServerManager.shared.uploadFile(fileName: n, imgIdType: .profile, localUrl: localUrl, completion: { (err, awsUrl) in
            self.setupProfileImage(getImg)
            self.handleAwsServerImageUploadCompletion(err, awsUrl)
        })
        AnalyticsManager.shared.finishTimeTrackingKey(.profileImageSettingTime)
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleAwsServerImageUploadCompletion(_ error: Error?, _ awsUrl: URL?){
        activityIndicator.isHidden = true
        activityIndicator.stop()
        UIApplication.shared.endIgnoringInteractionEvents()

        if let error = error {
            self.displayGlobalAlert(title: L("personal.error.title.upload-ids"),
                                    message: L("personal.error.message.upload-ids"),
                                    action: L("action.ok"),
                                    completion: nil)
            debugPrint("Upload image failed: \(error.localizedDescription)")
            return
        }
        
        if let publicUrl = awsUrl, publicUrl.absoluteString != "" {
            ProfileManager.shared.updateUserInfo(.imageUrl, value: publicUrl.absoluteString, completion: { (success) in
                if success {
                    self.setupProfileImageFromAws()
                    self.removeImageWithUrlInLocalFileDirectory(fileName: ImageTypeOfID.profile.rawValue + ".JPG")
                }
            })
        }else{
            debugPrint("Error: uploadAllImagesToAws(): task.result is nil. Unable to upload.")
        }
    }
    
    func saveImageToDocumentDirectory(img : UIImage, idType: ImageTypeOfID) -> URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(idType.rawValue).JPG" // UserDefaultKey.profileImageLocalName.rawValue
        let profileImgLocalUrl = documentUrl.appendingPathComponent(fileName)
        let uploadImg = img.getThumbnailImg(compression: imageCompress, maxPixelSize: 200) ?? img
        if let imgData = UIImageJPEGRepresentation(uploadImg, 1) {
            try? imgData.write(to: profileImgLocalUrl, options: .atomic)
        }
        debugPrint("save image to DocumentDirectory: \(profileImgLocalUrl)")
        return profileImgLocalUrl
    }
    
    func removeImageWithUrlInLocalFileDirectory(fileName: String){
        let fileManager = FileManager.default
        let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        if let filePath = documentUrl.path {
            debugPrint("try to remove file from path: \(filePath), fileExistsAtPath==\(fileManager.fileExists(atPath: filePath))")
            do {
                try fileManager.removeItem(atPath: "\(filePath)/\(fileName)")
                debugPrint("OK remove file at path: \(filePath), fileName = \(fileName)")
            } catch let err {
                debugPrint("error : when trying to move file: \(fileName), from path = \(filePath), get err = \(err)")
            }
        }
    }
}
// WECHAT lOGIN
extension PersonalInfoEditingViewController{
    
    func wechatButtonTapped(){
        wxloginStatus = "fillProfile"
        let urlStr = "weixin://"
        if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
            let req = SendAuthReq.init()
            req.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
            
            wechatAuthorizationState = "\((Int(arc4random()) + Date.getTimestampNow()) % 1000)"
            req.state = wechatAuthorizationState
            
            WXApi.send(req)
            
        } else {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
            }
        }
    }
    
    /**  获取用户信息  */
    func getUserInfo(openid:String,access_token:String) {
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openid)"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                print(jsonResult)
                if let imgUrl = jsonResult["headimgurl"] as? String {
                    ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (success) in
                        if success {
                            self.setupWechatImg()
                        }
                    })
                }
            }
        }
    }
}
// document operation
extension PersonalInfoEditingViewController{
    private func getDocumentUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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
        if let imageUrlString = ProfileManager.shared.getCurrentUser()?.imageUrl,let imgUrl = URL(string:imageUrlString){
            let urlRequst = URLRequest.init(url: imgUrl)
            _ = UIImageView.af_sharedImageDownloader.imageCache?.removeImage(for: urlRequst, withIdentifier: nil)
            self.imageButton.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, completion: nil)
            
            if let homeController = AppDelegate.shared().mainTabViewController?.homeViewController {
                homeController.userProfileImageBtn.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, completion: nil)
            }
            
            if let personalController = AppDelegate.shared().mainTabViewController?.personInfoController {
                personalController.userProfileImage.af_setImage(withURL: imgUrl)
            }
        } else {
            if let personalController = AppDelegate.shared().mainTabViewController?.personInfoController {
                personalController.userProfileImage.image = #imageLiteral(resourceName: "blankUserHeadImage")
            }
        }
    }
    

    internal func setupProfileImage(_ img: UIImage){
        imageButton.setImage(img, for: .normal)
    }
    
    internal func setupWechatImg(){
        let imgUrl = URL(string: ProfileManager.shared.getCurrentUser()?.imageUrl ?? "")
        imageButton.af_setImage(for: .normal, url: imgUrl!, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, completion: nil)
    }
}

