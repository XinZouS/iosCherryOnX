//
//  RequestController.swift
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
import BPCircleActivityIndicator

class RequestController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .clear
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    
    var activityIndicator: BPCircleActivityIndicator! // UIActivityIndicatorView!

    let labelW: CGFloat = 90
    
    var trip: Trip?
    var endAddress: Address?
    
    var imageUploadingSet: Set<String> = []
    var imageUploadSequence: [String : URL] = [:]

    let labelNames = [ "收货地址:", "货物价值", "货物清晰照:", "运货费用:"]
    let placeholders = ["请选择货物送达位置", "输入货物价格"]

    let basicCellId = "basicCellId"
    let imageCellId = "imageCellId"
    
    var cell02Destination: RequestBaseCell?
    var cell08Image: ImageCell?
    var cell07Cost: RequestBaseCell?
    var cellTotalValue: RequestBaseCell?
    
    /// for paymentButton.isEnable condictions
    var is02DestinationSet = false, is07takePicture = false
    
    let costCurrencyMarker: UILabel = {
        let l = UILabel()
        l.textColor = textThemeColor
        l.font = UIFont.boldSystemFont(ofSize: 24)
        l.textAlignment = .right
        l.text = "元"
        return l
    }()
    
    
    //MARK: - Methods Start Here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setUpTransparentView()
        setupNavigationBar()
        setupCollectionView()
        setupActivityIndicator()
    }
    
    private func setupCollectionView(){
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = false
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(RequestBaseCell.self, forCellWithReuseIdentifier: basicCellId)
        collectionView?.register(ImageCell.self, forCellWithReuseIdentifier: imageCellId)
        
        let w : CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? 10 : 36
        collectionView?.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: w, topConstent: 0, rightConstent: w, bottomConstent: 40, width: 0, height: 0)
        
    }
    
    private func setUpTransparentView(){
        view.addSubview(transparentView)
        transparentView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupNavigationBar(){
        title = "发货请求"
        //let rightItemButton = UIBarButtonItem(title: "支付方式", style: .plain, target: self, action: #selector(paymentButtonTapped))
        let rightItemButton = UIBarButtonItem(title: "提交", style: .done, target: self, action: #selector(handleSubmissionButton))
        navigationItem.rightBarButtonItem = rightItemButton
    }
    
    private func subtitleCellLabel(_ str: String) -> UILabel {
        let l = UILabel()
        l.text = str
        l.textAlignment = .center
        l.font = UIFont.systemFont(ofSize: 18)
        return l
    }
    
    private func setupActivityIndicator(){
        activityIndicator = BPCircleActivityIndicator() // UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x:view.center.x-15,y:view.center.y-64,width:0,height:0)
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    
}

extension RequestController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return labelNames.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellId : String = basicCellId
        switch indexPath.item {
        case 2 :
            cellId = imageCellId
        default:
            cellId = basicCellId
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RequestBaseCell
        cell.requestController = self
        cell.textField.delegate = self
        cell.textField.tag = indexPath.item
        cell.titleLabel.text = labelNames[indexPath.item]
        
        switch indexPath.item {
        case 1:
            cellTotalValue = cell
            cellTotalValue?.textField.placeholder = placeholders[indexPath.item]
            cellTotalValue?.textField.keyboardType = .numbersAndPunctuation
        case 2 :
            cell08Image = cell as? ImageCell
        case 3 :
            cell07Cost = cell
            cell07Cost?.textField.keyboardType = .numbersAndPunctuation
        default:
            cell02Destination = cell
            cell02Destination?.textField.placeholder = placeholders[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.width
        let h : CGFloat = 50
        
        switch indexPath.item {
        case 2:
            return CGSize(width: w, height: UIDevice.current.userInterfaceIdiom == .phone ? 180 : 260)
        default:
            return CGSize(width: w, height: h)
        }
    }
}


extension RequestController: UITextFieldDelegate {
    
    // dismiss keyboard with done button tapped
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        switch textField.tag {
        case 0:
            view.endEditing(true)
            destinationTextFieldTapped()
        default:
            transparentView.isHidden = false
            textField.becomeFirstResponder()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        cell02Destination?.textField.resignFirstResponder()
        cell07Cost?.textField.resignFirstResponder()
    }
    
    func getTripInfoBy(youxiangCode: String){
        print("TODO: connect to database, get Trip object by the youxiangCode. Also fillout all info needed!!!!!")
    }
    
    private func destinationTextFieldTapped(){
//        let addressSearchCtl = AddressSearchController()
//        addressSearchCtl.searchType = AddressSearchType.requestDestination
//        addressSearchCtl.requestCtl = self
//        navigationController?.pushViewController(addressSearchCtl, animated: true)
    }
    
    func setupDestinationAddress(string: String){
        is02DestinationSet = true
        cell02Destination?.textField.text = string
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard touches.first != nil else { return }
        
        textFieldsInAllCellResignFirstResponder()
    }
    
    /// OK button at bottom of page
    func paymentButtonTapped() {
        
        print("TODO: upload Request() to server")
        
        let t = "‼️您还没填完信息"
        let ok = "朕知道了"
        if !is02DestinationSet {
            displayAlert(title: t, message: "请从地图上选择您的快件寄送【收货地址】，我们将为您找到帮您送件的客户。", action: ok)
            return
        }
        if imageUploadingSet.count == 0 {
            displayAlert(title: t, message: "请拍摄您的物品照片，便于出行人了解详情。", action: ok)
            return
        }
    }
    
    @objc fileprivate func handleSubmissionButton() {
        
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
        
        uploadImagesToAwsAndGetUrls { (urls, error) in
            if let urls = urls {
                if let totalValueString = self.cellTotalValue?.textField.text,
                    let totalValue = Double(totalValueString),
                    let costString = self.cell07Cost?.textField.text,
                    let cost = Double(costString),
                    let endAddress = self.endAddress,
                    let trip = self.trip {
                    
                    //TODO: Put in description.
                    ApiServers.shared.postRequest(totalValue: totalValue,
                                                  cost: cost,
                                                  destination: endAddress,
                                                  trip: trip,
                                                  imageUrls: urls,
                                                  description: "",
                                                  completion: { (success, error, serverError) in
                        if let error = error {
                            let errStr = serverError.desplayString()
                            print("Post Request Error: \(error.localizedDescription), \(errStr)")
                            return
                        }
                        ProfileManager.shared.loadLocalUser(completion: nil)
                        print("Post request success!")
                    })
                    
                }
            }
            
            
        }
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
    
    internal func uploadImagesToAwsAndGetUrls(completion: @escaping([String]?, Error?) -> Void) {
        
        var urls = [String]()
        
        for pair in imageUploadSequence {
            let imageName = pair.key
            
            if let url = imageUploadSequence[imageName] {
                AwsServerManager.shared.uploadFile(fileName: imageName, imgIdType: .requestImages, localUrl: url, completion: { (err, getUrl) in
                    
                    if let err = err {
                        print("error in uploadImagesToAwsAndGetUrls(): err = \(err.localizedDescription)")
                        completion(nil, err)
                        return
                    }
                    
                    if let getUrl = getUrl {
                        urls.append(getUrl.absoluteString)
                        
                        if urls.count == self.imageUploadSequence.count {
                            urls.sort {$0 < $1}
                            // TODO: upload urls dictionary to our Server;
//                            print("\n\n search this senten to locate in code to get dictionary - Xin")
//                            print("get dictionary ready for uploading to Server = ")
//                            for pair in imageUrlsDictionary {
//                                print("key = \(pair.key), val = \(pair.value)")
//                            }
                            
                            completion(urls, nil)
                            // then remove the images from cache
                            self.removeAllImageFromLocal()
                        }
                        
                    } else {
                        completion(nil, nil)
                    }
                })
                
            } else {
                print("error in uploadImagesToAwsAndGetUrls(): can not get imageUploadSequence[fileName] url !!!!!!")
                completion(nil, nil)
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

