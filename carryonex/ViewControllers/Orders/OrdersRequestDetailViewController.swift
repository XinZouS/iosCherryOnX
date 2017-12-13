//
//  OrdersRequestDetailViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/29/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import AlamofireImage
import JXPhotoBrowser
import M13Checkbox
import MapKit
import BPCircleActivityIndicator

class OrdersRequestDetailViewController: UIViewController {
    
    @IBOutlet weak var blockerWidth: NSLayoutConstraint!
    weak var selectedCell: PhotoBrowserCollectionViewCell?
    @IBOutlet weak var phontobrowser: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    @IBOutlet weak var imageCountButton: UIButton!
    // trip info
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // request info
    @IBOutlet weak var senderPhoneButton: UIButton!
    @IBOutlet weak var senderImageButton: UIButton!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderScoreWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemValueLabel: UILabel!
    @IBOutlet weak var itemMessageTextView: UITextView!
    @IBOutlet weak var senderDescLabel: UILabel!
    
    // recipient info
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientPhoneLabel: UILabel!
    @IBOutlet weak var recipientAddressLabel: UILabel!
    @IBOutlet weak var recipientPhoneCallButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var mapViewHeighConstraint: NSLayoutConstraint!
    internal let locationManager = CLLocationManager()
    var selectedPin : MKPlacemark? = nil
    
    // done buttons
    @IBOutlet weak var finishButton: RequestTransactionButton!
    @IBOutlet weak var finishButton2: RequestTransactionButton!
    @IBOutlet weak var finishButtonStackViewHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusLoadingIndicator: BPCircleActivityIndicator!
    var isLoadingStatus = false {
        didSet {
            if isLoadingStatus {
                statusLoadingIndicator.isHidden = false
                statusLoadingIndicator.animate()
                finishButton.isEnabled = false
                finishButton2.isEnabled = false
            } else {
                statusLoadingIndicator.stop()
                statusLoadingIndicator.isHidden = true
                finishButton.isEnabled = true
                finishButton2.isEnabled = true
            }
        }
    }
    
    // payment menu at bottom of view
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var paymentMenuTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentMenuView: UIView!
    @IBOutlet weak var checkboxAlipay: UIView!
    @IBOutlet weak var checkboxWechatPay: UIView!
    @IBOutlet weak var gotoPaymentButton: UIButton!
    
    var checkAlipay: M13Checkbox?
    var checkWechat: M13Checkbox?
    
    let toShipperViewSegue = "toOtherShipperView"
    let postRateSegue = "PostRateSegue"
    
    var targetUserPhone: String?
    
    @IBAction func moreImageTapped(_ sender: Any) {
        
    }
    
    @IBAction func senderPhoneButtonTapped(_ sender: Any) {
        if let targetPhone = targetUserPhone, let url = URL(string:"tel://" + targetPhone) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func senderImageButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: toShipperViewSegue, sender: self)
    }
    
    @IBAction func recipientPhoneCallButtonTapped(_ sender: Any) {
        if let receipientPhone = request.endAddress?.phoneNumber, let url = URL(string:"tel://" + receipientPhone) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func goToPaymentHandler(_ sender: Any) {
        WalletManager.shared.aliPayAuth(request: request)
    }
    
    @IBAction func requestStatusButtonHandler(sender: RequestTransactionButton) {
        
        let transaction = sender.transaction
        print("Transaction tapped: \(transaction.displayString())")
        
        if transaction == .allowRating {
            performSegue(withIdentifier: postRateSegue, sender: nil)
            return
        }
        
        if transaction == .shipperPay {
            showPaymentView(true)
            return
        }
        
        let tripId = trip.id
        let requestId = request.id
        let requestCategory = category
        displayAlertOkCancel(title: "确认操作", message: transaction.confirmDescString()) { [weak self] (style) in
            if style == .default {
                self?.isLoadingStatus = true
                ApiServers.shared.postRequestTransaction(requestId: requestId, tripId: tripId, transaction: transaction, completion: { (success, error, statusId) in
                    if (success) {
                        if let statusId = statusId {
                            print("New status: \(statusId)")
                            TripOrderDataStore.shared.pull(category: requestCategory, delay: 1, completion: {
                                self?.isLoadingStatus = false
                            })
                        } else {
                            debugPrint("No status found, bad call")
                            self?.isLoadingStatus = false
                        }
                    } else {
                        self?.isLoadingStatus = false
                    }
                })
            }
            self?.backgroundViewHide()
        }
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
    
    // MARK: - VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"
        navigationController?.isNavigationBarHidden = false
        setupScrollView()
        setupView()
        setupCollectionView()
        setupPaymentMenuView()
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
                print("Get phone error: \(error.localizedDescription)")
                return
            }
            if let phone = phone as? String {
                self.targetUserPhone = phone
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        b.markType = .checkmark
        b.boxType = .circle
        b.checkmarkLineWidth = 4
        b.boxLineWidth = 2
        b.tintColor = colorCheckmarkGreen // selected
        b.secondaryTintColor = UIColor.lightGray // unselected
        b.borderColor = UIColor.lightGray
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
            senderDescLabel.text = "寄件人评分"
            recipientPhoneCallButton.isHidden = false
            senderScoreWidthConstraint.constant = CGFloat(request.ownerRating * 20) //*(100/5)
            updateMapViewToShow(false) // map for sender to see carrier
            
        } else {
            profileImageString = trip.carrierImageUrl
            senderNameLabel.text = trip.carrierRealName
            senderDescLabel.text = "出行人评分"
            recipientPhoneCallButton.isHidden = true
            senderScoreWidthConstraint.constant = CGFloat(trip.carrierRating * 20) //*(100/5)
        }
        
        if let urlString = profileImageString, let imgUrl = URL(string: urlString) {
            senderImageButton.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "UserInfo"), filter: nil, progress: nil, completion: nil)
        
        } else{
            senderImageButton.setImage(#imageLiteral(resourceName: "UserInfo"), for: .normal)
        }
        
        incomeLabel.text = currency.rawValue + request.priceString()
        recipientNameLabel.text = request.endAddress?.recipientName
        recipientPhoneLabel.text = request.endAddress?.phoneNumber
        recipientAddressLabel.text = request.endAddress?.detailedAddress
        itemValueLabel.text = currency.rawValue + request.itemValue()
        itemMessageTextView.attributedText = messageAttributeText(msg: request.note)
        
        dateMonthLabel.text = trip.getMonthString()
        dateDayLabel.text = trip.getDayString()
        startAddressLabel.text = trip.startAddress?.fullAddressString()
        endAddressLabel.text = trip.endAddress?.fullAddressString()
        blockerWidth.constant = UIScreen.main.bounds.width-150
        if request.images.count > 2{
            imageCountButton.setTitle("+\(request.images.count-2)", for: .normal)
        }else{
            imageCountButton.setTitle("", for: .normal)
        }
    }
    
    private func messageAttributeText(msg: String?) -> NSAttributedString {
        var m = "TA还没有写留言"
        if let getMsg = msg {
            m = getMsg
        }
        let title = "留言："
        let titleAtt = NSMutableAttributedString(string: title, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        let msgAtt = NSMutableAttributedString(string: m, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        titleAtt.append(msgAtt)
        return titleAtt
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: Notification.Name.Alipay.PaymentProcessed, object: nil, queue: nil) { [weak self] (notification) in
            if let status = notification.object as? AliPayResultStatus {
                if status == .success || status == .processing {
                    self?.displayAlert(title: "支付成功", message: status.statusDescription(), action: "好", completion: { [weak self] _ in
                        guard let strongSelf = self else { return }
                        
                        self?.backgroundViewHide()
                        
                        let tripId = strongSelf.trip.id
                        let requestId = strongSelf.request.id
                        let requestCategory = strongSelf.category
                        ApiServers.shared.postRequestTransaction(requestId: requestId, tripId: tripId, transaction: .shipperPay, completion: { (success, error, statusId) in
                            if (success) {
                                if let statusId = statusId {
                                    print("New status: \(statusId)")
                                    TripOrderDataStore.shared.pull(category: requestCategory, completion: nil)
                                } else {
                                    debugPrint("No status found, bad call")
                                }
                            }
                        })
                    })
                    
                } else {
                    self?.displayAlert(title: "支付失败", message: status.statusDescription(), action: "好")
                }
                
            } else {
                self?.displayAlert(title: "支付失败", message: "未知错误", action: "好")
            }
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.TripOrderStore.StoreUpdated,
                                               object: nil, queue: nil, using: { [weak self] (notification) in
                                                self?.reloadData()
        })
    }
    
    private func reloadData() {
        if let updatedRequest = TripOrderDataStore.shared.getRequest(category: category, requestId: self.request.id) {
            request = updatedRequest
            setupView()
        }
    }
    
    private func showPaymentView(_ isShown: Bool) {
        let offset: CGFloat = isShown ? paymentMenuView.bounds.height : -paymentMenuView.bounds.height
        paymentMenuTopConstraint.constant = offset
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.6, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        if offset > 0 {
            backgroundView.isHidden = false
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.backgroundView.alpha = 1
            }, completion: nil)
        }
    }
    
    public func backgroundViewHide(){
        showPaymentView(false)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
        }) { (complete) in
            if complete {
                self.backgroundView.isHidden = true
            }
        }
    }
    
    public func checkBoxDidChanged(_ checkBox: M13Checkbox){
        if checkBox.checkState == .unchecked {
            checkBox.checkState = .checked
        }
        if checkBox == checkAlipay {
            paymentType = .alipay
        }
        if checkBox == checkWechat {
            paymentType = .wechatPay
        }
    }
    
    private func paymentTypeDidChanged(){
        let aliState:    M13Checkbox.CheckState = (paymentType == .alipay)    ? .checked : .unchecked
        let wechatState: M13Checkbox.CheckState = (paymentType == .wechatPay) ? .checked : .unchecked
        checkAlipay?.setCheckState(aliState, animated: true)
        checkWechat?.setCheckState(wechatState, animated: true)
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
            case .inDelivery:
                updateMapViewToShow(true) // map for sender to see carrier
            case .delivered:
                finishButton.transaction = .shipperConfirm
            case .deliveryConfirmed:
                finishButton.transaction = .allowRating
            default:
                break
            }
        }
        
        //Stop user for leaving comment if it's been commented
        if request.isCommented == 1 && finishButton.transaction == .allowRating {
            finishButton.isUserInteractionEnabled = false
            finishButton.alpha = 0.3
        } else {
            finishButton.isUserInteractionEnabled = true
            finishButton.alpha = 1
        }
        
        //To prevent grid lock because of loading issue, re-enable button again upon
        //setting transaction
        isLoadingStatus = false
    }
    
    func updateRequestInfoAppearance(request: Request) {
        //Override
        if let statusId = request.statusId, let status = RequestStatus(rawValue: statusId) {
            updateButtonAppearance(status: status)
            updateMapViewToShow(status == .inDelivery)
            statusLabel.text = status.displayString()
            statusLabel.backgroundColor = status.displayColor(category: category)
        }
    }
    
    fileprivate func updateMapViewToShow(_ showMap: Bool){
        finishButtonStackViewHeighConstraint.constant = showMap ? 0 : 44
        mapViewHeighConstraint.constant = showMap ? mapView.bounds.width * 0.56 : 0 // 9:16 = 0.56
        print("done, now buton heigh = \(finishButtonStackViewHeighConstraint.constant), mapHeight = \(mapViewHeighConstraint.constant)")
        DispatchQueue.main.async {
            self.view.layoutIfNeeded()
        }
        if showMap {
            zoomToUserLocation()
        }
    }
}


extension OrdersRequestDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return request.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoBrowserCollectionViewCell.defalutId, for: indexPath) as! PhotoBrowserCollectionViewCell
        cell.imageView.af_setImage(withURL: URL(string: request.images[indexPath.row].imageUrl)!)
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
            vc.pageControlDelegate = PhotoBrowserDefaultPageControlDelegate(numberOfPages: request.images.count)
        } else {
            vc.pageControlDelegate = PhotoBrowserNumberPageControlDelegate(numberOfPages: request.images.count)
        }
        vc.show(index: indexPath.item)
    }
}
    
    
// 实现浏览器代理协议
extension OrdersRequestDetailViewController: PhotoBrowserDelegate {
    
    func numberOfPhotos(in photoBrowser: PhotoBrowser) -> Int {
        return request.images.count
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
    
    
    /// 最高清图，原图。（需要时可实现本方法）
    /*
     func photoBrowser(_ photoBrowser: PhotoBrowser, rawUrlForIndex index: Int) -> URL? {
     return nil
     // 测试
     return index == 2 ? URL(string: "https://b-ssl.duitang.com/uploads/item/201501/28/20150128173439_RK4XS.jpeg") : nil
     }*/
    
    /// 长按图片
    func photoBrowser(_ photoBrowser: PhotoBrowser, didLongPressForIndex index: Int, image: UIImage) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let saveImageAction = UIAlertAction(title: "保存图片", style: .default) { (_) in
            print("保存图片：\(image)")
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
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


// MARK: - Map delegate

extension OrdersRequestDetailViewController: CLLocationManagerDelegate {
    
    func zoomToUserLocation(){
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        // zoom in to user location
        guard let loc = locationManager.location?.coordinate else { return }
        let viewRegion = MKCoordinateRegionMakeWithDistance(loc, 600, 600)
        mapView.setRegion(viewRegion, animated: false)
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            //print("update location: \(location)") // will do update every 1sec
            let span = MKCoordinateSpanMake(0.03, 0.03)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get errrorroro HomePageController++ locationManager didFailWithError: \(error)")
        displayAlert(title: "‼️无法获取GPS", message: "定位失败，请打开您的GPS。错误信息：\(error)", action: "朕知道了")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("TODO: updateSearchResults...")
    }
    func targetCurrentLocBtnTapped(){
        locationManager.startUpdatingLocation()
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


// setup pin on the Map: MKMapViewDelegate, setup pin and its callout view
extension OrdersRequestDetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil //return nil so map view draws "blue dot" for standard user location
        }
        // Customized pinView:
//        let reusePinId = "HomeMapPinId"
//        //        let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePinId, for: annotation)
//        //        pinView.tintColor = .orange
//        //        pinView.canShowCallout = true
//
//        var pinView: MKAnnotationView?
//        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePinId) {
//            pinView = dequeuedAnnotationView
//            pinView?.annotation = annotation
//        }else {
//            pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reusePinId)
//            pinView?.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        // customize annotationView image
//        pinView?.canShowCallout = true
//        //pinView?.image = #imageLiteral(resourceName: "CarryonEx_Wechat_Icon")
//
//        // add left button on info view of pin
//        //        let sz = CGSize(width: 30, height: 30)
//        //        let button = UIButton(frame: CGRect(origin: .zero, size: sz))
//        //        button.setBackgroundImage(#imageLiteral(resourceName: "CarryonEx_A"), for: .normal)
//        //        //button.addTarget(self, action: #selector(getDirections), for: .touchUpInside) // driving nav API
//        //        pinView?.leftCalloutAccessoryView = button
//
//        return pinView
        return nil
    }
}
