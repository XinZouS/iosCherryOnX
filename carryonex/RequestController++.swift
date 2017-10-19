//
//  RequestController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/20/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Photos

import AWSCognito
import AWSCore
import AWSS3

import ALCameraViewController


extension RequestController: UITextFieldDelegate {
    
    // dismiss keyboard with done button tapped
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isWeightValidatedIn(textField)
        textField.resignFirstResponder()
        view.endEditing(true)
        setPaymentIsEnable()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        switch textField.tag {
            
        case 1: // starting address 取货地址
            view.endEditing(true)
            startingTextFieldTapped()
            
        case 2: // destination address 收货地址
            view.endEditing(true)
            destinationTextFieldTapped()

        case 3: // volume
            volumPickerMenu?.showUpAnimation(withTitle: "包裹长，宽，高(inch)")
            view.endEditing(true)
        default:
            transparentView.isHidden = false
            textField.becomeFirstResponder()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isVolumValidatedIn(textField)
        isWeightValidatedIn(textField)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        isVolumValidatedIn(textField)
        isWeightValidatedIn(textField)
        textField.resignFirstResponder()
        setPaymentIsEnable()
    }
    
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        cell00Youxiang?.textField.resignFirstResponder()
        cell01Departure?.textField.resignFirstResponder()
        cell02Destination?.textField.resignFirstResponder()
        cell03Volum?.textField.resignFirstResponder()
        cell04Weight?.textField.resignFirstResponder()
        //cell05SendingTime?.textField.resignFirstResponder()
        //cell06ExpectDelivery?.textField.resignFirstResponder()
        cell07Cost?.textField.resignFirstResponder()
    }
    private func isWeightValidatedIn(_ textField: UITextField) {
        if textField.tag == 4 {
            is04WeightSet = (textField.text != nil && textField.text != "" && textField.text != "0")
        }
    }
    private func isVolumValidatedIn(_ textField: UITextField) {
        if textField.tag == 3 {
            is03VolumSet = (textField.text != nil && textField.text != "")
        }
    }


    func volumeMenuOKButtonTapped(){
        print("volumeMenuOKButtonTapped")
        is03VolumSet = true
        volumPickerMenu?.dismissAnimation()
    }
    
    func expectDeliveryTimeMenuOKButtonTapped(){
        print("expectDeliveryTimeMenuOKButtonTapped")
        is06ExpectDeliverySet = true
        expectDeliveryTimePickerMenu?.dismissAnimation()
    }
    
    func pickersCancelButtonTapped(){
        print("pickersCancelButtonTapped")
        volumPickerMenu?.dismissAnimation()
        isVolumValidatedIn((cell03Volum?.textField)!)
        isWeightValidatedIn((cell04Weight?.textField)!)
        expectDeliveryTimePickerMenu?.dismissAnimation()
    }
    
    func getTripInfoBy(youxiangCode: String){
        print("TODO: connect to database, get Trip object by the youxiangCode. Also fillout all info needed!!!!!")
        
        
    }

    private func startingTextFieldTapped(){
        let addressSearchCtl = AddressSearchController()
        addressSearchCtl.searchType = AddressSearchType.requestStarting
        addressSearchCtl.requestCtl = self
        navigationController?.pushViewController(addressSearchCtl, animated: true)
    }
    func setupStartingAddress(string: String){
        is01DepartureSet = true
        cell01Departure?.textField.text = string
    }
    
    private func destinationTextFieldTapped(){
        // detail address collectionView:
//        let addressCtl = AddressController() // for detail address to fill up
//        self.request.destinationAddress = addressCtl.address
//        navigationController?.pushViewController(addressCtl, animated: true)
        // addressSearch by map:
        let addressSearchCtl = AddressSearchController()
        addressSearchCtl.searchType = AddressSearchType.requestDestination
        addressSearchCtl.requestCtl = self
        navigationController?.pushViewController(addressSearchCtl, animated: true)
    }
    func setupDestinationAddress(string: String){
        is02DestinationSet = true
        cell02Destination?.textField.text = string
    }


    func sendingTimeButtonTapped(){
        if cell00Youxiang?.textField.text == "666" { // get trip info by this youxiangCode
            let timeAvailableController = TimeAvailableController()
            timeAvailableController.request = self.request
            navigationController?.pushViewController(timeAvailableController, animated: true)
        }else{
            let sendingTimeCtl = SendingTimeController()
            sendingTimeCtl.requestController = self
            navigationController?.pushViewController(sendingTimeCtl, animated: true)
        }
    }
    
    func expectDeliveryTimeButtonTapped(){
//        pickerViewAnimateToShow(pickerTag: 6)
        expectDeliveryTimePickerMenu?.showUpAnimation(withTitle: "期望送达时间")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard touches.first != nil else { return }
        
        textFieldsInAllCellResignFirstResponder()
        
        setPaymentIsEnable()
    }

    private func setPaymentIsEnable(){
        print("check payment is enable: \(paymentButton.isEnabled)")
        let isOk = is01DepartureSet && is02DestinationSet && is03VolumSet && is04WeightSet //&& is05SendingTimeSet && is06ExpectDeliverySet
        //paymentButton.isEnabled = isOk
        paymentButton.backgroundColor = isOk ? buttonThemeColor : UIColor.lightGray
    }
    
    private func setupRequestInfo(){
        request.youxiangId = cell00Youxiang?.textField.text ?? ""
        //request.destinationAddress = 在AddressController里设置好后回传引用
        request.weight = Double(cell04Weight?.textField.text ?? "0") ?? 0.0
        
        print(request.printAll())
    }

    /// OK button at bottom of page
    func paymentButtonTapped(){
        print("TODO: upload images to aws, and get urls")
        uploadImagesToAwsAndGetUrls()
        print("TODO: upload Request() to server")

        let t = "‼️您还没填完信息"
        let ok = "朕知道了"
        if is01DepartureSet == false {
            displayAlert(title: t, message: "请从地图上选择您的【发件地址】，我们将为您找到帮您送件的客户。", action: ok)
            return
        }
        if is02DestinationSet == false {
            displayAlert(title: t, message: "请从地图上选择您的快件寄送【收货地址】，我们将为您找到帮您送件的客户。", action: ok)
            return
        }
        if is03VolumSet == false {
            displayAlert(title: t, message: "请选择您的包裹尺寸【货物总体积】，\n以英寸(inch)为单位。\r(1 inch = 2.54 cm)", action: ok)
            return
        }
        if is04WeightSet == false {
            displayAlert(title: t, message: "请填写【货物总重量】，\n以磅(lb)为单位。\n(1 kg = 2.2 lb) \n(1 市斤[500g] = 1.1 lb)", action: ok)
            return
        }
        setupRequestInfo()
        let paymentController = PaymentController()
        paymentController.request = self.request
        paymentController.requestCtl = self
//        request.youxiangId = cell00Youxiang?.textField.text
//        request.departureAddress = (cell01Departure?.textField.text as! Address)
//        request.destinationAddress = (cell02Destination?.textField.text as! Address)
//        request.weight = (cell04Weight?.textField.text as! Float)
        navigationController?.pushViewController(paymentController, animated: true)
    }
    
}


/**
 * for image operation in local and uploading to aws
 */
extension RequestController {
    
    func openALCameraController(){
        let corpingParms = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 200, height: 200))
        let cameraViewController = CameraViewController(croppingParameters: corpingParms, allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: true, completion: { (getImg, phAsset) in
            if let img = getImg {
                //let timeStamp = Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate
                let formatter = DateFormatter()
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = "yyyy_MM_dd_hhmmss"
                let imgName = "\(formatter.string(from: Date())).JPG"
                self.presentImageIntoCellCollectionView(img, imageName: imgName)
            }
            self.dismiss(animated: true, completion: nil)
        })
        self.present(cameraViewController, animated: true, completion: nil)
    }
    private func presentImageIntoCellCollectionView(_ image: UIImage, imageName: String){
        let localFileUrl = self.saveImageToDocumentDirectory(img: image, name: imageName)
        self.imageUploadSequence[imageName] = localFileUrl
        self.imageUploadingSet.insert(imageName)
        self.cell08Image?.images.append(ImageNamePair(name: imageName, image: image))
    }
    
    internal func uploadImagesToAwsAndGetUrls(){
        for pair in imageUploadSequence {
            let imageName = pair.key as! String
            prepareUploadFile(fileName: imageName)
        }
    }

    private func prepareUploadFile(fileName: String) {
        print("prepareUploadFile: \(fileName)")
        
        // Configure aws cognito credentials:
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2, identityPoolId: awsIdentityPoolId)
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // setup AWS Transfer Manager Request:
        let uploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest?.acl = .private
        uploadRequest?.key = fileName // MUST NOT change this!!
        uploadRequest?.body = imageUploadSequence[fileName]! //generateImageUrlInLocalTemporaryDirectory(fileName: fileName, idImg: imageToUpload)
        uploadRequest?.bucket = "\(awsBucketName)/RequestPhotos/\(ProfileManager.shared.currentUser?.id!)" // no / at the end of bucket
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
                self.displayAlert(title: "⛔️上传失败", message: "上传出现错误， 请稍后重试。", action: "换个姿势再来一次")
            }
            
            return nil
        }
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    private func saveImageCloudUrl(url : URL){
        let fileName: String = url.lastPathComponent
        request.imageUrls.append(url.absoluteString)
        print("OK!!! saveImageCloudUrl, Uploaded to url: \(url)")
    }
    
    func removeAllImageFromLocal(){
        for itemName in imageUploadingSet {
            removeImageWithUrlInLocalFileDirectory(fileName: itemName)
            imageUploadSequence.removeValue(forKey: itemName)
        }
        if imageUploadSequence.count == 0 {
            imageUploadingSet.removeAll()
        }
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
    
    func saveImageToDocumentDirectory(img : UIImage, name: String) -> URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = name //"\(name).JPG"
        let profileImgLocalUrl = documentUrl.appendingPathComponent(fileName)
        if let imgData = UIImageJPEGRepresentation(img, imageCompress) {
            try? imgData.write(to: profileImgLocalUrl, options: .atomic)
        }
        print("save image to DocumentDirectory: \(profileImgLocalUrl)")
        return profileImgLocalUrl
    }


}


extension RequestController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func setupVolumLenWidthHighValues(){
        for l in 1...maxLen {
            volumLen.append(l)
            request.length = volumLen[0]
        }
        for w in 1...maxWidth {
            volumWidth.append(w)
            request.width = volumWidth[0]
        }
        for h in 1...maxHigh {
            volumHigh.append(h)
            request.height = volumHigh[0]
        }
    }
    

    // MARK: pickerView delegate
    
    func openVolumePicker(){
        volumePicker.isHidden = !volumePicker.isHidden
        // will hide when begin to set phoneNum
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 3:
            return 3 // volume: l,w,h
        case 6:
            return 1 // exptDate
        default:
            return 0
        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView.tag == 3 { // volumePicker
            switch component {
            case 0:
                return volumLen.count
            case 1:
                return volumWidth.count
            case 2:
                return volumHigh.count
            default:
                return 0
            }
        }else
        if pickerView.tag == 6 { // expectDeliveryTimePicker
            return expectDeliveryTimes.count
        }
        return 0
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 3 {
            switch component {
            case 0:
                return row < volumLen.count ? "\(volumLen[row])" : "overflow" //"长"
            case 1:
                return row < volumWidth.count ? "\(volumWidth[row])" : "overflow" //"宽"
            case 2:
                return row < volumHigh.count ?"\(volumHigh[row])" : "overflow" //"高"
            default:
                return "尺寸???"
            }
        }else
        if pickerView.tag == 6, row < expectDeliveryTimes.count {
            return "\(expectDeliveryTimes[row])"  //"选择期望送达日期"
        }
        return "unknow pickerView"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 3 {
            switch component {
            case 0:
                request?.length = volumLen[row]
            case 1:
                request?.width  = volumWidth[row]
            case 2:
                request?.height  = volumHigh[row]
            default:
                print("--- Warning: selecing unknow data for item volum... in RequestController++.swift: 100")
                return
            }
            if let l = request?.length, let w = request?.width, let h = request?.height {
                let volum = l * w * h
                print("handle volum after user setup l,w,h !!!")
                request.length = l
                request.width = w
                request.height = h
                cell03Volum?.textField.text = "长:\(l) x 宽:\(w) x 高:\(h) = \(volum)"
            }
        }else
        if pickerView.tag == 6 {
            // remove the button placeholder
            let attributes: [String:Any] = [ NSForegroundColorAttributeName: UIColor.white ]
            let attTitleStr = NSAttributedString(string: " ", attributes: attributes)
            expectDeliveryTimeButton.setAttributedTitle(attTitleStr, for: .normal)
            
            // expectDeliveryTimes = ["三天内送达", "一周内送达", "二周内送达"]
            var expDateStr = "三天内送达"
            var delta : TimeInterval = 0
            let day : TimeInterval = 3600 * 24
            switch row {
            case 0: //"三天内送达"
                expDateStr = "三天内送达"
                delta = 3 * day
            case 1: //"一周内送达"
                expDateStr = "一周内送达"
                delta = 7 * day
            case 2: //"二周内送达"
                expDateStr = "二周内送达"
                delta = 14 * day
            default:
                delta = 0
            }
            //request.expectDeliveryTime = Date(timeIntervalSinceNow: delta).timeIntervalSince1970
            //let dateString = request.expectDeliveryTime!.description
            //cell06ExpectDelivery?.textField.text = expDateStr
            //print("set the request.expectDeliveryTime = \(dateString), timeNow=\(Date())")
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        label.textColor = .black
        label.textAlignment = .center
        
        
        if pickerView.tag == 3 {
            label.font = UIFont.systemFont(ofSize: 18)
            switch component {
            case 0:
                label.text = row < volumLen.count ? "\(volumLen[row])" : "overflow" //"长"
            case 1:
                label.text = row < volumWidth.count ? "\(volumWidth[row])" : "overflow" //"宽"
            case 2:
                label.text = row < volumHigh.count ?"\(volumHigh[row])" : "overflow" //"高"
            default:
                return label
            }
            return label
        }else
        if pickerView.tag == 6, row < expectDeliveryTimes.count {
            label.font = UIFont.systemFont(ofSize: 16)
            label.text = expectDeliveryTimes[row]
            
        }
        
        return label
    }

}


// MARK: - Pop alert view
extension RequestController {
    
    internal func displayAlert(title: String, message: String, action: String) {
        DispatchQueue.main.async {
            let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: action, style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            v.addAction(action)
            self.present(v, animated: true, completion: nil)
        }
    }
    
}



