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
        textField.resignFirstResponder()
        view.endEditing(true)
        setPaymentIsEnable()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

        switch textField.tag {
            
        case 0: // starting address 取货地址
            view.endEditing(true)
            startingTextFieldTapped()
            
        case 1: // destination address 收货地址
            view.endEditing(true)
            destinationTextFieldTapped()

        case 2: // volume
            volumPickerMenu?.showUpAnimation(withTitle: "包裹长，宽，高(inch)")
            view.endEditing(true)
        default:
            transparentView.isHidden = false
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        setPaymentIsEnable()
    }
    
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        cell01Departure?.textField.resignFirstResponder()
        cell02Destination?.textField.resignFirstResponder()
        cell03Volum?.textField.resignFirstResponder()
        cell04Weight?.textField.resignFirstResponder()
        cell07Cost?.textField.resignFirstResponder()
    }
    
    private func computePrice(){
        let price = 100
        request.totalValue = price
        costSumLabel.text = "\(price)"
    }
    

    func volumeMenuOKButtonTapped(){
        print("volumeMenuOKButtonTapped")
        computePrice()
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
        computePrice()
        volumPickerMenu?.dismissAnimation()
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
//        if cell00Youxiang?.textField.text == "666" { // get trip info by this youxiangCode
//            let timeAvailableController = TimeAvailableController()
//            timeAvailableController.request = self.request
//            navigationController?.pushViewController(timeAvailableController, animated: true)
//        }else{
//            let sendingTimeCtl = SendingTimeController()
//            sendingTimeCtl.requestController = self
//            navigationController?.pushViewController(sendingTimeCtl, animated: true)
//        }
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

    internal func setPaymentIsEnable(){
        print("check payment is enable: \(paymentButton.isEnabled)")
        is02DestinationSet = request.endAddress != nil
        is07takePicture = imageUploadSequence.count > 0
        let isOk = is02DestinationSet && is07takePicture//&
        paymentButton.backgroundColor = isOk ? buttonThemeColor : UIColor.lightGray
        setupRequestInfo()
    }
    
    private func setupRequestInfo(){
        computePrice()
    }

    /// OK button at bottom of page
    func paymentButtonTapped(){
        uploadImagesToAwsAndGetUrls()
        print("TODO: upload Request() to server")

        let t = "‼️您还没填完信息"
        let ok = "朕知道了"
        if is02DestinationSet == false {
            displayAlert(title: t, message: "请从地图上选择您的快件寄送【收货地址】，我们将为您找到帮您送件的客户。", action: ok)
            return
        }
        if imageUploadingSet.count == 0 {
            displayAlert(title: t, message: "请拍摄您的物品照片，便于出行人了解详情。", action: ok)
            return
        }
        setupRequestInfo()
        let paymentController = PaymentController()
        paymentController.request = self.request
        paymentController.requestCtl = self
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
        
        var urls = [String]()
        
        for pair in imageUploadSequence {
            let imageName = pair.key
            
            if let url = imageUploadSequence[imageName] {
                AwsServerManager.shared.uploadFile(fileName: imageName, imgIdType: .requestImages, localUrl: url, completion: { (err, getUrl) in
                    if let err = err {
                        print("error in uploadImagesToAwsAndGetUrls(): err = \(err.localizedDescription)")
                        return
                    }
                    if let getUrl = getUrl {
                        urls.append(getUrl.absoluteString)
                        
                        if urls.count == self.imageUploadSequence.count {
                            urls.sort {$0 < $1}
                            var imageUrlsDictionary: [Int: String] = [:] // order and urlString: {"0":"img0", "1":"img1", ...}
                            for i in 0..<urls.count {
                                imageUrlsDictionary[i] = urls[i]
                            }
                            // TODO: upload urls dictionary to our Server;
                            print("\n\n search this senten to locate in code to get dictionary - Xin")
                            print("get dictionary ready for uploading to Server = ")
                            for pair in imageUrlsDictionary {
                                print("key = \(pair.key), val = \(pair.value)")
                            }
                            
                            // then remove the images from cache
                            self.removeAllImageFromLocal()
                        }
                    }
                })

            } else {
                print("error in uploadImagesToAwsAndGetUrls(): can not get imageUploadSequence[fileName] url !!!!!!")
            }
        }
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
        
        guard let filePath = documentUrl.path else { return }
        print("try to remove file from path: \(filePath), fileExistsAtPath==\(fileManager.fileExists(atPath: filePath))")
        do {
            try fileManager.removeItem(atPath: "\(filePath)/\(fileName)")
            print("OK remove file at path: \(filePath), fileName = \(fileName)")
        }catch let err {
            print("error : when trying to move file: \(fileName), from path = \(filePath), get err = \(err)")
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
