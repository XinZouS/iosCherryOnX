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
    
    // payment menu at bottom of view
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var paymentMenuTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var paymentMenuView: UIView!
    @IBOutlet weak var checkboxAlipay: UIView!
    @IBOutlet weak var checkboxWechatPay: UIView!
    @IBOutlet weak var gotoPaymentButton: RequestTransactionButton!
    var checkAlipay: M13Checkbox?
    var checkWechat: M13Checkbox?
    
    
    let toShipperViewSegue = "toOtherShipperView"
    let postRateSegue = "PostRateSegue"
    
    @IBAction func moreImageTapped(_ sender: Any) {
        
    }
    
    @IBAction func senderPhoneButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func senderImageButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: toShipperViewSegue, sender: self)
    }
    
    @IBAction func recipientPhoneCallButtonTapped(_ sender: Any) {
    
    }
    
    @IBAction func PhoneButtonTapped(_ sender: Any) {        
        if let PhoneNumberUrl = recipientPhoneLabel.text,let url = URL(string:"tel://"+PhoneNumberUrl) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func requestStatusButtonHandler(sender: RequestTransactionButton) {
        let transaction = sender.transaction
        print("Transaction tapped: \(transaction.displayString())")
        
        if transaction == .allowRating {
            performSegue(withIdentifier: postRateSegue, sender: nil)
            return
        }
        if transaction == .shipperPay, paymentMenuTopConstraint.constant <= 0 {
            paymentMenuAnimateShowHide()
            return
        }
        
        let tripId = trip.id
        let requestId = request.id
        let requestCategory = category
        displayAlertOkCancel(title: "确认操作", message: transaction.confirmDescString()) { [weak self] (style) in
            if style == .default {
                ApiServers.shared.postRequestTransaction(requestId: requestId,
                                                         tripId: tripId,
                                                         transaction: transaction,
                                                         completion: { (success, error, statusId) in
                                                            if (success) {
                                                                if let statusId = statusId {
                                                                    print("New status: \(statusId)")
                                                                    TripOrderDataStore.shared.pull(category: requestCategory, completion: {
                                                                        self?.reloadData()
                                                                    })
                                                                } else {
                                                                    debugPrint("No status found, bad call")
                                                                }
                                                            }
                })
            }
        }
    }
    
    
    // MARK: - Data models
    var trip: Trip = Trip()
    
    var request: Request!
    var category: TripCategory = .carrier
    
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == postRateSegue, let viewController = segue.destination as? OrderCommentRateController {
            viewController.category = category
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
        gotoPaymentButton.transaction = .shipperPay
    }
    private func setupPaymentCheckbox(_ b: M13Checkbox){
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
            
        } else {
            profileImageString = trip.carrierImageUrl
            senderNameLabel.text = trip.carrierRealName
            senderDescLabel.text = "出行人评分"
            recipientPhoneCallButton.isHidden = true
            senderScoreWidthConstraint.constant = CGFloat(trip.carrierRating * 20) //*(100/5)
        }
        
        if let urlString = profileImageString, let imgUrl = URL(string: urlString) {
            senderImageButton.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "carryonex_UserInfo"), filter: nil, progress: nil, completion: nil)
        }else{
            senderImageButton.setImage(#imageLiteral(resourceName: "carryonex_UserInfo"), for: .normal)
        }
        
        incomeLabel.text = "$" + request.priceString()
        recipientNameLabel.text = request.endAddress?.recipientName
        recipientPhoneLabel.text = request.endAddress?.phoneNumber
        recipientAddressLabel.text = request.endAddress?.detailedAddress
        itemValueLabel.text = "$" + request.itemValue()
        itemMessageTextView.text = request.note
        
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
    
    
    private func reloadData() {
        if let updatedRequest = TripOrderDataStore.shared.getRequest(category: category, requestId: self.request.id) {
            request = updatedRequest
            setupView()
        }
    }
    
    private func paymentMenuAnimateShowHide(){
        let toShow: Bool = paymentMenuTopConstraint.constant <= 0
        let offset: CGFloat = toShow ? paymentMenuView.bounds.height : -50
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
        paymentMenuAnimateShowHide()
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.backgroundView.alpha = 0
        }) { (complete) in
            if complete {
                self.backgroundView.isHidden = true
            }
        }
    }
    
    @IBAction func checkboxValueChanged(_ sender: Any){
        switch paymentType {
        case .alipay:
            paymentType = .wechatPay
            
        case .wechatPay:
            paymentType = .alipay
            
        default:
            paymentType = .alipay
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
            case .waiting:
                buttonsToShow = .twoButtons
            case .accepted, .delivered, .paid, .inDelivery, .deliveryConfirmed: //.pendingRefund,
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
//            case .pendingRefund:
//                finishButton.transaction = .carrierReceive
            case .inDelivery:
                finishButton.transaction = .carrierShip
            case .delivered, .deliveryConfirmed:
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
        let maxY = scrollView.contentSize.height - self.view.bounds.height + 100
        if x != 0 {
            scrollView.setContentOffset(CGPoint(x: 0, y: y), animated: false)
        }
        if y < 0 || y > maxY {
            return
        }
        scrollView.setContentOffset(CGPoint(x:0, y: y), animated: false)
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



