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
    var activityIndicator: UIActivityIndicatorCustomizeView! // UIActivityIndicatorView!
    var wechatAuthorizationState: String = ""
    override func viewDidLoad() {
        setupUser()
        setupNavigationBar()
        setupActivityIndicator()
        addWeChatObservers()
    }
    
    fileprivate func addWeChatObservers() {
        /**  微信通知  */
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.changeHeadImg, object: nil, queue: nil) { [weak self] notification in
            
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
        if let getUser = ProfileManager.shared.getCurrentUser() {
            user = getUser
            imageButton.af_setImage(for: .normal, url: URL(string: (user?.imageUrl)!)!, placeholderImage: #imageLiteral(resourceName: "carryonex_UserInfo"), filter: nil, progress: nil, completion: nil)
            nameTextField.text = user?.realName
            if let childVC = self.childViewControllers.first as? PersonalTable {
                childVC.emailTextField.text = user?.email
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
        //if let childVC = self.childViewControllers.first as? PersonalTable {
//            let genderString = childVC.genderTextField.text
//            let emailString = childVC.emailTextField.text
        //}
    }
    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorCustomizeView() // UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
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
        activityIndicator.startAnimating()
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
            activityIndicator.stopAnimating()
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
                    self.activityIndicator.stopAnimating()
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

