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
import BPCircleActivityIndicator

class PersonalInfoEditingViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    var user: ProfileUser?
    var activityIndicator: BPCircleActivityIndicator! // UIActivityIndicatorView!
    var wechatAuthorizationState: String = ""
    override func viewDidLoad() {
        setupUser()
        setupNavigationBar()
        setupActivityIndicator()
        addWeChatObservers()
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
    
    fileprivate func addWeChatObservers() {
        /**  微信通知  */
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.ChangeProfileImg, object: nil, queue: nil) { [weak self] notification in
            
            if let response = notification.object as? SendAuthResp {
                guard let state = response.state, state == self?.wechatAuthorizationState else {
                    self?.displayAlert(title: "Error", message: "Invalid response state, please try to relogin with WeChat.", action: "OK")
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
                imageButton.af_setImage(for: .normal, url: imageUrl, placeholderImage: #imageLiteral(resourceName: "carryonex_UserInfo"), filter: nil, progress: nil, completion: nil)
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
            let m = "请保持网络连接，稍后再试一次。"
            displayGlobalAlert(title: "⚠️获取信息失败", message: m, action: "OK", completion: {
                print("TODO: handle error when GET user failed in PersonalInfoEditingViewController;")
            })
        }
    }
    
    private func setupNavigationBar(){
        title = "编辑个人资料"
        let save = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = save
    }
    
    @objc private func saveButtonTapped(){
        if let childVC = self.childViewControllers.first as? PersonalTable {
            var genderString = ""
            let emailString = childVC.emailTextField.text
            if let gender = childVC.genderTextField.text {
            switch gender {
            case ProfileGender.male.displayString() :
                    genderString = ProfileGender.male.rawValue
            case ProfileGender.female.displayString():
                    genderString = ProfileGender.female.rawValue
            case ProfileGender.other.displayString():
                    genderString = ProfileGender.other.rawValue
                default:
                    genderString = ProfileGender.undefined.rawValue
                }
            }
            let emailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
            let matcher = MyRegex(emailPattern)
            if let maybeEmail = emailString {
                let isMatch = matcher.match(input: maybeEmail)
                if isMatch {
                    let profile :[String:Any] = ["real_name":nameTextField.text ?? "",
                                                 "email": emailString ?? "",
                                                 "gender": genderString ]
                    ProfileManager.shared.updateUserInfo(info:profile, completion: { (success) in
                        if success{
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            debugPrint("change profile error")
                        }
                    })
                }else{
                    let errMsg = "亲，请输入正确的邮箱号"
                    displayGlobalAlert(title: "保存失败", message: errMsg, action: "回去修改", completion: {
                        if let childVC = self.childViewControllers.first as? PersonalTable {
                            childVC.emailTextField.becomeFirstResponder()
                        }
                    })
                }
            } else {
                debugPrint("unwrap failure")
            }
        }
    }
    private func setupActivityIndicator(){
        activityIndicator = BPCircleActivityIndicator() // UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = view.center
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    
    @IBAction func PenTapped(_ sender: Any) {
        nameTextField.becomeFirstResponder()
    }
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        let attachmentMenu = UIAlertController(title: "选择图片来源", message: "从相册选择头像或现在拍一张吧", preferredStyle: .actionSheet)
        let openLibrary = UIAlertAction(title: "相册选择", style: .default) { (action) in
            self.openImagePickerWith(source: .photoLibrary, isAllowEditing: true)
        }
        let openCamera = UIAlertAction(title: "打开相机", style: .default) { (action) in
            self.openALCameraController()
        }
        let wechatLogin = UIAlertAction(title: "微信获得信息", style: .default) { (action) in
            self.wechatButtonTapped()
        }
        let cancelSelect = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        attachmentMenu.addAction(openLibrary)
        attachmentMenu.addAction(openCamera)
        attachmentMenu.addAction(wechatLogin)
        attachmentMenu.addAction(cancelSelect)
        
        present(attachmentMenu, animated: true, completion: nil)
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
        var getImg : UIImage = #imageLiteral(resourceName: "CarryonEx_User")
        if let editedImg = info[UIImagePickerControllerEditedImage] as? UIImage {
            getImg = editedImg
        }else if let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            getImg = originalImg
        }
        uploadImageToAws(getImg: getImg)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func openALCameraController(){
        let corpingParms = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 160, height: 160))
        let cameraViewController = CameraViewController(croppingParameters: corpingParms, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { (getImg, phAsset) in
            
            if let image = getImg {
                self.setupProfileImage(image)
                self.uploadImageToAws(getImg: image)
            }
            self.dismiss(animated: true, completion: nil)
        })
        self.present(cameraViewController, animated: true, completion: nil)
    }
}
/// MARK: - Image upload to AWS
extension PersonalInfoEditingViewController{
    func uploadImageToAws(getImg: UIImage){
        activityIndicator.isHidden = false
        activityIndicator.animate()
        UIApplication.shared.beginIgnoringInteractionEvents()
        let localUrl = self.saveImageToDocumentDirectory(img: getImg, idType: .profile)
        let n = ImageTypeOfID.profile.rawValue + ".JPG"
        AwsServerManager.shared.uploadFile(fileName: n, imgIdType: .profile, localUrl: localUrl, completion: { (err, awsUrl) in
            self.handleAwsServerImageUploadCompletion(err, awsUrl)
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleAwsServerImageUploadCompletion(_ error: Error?, _ awsUrl: URL?){
        if let err = error {
            activityIndicator.isHidden = true
            activityIndicator.stop()
            UIApplication.shared.endIgnoringInteractionEvents()
            let msg = "请检查您的网络设置或重新登陆，也可联系客服获取更多帮助，为此给您带来的不便我们深表歉意！出现错误：\(err)"
            self.displayGlobalAlert(title: "⛔️上传出错了", message: msg, action: "朕知道了", completion: nil)
        }
        if let publicUrl = awsUrl, publicUrl.absoluteString != "" {
            print("HomePageController++: uploadImage get publicUrl.absoluteStr = \(publicUrl.absoluteString)")
            ProfileManager.shared.updateUserInfo(.imageUrl, value: publicUrl.absoluteString, completion: { (success) in
                if success {
                    self.setupProfileImageFromAws()
                    self.removeImageWithUrlInLocalFileDirectory(fileName: ImageTypeOfID.profile.rawValue + ".JPG")
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stop()
                    UIApplication.shared.endIgnoringInteractionEvents()
                }
            })
        }else{
            print("errrorrr!!! uploadAllImagesToAws(): task.result is nil, !!!! did not upload")
        }
    }
    
    func saveImageToDocumentDirectory(img : UIImage, idType: ImageTypeOfID) -> URL {
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
            self.imageButton.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "CarryonEx_User"), filter: nil, progress: nil, completion: nil)
            
            if let homeController = AppDelegate.shared().mainTabViewController?.homeViewController {
                homeController.userProfileImageBtn.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "CarryonEx_User"), filter: nil, progress: nil, completion: nil)
            }
            
            if let personalController = AppDelegate.shared().mainTabViewController?.personInfoController {
                personalController.userProfileImage.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "CarryonEx_User"), filter: nil, progress: nil, completion: nil)
            }
        }
    }
    

    internal func setupProfileImage(_ img: UIImage){
        imageButton.setImage(img, for: .normal)
    }
    
    internal func setupWechatImg(){
        let imgUrl = URL(string: ProfileManager.shared.getCurrentUser()?.imageUrl ?? "")
        imageButton.af_setImage(for: .normal, url: imgUrl!, placeholderImage: #imageLiteral(resourceName: "CarryonEx_UploadProfile"), filter: nil, progress: nil, completion: nil)
    }
}

