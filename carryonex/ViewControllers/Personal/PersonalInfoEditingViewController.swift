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

class PersonalInfoEditingViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    // for tableView:
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak
    var genderTextField: UITextField!
//    @IBOutlet weak
    var emailTextField: UITextField!
    let tableCellId = "PersonalInfoTableCell"
    
    let tableRows = ["性别","邮箱"]
    let genderPickerView = UIPickerView()
    var pickerData: [String] = []
    

    var user: ProfileUser?
    var newProfile: UIImage = #imageLiteral(resourceName: "blankUserHeadImage")
    var isProfileImageChanged = false
    var activityIndicator: BPCircleActivityIndicator! // UIActivityIndicatorView!
    var wechatAuthorizationState: String = ""
    var settedGender: ProfileGender = .undefined
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addWechatObserver()
        imageButton.setImage(#imageLiteral(resourceName: "profilePlaceholderPng"), for: .normal)
        setupUser()
        //setupActivityIndicator()
        
        nameTextField.inputAccessoryView = setupTextFieldToolbar()
        nameTextField.text = user?.realName ?? ""
        setupTableViewAndPicker()
    }
    
    private func setupTableViewAndPicker(){
        pickerData = [L("personal.ui.title.gender-male"),
                      L("personal.ui.title.gender-female"),
                      L("personal.ui.title.gender-other"),
                      L("personal.ui.title.gender-unknow")
        ] // ["男", "女", "其他", "未知"]
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = colorTableCellSeparatorLightGray
    }
    
    @objc fileprivate func dismissKeyboard(){
        nameTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    fileprivate func addWechatObserver() {
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
            if let imageUrlString = currentUser.imageUrl, let imageUrl = URL(string: imageUrlString) {
                imageButton.af_setBackgroundImage(for: .normal, url: imageUrl, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, completion: nil)
            } else {
                imageButton.setBackgroundImage(newProfile, for: .normal)
            }
            
        } else {
            displayGlobalAlert(title: L("personal.error.title.network"), message: L("personal.error.message.network"), action: L("action.ok"), completion: nil)
            //TODO: handle error when GET user failed in PersonalInfoEditingViewController
        }
    }
    
    private func setupActivityIndicator(){
        activityIndicator = BPCircleActivityIndicator()
        activityIndicator.isHidden = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
    }

    @objc private func saveButtonTapped(){
        dismissKeyboard() // dismiss keyboard
        
        let emailString = emailTextField.text ?? ""
        let emailPattern = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let matcher = MyRegex(emailPattern)
        
        if emailString.isEmpty || matcher.match(input: emailString) {
            
            AppDelegate.shared().startLoading()
            
            let profile: [String:Any] = ["real_name": nameTextField.text ?? "",
                                         "email": emailString,
                                         "gender": settedGender.rawValue]
            if isProfileImageChanged {
                uploadImageToAws(getImg: newProfile)
            }
            
            ProfileManager.shared.updateUserInfo(info: profile, completion: { (success) in
                DispatchQueue.main.async {
                    AppDelegate.shared().stopLoading()
                }
                if success{
                    self.dismiss(animated: true, completion: nil)
                } else {
                    DLog("error: ProfileManager.shared.updateUserInfo unsuccess...")
                }
            })
        } else { // email invalide:
            displayGlobalAlert(title: L("personal.error.message.network"),
                               message: L("personal.error.message.upload-email"),
                               action: L("action.ok"),
                               completion: { [weak self] _ in
                self?.emailTextField.becomeFirstResponder()
            })
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
            //self.openImagePickerWith(source: .photoLibrary, isAllowEditing: true)
            self.openALImageController()
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



extension PersonalInfoEditingViewController: UIPickerViewDataSource {
    
    fileprivate func setupTextFieldToolbar() -> UIToolbar {
        let toolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        toolbar.barStyle = UIBarStyle.default
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: L("action.done"), style: UIBarButtonItemStyle.done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [flexSpace,done]
        toolbar.sizeToFit()
        
        return toolbar
    }
    
}

extension PersonalInfoEditingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as! PersonalInfoTableCell
        cell.titleLb.text = tableRows[indexPath.row]
        cell.selectionStyle = .none

        switch indexPath.row {
        case 0: // gender
            genderTextField = cell.textField
            let traits = genderTextField.value(forKey: "textInputTraits") as AnyObject
            traits.setValue(UIColor.clear, forKey: "insertionPointColor")
            genderTextField.inputView = genderPickerView
            genderTextField.inputAccessoryView = setupTextFieldToolbar()
            
            if let genderString = user?.gender {
                switch genderString {
                case ProfileGender.male.rawValue:
                    genderTextField.text = ProfileGender.male.displayString()
                    settedGender = .male
                case ProfileGender.female.rawValue:
                    genderTextField.text = ProfileGender.female.displayString()
                    settedGender = .female
                case ProfileGender.other.rawValue:
                    genderTextField.text = ProfileGender.other.displayString()
                    settedGender = .other
                default:
                    genderTextField.text = ProfileGender.undefined.displayString()
                    settedGender = .undefined
                }
            }
            
        case 1: // email
            emailTextField = cell.textField
            emailTextField.placeholder = "E-mail"
            cell.textField.inputAccessoryView = setupTextFieldToolbar()
            emailTextField.text = user?.email ?? ""
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            genderTextField.becomeFirstResponder()
            
        case 1:
            emailTextField.becomeFirstResponder()
            
        default:
            break
        }
    }
    
}

extension PersonalInfoEditingViewController: UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = pickerData[genderPickerView.selectedRow(inComponent: 0)]
        
        switch row {
        case 0:
            settedGender = .male
        case 1:
            settedGender = .female
        case 2:
            settedGender = .other
        case 3:
            settedGender = .undefined
        default:
            settedGender = .undefined
        }
        
    }
    
    @IBAction func commitButtonTapped(_ sender: Any) {
        let idCV = PhotoIDController()
        self.navigationController?.pushViewController(idCV, animated: true)
        self.navigationController?.navigationBar.shadowImage = colorTableCellSeparatorLightGray.as1ptImage()
    }
    
}



/// MARK: - ALCameraView or ImagePicker setup

extension PersonalInfoEditingViewController {
    
    func openImagePickerWith(source: UIImagePickerControllerSourceType, isAllowEditing: Bool) {
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
        if let editedImg = info[UIImagePickerControllerEditedImage] as? UIImage {
            newProfile = editedImg
        }else if let originalImg = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newProfile = originalImg
        }
        setupProfileImage(newProfile)
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        AnalyticsManager.shared.clearTimeTrackingKey(.profileImageSettingTime)
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func openALImageController() {
        let corpingParms = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 300, height: 300))
        let imgPickerVC = CameraViewController.imagePickerViewController(croppingParameters: corpingParms) { (getImg, phAsset) in
            
            if let image = getImg {
                self.setupProfileImage(image)
                
            } else { // unable to set image, then reset timer;
                AnalyticsManager.shared.clearTimeTrackingKey(.profileImageSettingTime)
            }
            self.dismiss(animated: true, completion: nil)
        }
        self.present(imgPickerVC, animated: true, completion: nil)
    }
    
    fileprivate func openALCameraController(){
        let corpingParms = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 160, height: 160))
        let cameraViewController = CameraViewController(croppingParameters: corpingParms, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { (getImg, phAsset) in
            
            if let image = getImg {
                self.setupProfileImage(image)
                
            } else { // unable to set image, then reset timer;
                AnalyticsManager.shared.clearTimeTrackingKey(.profileImageSettingTime)
            }
            self.dismiss(animated: true, completion: nil)
        })
        self.present(cameraViewController, animated: true, completion: nil)
    }
}

// MARK: - Image upload to AWS

extension PersonalInfoEditingViewController {
    
    func uploadImageToAws(getImg: UIImage) {
        let localUrl = self.saveImageToDocumentDirectory(img: getImg, idType: .profile)
        let n = ImageTypeOfID.profile.rawValue + ".JPG"
        
        AwsServerManager.shared.uploadFile(fileName: n, imgIdType: .profile, localUrl: localUrl, completion: { (error, awsUrl) in
            if let error = error {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stop()
                self.displayGlobalAlert(title: L("personal.error.title.upload-ids"),
                                        message: L("personal.error.message.upload-ids") + error.localizedDescription,
                                        action: L("action.ok"),
                                        completion: nil)
                DLog("Upload image failed: \(error.localizedDescription)")
                return
            }
            
            if let publicUrl = awsUrl, !publicUrl.absoluteString.isEmpty {
                let urlRequest = URLRequest(url: publicUrl)
                if let imageCache = UIImageView.af_sharedImageDownloader.imageCache {
                    _ = imageCache.removeImage(for: urlRequest, withIdentifier: nil)
                    imageCache.removeAllImages()
                }
                self.setupProfileImageUrl(publicUrl)
                
                ProfileManager.shared.updateUserInfo(.imageUrl, value: publicUrl.absoluteString, completion: { (success) in
                    if success {
                        self.removeImageWithUrlInLocalFileDirectory(fileName: ImageTypeOfID.profile.rawValue + ".JPG")
                    } else {
                        DLog("error: updateUserProfileUrl() unsuccess, abording....")
                    }
                })
            } else {
                DLog("Error: uploadAllImagesToAws(): publicUrl.absoluteString.isEmpty, Unable to upload.")
            }
        })
        AnalyticsManager.shared.finishTimeTrackingKey(.profileImageSettingTime)
    }
    
    func saveImageToDocumentDirectory(img : UIImage, idType: ImageTypeOfID) -> URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(idType.rawValue).JPG"
        let profileImgLocalUrl = documentUrl.appendingPathComponent(fileName)
        let uploadImg = img.getThumbnailImg(compression: imageCompress, maxPixelSize: 300) ?? img
        if let imgData = UIImageJPEGRepresentation(uploadImg, 1) {
            try? imgData.write(to: profileImgLocalUrl, options: .atomic)
        }
        DLog("save image to DocumentDirectory: \(profileImgLocalUrl)")
        return profileImgLocalUrl
    }
    
    func removeImageWithUrlInLocalFileDirectory(fileName: String){
        let fileManager = FileManager.default
        let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        if let filePath = documentUrl.path {
            DLog("try to remove file from path: \(filePath), fileExistsAtPath==\(fileManager.fileExists(atPath: filePath))")
            do {
                try fileManager.removeItem(atPath: "\(filePath)/\(fileName)")
                DLog("OK remove file at path: \(filePath), fileName = \(fileName)")
            } catch let err {
                DLog("error : when trying to move file: \(fileName), from path = \(filePath), get err = \(err)")
            }
        }
    }
}
// WECHAT lOGIN
extension PersonalInfoEditingViewController {
    
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
                if let imgUrl = jsonResult["headimgurl"] as? String {
                    ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (success) in
                        if success, let url = URL(string: imgUrl) {
                            self.setupProfileImageUrl(url)
                        }
                    })
                }
            }
        }
    }
}

// document operation
extension PersonalInfoEditingViewController {
    
    private func getDocumentUrl() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    public func removeProfileImageFromLocalFile(){
        let documentUrl = getDocumentUrl()
        let fileUrl = documentUrl.appendingPathComponent(ImageTypeOfID.profile.rawValue + ".JPG")
        do {
            try FileManager.default.removeItem(at: fileUrl)
        }catch let err {
            DLog("[ERROR]: removeProfileImageFromLocalFile() \(err.localizedDescription) | File: \(fileUrl)")
        }
    }
    
    internal func setupProfileImageUrl(_ url: URL){
        guard let homeVC = AppDelegate.shared().mainTabViewController?.homeViewController,
            let personalVC = AppDelegate.shared().mainTabViewController?.personInfoController else {
            DLog("\n[ERROR]: unable to get homeViewController or personInfoController when setupProfileImageFromAws(), abording...")
            return
        }
        imageButton.af_setBackgroundImage(for: .normal, url: url, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, completion: nil)
        homeVC.userProfileImageView.af_setImage(withURL: url)
        personalVC.userProfileImage.image = #imageLiteral(resourceName: "blankUserHeadImage")
    }
    

    internal func setupProfileImage(_ img: UIImage){
        let sqr = img.squareCrop()
        imageButton.setBackgroundImage(sqr, for: .normal)
        newProfile = sqr
        isProfileImageChanged = true
    }
}



class PersonalInfoTableCell: UITableViewCell {
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var textField: UITextField!
}
