//
//  OrdersTripDetailViewController.swift
//  carryonex
//
//  Created by Xin Zou on 1/3/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import UIKit
import AlamofireImage
import JXPhotoBrowser
import M13Checkbox
import MapKit
import MessageUI

class OrdersRequestDetailViewController: UIViewController {
    
    weak var selectedCell: PhotoBrowserCollectionViewCell?
    @IBOutlet weak var phontobrowser: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var imageCountButton: UIButton!
    // trip info
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var shippingFeeTitleLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var incomeHintLabel: UILabel!
    @IBOutlet weak var incomePaidHintLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // request info
    @IBOutlet weak var senderPhoneButton: PhoneMsgButton!
    @IBOutlet weak var senderImageButton: UIButton!
    @IBOutlet weak var senderProfileImageView: UIImageView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderStar5MaskWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var senderScoreWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollViewImageMaskWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemValueLabel: UILabel!
    @IBOutlet weak var itemMessageTextView: UITextView!
    @IBOutlet weak var senderDescLabel: UILabel!
    
    // recipient info
    @IBOutlet weak var recipientNameTitleLabel: UILabel!
    @IBOutlet weak var recipientPhoneTitleLabel: UILabel!
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientPhoneLabel: UILabel!
    @IBOutlet weak var recipientAddressLabel: UILabel!
    @IBOutlet weak var recipientPhoneCallButton: PhoneMsgButton!
    @IBOutlet weak var expressInfoView: UIView!
    @IBOutlet weak var expressInfoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var expressCompanyTitleLabel: UILabel!
    @IBOutlet weak var expressCompanyNameLabel: UILabel!
    @IBOutlet weak var expressTrackingNumTitleLabel: UILabel!
    @IBOutlet weak var expressTrackingNumberLabel: UILabel!    
    @IBOutlet weak var expressTrackingButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewHeighConstraint: NSLayoutConstraint!
    var selectedPin : MKPlacemark? = nil
    
    // done buttons
    @IBOutlet weak var finishButton: RequestTransactionButton!
    @IBOutlet weak var finishButton2: RequestTransactionButton!
    @IBOutlet weak var finishButtonStackViewHeighConstraint: NSLayoutConstraint!
    
    // payment menu at bottom of view
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var paymentMenuTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentMenuView: UIView!
    @IBOutlet weak var checkboxAlipay: UIView!
    @IBOutlet weak var checkboxWechatPay: UIView!
    @IBOutlet weak var gotoPaymentButton: UIButton! //goToPaymentHandler() for touchupinside
    
    // delivery info view
    @IBOutlet weak var deliveryInfoView: UIView!
    @IBOutlet weak var deliveryInfoViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var deliveryInfoTitleLabel: UILabel!
    @IBOutlet weak var trackingNumTitleLabel: UILabel!
    @IBOutlet weak var trackingNumTextField: ThemTextField!
    @IBOutlet weak var deliveryCompanyTitleLabel: UILabel!
    @IBOutlet weak var deliveryCompanyTextField: ThemTextField!
    @IBOutlet weak var deliveryCompanyButton: UIButton!
    @IBOutlet weak var deliveryInfoOKButton: UIButton!
    let textFieldFont = UIFont.systemFont(ofSize: 16)
    let deliveryCompanyPickerView = UIPickerView()
    var deliveryCompanyPickerData: [String] = []
    var deliveryCompanyId: String = ""
    let deliveryCompanyIDs = ["shunfeng", "shentong", "yuantong", "zhongtong", "huitongkuaidi",
                                  "yunda", "zhaijisong", "EMS", "upsen", "usps",
                                  "tnten", "fedexus", "canpost", "auspost", "hkpost"]
    let deliveryCompanyStringOf = ["shunfeng":"顺丰快递", "shentong":"申通快递", "yuantong":"圆通快递", "zhongtong":"中通快递", "huitongkuaidi":"百世汇通",
                                   "yunda":"韵达快递", "zhaijisong":"宅急送", "EMS":"EMS", "upsen":"UPS", "usps":"USPS",
                                   "tnten":"TNT", "fedexus":"FedEx", "canpost":"Canada Post", "auspost":"澳大利亚邮政", "hkpost":"香港邮政"]
    
    var isLoadingStatus = false {
        didSet {
            handleLoadingStatus()
        }
    }
    
    var checkAlipay: M13Checkbox?
    var checkWechat: M13Checkbox?
    
    let toShipperViewSegue = "toOtherShipperView"
    let postRateSegue = "PostRateSegue"
    let expressTrackingSegue = "expressTrackingSegue"
    
    var targetUserPhone: String?
    
    @IBAction func moreImageTapped(_ sender: Any) {
        
    }
    
    @IBAction func senderPhoneButtonTapped(_ sender: Any) {
        guard let senderPhone = self.targetUserPhone else { return }
        displayPhoneMessageAlert(targetPhone: senderPhone, referenceView: senderPhoneButton)
    }
    
    @IBAction func senderImageButtonTapped(_ sender: Any) {
        AnalyticsManager.shared.trackCount(.otherProfileVisitCount) //查看对方个人页面次数
        performSegue(withIdentifier: toShipperViewSegue, sender: self)
    }
    
    @IBAction func recipientPhoneCallButtonTapped(_ sender: Any) {
        guard let recipientPhone = request.endAddress?.phoneNumber else { return }
        displayPhoneMessageAlert(targetPhone: recipientPhone, referenceView: recipientPhoneCallButton)
    }
    
    @IBAction func goToPaymentHandler(_ sender: Any) {
        
        isLoadingStatus = true
        
        showPaymentView(false)
        
        if paymentType == .alipay {
            AnalyticsManager.shared.trackCount(.alipayPayCount)
            WalletManager.shared.aliPayAuth(request: request, completion: {
                self.isLoadingStatus = false
            })
            
        } else if paymentType == .wechatPay {
            AnalyticsManager.shared.trackCount(.wechatPayCount)
            WalletManager.shared.wechatPayAuth(request: request, completion: {
                self.isLoadingStatus = false
            })
        }
    }
    
    @IBAction func requestStatusButtonHandler(sender: RequestTransactionButton) {
        
        let transaction = sender.transaction
        //DLog("Transaction tapped: \(transaction.displayString())")
        
        if transaction == .allowRating {
            performSegue(withIdentifier: postRateSegue, sender: nil)
            return
        }
        
        if transaction == .carrierShip {
            showDeliveryInfoView(true)
            return
        }
        
        //Comment this to bypass payment
        //------------------------------
//        if transaction == .shipperPay {
//            showPaymentView(true)
//            return
//        }
        //------------------------------
        
        displayAlertOkCancel(title: L("orders.confirm.title.submit"), message: transaction.confirmDescString()) { [weak self] (style) in
            if style == .default {
                self?.processTransaction(transaction)
            }
            self?.backgroundViewHide()
        }
    }
    
    private func processTransaction(_ transaction: RequestTransaction) {
        
        let tripId = trip.id
        let requestId = request.id
        let requestCategory = category
        
        self.isLoadingStatus = true
        
        ApiServers.shared.postRequestTransaction(requestId: requestId, tripId: tripId, transaction: transaction, completion: { (success, error, statusId) in
            self.isLoadingStatus = false
            
            if let statusId = statusId {
                TripOrderDataStore.shared.updateRequestToStatus(category: requestCategory, requestId: self.request.id, status: statusId)
                
                //Track the new status to Fabric
                if let status = RequestStatus(rawValue: statusId) {
                    AnalyticsManager.shared.track(.requestStatusChange, attributes: ["status": status.analyticString()])
                }
                
            } else {
                DLog("No status found, bad call")
            }
        })
    }
    
    
    @IBAction func deliveryCompanyButtonTapped(_ sender: Any) {
        deliveryCompanyTextField.becomeFirstResponder()
    }
    
    @IBAction func deliveryInfoOKButtonTapped(_ sender: Any) {
        deliveryInfoSend()
    }
    
    @IBAction func expressTrackingButtonHandler(_ sender: Any) {
        // push PackageTracking by expressTrackingSegue
    }
    
    // MARK: - Data models
    var trip: Trip = Trip()
    
    var request: Request!
    var category: TripCategory = .carrier
    var currency: CurrencyType = .CNY
    
    var paymentType: Payment = .alipay {
        didSet{
            paymentTypeDidChanged()
        }
    }
    
    var buttonsToShow: OrderButtonToShow = .noButtons {
        didSet {
            switch buttonsToShow {
            case .noButtons:
                finishButton.isHidden = true
                finishButton2.isHidden = true
            case .oneButton:
                finishButton.isHidden = false
                finishButton2.isHidden = true
            case .twoButtons:
                finishButton.isHidden = false
                finishButton2.isHidden = false
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupView()
        setupNavigationBar()
        setupCollectionView()
        setupPaymentMenuView()
        setupDeliveryInfoView()
        addObservers()
        
        //Load Phone
        var targetUserId: Int
        if category == .carrier {
            targetUserId = request.ownerId
        } else {
            targetUserId = trip.carrierId
        }
        
        ApiServers.shared.getUserInfo(.phone, userId: targetUserId) { (phone, error) in
            if let error = error {
                DLog("Get phone error: \(error.localizedDescription)")
                self.senderPhoneButton.isHidden = true
                return
            }
            if let phone = phone as? String, phone.count > 1 {
                self.senderPhoneButton.isHidden = false
                self.targetUserPhone = phone
            }else{
                self.senderPhoneButton.isHidden = true
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        title = " "
        if segue.identifier == postRateSegue, let viewController = segue.destination as? OrderCommentRateController {
            viewController.category = category
            viewController.requestId = request.id
            if category == .carrier {
                viewController.commenteeId = request.ownerId
                viewController.commenteeRealName = request.ownerRealName ?? request.ownerUsername
                viewController.commenteeImage = request.ownerImageUrl
            } else {
                viewController.commenteeId = trip.carrierId
                viewController.commenteeRealName = trip.carrierRealName ?? trip.carrierUsername
                viewController.commenteeImage = trip.carrierImageUrl
            }
            
        }
        if segue.identifier == toShipperViewSegue, let viewController = segue.destination as? ShipperInfoViewController {
            if category == .carrier {
                viewController.commenteeId = request.ownerId
                viewController.commenteeRealName = request.ownerRealName ?? request.ownerUsername
                viewController.commenteeImage = request.ownerImageUrl
                viewController.phoneNumber = request.ownerUsername
            } else {
                viewController.commenteeId = trip.carrierId
                viewController.commenteeRealName = trip.carrierRealName ?? trip.carrierUsername
                viewController.commenteeImage = trip.carrierImageUrl
                viewController.phoneNumber = trip.carrierPhone
            }
            
        }
        if segue.identifier == expressTrackingSegue, let vc = segue.destination as? PackageTrackingViewController {
            vc.companyCode = request.express?.companyCode ?? ""
            vc.tracking = request.express?.expressNumber ?? ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = L("orders.ui.title.order-request-detail")
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupPaymentMenuView(){
        let sz: CGFloat = 30.0
        checkAlipay = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: sz, height: sz))
        checkWechat = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: sz, height: sz))
        setupPaymentCheckbox(checkAlipay!)
        setupPaymentCheckbox(checkWechat!)
        paymentType = .alipay
        checkboxAlipay.addSubview(checkAlipay!)
        checkboxWechatPay.addSubview(checkWechat!)
        
        let tapRgr = UITapGestureRecognizer(target: self, action: #selector(backgroundViewHide))
        backgroundView.isHidden = true
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapRgr)
    }
    
    private func setupPaymentCheckbox(_ b: M13Checkbox){
        b.addTarget(self, action: #selector(checkBoxDidChanged(_:)), for: .valueChanged)
        b.stateChangeAnimation = .stroke
        b.markType = .checkmark
        b.boxType = .circle
        b.checkmarkLineWidth = 4
        b.boxLineWidth = 2
        b.tintColor = colorCheckmarkGreen // selected
        b.secondaryTintColor = UIColor.lightGray // unselected
        //b.borderColor = UIColor.lightGray //TODO: FIX THIS
    }
    
    private func setupDeliveryInfoView() {
        deliveryInfoView.layer.masksToBounds = true
        deliveryInfoView.layer.cornerRadius = 6
        
        deliveryInfoTitleLabel.textColor = colorTextBlack
        trackingNumTitleLabel.textColor = colorTextBlack
        deliveryCompanyTitleLabel.textColor = colorTextBlack
        deliveryInfoTitleLabel.text = L("orders.ui.title.delivery-info")
        trackingNumTitleLabel.text = L("orders.ui.title.delivery-tracking")
        deliveryCompanyTitleLabel.text = L("orders.ui.title.delivery-company")
        
        trackingNumTextField.delegate = self
        deliveryCompanyTextField.delegate = self
        trackingNumTextField.setAttributedPlaceholder(" ", color: colorTextFieldPlaceholderBlack)
        deliveryCompanyTextField.setAttributedPlaceholder(" ", color: colorTextFieldPlaceholderBlack)
        
        deliveryCompanyButton.setTitle(" ", for: .normal)
        deliveryInfoOKButton.setTitle(L("action.done"), for: .normal)
        deliveryInfoOKButton.layer.cornerRadius = 5
        deliveryInfoOKButton.layer.masksToBounds = true

        setupDeliveryPicker()
    }
    
    private func setupDeliveryPicker() {
        deliveryCompanyPickerView.delegate = self
        deliveryCompanyPickerView.dataSource = self
        var nameStrs: [String] = []
        for id in deliveryCompanyIDs {
            if let str = deliveryCompanyStringOf[id], !str.isEmpty {
                nameStrs.append(str)
            }
        }
        deliveryCompanyPickerData = nameStrs
    }
    
    private func setupCollectionView(){
        phontobrowser.register(PhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: PhotoBrowserCollectionViewCell.defalutId)
    }
    
    private func setupScrollView(){
        scrollView.delegate = self
        scrollView.isDirectionalLockEnabled = true
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = (UIDevice.current.userInterfaceIdiom == .phone)
    }
    
    private func setupView() {
        
        updateRequestInfoAppearance(request: request)
        
        if let trip = TripOrderDataStore.shared.getTrip(category: category, id: request.tripId) {
            self.trip = trip
        }
        
        var profileImageString: String?
        
        if category == .carrier {
            profileImageString = request.ownerImageUrl
            senderNameLabel.text = request.ownerRealName
            senderDescLabel.text = L("orders.ui.message.sender-desc-sender")
            recipientPhoneCallButton.isHidden = false
            if let rating = request.ownerRating {
                let fullLength = senderStar5MaskWidthConstraint.constant
                senderScoreWidthConstraint.constant = fullLength * CGFloat(rating / 5.0)
            }
            updateMapViewToShow(false)
        }
        
        senderProfileImageView.layer.cornerRadius = senderProfileImageView.bounds.width/2
        senderProfileImageView.clipsToBounds = true

        if let urlString = profileImageString, let imgUrl = URL(string: urlString) {
            senderProfileImageView.af_setImage(withURL: imgUrl)
        } else {
            senderProfileImageView.image = #imageLiteral(resourceName: "blankUserHeadImage")
        }
        
        incomeLabel.text = currency.rawValue + request.priceString()
        incomeHintLabel.text = request.priceStdString()
        incomePaidHintLabel.text = L("orders.ui.title.item-paid")
        incomePaidHintLabel.isHidden = !request.isPaidByShiper()
        shippingFeeTitleLabel.text = L("orders.ui.title.shipping-fee")
        recipientNameTitleLabel.text = L("orders.ui.title.receiver-name")
        recipientNameLabel.text = request.endAddress?.recipientName
        recipientPhoneTitleLabel.text = L("orders.ui.title.receiver-phone")
        recipientPhoneLabel.text = request.endAddress?.phoneNumber
        recipientAddressLabel.text = request.endAddress?.detailedAddress
        itemValueLabel.text = currency.rawValue + request.itemValue()
        itemMessageTextView.attributedText = messageAttributeText(msg: request.note)
        
        dateMonthLabel.text = trip.getMonthString()
        dateDayLabel.text = trip.getDayString()
        startAddressLabel.text = trip.startAddress?.fullAddressString()
        endAddressLabel.text = trip.endAddress?.fullAddressString()
        if request.getImages().count > 2{
            imageCountButton.setTitle("+\(request.getImages().count-2)", for: .normal)
        }else{
            imageCountButton.setTitle("", for: .normal)
        }
        setupExpressInfo(request.express)
    }
    
    private func setupExpressInfo(_ express: Express?) {
        guard request.isInExpress(), let exp = express else {
            expressInfoViewHeightConstraint.constant = 0
            expressInfoView.isHidden = true
            return
        }
        expressInfoViewHeightConstraint.constant = 150
        expressInfoView.isHidden = false
        expressInfoView.backgroundColor = .white
        expressCompanyTitleLabel.textColor = colorTextBlack
        expressCompanyNameLabel.textColor = colorTextBlack
        expressTrackingNumTitleLabel.textColor = colorTextBlack
        expressTrackingNumberLabel.textColor = colorTextBlack
        expressCompanyTitleLabel.text = L("orders.ui.title.delivery-company")
        expressCompanyNameLabel.text = exp.company
        expressTrackingNumTitleLabel.text = L("orders.ui.title.delivery-tracking")
        expressTrackingNumberLabel.text = exp.expressNumber
        expressTrackingButton.setTitle(L("orders.ui.title.delivery-details"), for: .normal)
    }

    
    private func messageAttributeText(msg: String?) -> NSAttributedString {
        var m = L("orders.ui.placeholder.note-empty")
        if let getMsg = msg {
            m = getMsg
        }
        let title = L("orders.ui.placeholder.note-msg")
        let titleAtt = NSMutableAttributedString(string: title, attributes: [
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14),
            NSForegroundColorAttributeName: colorTextBlack
        ])
        let msgAtt = NSMutableAttributedString(string: m, attributes: [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14),
            NSForegroundColorAttributeName: colorTextBlack
        ])
        titleAtt.append(msgAtt)
        return titleAtt
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name.Alipay.PaymentProcessed, object: nil, queue: nil) { [weak self] (notification) in
            if let status = notification.object as? AliPayResultStatus {
                
                if status == .success || status == .processing {
                    self?.displayAlert(title: L("orders.confirm.title.payment"), message: status.statusDescription(), action: L("action.ok"), completion: { [weak self] _ in
                        guard let strongSelf = self else { return }
                        strongSelf.backgroundViewHide()
                        strongSelf.processTransaction(.shipperPay)
                    })
                    
                } else {
                    self?.displayAlert(title: L("orders.error.title.payment"), message: status.statusDescription(), action: L("action.ok"))
                }
                
            } else {
                self?.displayAlert(title: L("orders.error.title.payment"), message: L("orders.error.message.payment"), action: L("action.ok"))
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.TripOrderStore.StoreUpdated, object: nil, queue: nil, using: { [weak self] (notification) in
            self?.reloadData()
        })
        
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.PaySuccess, object: nil, queue: nil) { [weak self] (notification) in
            guard let payResp = notification.object as? PayResp else {
                DLog("Wechat Pay response empty")
                return
            }
            DLog("Wechat Pay response returnkey: \(payResp.returnKey)")
            //TODO: Update message
            self?.displayAlert(title: L("orders.confirm.title.wechatpay"), message: "", action: L("action.ok"), completion: {
                self?.processTransaction(.shipperPay)
            })
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.WeChat.PayFailed, object: nil, queue: nil) { [weak self] (notification) in
            guard let payResp = notification.object as? PayResp else {
                DLog("Wechat Pay response empty: ()")
                return
            }
            DLog("Wechat Pay response returnkey: \(payResp.returnKey)")
            //TODO: Update message
            self?.displayAlert(title: L("orders.error.title.wechatpay"), message: "", action: L("action.ok"))
        }
    }
    
    private func reloadData() {
        if let updatedRequest = TripOrderDataStore.shared.getRequest(category: category, requestId: self.request.id) {
            request = updatedRequest
            setupView()
        }
    }
    
    private func handleLoadingStatus() {
        if isLoadingStatus {
            AppDelegate.shared().startLoading()
            
            finishButton.isEnabled = false
            finishButton2.isEnabled = false
            
        } else {
            AppDelegate.shared().stopLoading()
            
            finishButton.isEnabled = true
            finishButton2.isEnabled = true
        }
    }
    
    private func showPaymentView(_ isShown: Bool) {
        guard (paymentMenuTopConstraint.constant < 0 && isShown) || (paymentMenuTopConstraint.constant >= 0 && !isShown) else {
            return
        }
        let offset: CGFloat = isShown ? paymentMenuView.bounds.height : -paymentMenuView.bounds.height
        paymentMenuTopConstraint.constant = offset
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.6, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        if offset <= 0 {
            backgroundViewHide()
        }else{
            backgroundViewShow()
        }
        AnalyticsManager.shared.startTimeTrackingKey(.requestPayTime)
    }
    
    public func backgroundViewHide(){
        showPaymentView(false)
        showDeliveryInfoView(false)
        backgroundView.isHidden = true
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
        }) { (complete) in
            if complete {
                self.backgroundView.isHidden = true
            }
        }
    }
    public func backgroundViewShow() {
        backgroundView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 1
        }, completion: nil)
    }
    
    public func checkBoxDidChanged(_ checkBox: M13Checkbox){
        if checkBox.checkState == .unchecked {
            checkBox.checkState = .checked
        }
        
        if checkBox == checkAlipay {
            paymentType = .alipay
            
        } else if checkBox == checkWechat {
            paymentType = .wechatPay
        }
    }
    
    private func paymentTypeDidChanged(){
        let aliState:    M13Checkbox.CheckState = (paymentType == .alipay)    ? .checked : .unchecked
        let wechatState: M13Checkbox.CheckState = (paymentType == .wechatPay) ? .checked : .unchecked
        checkAlipay?.setCheckState(aliState, animated: true)
        checkWechat?.setCheckState(wechatState, animated: true)
    }
    
    public func showDeliveryInfoView(_ isShow: Bool) {
        guard (isShow && deliveryInfoViewBottomConstraint.constant < 0) || (!isShow && deliveryInfoViewBottomConstraint.constant >= 0) else {
            return
        }
        deliveryInfoViewBottomConstraint.constant = isShow ? 300 : -50
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.6, initialSpringVelocity: 0.6, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        if isShow {
            backgroundViewShow()
        } else {
            backgroundViewHide()
        }
    }
    
    private func deliveryInfoSend() {
        
        showDeliveryInfoView(false)
        
        guard let trackingNum = trackingNumTextField.text, !trackingNum.isEmpty else {
            displayGlobalAlert(title: L("orders.error.title.delivery-info"),
                               message: L("orders.error.message.delivery-info"),
                               action: L("action.ok"), completion: {
                self.trackingNumTextField.becomeFirstResponder()
            })
            return
        }
        
        guard !deliveryCompanyId.isEmpty else {
            displayGlobalAlert(title: L("orders.error.title.delivery-info"),
                               message: L("orders.error.message.delivery-info"),
                               action: L("action.ok"), completion: {
                self.deliveryCompanyTextField.becomeFirstResponder()
            })
            return
        }
        
        ApiServers.shared.postExpress(requestId: request.id, companyCode: deliveryCompanyId, expressNumber: trackingNum) { (success, error) in
            if let error = error {
                self.displayGlobalAlert(title: L("orders.error.title.express-post"),
                                   message: L("orders.error.message.express-post") + ", " + error.localizedDescription,
                                   action: L("action.ok"), completion: nil)
                return
            }
            DLog("[RESULT] upload express isSuccess=\(success)")
            
            if success {
                self.processTransaction(.carrierShip)
                
                if let companyString = self.deliveryCompanyStringOf[self.deliveryCompanyId] {
                    let express = Express.init(id: -999,
                                               expressNumber: trackingNum,
                                               companyCode: self.deliveryCompanyId,
                                               company: companyString,
                                               timestamp: Date.getTimestampNow())
                    
                    TripOrderDataStore.shared.updateRequestWithExpress(express: express,
                                                                       category: self.category,
                                                                       requestId: self.request.id)
                }
                self.reloadData()
                
            } else {
                //TODO Display error.
            }
        }
    }

}


extension OrdersRequestDetailViewController: OrderListCardCellProtocol {
    
    func updateButtonAppearance(status: RequestStatus) {
        if category == .carrier {
            updateMapViewToShow(false)
            switch status {
            case .waiting, .inDelivery:
                buttonsToShow = .twoButtons
            case .accepted, .paid, .deliveryConfirmed:
                buttonsToShow = .oneButton
            default:
                buttonsToShow = .noButtons
            }
            
            switch status {
            case .waiting:
                finishButton.transaction = .carrierAccept
                finishButton2.transaction = .carrierReject
            case .accepted:
                finishButton.transaction = .carrierCancel
            case .paid:
                finishButton.transaction = .carrierReceive
            case .inDelivery:
                finishButton.transaction = .carrierDeliver
                finishButton2.transaction = .carrierShip
            case .deliveryConfirmed:
                finishButton.transaction = .allowRating
            default:
                break
            }
            
        } else {
            //Sender
            switch status {
            case .waiting, .accepted:
                buttonsToShow = .twoButtons
            case .delivered, .deliveryConfirmed:
                buttonsToShow = .oneButton
            default:
                buttonsToShow = .noButtons
            }
            
            switch status {
            case .waiting:
                finishButton.transaction = .shipperCancel
                finishButton2.transaction = .shipperPairing
            case .accepted:
                finishButton.transaction = .shipperPay
                finishButton2.transaction = .shipperCancel
            case .delivered:
                finishButton.transaction = .shipperConfirm
            case .deliveryConfirmed:
                finishButton.transaction = .allowRating
            default:
                break
            }
        }
        
        //Stop user for leaving comment if it's been commented
        guard let userId = ProfileManager.shared.getCurrentUser()?.id else {
            return
        }
        
        if finishButton.transaction == .allowRating {
            if let commentStatus = CommentStatus(rawValue: request.commentStatus)  {
                switch commentStatus {
                case .NoComment:
                    enableFinishButton()
                case .CarrierCommented:
                    if self.trip.carrierId == userId {
                        disableFinishButton()
                    } else {
                        enableFinishButton()
                    }
                case .SenderCommented:
                    if request.ownerId == userId {
                        disableFinishButton()
                    } else {
                        enableFinishButton()
                    }
                case .Completed:
                    disableFinishButton()
                }
            }
        }
        
        //To prevent grid lock because of loading issue, re-enable button again upon
        //setting transaction
        isLoadingStatus = false
    }
    
    func enableFinishButton() {
        finishButton.isHidden = false
    }
    
    func disableFinishButton() {
        finishButton.isHidden = true
    }
    
    func updateRequestInfoAppearance(request: Request) {
        //Override
        if let statusId = request.statusId, let status = RequestStatus(rawValue: statusId) {
            updateButtonAppearance(status: status)
            updateMapViewToShow(status == .inDelivery)
            statusLabel.text = status.displayString(isCommented: request.isCommented(category), isByExpress: request.isInExpress())
            statusLabel.textColor = status.displayTextColor(category: category)
            statusLabel.backgroundColor = status.displayColor(category: category)
        }
    }
    
    fileprivate func updateMapViewToShow(_ showMap: Bool){
        finishButtonStackViewHeighConstraint.constant = showMap ? 0 : 44
        mapViewHeighConstraint.constant = showMap ? mapView.bounds.width : 0
        DLog("done, now button heigh = \(finishButtonStackViewHeighConstraint.constant), mapHeight = \(mapViewHeighConstraint.constant)")
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
        if showMap {
            zoomToUserLocation()
        }
    }
    
    fileprivate func displayPhoneMessageAlert(targetPhone: String, referenceView rfv: UIView) {
        displayGlobalAlertActions(style: .actionSheet, title: L("orders.ui.title.contacts"), message: "", actions: [L("orders.ui.action.call"), L("orders.ui.action.sms")], referenceView: rfv) { (tag) in
            
            switch tag {
            case 0: // phone call
                if let url = URL(string: "tel://" + targetPhone) {
                    //根据iOS系统版本，分别处理
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }

            case 1: // text message
                self.sendSMSto(phone: targetPhone)
            
            default:
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

}

// Send SMS delegate
extension OrdersRequestDetailViewController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func sendSMSto(phone: String) {
        if MFMessageComposeViewController.canSendText() {
            let msgVC = MFMessageComposeViewController()
            msgVC.body = ""
            msgVC.recipients = [phone]
            msgVC.messageComposeDelegate = self
            present(msgVC, animated: true, completion: nil)
        }
    }
    
}


extension OrdersRequestDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imgCount = request.getImages().count
        scrollViewImageMaskWidthConstraint.constant = imgCount < 2 ? 50 : 100 //58 = 52 + 6
        return imgCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCollectionViewCell.defalutId, for: indexPath) as! PhotoBrowserCollectionViewCell
        
        if let url = URL(string: request.getImages()[indexPath.row].displayUrl()) {
            cell.imageView.af_setImage(withURL:url)
        }
        
        return cell
    }
}


extension OrdersRequestDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? PhotoBrowserCollectionViewCell else {
            return
        }
        selectedCell = cell
        // 调起图片浏览器
        let vc = PhotoBrowser(showByViewController: self, delegate: self)
        // 装配PageControl，提供了两种PageControl实现，若需要其它样式，可参照着自由定制
        if arc4random_uniform(2) % 2 == 0 {
            vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: request.getImages().count)
        } else {
            vc.pageControlDelegate = PhotoBrowserNumberPageControlDelegate(numberOfPages: request.getImages().count)
        }
        vc.show(index: indexPath.item)
    }
}


// 实现浏览器代理协议
extension OrdersRequestDetailViewController: PhotoBrowserDelegate {
    
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return request.getImages().count
    }
    
    /// 缩放起始视图
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailViewForIndex index: Int) -> UIView? {
        return phontobrowser?.cellForItem(at: IndexPath(item: index, section: 0))
    }
    
    /// 图片加载前的placeholder
    func photoBrowser(_ photoBrowser: PhotoBrowser, thumbnailImageForIndex index: Int) -> UIImage? {
        let cell = phontobrowser?.cellForItem(at: IndexPath(item: index, section: 0)) as? PhotoBrowserCollectionViewCell
        // 取thumbnailImage
        return cell?.imageView.image
    }
    
    func photoBrowser(_ photoBrowser: PhotoBrowser, highQualityUrlForIndex index: Int) -> URL? {
        return URL(string: request.getImages()[index].imageUrl)
    }
    
    /// 长按图片
    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveImageAction = UIAlertAction(title: L("orders.confirm.title.save-image"), style: .default) { (_) in
            DLog("保存图片：\(image)")
        }
        let cancelAction = UIAlertAction(title: L("action.cancel"), style: .cancel, handler: nil)
        
        actionSheet.addAction(saveImageAction)
        actionSheet.addAction(cancelAction)
        photoBrowser.present(actionSheet, animated: true, completion: nil)
    }
}


extension OrdersRequestDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let y = scrollView.contentOffset.y
        let maxY = scrollView.contentSize.height - self.view.bounds.height + 60
        let setY = y < 0 ? 0 : (y > maxY ? maxY : y)
        
        if x != 0 {
            scrollView.setContentOffset(CGPoint(x:0, y: setY), animated: false)
        }
    }
    
}


extension OrdersRequestDetailViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return deliveryCompanyPickerData.count
    }
    
}

extension OrdersRequestDetailViewController: UIPickerViewDelegate {
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return deliveryCompanyPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        deliveryCompanyId = deliveryCompanyIDs[deliveryCompanyPickerView.selectedRow(inComponent: 0)]
        deliveryCompanyTextField.text = deliveryCompanyStringOf[deliveryCompanyId]
    }
    
    
}

extension OrdersRequestDetailViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == deliveryCompanyTextField {
            deliveryCompanyTextField.inputView = deliveryCompanyPickerView
        }
        textFieldAddToolBar(textField)
    }
    
    fileprivate func textFieldAddToolBar(_ textField: UITextField) {
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
        
        textField.font = textFieldFont
        textField.delegate = self
        textField.inputAccessoryView = bar
    }
    func textFieldDoneButtonTapped(){
        dismissKeyboard()
    }
    func textFieldCancelButtonTapped() {
        dismissKeyboard()
    }
    private func dismissKeyboard() {
        deliveryCompanyTextField.resignFirstResponder()
        trackingNumTextField.resignFirstResponder()
    }
}


// MARK: - Map delegate

extension OrdersRequestDetailViewController: CLLocationManagerDelegate {
    
    func zoomToUserLocation(){
        
        mapView.showsPointsOfInterest = true
        mapView.mapType = .standard
        
        ApiServers.shared.getUserGPS(userId: trip.carrierId) { (gpsObject, error) in
            if let error = error {
                DLog("Order request get gps object error: \(error.localizedDescription)")
                return
            }
            
            guard let gps = gpsObject, let latitude = gps.latitude, let longitude = gps.longitude else {
                DLog("No GPS values found.")
                return
            }
            
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, 600, 600)
            self.mapView.setRegion(viewRegion, animated: false)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = self.trip.carrierRealName
            self.mapView.addAnnotation(annotation)
        }
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        DLog("TODO: updateSearchResults...")
    }
    
    /// HandleMapSearch delegate:
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        
        DispatchQueue.main.async {
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            self.mapView.setRegion(region, animated: true)
        }
    }
}


