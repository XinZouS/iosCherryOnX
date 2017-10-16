//
//  HomePageController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import MapKit



/**
 for textField and keyboard control;
 */
extension HomePageController: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //searchTextField.becomeFirstResponder()
        tableViewHeightConstraint?.constant = tableViewHeigh
        print("--------textFieldDidBeginEditing----------")
        animateTableView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tableViewHeightConstraint?.constant = 0
        print("--------textFieldDidEndEditing----------")
        animateTableView()
    }
    
    private func animateTableView(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.6, options: .curveEaseIn, animations: { 
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self.view)
        let sideMargin: CGFloat = 40  // margin in setupSearchContents()
        let topMargin : CGFloat = 90
        //print("touch location = \(location)")
        if location.x < sideMargin || location.x > UIScreen.main.bounds.width - sideMargin || location.y < topMargin {
            searchTextField.resignFirstResponder()
        }
    }
    
}

//extension HomePageController: UITableViewDelegate, UITableViewDataSource {
//    
//    // MARK: - Table view data source
//
//    func searchButtonTapped(){
//        print("searchButtonTapped!!!")
//    }
//    
//    
//    func setupSearchTableView(){
//        tableView.register(HomePageTableCell.self, forCellReuseIdentifier: searchCellId)
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return searchFilteredResult.count != 0 ? searchFilteredResult.count : searchDataPool.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: searchCellId, for: indexPath)
//        
//        if searchFilteredResult.count > 0 {
//            cell.textLabel?.text = searchFilteredResult[indexPath.row]
//        } else {
//            cell.textLabel?.text = searchDataPool[indexPath.row]
//        }
//        return cell
//    }
//}


extension HomePageController {
    
    // MARK: - Save user into local disk
    
    internal func saveUserIntoLocalDisk(){
        if User.shared.phone != nil && User.shared.id != nil {
            User.shared.saveIntoLocalDisk()
        }
    }
    
    internal func fetchUserFromLocalDiskAndSetup(){
        User.shared.loadFromLocalDisk()
    }
    
    internal func removeUserFromLocalDisk(){
        User.shared.removeFromLocalDisk()
    }
    

    
    /// MUST check if user isVerified
    
    func callShipperButtonTapped(){
        if User.shared.isVerified {
            let isShipper = User.shared.isShipper
            if isShipper! {
                let postTripCtl = PostTripController(collectionViewLayout: UICollectionViewFlowLayout())
                navigationController?.pushViewController(postTripCtl, animated: true)
            }else{
                let itemTypeListCtl = ItemTypeListController(collectionViewLayout: UICollectionViewFlowLayout())
                navigationController?.pushViewController(itemTypeListCtl, animated: true)
            }
        }else{
            let photoIdCtl = PhotoIDController()
//            let verifyNvg = UINavigationController(rootViewController: verifyView) // for single page
//            present(verifyNvg, animated: false, completion: nil)
            photoIdCtl.homePageController = self
            navigationController?.pushViewController(photoIdCtl, animated: true) // for navigation page
        }
    }
    
    /// MARK: - for development use only:
    func gotoItemTypePage(){
        let itemTypeListCtl = ItemTypeListController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(itemTypeListCtl, animated: true)
    }
    func gotoIDPage(){
        let p = PhotoIDController()
        p.homePageController = self
        navigationController?.pushViewController(p, animated: true) // for navigation page
    }
    func gotoConfirmPage(){
        navigationController?.pushViewController(ConfirmBaseController(), animated: true)
    }
    func showNewRequestAlert(){
        let request = Request.fakeRequestDemo() // new Request from server,
        /// -TODO: setup new request info and present to shipper:
        print("TODO: setup new request info and present to shipper")
        
        var itemString: NSMutableString = ""
        for m in request.numberOfItem {
            let name = m.key
            let num = m.value
            itemString.append("\(name)x\(num), ")
        }
        request.expectDeliveryTime = Date()
        request.departureAddress = Address()   //TODO: for test only
        request.destinationAddress = Address() //TODO: for test only
        let dpt = "\(request.departureAddress!.country.rawValue), \(request.departureAddress!.state), \(request.departureAddress!.city)"
        let des = "\(request.destinationAddress!.country.rawValue), \(request.destinationAddress!.state), \(request.destinationAddress!.city)"
        let pic = "\(request.departureAddress!.city), \(request.departureAddress!.detailAddress)"
        let exp = "\(request.expectDeliveryTime!.description)"
        let msg = "运费：$66，货物（\(itemString)）从 \(dpt) 出发到 \(des) ，取货地点 \(pic), 期望到达时间：\(exp)"
        let alertCtl = UIAlertController(title: "订单编号666666", message: msg, preferredStyle: .alert)
        
        let actionCancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            print("TODO: !!!!! shipper pass this request, send to server and find next!")
            self.dismiss(animated: true, completion: nil)
        }
        let actionConfirmTime = UIAlertAction(title: "确认时间", style: .default) { (action) in
            print("TODO: !!!!! shipper take this request, go to confirmTime controller!")
            self.dismiss(animated: true, completion: nil)
            
            let timeAvailableController = TimeAvailableController()
            timeAvailableController.request = request
            self.navigationController?.pushViewController(timeAvailableController, animated: true)

        }
        alertCtl.addAction(actionCancel)
        alertCtl.addAction(actionConfirmTime)
        
        present(alertCtl, animated: true, completion: nil)
    }
    func showOnboardingPage(){
        UserDefaults.standard.set(false, forKey: "OnboardingFinished")
        self.present(OnboardingController(), animated: true, completion: nil)
    }
    
    
    
    func showUserInfoSideMenu(){
        
        let userInfoVC = UserInfoViewController(collectionViewLayout: UICollectionViewFlowLayout())
//        navigationController?.pushViewController(userInfoVC, animated: true)
        // replace above by custimize transit animation:
        title = "  " //for change "< Back" as "<"
        navigationController?.pushViewController(userInfoVC, animated: true)
        
        // plan A: with slide-out menu
        //self.pageContainer?.toggleLeftPanel()
    }
    
    func showGiftController(){
        present(WaitingController(), animated: true, completion: nil)
    }
    
    func pullSideButtonTapped(){
        let layout = UICollectionViewFlowLayout()
        let ordersLogCtl = OrdersLogController(collectionViewLayout: layout)
        navigationController?.pushViewController(ordersLogCtl, animated: true)
    }
    
//    internal func switchUserType(){
//        let s = User.shared.isShipper!
//        User.shared.isShipper = !s
//
//        setupUIContentsForUserIsShipperOrNot()
//        flipPageHorizontally()
//    }
    internal func switchToSender(){
        User.shared.isShipper = false
        setupUIContentsForUserIsShipperOrNot()
        flipPageHorizontally()
    }
    internal func switchToShiper(){
        User.shared.isShipper = true
        setupUIContentsForUserIsShipperOrNot()
        flipPageHorizontally()
    }
    
    internal func setupUIContentsForUserIsShipperOrNot(){
        let s = User.shared.isShipper!
        changeTextTo(isShipper: s)
//        changeImageTo(isShipper: s)
    }
    internal func setupSwitchUserTypeBtnTitle(str: String){
        let attriStr = NSMutableAttributedString(string: str, attributes: switchUserTypeAttributes)
        switchUserTypeButton.setAttributedTitle(attriStr, for: .normal)
    }
    // for text and button image
    private func changeTextTo(isShipper: Bool){
        let uStr = isShipper ? btnTitleShipForMe : btnTitleShipForYou
        setupSwitchUserTypeBtnTitle(str: uStr)
        print("now I am a shipper == \(User.shared.isShipper), I can change to \(uStr)")
    }
//    private func changeImageTo(isShipper: Bool){
//        let newImgSideBtn : UIImage = isShipper ? #imageLiteral(resourceName: "CarryonEx_B") : #imageLiteral(resourceName: "CarryonEx_A")
//        let newImgMainBtn : UIImage = isShipper ? #imageLiteral(resourceName: "CarryonEx_Transportation") : #imageLiteral(resourceName: "CarryonEx_Logo")
//        pullSideBtnViewButton.setImage(newImgSideBtn, for: .normal)
//        callShipperButton.setImage(newImgMainBtn, for: .normal)
//    }

    private func flipPageHorizontally(){
        var rotate3D = CATransform3DIdentity
        rotate3D.m34 = 1.0 / -1000
        rotate3D = CATransform3DRotate(rotate3D, CGFloat(M_PI / 0.3), 0.0, 1.0, 0.0)
        view.layer.transform = rotate3D
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.6, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layer.transform = CATransform3DIdentity
        }, completion: nil)
    }

    
    private func pushViewFromLeftToRight(destVC: UIViewController){
        // push navigationController from left-->right
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.25
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.pushViewController(destVC, animated: false)
    }
    
    func setupSwipGestureRecognizer(){
        let swipLeft = UISwipeGestureRecognizer(target: sideButtonContainerView, action: #selector(swiped))
        
        let swipRight = UISwipeGestureRecognizer(target: sideButtonContainerView, action: #selector(swiped))
    }

    func swiped(_ gesture: UIGestureRecognizer){
        guard let swipeGesture = gesture as? UISwipeGestureRecognizer else { return }
        
        switch swipeGesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            pullSideButtonTapped()
        case UISwipeGestureRecognizerDirection.right:
            pullSideButtonTapped()
        default:
            break
        }
    }
}

// MARK: - Map setup
extension HomePageController: CLLocationManagerDelegate, HandleMapSearch {
    
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
extension HomePageController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil //return nil so map view draws "blue dot" for standard user location
        }
//        let reusePinId = "HomeMapPinId"
////        let pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePinId, for: annotation)
////        pinView.tintColor = .orange
////        pinView.canShowCallout = true
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
////        let sz = CGSize(width: 30, height: 30)
////        let button = UIButton(frame: CGRect(origin: .zero, size: sz))
////        button.setBackgroundImage(#imageLiteral(resourceName: "CarryonEx_A"), for: .normal)
////        //button.addTarget(self, action: #selector(getDirections), for: .touchUpInside) // driving nav API
////        pinView?.leftCalloutAccessoryView = button
//
//        return pinView
        return nil
    }
    
}

//extension HomePageController : UISearchBarDelegate { // need open delegate in HomeController::ViewDidLoad()
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        animateSearchContainerWhen(isBeginEditing: true)
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        animateSearchContainerWhen(isBeginEditing: false)
//    }
//    
//    private func animateSearchContainerWhen(isBeginEditing: Bool) {
//        searchContainerTopConstraint.constant = isBeginEditing ? 0 : searchContentTopMargin
//        searchContainerLeftConstraint.constant = isBeginEditing ? 0 : searchContentSideMargin
//        searchContainerRightConstraint.constant = isBeginEditing ? 0 : -searchContentSideMargin
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: { 
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
//    
//}

// MARK: - Pop alert view
extension HomePageController {
    
    func showAlertFromPhotoIdController(){
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.showAlertFromPhotoIdAfterDelay), userInfo: nil, repeats: false)
    }
    
    internal func showAlertFromPhotoIdAfterDelay(){
        DispatchQueue.main.async { 
            let msg = "已成功上传您的证件照片，我们将尽快审核，谢谢！若有问题我们将会短信通知您。现在继续发现旅程吧😊"
            self.displayAlert(title: "✅上传完成", message: msg, action: "朕知道了")
        }
    }
    
    func displayAlert(title: String, message: String, action: String) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        v.addAction(action)
        present(v, animated: true, completion: nil)
    }
    
}




