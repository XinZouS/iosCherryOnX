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
    @IBOutlet weak var youxiangCodeTitleLabel: UILabel!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    @IBOutlet weak var senderProfileImageButton: UIButton!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var tripNoteLabel: UILabel!
    @IBOutlet weak var tripNoteLabelHeighConstraint: NSLayoutConstraint!
    
    // detail info card
    @IBOutlet weak var senderInfoCardView: UIView!
    @IBOutlet weak var senderInfoTitleLabel: UILabel!
    @IBOutlet weak var nameTextField: ThemTextField!      // 0
    @IBOutlet weak var phoneTextField: ThemTextField!     // 1
    @IBOutlet weak var addressTextView: ThemTextView!   // 2
    @IBOutlet weak var addressTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addressTextViewUnderlineView: UIView!
    let addressTextViewHeight: CGFloat = 32
    let addressTextViewEstimateY: CGFloat = 50
    @IBOutlet weak var itemImagesTitleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewMaskImageView: UIImageView!
    @IBOutlet weak var collectionViewMaskIcon: UIImageView!
    @IBOutlet weak var collectionViewMaskLabel: UILabel!
    @IBOutlet weak var collectionViewMaskButton: UIButton!
    @IBOutlet weak var messageTitleLabel: UILabel!
    @IBOutlet weak var messageTextView: ThemTextView!   // 3
    @IBOutlet weak var messageTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextViewUnderlineView: UIView!
    let messageTextViewHeight: CGFloat = 32
    let messageTextViewEstimateY: CGFloat = 500
    let textFieldFont = UIFont.systemFont(ofSize: 16)
    
    // price contents
    @IBOutlet weak var priceValueTitleLabel: UILabel!
    @IBOutlet weak var priceCurrencyTypeLabel: UILabel!
    @IBOutlet weak var priceValueTextField: ThemTextField! // 4
    @IBOutlet weak var priceValueTextFieldLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var carrierPrepayTitleLabel: UILabel!
    @IBOutlet weak var currencyTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var priceMinLabel: UILabel!
    @IBOutlet weak var priceMidLabel: UILabel!
    @IBOutlet weak var priceMaxLabel: UILabel!
    @IBOutlet weak var pricePrePaySwitch: UISwitch!
    @IBOutlet weak var priceShipingFeeTitleLabel: UILabel!
    @IBOutlet weak var priceShipingFeeLabel: UILabel!
    @IBOutlet weak var priceShipingFeeHintLabel: UILabel!
    @IBOutlet weak var priceSlider: UISlider!
    @IBOutlet weak var priceFinalTitleLabel: UILabel!
    @IBOutlet weak var priceFinalLabel: UILabel!
    @IBOutlet weak var priceFinalHintLabel: UILabel!
    @IBOutlet weak var priceMaxInfoButton: UIButton!
    @IBOutlet weak var priceMaxInfoIconLabel: UILabel!
    @IBOutlet weak var priceMaxValueHintLabel: UILabel!
    
//    let kShippInfoSegue = "ShipperInfoSegue"
    
    var priceMaxValueLimit: Double = 9999999.0 { // use var so we can change it from server; we still need this incase of number overflow;
        didSet{
            priceMaxValueHintLabel.text = L("sender.ui.message.item-value-max") + "\(currencyType.rawValue)\(priceMaxValueLimit)"
        }
    }
        
    // DONE!
    @IBOutlet weak var submitButton: UIButton!
    // MARK: - actions forcontents
    
    @IBAction func senderProfileImageButtonTapped(_ sender: Any) {
        AppDelegate.shared().handleMainNavigation(navigationSegue: .shipperProfile, sender: trip)
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
        gotoWebview(title: "sender.ui.title.item-value-info", url: "\(ApiServers.shared.host)/doc_privacy")
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
        let currVal = roundSliderValue(priceSlider.value, step: 0.1)
        
        // shiping fee hint:
        priceShipingFeeLabel.text = currencyType.rawValue + String(format: "%.2f", currVal)
        let mid = Double(priceSlider.minimumValue + priceSlider.maximumValue) / 2.0
        let pc1 = (currVal - mid) * 100.0 / mid
        if pc1 > -1 && pc1 < 1 {
            priceShipingFeeHintLabel.text = L("sender.ui.message.price-standard") // "标准价"
        } else {
            let lv1 = pc1 < 0 ? L("sender.ui.message.price-lower-than") : L("sender.ui.message.price-higher-than")
            priceShipingFeeHintLabel.text = lv1 + L("sender.ui.message.price-standard") + "\(Int(abs(pc1)))%"
        }
        
        // final price hint:
        let priceItemValue = Double(priceValueTextField.text ?? "0") ?? 0.0
        let prePayVal: Double = pricePrePaySwitch.isOn ? priceItemValue : 0.0
        priceFinal = currVal + prePayVal
        priceShipFee = currVal
        priceValueTextField.resignFirstResponder()
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
    var priceShipFee: Double = 0.1
    var priceMiddl: Double = 2.5
    var priceFinal: Double = 5 {
        didSet {
            priceShipingFeeLabel.text = currencyType.rawValue + String(format: "%.2f", Double(priceFinal))
            priceFinalLabel.text = currencyType.rawValue + String(format: "%.2f", priceFinal)
        }
    }

    var keyboardHeight: CGFloat = 160
    var isLoading: Bool = false {
        didSet{
            if isLoading {
                AppDelegate.shared().startLoading()
            } else {
                AppDelegate.shared().stopLoading()
            }
        }
    }
    // textField editing with scrollView animation
    var isTextFieldBeginEditing = false
    var isTextViewEditing = false
    // textView placeholder text status
    var isAddressTextViewBeenEdited = false
    var isMessageTextViewBeenEdited = false
    let messageWordsLimite: Int = 140

    
    //MARK: - View Cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTypeSegmentControl.isHidden = true // TODO: for now, only support .CNY
        scrollView.delegate = self
        setupCollectionView()
        setupViewLabels()
        setupTextFields()
        setupSlider()
        setupPriceParams()
        setupCardView()

        //Get realname
        if let targetUserId = trip?.carrierId {
            ApiServers.shared.getUserInfo(.realName, userId: targetUserId) { (realName, error) in
                if let error = error {
                    DLog("Get real name error: \(error.localizedDescription)")
                    return
                }
                if let realName = realName as? String {
                    self.trip?.carrierRealName = realName
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSubmitButtonStatus()
        setupCountryCodeTextField()
        setupNavigationBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = " "
    }
    
    private func setupNavigationBar(){
        title = L("sender.ui.title.new-request")
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == kShippInfoSegue {
//            if let shipperInfoViewController = segue.destination as? ShipperInfoViewController, let trip = trip {
//                shipperInfoViewController.commenteeId = trip.carrierId
//                shipperInfoViewController.commenteeRealName = trip.carrierRealName ?? trip.carrierUsername
//                shipperInfoViewController.commenteeImage = trip.carrierImageUrl
//                shipperInfoViewController.phoneNumber = trip.carrierPhone
//            }
//        }
//    }
    
    //MARK: View Setup
    
    private func setupCardView(){
        if let endCountry = trip?.endAddress?.country,
            let endState = trip?.endAddress?.state,
            let endCity = trip?.endAddress?.city,
            let startCountry = trip?.startAddress?.country,
            let startState = trip?.startAddress?.state,
            let startCity = trip?.startAddress?.city {
            if let imageUrl = trip?.carrierImageUrl, let url = URL(string:imageUrl) {
                senderProfileImageButton.af_setImage(for: .normal, url: url)
            } else {
                senderProfileImageButton.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
            }
            endAddressLabel.text = endCountry + " " + endState + " " + endCity
            startAddressLabel.text = startCountry + " " + startState + " " + startCity
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
    
    private func setupViewLabels() {
        youxiangCodeTitleLabel.text = L("sender.ui.title.youxiangcode")
        senderInfoTitleLabel.text = L("sender.ui.sessiontitle.recipient-info")
        itemImagesTitleLabel.text = L("sender.ui.sessiontitle.item-photos")
        collectionViewMaskLabel.text = L("sender.ui.title.collection-mask")
        priceValueTitleLabel.text = L("sender.ui.sessiontitle.price-value")
        carrierPrepayTitleLabel.text = L("sender.ui.sessiontitle.prepay")
        messageTitleLabel.text = L("sender.ui.sessiontitle.note")
        priceShipingFeeTitleLabel.text = L("sender.ui.sessiontitle.price-offer")
        priceShipingFeeHintLabel.text = L("sender.ui.message.price-standard")
        priceFinalTitleLabel.text = L("sender.ui.sessiontitle.price-final")
        submitButton.setTitle(L("sender.ui.title.submit"), for: .normal)
    }

    private func setupTextFields(){
        textFieldAddToolBar(nameTextField, nil)
        textFieldAddToolBar(phoneTextField, nil)
        textFieldAddToolBar(nil, addressTextView)
        textFieldAddToolBar(nil, messageTextView)
        textFieldAddToolBar(priceValueTextField, nil)
        textFieldAddToolBar(countryCodeTextField,nil)
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: L("sender.ui.placeholder.name"), attributes: [NSForegroundColorAttributeName: colorTextFieldPlaceholderBlack])
        nameTextField.editingDidEnd()
        phoneTextField.attributedPlaceholder = NSAttributedString(string: L("sender.ui.placeholder.phone"), attributes: [NSForegroundColorAttributeName: colorTextFieldPlaceholderBlack])
        phoneTextField.editingDidEnd()
        addressTextView.font = textFieldFont
        messageTextView.font = textFieldFont
        //let formatter = NumberFormatter()  --for now we use unlimited price;
        //let limiteStr = formatter.string(from: NSNumber(value: priceMaxValueLimit)) ?? "10000.0"
        let pricePH: String = L("sender.ui.placeholder.price-value") //  + "\(limiteStr)" + ")"  --for now we use unlimited price;
        priceValueTextField.attributedPlaceholder = NSAttributedString(string: pricePH, attributes: [NSForegroundColorAttributeName: colorTextFieldPlaceholderBlack])
        priceValueTextField.editingDidEnd()
        
        addressTextViewHeightConstraint.constant = addressTextViewHeight
        messageTextViewHeightConstraint.constant = messageTextViewHeight
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
    
    fileprivate func setupPriceParams() {
        
        if let startCountry = trip?.startAddress?.country, let endCountry = trip?.endAddress?.country {
            //International
            if startCountry != endCountry {
                if let configData = ApiServers.shared.configData {
                    priceParamA = configData.intlPrice.a
                    priceParamB = configData.intlPrice.b
                    updatePriceContentsFor(newPrice: 10) // default val
                    return
                }
            }
            
            //Same City
            if let startState = trip?.startAddress?.state,
                let endState = trip?.endAddress?.state,
                let startCity = trip?.startAddress?.city,
                let endCity = trip?.endAddress?.city {
                if startCountry == endCountry, startState == endState, startCity == endCity {
                    if let configData = ApiServers.shared.configData {
                        priceParamA = configData.sameCityPrice.a
                        priceParamB = configData.sameCityPrice.b
                        updatePriceContentsFor(newPrice: 10) // default val
                        return
                    }
                }
            }
        }
        
        if let configData = ApiServers.shared.configData {
            priceParamA = configData.domesticPrice.a
            priceParamB = configData.domesticPrice.b
            updatePriceContentsFor(newPrice: 10) // default val
        }
    }

    fileprivate func calculatePrice(type: PriceFunctionType) -> Double {
        let priceFactor = self.trip?.priceFactor ?? 1.0
        switch type {
        case .linear: // if a=0.15, b=36, so pGet = x * a + b, b also as the min of price;
            return (priceShipFee * priceParamA + Double(priceParamB)) * priceFactor //(Double(priceParamB) / 100)
        case .logarithmic:
            DLog("TODO: logarithmic func for price")
            return 10
        case .exponential:
            DLog("TODO: exponential func for price")
            return 10
        }
    }

    @objc fileprivate func handleSubmissionButton() {
        guard let name = nameTextField.text, name.count != 0 else {
            self.displayGlobalAlert(title: L("sender.error.title.info"), message: L("sender.error.message.recipient"), action: L("action.ok"), completion: { [weak self] _ in
                self?.nameTextField.becomeFirstResponder()
            })
            return
        }
        
        guard let phone = phoneTextField.text, phone.count > 5 else {
            self.displayGlobalAlert(title: L("sender.error.title.info"), message: L("sender.error.message.phone"), action: L("action.ok"), completion: { [weak self] _ in
                self?.phoneTextField.becomeFirstResponder()
            })
            return
        }
        
        guard let destAddressStr = addressTextView.text, destAddressStr.count > 0 else {
            self.displayGlobalAlert(title: L("sender.error.title.info"), message: L("sender.error.message.address"), action: L("action.ok"), completion: { [weak self] _ in
                self?.addressTextView.becomeFirstResponder()
            })
            return
        }
        
        guard imageUploadingSet.count != 0 else {
            displayGlobalAlert(title: L("sender.error.title.info"), message: L("sender.error.message.photo-miss"), action: L("action.ok"), completion: nil)
            return
        }
        
        guard let price = priceValueTextField.text, price != "" else {
            displayGlobalAlert(title: L("sender.error.title.info"), message: L("sender.error.message.price"), action: L("action.ok"), completion: nil)
            return
        }
        
        guard isLoading == false else {
            return
        }
        isLoading = true
        AnalyticsManager.shared.finishTimeTrackingKey(.senderPlacePriceTime)
        AnalyticsManager.shared.finishTimeTrackingKey(.senderDetailTotalTime)
        
        self.uploadImagesToAwsAndGetUrls { [weak self] (urls, error) in
            guard let strongSelf = self else { return }
            
            if let err = error {
                DLog("Error: \(err.localizedDescription)")
                strongSelf.displayGlobalAlert(title: L("sender.error.title.upload"),
                                              message: L("sender.error.message.upload-photo"),
                                              action: L("sender.error.action.upload-photo"),
                                              completion: nil)
                return
            }
            
            if let urls = urls, let trip = strongSelf.trip, let address = trip.endAddress {
                var imgUrls: [String] = []
                var thumbnails: [String] = []
                for url in urls {
                    if url.contains("thumbnail") {
                        thumbnails.append(url)
                    }else{
                        imgUrls.append(url)
                    }
                }
                let msg = strongSelf.isMessageTextViewBeenEdited ? strongSelf.messageTextView.text : ""
                let totalValue = Double(price) ?? Double(strongSelf.priceShipFee)
                let cost = strongSelf.priceFinal
                let stdPrice = strongSelf.priceMiddl
                address.recipientName = name
                address.phoneNumber = strongSelf.zoneCodeInput + phone
                address.detailedAddress = destAddressStr

                ApiServers.shared.postRequest(totalValue: totalValue,
                                              cost: cost,
                                              stdPrice: stdPrice,
                                              destination: address,
                                              trip: trip,
                                              imageUrls: imgUrls,
                                              imageThumbnails: thumbnails,
                                              description: msg ?? "",
                                              completion: { (success, error, serverErr) in
                                                
                                                strongSelf.isLoading = false
                                                AnalyticsManager.shared.finishTimeTrackingKey(.senderPlacePriceTime)

                                                if let error = error {
                                                    DLog("Post Request Error: \(error.localizedDescription)")
                                                    strongSelf.displayGlobalAlert(title: L("sender.error.title.upload"),
                                                                                  message: L("sender.error.message.post-failed"),
                                                                                  action: L("action.ok"),
                                                                                  completion: nil)
                                                    return
                                                }
                                                
                                                strongSelf.removeAllImageFromLocal()
                                                strongSelf.displayGlobalAlert(title: L("sender.confirm.title.post"),
                                                                              message: L("sender.confirm.message.post"),
                                                                              action: L("action.ok"),
                                                                              completion: { [weak self] _ in
                                                    self?.navigationController?.popToRootViewController(animated: true)
                                                })
                                                
                                                ProfileManager.shared.loadLocalUser(completion: nil)
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
        submitButton.backgroundColor = ok ? colorTheamRed : colorButtonGray
        submitButton.setTitleColor(ok ? UIColor.white : colorButtonTitleGray, for: .normal)
    }
    
    fileprivate func getTripErrorAndReturnPrePage(){
        self.displayGlobalAlert(title: L("sender.error.title.youxiang-miss"),
                                message: L("sender.error.message.youxiang-miss"),
                                action: L("sender.error.action.youxiang-miss"),
                                completion: { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
    }

    private func roundSliderValue(_ v: Float, step: Float) -> Double {
        guard let priceStr = priceValueTextField.text, let priceBySender = Double(priceStr) else {
            return  0
        }
        if priceBySender > 100 {
            return Double(round(v))
        }
        let factor = 1.0 / step
        return Double(round(v * factor) / factor)
    }
    
    fileprivate func animateUIifNeeded(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.6, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
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
            guard let getImgName = images[i].name else {
                continue
            }
            DLog("get imageName = \(getImgName), target name = \(imgName), trying to remove it...")
            if getImgName == imgName {
                images.remove(at: i)
                imageUploadingSet.remove(imgName)
                imageUploadSequence.removeValue(forKey: imgName)
                if let baseName = imgName.components(separatedBy: ".").first {
                    DLog("get imageName = \(imgName), target name = \(baseName)_thumbnail.JPG, trying to remove it...")
                    imageUploadingSet.remove("\(baseName)_thumbnail.JPG")
                    imageUploadSequence.removeValue(forKey: "\(baseName)_thumbnail.JPG")
                }
                collectionViewMasksHide(imageUploadingSet.count != 0)
                DLog("OK, remove file success: \(imgName)")
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
                formatter.dateFormat = "yyyy_MM_dd_HHmmss"
                let dateTimeStr: String = formatter.string(from: Date())
                self.presentImageIntoCellCollectionView(img, baseName: dateTimeStr)
            }
            self.dismiss(animated: true, completion: nil)
        })
        self.present(cameraViewController, animated: true, completion: nil)
    }
    
    private func presentImageIntoCellCollectionView(_ image: UIImage, baseName: String){
        // for original image uploading:
        let imageName = baseName + ".JPG"
        let localFileUrl = self.saveImageToDocumentDirectory(img: image, name: imageName)
        self.imageUploadSequence[imageName] = localFileUrl
        self.imageUploadingSet.insert(imageName)
        self.images.append(ImageNamePair(name: imageName, image: image))
        collectionViewMasksHide(imageUploadingSet.count != 0)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        // for thumbnail image uploading:
        if let thumbnail: UIImage = image.getThumbnailImg(compression: 1.0, maxPixelSize: 200) {
            let thumbnailName = baseName + "_thumbnail.JPG"
            let localThumbnailUrl = self.saveImageToDocumentDirectory(img: thumbnail, name: thumbnailName)
            self.imageUploadSequence[thumbnailName] = localThumbnailUrl
            self.imageUploadingSet.insert(thumbnailName)
        }else{
            DLog("Error: SenderDetailViewController::saveThumbnailOf() unable to get thumbnail from image: \(baseName)")
        }
    }
    
    internal func uploadImagesToAwsAndGetUrls(completion: @escaping([String]?, Error?) -> Void) {
        
        var urls: [String] = []
        
        for pair in imageUploadSequence {
            let imageName = pair.key
            
            if let url = imageUploadSequence[imageName] {
                AwsServerManager.shared.uploadFile(fileName: imageName, imgIdType: .requestImages, localUrl: url, completion: { (err, getUrl) in
                    
                    if let err = err {
                        DLog("error in uploadImagesToAwsAndGetUrls(): err = \(err.localizedDescription)")
                        self.displayGlobalAlert(title: L("sender.error.title.upload"), message: L("sender.error.message.upload-photo"), action: L("action.ok"), completion: nil)
                        completion(nil, err)
                        return
                    }
                    
                    if let getUrl = getUrl {
                        urls.append(getUrl.absoluteString)
                        
                        if urls.count == self.imageUploadSequence.count {
                            urls.sort {$0 < $1}
                            completion(urls, err)
                            AnalyticsManager.shared.track(.viewImageCount, attributes: ["imageCount": urls.count])
                        }
                        
                    } else {
                        completion(nil, err)
                    }
                })
                
            } else {
                DLog("error in uploadImagesToAwsAndGetUrls(): can not get imageUploadSequence[fileName] url !!!!!!")
                self.displayGlobalAlert(title: L("sender.error.title.upload"), message: L("sender.error.message.upload-photo"), action: L("action.ok"), completion: nil)
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
        
        guard let filePath = documentUrl.path, fileManager.fileExists(atPath: "\(filePath)/\(fileName)") else { return }
        DLog("\ntry to removeImageWithUrlInLocalFileDirectory fileName = \(fileName), fileExistsAtPath== TRUE,")
        do {
            if fileManager.fileExists(atPath: "\(filePath)/\(fileName)"){
                try fileManager.removeItem(atPath: "\(filePath)/\(fileName)")
                DLog("OK remove file at path: \(filePath), fileName = \(fileName)")
            }
            if let baseName = fileName.components(separatedBy: ".").first, fileManager.fileExists(atPath: "\(filePath)/\(baseName)_thumbnail.JPG") {
                try fileManager.removeItem(atPath: "\(filePath)/\(baseName)_thumbnail.JPG")
                DLog("OK remove thumbnail at path: \(filePath), fileName = \(baseName)_thumbnail.JPG")
            }
        }catch let err {
            DLog("error : when trying to move file: \(fileName), from path = \(filePath), get err = \(err)")
        }
    }
    
    func saveImageToDocumentDirectory(img : UIImage, name: String) -> URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = name //"\(name).JPG"
        let profileImgLocalUrl = documentUrl.appendingPathComponent(fileName)
        if let imgData = UIImageJPEGRepresentation(img, imageCompress) {
            try? imgData.write(to: profileImgLocalUrl, options: .atomic)
        }
        DLog("save image to DocumentDirectory: \(profileImgLocalUrl)")
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
        
        if textView == addressTextView {
            return true
        }
        
        // check for placeholder
        if !isMessageTextViewBeenEdited {
            isMessageTextViewBeenEdited = true
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
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isTextViewEditing = true
        if textView == addressTextView {
            animateScrollViewToShow(addressTextView)
            addressTextViewUnderlineView.backgroundColor = colorTheamRed
            if !isAddressTextViewBeenEdited {
                textView.text = ""
                textView.textColor = colorTextBlack
                addressTextView.isActive = true
            }
            
        } else if textView == messageTextView {
            animateScrollViewToShow(messageTextView)
            messageTextViewUnderlineView.backgroundColor = colorTheamRed
            if !isMessageTextViewBeenEdited {
                textView.text = ""
                textView.textColor = colorTextBlack
                messageTextView.isActive = true
            }
            AnalyticsManager.shared.finishTimeTrackingKey(.senderPlacePriceTime)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        isTextViewEditing = false
        if textView == addressTextView {
            if textView.text == "" {
                textView.text = L("sender.ui.placeholder.address")
                textView.textColor = colorTextFieldPlaceholderBlack
                isAddressTextViewBeenEdited = false
            }
            addressTextViewUnderlineView.backgroundColor = colorTextFieldUnderLineLightGray
            addressTextView.isActive = false
            
        }else if textView == messageTextView {
            let placeholderTxt = L("sender.ui.placeholder.note") + "\(messageWordsLimite)"
            if textView.text == "" {
                textView.text = placeholderTxt
                textView.textColor = colorTextFieldPlaceholderBlack
                isMessageTextViewBeenEdited = false
            }
            messageTextViewUnderlineView.backgroundColor = colorTextFieldUnderLineLightGray
            messageTextView.isActive = false
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        guard let t = textView.text else { return }
        if textView == addressTextView {
            isAddressTextViewBeenEdited = !t.isEmpty
        }
        if textView == messageTextView {
            isMessageTextViewBeenEdited = !t.isEmpty
        }
        guard t.count > 1 else { return }
        let sz = CGSize(width: textView.bounds.width - 10, height: 100)
        let option = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let atts = [NSFontAttributeName: textFieldFont]
        let estimateRect = NSString(string: t).boundingRect(with: sz, options: option, attributes: atts, context: nil)
        
        if textView == addressTextView {
            self.addressTextViewHeightConstraint.constant = max(self.addressTextViewHeight, estimateRect.height + 10)

        }else if textView == messageTextView {
            self.messageTextViewHeightConstraint.constant = max(self.messageTextViewHeight, estimateRect.height + 10)
        }
    }
    
    private func isInputTextInLimiteWords(_ textView: UITextView) -> Bool {
        let ok = textView.text.count <= messageWordsLimite
        messageTitleLabel.text = ok ? L("sender.ui.title.note-ok") : (L("sender.ui.title.note-overflow") + "\(messageWordsLimite)")
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        animateScrollViewToShow(textField)
        
        if textField == nameTextField ||
            textField == phoneTextField { // make sure is target textFields, then check text:
            if (nameTextField.text?.isEmpty ?? true) &&
                (phoneTextField.text?.isEmpty ?? true) {
                // all [empty], then fire timmer, otherwise it already running;
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
            textField == phoneTextField { // make sure is target textFields, then check text:
            if !(nameTextField.text?.isEmpty ?? true) &&
                !(phoneTextField.text?.isEmpty ?? true) {
                // all [filled], then stop timmer, otherwise it already stopped;
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
        
        let doneBtn = UIBarButtonItem(title: L("action.done"), style: .done, target: self, action: #selector(textFieldDoneButtonTapped))
        let cancelBtn = UIBarButtonItem(title: L("action.cancel"), style: .plain, target: self, action: #selector(textFieldCancelButtonTapped))
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
            tv.textColor = colorTextFieldPlaceholderBlack
            if tv == addressTextView {
                tv.text = L("sender.ui.placeholder.address")
            }else if tv == messageTextView {
                tv.text = L("sender.ui.placeholder.note") + "\(messageWordsLimite)"
            }
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
            
            priceShipFee = min(d, priceMaxValueLimit)
            updatePriceContentsFor(newPrice: priceShipFee)
        }
    }
    
    fileprivate func gotoWebview(title: String, url: String) {
        let webVC = WebController()
        self.navigationController?.pushViewController(webVC, animated: true)
        webVC.title = title
        webVC.url = URL(string: url)
    }
    
    fileprivate func updatePriceContentsFor(newPrice: Double) {
        priceValueTitleLabel.text = L("sender.ui.title.item-value") //+ currencyType.rawValue
        let pGet = calculatePrice(type: .linear)
        let pMin: Double = max(pGet * 0.7, priceParamB)
        let pMax: Double = pGet + (pGet - pMin)
        priceMiddl = (pMax + pMin) / 2.0
        priceMinLabel.text = String(format: "%.1f", pMin)
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
        addressTextView.resignFirstResponder()
        messageTextView.resignFirstResponder()
        priceValueTextField.resignFirstResponder()
    }

    fileprivate func animateScrollViewToShow(_ v: UIView){
        isTextFieldBeginEditing = true // for scrollview content offset adjustment
        let locOnScreen = v.convert(CGPoint(x: 0, y: 0), to: view)
        let offsetY = locOnScreen.y - 120
        let newLoc = CGPoint(x: 0, y: scrollView.contentOffset.y + offsetY)
        scrollView.setContentOffset(newLoc, animated: true)
        _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { (timer) in
            self.isTextFieldBeginEditing = false // for scrollview content offset adjustment
        })
    }
    
}

extension SenderDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !isTextFieldBeginEditing && !isTextViewEditing {
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
