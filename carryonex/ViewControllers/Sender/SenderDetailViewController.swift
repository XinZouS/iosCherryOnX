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
import BPCircleActivityIndicator
import AlamofireImage


struct ImageNamePair {
    var name : String?
    var image: UIImage?
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
}

class SenderDetailViewController: UIViewController{
    
    lazy var flagPicker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = pickerColorLightGray
        p.dataSource = self
        p.delegate = self
        p.isHidden = false
        return p
    }()
    var zoneCodeInput = "1"
    
    @IBOutlet weak var countryCodeTextField: UITextField! //5
    @IBOutlet weak var scrollView: UIScrollView!
    
    // master info card
    @IBOutlet weak var shiperInfoCardView: UIView!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    @IBOutlet weak var senderProfileImageButton: UIButton!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var tripNoteLabel: UILabel!
    @IBOutlet weak var tripNoteLabelHeighConstraint: NSLayoutConstraint!
    
    // detail info card
    @IBOutlet weak var senderInfoCardView: UIView!
    @IBOutlet weak var nameTextField: ThemTextField!      // 0
    @IBOutlet weak var phoneTextField: ThemTextField!     // 1
    @IBOutlet weak var addressTextField: ThemTextField!   // 2
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewMaskImageView: UIImageView!
    @IBOutlet weak var collectionViewMaskIcon: UIImageView!
    @IBOutlet weak var collectionViewMaskLabel: UILabel!
    @IBOutlet weak var collectionViewMaskButton: UIButton!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageTextView: ThemTextView!   // 3
    
    // price contents
    @IBOutlet weak var priceValueTitleLabel: UILabel!
    @IBOutlet weak var priceCurrencyTypeLabel: UILabel!
    @IBOutlet weak var priceValueTextField: ThemTextField! // 4
    @IBOutlet weak var priceValueTextFieldLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var currencyTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var priceMinLabel: UILabel!
    @IBOutlet weak var priceMidLabel: UILabel!
    @IBOutlet weak var priceMaxLabel: UILabel!
    @IBOutlet weak var pricePrePaySwitch: UISwitch!
    @IBOutlet weak var priceShipingFeeLabel: UILabel!
    @IBOutlet weak var priceShipingFeeHintLabel: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var priceFinalLabel: UILabel!
    @IBOutlet weak var priceFinalHintLabel: UILabel!
    @IBOutlet weak var priceMaxInfoButton: UIButton!
    @IBOutlet weak var priceMaxInfoIconLabel: UILabel!
    @IBOutlet weak var priceMaxValueHintLabel: UILabel!
    var priceMaxValueLimit: Double = 10000.0 { // use var so we can change it from server;
        didSet{
            priceMaxValueHintLabel.text = "小提示：寄送物品价值限制至多" + "\(currencyType.rawValue)\(priceMaxValueLimit)"
        }
    }
        
    // DONE!
    @IBOutlet weak var submitButton: UIButton!
    // MARK: - actions forcontents
    
    @IBAction func senderProfileImageButtonTapped(_ sender: Any) {
        //TODO: open sender personal page;
    }
    
    
    @IBAction func collectionViewMaskButtonTapped(_ sender: Any) {
        openALCameraController()
    }
    
    @IBAction func currencyTypeSegmentValueChanged(_ sender: Any) {
        currencyType = currencyTypeSegmentControl.selectedSegmentIndex == 0 ? .USD : .CNY
        updatePriceContentsFor(newPrice: priceShipFee)
    }
    
    
    @IBAction func priceMaxInfoButtonTapped(_ sender: Any) {
        // TODO: connect url for price info, now using fake url:
        gotoWebview(title: "物品价值说明", url: "\(ApiServers.shared.host)/doc_privacy")
    }
    
    @IBAction func pricePrePaySwitchChanged(_ sender: Any) {
        if pricePrePaySwitch.isOn {
            priceFinal += priceShipFee
        } else {
            priceFinal -= priceShipFee
        }
    }
    
    @IBAction func priceSliderValueChanged(_ sender: Any) {
        guard priceMiddl > 0 else { return }
        let currVal = Double(priceSlider.value)
        // shiping fee hint:
        priceShipingFeeLabel.text = currencyType.rawValue + String(format: "%.2f", currVal)
        let mid = Double(priceSlider.minimumValue + priceSlider.maximumValue) / 2.0
        let pc1 = (currVal - mid) * 100.0 / mid
        if pc1 > -1 && pc1 < 1 {
            priceShipingFeeHintLabel.text = "标准价"
        } else {
            let lv1 = pc1 < 0 ? "低于" : "高于"
            priceShipingFeeHintLabel.text = lv1 + "标准价" + "\(Int(abs(pc1)))%"
        }
        
        // final price hint:
        let prePayVal: Double = pricePrePaySwitch.isOn ? priceShipFee : 0.0
        priceFinal = currVal + prePayVal
        priceValueTextField.resignFirstResponder()
        //let pc2 = (priceFinal - priceMiddl) * 100.0 / priceMiddl
        //let lv2 = pc2 < 0 ? "低于" : "高于"
        //priceFinalHintLabel.text = lv2 + "标准价\(Int(pc2))%"
    }
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        handleSubmissionButton()
    }
    
    enum PriceFunctionType: Int {
        case linear = 0
        case exponential = 1
        case logarithmic = 2
    }
    var priceParamA: Double = 1
    var priceParamB: Double = 1
    
    // MARK: - model properties
    
    var trip: Trip?
    
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

    var currencyType: CurrencyType = .CNY
    var priceShipingFee: Double = 0.1
    var priceShipFee: Double = 0.1
    var priceMiddl: Double = 2.5
    var priceFinal: Double = 5 {
        didSet {
            priceShipingFeeLabel.text = currencyType.rawValue + String(format: "%.2f", Double(priceSlider.value))
            priceFinalLabel.text = currencyType.rawValue + String(format: "%.2f", priceFinal)
        }
    }

    var keyboardHeight: CGFloat = 160
    var activityIndicator: BPCircleActivityIndicator! // UIActivityIndicatorView!
    var isLoading: Bool = false {
        didSet{
            if isLoading {
                activityIndicator.isHidden = false
                activityIndicator.animate()
            } else {
                activityIndicator.isHidden = true
                activityIndicator.stop()
            }
            submitButton.backgroundColor = isLoading ? colorErrGray : colorTheamRed
        }
    }
    // textField editing with scrollView animation
    var isTextFieldBeginEditing = false
    // textView placeholder text status
    var isTextViewBeenEdited = false
    let messageWordsLimite: Int = 140

    
    //MARK: - Methods Start Here
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "寄件"
        currencyTypeSegmentControl.isHidden = true // TODO: for now, only support .CNY
        scrollView.delegate = self
        setupCollectionView()
        setupTextFields()
        setupActivityIndicator()
        setupSlider()
        getPriceFunctionFromServer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCardView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSubmitButtonStatus()
        setupCountryCodeTextField()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AnalyticsManager.shared.finishTimeTrackingKey(.senderPlacePriceTime)
    }
    
    private func setupCardView(){
        if let endCountry = trip?.endAddress?.country?.rawValue,
            let endState = trip?.endAddress?.state,
            let endCity = trip?.endAddress?.city,
            let startCountry = trip?.startAddress?.country?.rawValue,
            let startState = trip?.startAddress?.state,
            let startCity = trip?.startAddress?.city {
            if let imageUrl = trip?.carrierImageUrl,let url = URL(string:imageUrl){
                senderProfileImageButton.af_setImage(for: .normal, url: url)
            }else{
                senderProfileImageButton.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
            }
            endAddressLabel.text = endCountry+" "+endState+" "+endCity
            startAddressLabel.text = startCountry+" "+startState+" "+startCity
        }
        
        youxiangCodeLabel.text = trip?.tripCode
        if let note = trip?.note, note != "" {
            tripNoteLabel.text = note
            tripNoteLabelHeighConstraint.constant = 46
        }else{
            tripNoteLabelHeighConstraint.constant = 0
        }
        view.layoutIfNeeded()
        
        dateMonthLabel.text = trip?.getMonthString()
        dateDayLabel.text = trip?.getDayString()
        
        // TODO: get shiper image url and setup profile image for trip card;
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
        textFieldAddToolBar(nameTextField, nil)
        textFieldAddToolBar(phoneTextField, nil)
        textFieldAddToolBar(addressTextField, nil)
        textFieldAddToolBar(nil, messageTextView)
        textFieldAddToolBar(priceValueTextField, nil)
        textFieldAddToolBar(countryCodeTextField,nil)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        let limiteStr = formatter.string(from: NSNumber(value: priceMaxValueLimit)) ?? "10000.0"
        priceValueTextField.placeholder = "输入价值(不超过￥" + "\(limiteStr)" + ")"
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    private func setupActivityIndicator(){
        activityIndicator = BPCircleActivityIndicator()
        activityIndicator.frame = CGRect(x:view.center.x-15,y:view.center.y-64,width:0,height:0)
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
    }
    
    private func setupSlider(){
        let droplet = #imageLiteral(resourceName: "droplet-png").scaleTo(newSize: CGSize(width: 20, height: 20))
        priceSlider.setThumbImage(droplet, for: .normal)
        priceSlider.setThumbImage(droplet, for: .highlighted)
    }
    
    private func setupCountryCodeTextField(){
        countryCodeTextField.inputView = flagPicker
    }
    
    @IBAction func CountryCodeTapped(_ sender: Any) {

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
    
    
    private func getPriceFunctionFromServer(){ // (bool, str, [str,double])
        ApiServers.shared.getRequestPrice { (success, msg, dictionary) in
            guard success else {
                self.displayGlobalAlertActions(title: "出错了", message: "价格参数获取失败", actions: [L("action.cancel"),L("action.redo")], completion: { [weak self] (tag) in
                    if tag == 0 { // cancel, go back
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        self?.getPriceFunctionFromServer()
                    }
                })
                return
            }
            if let dic = dictionary {
                if let a = dic["a"] {
                    self.priceParamA = a
                }
                if let b = dic["b"] {
                    self.priceParamB = b
                }
            }
        }
    }
    
    fileprivate func calculatePrice(type: PriceFunctionType) -> Double {
        switch type {
        case .linear:
            return priceShipFee * priceParamA + (Double(priceParamB) / 100)
        case .logarithmic:
            print("TODO: logarithmic func for price")
            return 10
        case .exponential:
            print("TODO: exponential func for price")
            return 10
        }
    }


    @objc fileprivate func handleSubmissionButton() {
        guard let name = nameTextField.text, name.count != 0 else {
            self.displayGlobalAlert(title: "信息不足", message: "请填写收件人姓名", action: L("action.ok"), completion: { [weak self] _ in
                self?.nameTextField.becomeFirstResponder()
            })
            return
        }
        
        guard let phone = phoneTextField.text, phone.count > 5 else {
            self.displayGlobalAlert(title: "信息不足", message: "请填写手机号", action: L("action.ok"), completion: { [weak self] _ in
                self?.phoneTextField.becomeFirstResponder()
            })
            return
        }
        
        guard let destAddressStr = addressTextField.text, destAddressStr.count > 0 else {
            self.displayGlobalAlert(title: "信息不足", message: "请填写收件信息", action: L("action.ok"), completion: { [weak self] _ in
                self?.addressTextField.becomeFirstResponder()
            })
            return
        }
        
        guard imageUploadingSet.count != 0 else {
            displayGlobalAlert(title: "信息不足", message: "请提交您的物品照片，便于出行人了解详情", action: L("action.ok"), completion: nil)
            return
        }
        
        guard let price = priceValueTextField.text, price != "" else {
            displayGlobalAlert(title: "信息不足", message: "请准确填写您的货物价值，和运费报价给出行人", action: L("action.ok"), completion: nil)
            return
        }
        
        guard isLoading == false else {
            return
        }
        
        isLoading = true
        AnalyticsManager.shared.finishTimeTrackingKey(.senderPlacePriceTime)
        AnalyticsManager.shared.finishTimeTrackingKey(.senderDetailTotalTime)
        
        self.uploadImagesToAwsAndGetUrls { [weak self] (urls, error) in
            self?.isLoading = false
            guard let strongSelf = self else { return }
            
            if let err = error {
                strongSelf.isLoading = false
                debugPrint("Error: \(err.localizedDescription)")
                strongSelf.displayGlobalAlert(title: "出错", message: "照片上传失败", action: "重新提交", completion: nil)
                return
            }
            
            if let urls = urls, let trip = strongSelf.trip, let address = trip.endAddress {
                
                let msg = strongSelf.isTextViewBeenEdited ? strongSelf.messageTextView.text : ""
                let totalValue = Double(strongSelf.priceShipFee)
                let cost = strongSelf.priceFinal
                address.recipientName = name
                address.phoneNumber = strongSelf.zoneCodeInput + phone
                address.detailedAddress = destAddressStr

                ApiServers.shared.postRequest(totalValue: totalValue,
                                              cost: cost,
                                              destination: address,
                                              trip: trip,
                                              imageUrls: urls,
                                              description: msg ?? "",
                                              completion: { (success, error, serverErr) in
                                                
                                                if let error = error {
                                                    strongSelf.isLoading = false
                                                    print("Post Request Error: \(error.localizedDescription)")
                                                    strongSelf.displayGlobalAlert(title: "出错",
                                                                                  message: "发布请求失败，请确保您的网络连接正常，稍后再试",
                                                                                  action: L("action.ok"),
                                                                                  completion: nil)
                                                    return
                                                }
                                                
                                                strongSelf.isLoading = false
                                                strongSelf.removeAllImageFromLocal()
                                                strongSelf.displayGlobalAlert(title: "订单发布成功",
                                                                              message: "订单提交成功，请及时关注订单状态",
                                                                              action: L("action.ok"),
                                                                              completion: { [weak self] _ in
                                                    self?.navigationController?.popToRootViewController(animated: true)
                                                })
                                                
                                                TripOrderDataStore.shared.pull(category: .sender, delay: 1, completion: nil)
                })

            } else {
                strongSelf.getTripErrorAndReturnPrePage()
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
        self.displayGlobalAlert(title: "游箱号有误", message: "无法查到对方出行信息", action: "重新填写游箱号", completion: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
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
            cell.imageFileName = images[indexPath.item].name ?? "no_imgname"
            cell.imageView.image = images[indexPath.item].image ?? UIImage()
            cell.cancelButton.isHidden = false
        } else {
            cell.cancelButton.isHidden = true
            cell.imageView.image = #imageLiteral(resourceName: "imageUploadPlaceholder") // upload ID image
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
                collectionViewMasksHide(imageUploadingSet.count != 0)
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
        collectionViewMasksHide(imageUploadingSet.count != 0)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    internal func uploadImagesToAwsAndGetUrls(completion: @escaping([String]?, Error?) -> Void) {
        
        var urls = [String]()
        
        for pair in imageUploadSequence {
            let imageName = pair.key
            
            if let url = imageUploadSequence[imageName] {
                AwsServerManager.shared.uploadFile(fileName: imageName, imgIdType: .requestImages, localUrl: url, completion: { (err, getUrl) in
                    
                    if let err = err {
                        print("error in uploadImagesToAwsAndGetUrls(): err = \(err.localizedDescription)")
                        self.displayGlobalAlert(title: "出错", message: "照片上传失败", action: L("action.ok"), completion: nil)
                        completion(nil, err)
                        return
                    }
                    
                    if let getUrl = getUrl {
                        urls.append(getUrl.absoluteString)
                        
                        if urls.count == self.imageUploadSequence.count {
                            urls.sort {$0 < $1}
                            completion(urls, nil)
                            AnalyticsManager.shared.track(.viewImageCount, attributes: ["imageCount": urls.count])
                        }
                        
                    } else {
                        completion(nil, nil)
                    }
                })
                
            } else {
                print("error in uploadImagesToAwsAndGetUrls(): can not get imageUploadSequence[fileName] url !!!!!!")
                self.displayGlobalAlert(title: "出错", message: "照片上传失败", action: L("action.ok"), completion: nil)
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
    
    fileprivate func collectionViewMasksHide(_ isHide: Bool){
        collectionViewMaskImageView.isHidden = isHide
        collectionViewMaskButton.isHidden = isHide
        collectionViewMaskLabel.isHidden = isHide
        collectionViewMaskIcon.isHidden = isHide
    }
    
}


// MARK: -
extension SenderDetailViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // check for placeholder
        if !isTextViewBeenEdited {
            isTextViewBeenEdited = true
        }
        // check for return key
        if text == "\n" {
            priceValueTextField.becomeFirstResponder()
            return false
        }
        // check for backspace key
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                _ = isInputTextInLimiteWords(textView)
                return true
            }
        }
        // check for input limite
        return isInputTextInLimiteWords(textView)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let placeholderTxt = "给出行人的注意事项或特殊要求，字数限制在" + "\(messageWordsLimite)"
        if textView.text == "" {
            textView.text = placeholderTxt
            textView.textColor = .lightGray
            isTextViewBeenEdited = false
        }
        messageTextView.isActive = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !isTextViewBeenEdited {
            textView.text = ""
            textView.textColor = .black
            messageTextView.isActive = true
        }
        AnalyticsManager.shared.finishTimeTrackingKey(.senderPlacePriceTime)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // check for decimal 6.66:
        guard textField == priceValueTextField else {
            return true
        }
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let expression = "^[0-9]*((\\.|,)[0-9]{0,2})?$"
        let allowCommentAndWitespace = NSRegularExpression.Options.allowCommentsAndWhitespace
        let reportProgress = NSRegularExpression.MatchingOptions.reportProgress
        let regex = try! NSRegularExpression(pattern: expression, options: allowCommentAndWitespace)
        let numberOfMatches = regex.numberOfMatches(in: newString, options: reportProgress, range: NSMakeRange(0, (newString as NSString).length))
        
        return numberOfMatches != 0
    }
    
    private func isInputTextInLimiteWords(_ textView: UITextView) -> Bool {
        let ok = textView.text.count <= messageWordsLimite
        messageTitleLabel.text = ok ? "留言" : ("留言字数限制" + "\(messageWordsLimite)")
        return ok
    }

}

extension SenderDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            phoneTextField.becomeFirstResponder()
            return false
        }
        keyboardDismiss()
        return false
    }
    
    public func textFieldDidChange(_ textField: UITextField){
        updateSubmitButtonStatus()
        preparePriceIn(textField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateScrollViewToShow(textField)
        
        if textField == nameTextField ||
            textField == phoneTextField ||
            textField == addressTextField { // make sure is target textFields, then check text:
            if (nameTextField.text?.isEmpty ?? true) &&
                (phoneTextField.text?.isEmpty ?? true) &&
                (addressTextField.text?.isEmpty ?? true) { // all [empty], then fire timmer, otherwise it already running;
                AnalyticsManager.shared.startTimeTrackingKey(.senderDetailFillTime)
            }
        }
        if textField == priceValueTextField {
            if (priceValueTextField.text?.isEmpty ?? true) {
                AnalyticsManager.shared.startTimeTrackingKey(.senderAddPriceTime)
                AnalyticsManager.shared.startTimeTrackingKey(.senderPlacePriceTime)
                
            } else {
                AnalyticsManager.shared.trackCount(.senderPlacePriceCount)
            }
        } else {
            AnalyticsManager.shared.finishTimeTrackingKey(.senderPlacePriceTime)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField ||
            textField == phoneTextField ||
            textField == addressTextField { // make sure is target textFields, then check text:
            if !(nameTextField.text?.isEmpty ?? true) &&
                !(phoneTextField.text?.isEmpty ?? true) &&
                !(addressTextField.text?.isEmpty ?? true) { // all [filled], then stop timmer, otherwise it already stopped;
                AnalyticsManager.shared.finishTimeTrackingKey(.senderDetailFillTime)
            }
        }
        if textField == priceValueTextField {
            if (priceValueTextField.text == nil || priceValueTextField.text == "") {
                //priceValueTextFieldLeftConstraint.constant = 0
                //animateUIifNeeded()
            } else {
                AnalyticsManager.shared.finishTimeTrackingKey(.senderAddPriceTime)
                preparePriceIn(textField)
            }
        }
    }
    
    fileprivate func textFieldAddToolBar(_ textField: UITextField?, _ textView: UITextView?) {
        let bar = UIToolbar()
        bar.barStyle = .default
        bar.isTranslucent = true
        bar.tintColor = .black
        
        let doneBtn = UIBarButtonItem(title: "完成", style: .done, target: self, action: #selector(textFieldDoneButtonTapped))
        let cancelBtn = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(textFieldCancelButtonTapped))
        let spaceBtn = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.setItems([cancelBtn, spaceBtn, doneBtn], animated: false)
        bar.isUserInteractionEnabled = true
        bar.sizeToFit()
        
        if let tf = textField {
            tf.delegate = self
            tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            tf.inputAccessoryView = bar
        }
        if let tv = textView {
            tv.delegate = self
            tv.inputAccessoryView = bar
            tv.textColor = .lightGray
            tv.text = "给出行人的注意事项或特殊要求，字数限制: \(messageWordsLimite)"
        }
    }
    
    func textFieldDoneButtonTapped(){
        countryCodeTextField.resignFirstResponder()
        keyboardDismiss()
    }
    func textFieldCancelButtonTapped(){
        countryCodeTextField.resignFirstResponder()
        keyboardDismiss()
    }
    
    fileprivate func preparePriceIn(_ textField: UITextField){
        if textField == priceValueTextField, let v = priceValueTextField.text, let d = Double(v) {
            
            if d > priceMaxValueLimit {
                textField.text = "\(priceMaxValueLimit)"
                //priceMaxValueHintLabel.isHidden = true // TODO: for now, we don't need this to show;
                priceMaxInfoButton.setTitleColor(colorTheamRed, for: .normal)
                priceMaxInfoIconLabel.backgroundColor = colorTheamRed
                priceMaxInfoIconLabel.textColor = .white
            } else {
                //priceMaxValueHintLabel.isHidden = true // TODO: for now, we don't need this to show;
                priceMaxInfoButton.setTitleColor(.lightGray, for: .normal)
                priceMaxInfoIconLabel.backgroundColor = colorLineLightGray
                priceMaxInfoIconLabel.textColor = .gray
            }
            
            priceShipFee = d
            updatePriceContentsFor(newPrice: d)
        }
    }
    
    fileprivate func gotoWebview(title: String, url: String) {
        let webVC = WebController()
        self.navigationController?.pushViewController(webVC, animated: true)
        webVC.title = title
        webVC.url = URL(string: url)
    }
    
    fileprivate func updatePriceContentsFor(newPrice: Double) {
        priceValueTitleLabel.text = "物品价值" //+ currencyType.rawValue
        let pMin: Double = 0.1
        let pGet = calculatePrice(type: .linear)
        let pMax: Double = (newPrice < pMin || pGet < pMin) ? 10.0 : pGet
        priceMiddl = Double(Int(pMax * 100) + Int(pMin * 100)) / 200.0
        priceMinLabel.text = String(format: "%.2f", pMin)
        priceMaxLabel.text = String(format: "%.0f", pMax)
        priceMidLabel.text = String(format: "%.0f", priceMiddl)

        priceSlider.minimumValue = Float(pMin)
        priceSlider.maximumValue = Float(pMax)
        priceSlider.setValue(Float(priceMiddl), animated: false)
        priceFinal = pricePrePaySwitch.isOn ? (priceMiddl + newPrice) : priceMiddl
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
        nameTextField.resignFirstResponder()
        phoneTextField.resignFirstResponder()
        addressTextField.resignFirstResponder()
        messageTextView.resignFirstResponder()
        priceValueTextField.resignFirstResponder()
    }

    private func animateScrollViewToShow(_ textField: UITextField){
        isTextFieldBeginEditing = true // for scrollview content offset adjustment
        let locOnScreen = textField.convert(CGPoint(x: 0, y: 0), to: view)
        let offsetY = locOnScreen.y - 120
        let newLoc = CGPoint(x: 0, y: scrollView.contentOffset.y + offsetY)
        scrollView.setContentOffset(newLoc, animated: true)
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.isTextFieldBeginEditing = false // for scrollview content offset adjustment
        })
    }
    
    fileprivate func animateUIifNeeded(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.6, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension SenderDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isTextFieldBeginEditing {
            keyboardDismiss()
        }
    }
}

// MARK: -
class ItemImageCollectionCell: UICollectionViewCell {
    
    var parentVC: SenderDetailViewController?
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var imageFileName = "" {
        didSet{
            cancelButton.isHidden = false
            cancelButton.isEnabled = true
        }
    }
    
    
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


// MARK: pickerView delegate
extension SenderDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return flagsTitle.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return flagsTitle[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let zoneCode = codeOfFlag[flagsTitle[row]],let zoneFlag = Flag[flagsTitle[row]]{
            zoneCodeInput = zoneCode
            countryCodeTextField.text = zoneFlag
        }
    }
}
