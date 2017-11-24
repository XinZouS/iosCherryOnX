//
//  SenderDetailViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/20/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Photos
import AWSCognito
import AWSCore
import AWSS3
import ALCameraViewController


class SenderDetailViewController: UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    // master info card
    @IBOutlet weak var shiperInfoCardView: UIView!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    @IBOutlet weak var senderProfileImageButton: UIButton!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    // detail info card
    @IBOutlet weak var senderInfoCardView: UIView!
    @IBOutlet weak var nameTextField: UITextField!      // 0
    @IBOutlet weak var phoneTextField: UITextField!     // 1
    @IBOutlet weak var addressTextField: UITextField!   // 2
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageTextView: UITextView!   // 3
    // price contents
    @IBOutlet weak var priceValueTitleLabel: UILabel!
    @IBOutlet weak var priceValueTextField: UITextField! // 4
    @IBOutlet weak var priceValueTextFieldLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var currencyTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var priceMinLabel: UILabel!
    @IBOutlet weak var priceMidLabel: UILabel!
    @IBOutlet weak var priceMaxLabel: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var priceFinalLabel: UILabel!
    @IBOutlet weak var priceFinalHintLabel: UILabel!
    // DONE!
    @IBOutlet weak var submitButton: UIButton!

    // MARK: - actions forcontents
    
    @IBAction func senderProfileImageButtonTapped(_ sender: Any) {
        //TODO:
    }
    
    @IBAction func currencyTypeSegmentValueChanged(_ sender: Any) {
        currencyType = currencyTypeSegmentControl.selectedSegmentIndex == 0 ? .USD : .CNY
        updatePriceContentsFor(newPrice: priceValue)
    }
    
    @IBAction func priceSliderValueChanged(_ sender: Any) {
        priceFinal = Double(priceSlider.value)
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        handleSubmissionButton()
    }
    
    
    // MARK: - model properties
    
    var trip: Trip?
    var priceValue: Double = 5
    
    let cellId = "ItemImageCollectionCell"
    var imageUploadingSet: Set<String> = []
    var imageUploadSequence: [String : URL] = [:]
    
    var images : [ImageNamePair] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    struct ImageNamePair {
        var name : String?
        var image: UIImage?
        
        init(name: String, image: UIImage) {
            self.name = name
            self.image = image
        }
    }

    var currencyType: CurrencyType = .USD
    var priceFinal: Double = 5 {
        didSet {
            priceFinalLabel.text = currencyType.rawValue + String(format: "%.2f", priceFinal)
        }
    }
    enum textFieldTag: Int {
        case name = 0
        case phone = 1
        case address = 2
        case message = 3
        case price = 4
    }
    
    var keyboardHeight: CGFloat = 160
    var activityIndicator: UIActivityIndicatorCustomizeView! // UIActivityIndicatorView!
    var isLoading: Bool = false {
        didSet{
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
            submitButton.backgroundColor = isLoading ? colorErrGray : colorTheamRed
        }
    }

    //MARK: - Methods Start Here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "寄件"
        scrollView.delegate = self
        setupCollectionView()
        setupTextFields()
        setupActivityIndicator()
        setupSlider()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSubmitButtonStatus()
        setupMasterCardInfo()
    }
    
    private func setupCollectionView(){
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = false
        collectionView.backgroundColor = .white
    }
    
    private func setupTextFields(){
        nameTextField.delegate = self
        phoneTextField.delegate = self
        addressTextField.delegate = self
        priceValueTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        priceValueTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorCustomizeView()
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
    }
    
    private func setupSlider(){
        let droplet = #imageLiteral(resourceName: "droplet-png").scaleTo(newSize: CGSize(width: 20, height: 20))
        priceSlider.setThumbImage(droplet, for: .normal)
        priceSlider.setThumbImage(droplet, for: .highlighted)
    }
    
    private func setupMasterCardInfo(){
        guard trip != nil else {
            getTripErrorAndReturnPrePage()
            return
        }
        if let d = trip?.pickupDate {
            let date = Date(timeIntervalSince1970: d)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd YYYY"
            
            let userCalendar = Calendar.current
            let requestdComponents: Set<Calendar.Component> = [.year, .month, .day]
            let dateComponents = userCalendar.dateComponents(requestdComponents, from: date)
            
            dateMonthLabel.text = formatter.shortMonthSymbols.first
            dateDayLabel.text = "\(dateComponents.day ?? 0)"
            youxiangCodeLabel.text = trip?.tripCode ?? "no_trip_id"
            startAddressLabel.text = trip?.startAddress?.descriptionString()
            endAddressLabel.text = trip?.endAddress?.descriptionString()
            // TODO: get image url for shiper;
        }
        
    }



    @objc fileprivate func handleSubmissionButton() {
        let t = "‼️您还没填完信息"
        let ok = "朕知道了"
        guard let name = nameTextField.text, name.count != 0 else {
            let m = "请填写收件人【姓名】。"
            displayGlobalAlert(title: t, message: m, action: ok, completion: {
                self.nameTextField.becomeFirstResponder()
            })
            return
        }
        guard let phone = phoneTextField.text, phone.count > 5 else {
            let m = "请填写收件人【手机号】，方便出行人联系收件人。"
            displayGlobalAlert(title: t, message: m, action: ok, completion: {
                self.phoneTextField.becomeFirstResponder()
            })
            return
        }
        guard let destAddressStr = addressTextField.text, destAddressStr.count > 6 else {
            let m = "请填写完整的【收件地址】，方便出行人顺利送达。"
            displayGlobalAlert(title: t, message: m, action: ok, completion: {
                self.addressTextField.becomeFirstResponder()
            })
            return
        }
        guard imageUploadingSet.count != 0 else {
            displayGlobalAlert(title: t, message: "请拍摄您的物品照片，便于出行人了解详情。", action: ok, completion: nil)
            return
        }
        guard let price = priceValueTextField.text, price != "" else {
            displayGlobalAlert(title: t, message: "请正确设置您的货物价值，和具有吸引力的报价给出行人。", action: ok, completion: nil)
            return
        }
        
        isLoading = true
        uploadImagesToAwsAndGetUrls { (urls, error) in
            if let err = error {
                self.isLoading = false
                let m = "上传照片失败啦，错误信息：\(err.localizedDescription)"
                self.displayGlobalAlert(title: "哎呀", message: m, action: "稍后再试一次", completion: nil)
                return
            }
            // TODO BUG: test use fake trip only, remove this before launch!!!
            self.trip = Trip()
            
            if let urls = urls, let trip = self.trip, let address = trip.endAddress {
                
                let totalValue = Double(self.priceValue)
                let cost = self.priceFinal
                address.recipientName = name
                address.phoneNumber = phone
                address.detailedAddress = destAddressStr

                ApiServers.shared.postRequest(totalValue: totalValue,
                                              cost: cost,
                                              destination: address,
                                              trip: trip,
                                              imageUrls: urls,
                                              description: "",
                                              completion: { (success, error) in
                                                
                                                if let error = error {
                                                    self.isLoading = false
                                                    print("Post Request Error: \(error.localizedDescription)")
                                                    let m = "发布请求失败啦！请确保您的网络连接正常，稍后再试一次。"
                                                    self.displayGlobalAlert(title: "⚠️遇到错误", message: m, action: ok, completion: nil)
                                                    return
                                                }
                                                print("Post request success!")
                                                self.isLoading = false
                                                self.removeAllImageFromLocal()
                })

            } else {
                self.getTripErrorAndReturnPrePage()
            }
            
            
        }
    }

    private func isAllInfoReady() -> Bool {
        guard nameTextField.text != nil, nameTextField.text != "" else { return false }
        guard phoneTextField.text != nil, phoneTextField.text != "" else { return false }
        guard imageUploadingSet.count > 0 else { return false }
        guard priceValueTextField.text != nil, priceValueTextField.text != "" else { return false }
        return true
    }
    
    fileprivate func updateSubmitButtonStatus() {
        let ok = isAllInfoReady()
        submitButton.backgroundColor = ok ? colorTheamRed : colorErrGray
    }
    
    fileprivate func getTripErrorAndReturnPrePage(){
        let m = "出行人的行程信息不完整，请确保您填写的游箱号正确。"
        self.displayGlobalAlert(title: "⛔️获取行程失败", message: m, action: "重新填写游箱号", completion: {
            self.navigationController?.popViewController(animated: true)
        })
    }

    
}

// MARK: -
extension SenderDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    // number of images = [1,6]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(images.count + 1, 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? ItemImageCollectionCell else {
            return UICollectionViewCell()
        }
        cell.parentVC = self
        cell.backgroundColor = .white
        // number of images = [1,6]
        if indexPath.item < images.count || (images.count == 6) {
            cell.imageFileName = images[indexPath.item].name!
            cell.imageView.image = images[indexPath.item].image!
            cell.cancelButton.isHidden = false
            cell.cancelButton.isEnabled = true
        } else {
            cell.cancelButton.isHidden = true
            cell.cancelButton.isEnabled = false
            cell.imageView.image = #imageLiteral(resourceName: "CarryonEx_UploadID") // upload ID image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let s : CGFloat = (collectionView.bounds.width - 20) / (UIDevice.current.userInterfaceIdiom == .phone ? 3 : 6)
        return CGSize(width: s, height: s)
    }

    
}

extension SenderDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == images.count { // adding image cell tapped
            openALCameraController()
        }
    }
    
    func removeImagePairOfName(imgName: String) {
        for i in 0..<images.count {
            print("get imageName = \(images[i].name!), target name = \(imgName), trying to remove it...")
            if images[i].name! == imgName {
                images.remove(at: i)
                imageUploadingSet.remove(imgName)
                imageUploadSequence.removeValue(forKey: imgName)
                print("OK, remove file success: \(imgName)")
                return
            }
        }
    }
    
    
}


/// MARK: - image operation in local and uploading to AWS

extension SenderDetailViewController {
    
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
        self.images.append(ImageNamePair(name: imageName, image: image))
    }
    
    internal func uploadImagesToAwsAndGetUrls(completion: @escaping([String]?, Error?) -> Void) {
        
        var urls = [String]()
        
        for pair in imageUploadSequence {
            let imageName = pair.key
            
            if let url = imageUploadSequence[imageName] {
                AwsServerManager.shared.uploadFile(fileName: imageName, imgIdType: .requestImages, localUrl: url, completion: { (err, getUrl) in
                    
                    if let err = err {
                        print("error in uploadImagesToAwsAndGetUrls(): err = \(err.localizedDescription)")
                        let m = "无法上传图片到服务器，请确保您的网络连接正常，稍后再试一次。错误信息：" + err.localizedDescription
                        self.displayGlobalAlert(title: "⚠️上传图片失败", message: m, action: "朕知道了", completion: nil)
                        completion(nil, err)
                        return
                    }
                    
                    if let getUrl = getUrl {
                        urls.append(getUrl.absoluteString)
                        
                        if urls.count == self.imageUploadSequence.count {
                            urls.sort {$0 < $1}
                            completion(urls, nil)
                        }
                        
                    } else {
                        completion(nil, nil)
                    }
                })
                
            } else {
                print("error in uploadImagesToAwsAndGetUrls(): can not get imageUploadSequence[fileName] url !!!!!!")
                let m = "无法找到要上传的图片，请用手机拍照或从相册中选取。"
                self.displayGlobalAlert(title: "⚠️选择图片失败", message: m, action: "朕知道了", completion: nil)
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


// MARK: -
extension SenderDetailViewController: UITextFieldDelegate {
    
    public func textFieldDidChange(_ textField: UITextField){
        updateSubmitButtonStatus()
        if textField.tag == textFieldTag.price.rawValue, let v = priceValueTextField.text {
            let d = Double(v) ?? 5.0
            priceValue = d
            updatePriceContentsFor(newPrice: d)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == textFieldTag.price.rawValue {
            //scrollViewAnimateToBottom()
            priceValueTextFieldLeftConstraint.constant = priceValueTitleLabel.bounds.width
            animateUIifNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == textFieldTag.price.rawValue, (priceValueTextField.text == nil || priceValueTextField.text == "") {
            priceValueTextFieldLeftConstraint.constant = 0
            animateUIifNeeded()
        }
    }
    
    fileprivate func updatePriceContentsFor(newPrice: Double) {
        priceValueTitleLabel.text = "物品价值: " + currencyType.rawValue
        let r: Double = 0.1 // set price as [$5, 10% offerPrice]
        let pMin: Double = 5
        let pMax: Double = (newPrice < 5.0 || newPrice * r < 5.0) ? 10.0 : newPrice * r
        let pMid: Double = Double(Int(pMax * 100) + Int(pMin * 100)) / 200.0
        priceMinLabel.text = currencyType.rawValue + String(format: "%.2f", pMin)
        priceMidLabel.text = currencyType.rawValue + String(format: "%.2f", pMid)
        priceMaxLabel.text = currencyType.rawValue + String(format: "%.2f", pMax)
        
        priceSlider.minimumValue = Float(pMin)
        priceSlider.setValue(Float(pMid), animated: true)
        priceSlider.maximumValue = Float(pMax)
        priceFinal = pMid
        
        let pc = (priceFinal - pMid) * 100.0 / pMid
        let lv = pc < 0 ? "低于" : "高于"
        priceFinalHintLabel.text = lv + "标准价\(pc)%"
    }
    
    private func scrollViewAnimateToBottom(){
        var offset = scrollView.contentOffset
        let expOffset = scrollView.bounds.height - view.bounds.height
        if offset.y < expOffset {
            offset.y = expOffset
        }
        offset.y += keyboardHeight
        scrollView.setContentOffset(offset, animated: true)
    }
    
    public func keyboardWillShow(_ notification: Notification) {
        guard let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else { return }
        keyboardHeight = frame.cgRectValue.height
    }
    
    public func keyboardWillHide(_ notification: Notification) {
//        var offset = scrollView.contentOffset
//        if offset.y < 40 {
//            return
//        }
//        offset.y -= keyboardHeight
//        scrollView.setContentOffset(offset, animated: true)
    }
    
    fileprivate func keyboardDismiss(){
        addressTextField.resignFirstResponder()
        priceValueTextField.resignFirstResponder()
    }

    fileprivate func animateUIifNeeded(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.6, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
}

extension SenderDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        keyboardDismiss()
    }
}



// MARK: -
class ItemImageCollectionCell: UICollectionViewCell {
    
    var parentVC: SenderDetailViewController?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var imageFileName = ""
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        removeLocalImageWithFileName()
        removeLocalImageInCollectionView()
    }
    
    private func removeLocalImageWithFileName(){
        parentVC?.removeImageWithUrlInLocalFileDirectory(fileName: imageFileName)
    }
    
    private func removeLocalImageInCollectionView(){
        parentVC?.removeImagePairOfName(imgName: imageFileName)
    }
    
    
}






