//
//  HomePageController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import MapKit

import Photos

import AWSCognito
import AWSCore
import AWSS3

import ALCameraViewController



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

extension HomePageController {
    
    /// MUST check if user isVerified
    func callShipperButtonTapped(){
        var verified = false
        
        if let profileUser = ProfileManager.shared.getCurrentUser() {
            verified = profileUser.isIdVerified
        }
        
        if verified {
            let postTripCtl = PostTripController(collectionViewLayout: UICollectionViewFlowLayout())
            let navigationPostTrip = UINavigationController(rootViewController: postTripCtl)
            self.present(navigationPostTrip, animated: true, completion: nil)
            
        } else {
            let photoIdCtl = PhotoIDController()
            photoIdCtl.homePageController = self
            let navigationPhotoId = UINavigationController(rootViewController: photoIdCtl)
            self.present(navigationPhotoId, animated: true, completion: nil)
        }
    }
    
    /// MARK: - for development use only:
    func gotoItemTypePage(){
        let ItemListYouxiangInputCtl = ItemListYouxiangInputController()
        let navigationItemTypeList = UINavigationController(rootViewController: ItemListYouxiangInputCtl)
        self.present(navigationItemTypeList, animated: true, completion: nil)
    }
    func gotoTripPage(){
        let postTripCtl = PostTripController(collectionViewLayout: UICollectionViewFlowLayout())
        let navTrip = UINavigationController(rootViewController: postTripCtl)
        present(navTrip, animated: true, completion: nil)
    }
    func gotoIDPage(){
        let p = PhotoIDController()
        p.homePageController = self
        //navigationController?.pushViewController(p, animated: true) // for navigation page
        let navigationIdPage = UINavigationController(rootViewController: p)
        self.present(navigationIdPage, animated: true, completion: nil)
    }
    func gotoConfirmPage(){
        //navigationController?.pushViewController(ConfirmBaseController(), animated: true)
        self.present(ConfirmBaseController(), animated: true, completion: nil)
    }
    func showNewRequestAlert(){
        let request = Request.fakeRequestDemo() // new Request from server,
        /// -TODO: setup new request info and present to shipper:
        print("TODO: setup new request info and present to shipper")
        
        let itemString: NSMutableString = ""
        for m in request.numberOfItem {
            let name = m.key
            let num = m.value
            itemString.append("\(name)x\(num), ")
        }
        request.departureAddress = Address()   //TODO: for test only
        request.destinationAddress = Address() //TODO: for test only
        
        if let departAddr = request.departureAddress, let destinationAddr = request.destinationAddress {
            if let dptCountry = departAddr.country,
                let dptSate = departAddr.state,
                let dptCity = departAddr.city,
                let destinCountry = destinationAddr.country,
                let destinSate = destinationAddr.state,
                let destinCity = destinationAddr.city,
                let dptDetailAddr = departAddr.detailAddress
            {
                let dpt = "\(dptCountry.rawValue), \(dptSate), \(dptCity)"
                let des = "\(destinCountry.rawValue), \(destinSate), \(destinCity)"
                let pic = "\(dptCity), \(dptDetailAddr)"
                let msg = "运费：$66，货物（\(itemString)）从 \(dpt) 出发到 \(des) ，取货地点 \(pic)" //, 期望到达时间：\(exp)"
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
                    //self.navigationController?.pushViewController(timeAvailableController, animated: true)
                    self.present(timeAvailableController, animated: true, completion: nil)
                }
                alertCtl.addAction(actionCancel)
                alertCtl.addAction(actionConfirmTime)
                
                present(alertCtl, animated: true, completion: nil)
            }
        }
    }
    
//    private func showOnboardingPage(){
//        UserDefaults.standard.set(false, forKey: "OnboardingFinished")
//        self.present(OnboardingController(), animated: true, completion: nil)
//    }
    
    func showUserInfoSideMenu(){
        
        // plan C: use UIView for the menu, without navigationBar
        userInfoMenuViewAnimateShow()
        
        // plan B: use single page for the menu, with navigationBar
        //let userInfoVC = UserInfoViewController(collectionViewLayout: UICollectionViewFlowLayout())
        //navigationItem.title = "  " //for change "< Back" as "<"
        //navigationController?.pushViewController(userInfoVC, animated: true)
        
        // plan A: with slide-out menu
        //self.pageContainer?.toggleLeftPanel()
    }
    
    private func userInfoMenuViewAnimateShow(){
        let offset = userInfoMenuView.bounds.width
        self.userInfoMenuRightConstraint?.constant = offset
        self.backgroundBlackView.isHidden = false
        self.backgroundBlackView.backgroundColor = UIColor(white: 0, alpha: 0)
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.backgroundBlackView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func userInfoMenuViewAnimateHide(){
        self.userInfoMenuRightConstraint?.constant = 0
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1.2, options: .curveEaseIn, animations: {
            self.backgroundBlackView.backgroundColor = UIColor(white: 0, alpha: 0)
            self.view.layoutIfNeeded()
        }, completion: { (finished) in
            if finished {
                self.backgroundBlackView.isHidden = true
            }
        })
    }
    
    func showGiftController(){
        present(WaitingController(), animated: true, completion: nil)
    }
    
    func pullSideButtonTapped(){
//        let waitingListCtl = WaitingListController(collectionViewLayout: UICollectionViewFlowLayout())
//        let waitingListView = UINavigationController(rootViewController: waitingListCtl)
//        self.present(waitingListView, animated: true, completion: nil)
        // replaced by OrdersLogController() ---------------------------
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let ordersLogCtl = OrdersLogController(collectionViewLayout: layout)
        let ordersNav = UINavigationController(rootViewController: ordersLogCtl)
        ordersNav.title = "我的游箱"
        self.present(ordersNav, animated: true)
    }
    
    private func flipPageHorizontally(){
        var rotate3D = CATransform3DIdentity
        rotate3D.m34 = 1.0 / -1000
        rotate3D = CATransform3DRotate(rotate3D, CGFloat(Double.pi / 0.3), 0.0, 1.0, 0.0)
        view.layer.transform = rotate3D
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.6, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.view.layer.transform = CATransform3DIdentity
        }, completion: nil)
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



/// for user image selection and upload to AWS
extension HomePageController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func profileImageButtonTapped(){
        let attachmentMenu = UIAlertController(title: "选择图片来源", message: "从相册选择头像或现在拍一张吧", preferredStyle: .actionSheet)
        let openLibrary = UIAlertAction(title: "相册选择", style: .default) { (action) in
            self.openImagePickerWith(source: .photoLibrary, isAllowEditing: true)
        }
        let openCamera = UIAlertAction(title: "打开相机", style: .default) { (action) in
            self.openImagePickerWith(source: .camera, isAllowEditing: true)
        }
        let wechatLogin = UIAlertAction(title: "微信获得信息", style: .default) { (action) in
            self.wechatButtonTapped()
        }
        let cancelSelect = UIAlertAction(title: "取消", style: .cancel) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        attachmentMenu.addAction(openLibrary)
        attachmentMenu.addAction(openCamera)
         attachmentMenu.addAction(wechatLogin)
        attachmentMenu.addAction(cancelSelect)
        
        present(attachmentMenu, animated: true, completion: nil)
    }
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            //activityIndicator.startAnimating()
            userInfoMenuView.userProfileView.setupProfileImage(editedImage)
            if let localUrl = info[UIImagePickerControllerReferenceURL] as? URL {
                uploadProfileImageToAws(assetUrl: localUrl, image: editedImage)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    internal func openImagePickerWith(source: UIImagePickerControllerSourceType, isAllowEditing: Bool){
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = source
        imagePicker.allowsEditing = isAllowEditing
        imagePicker.delegate = self
        imagePicker.navigationBar.isTranslucent = false
        imagePicker.navigationBar.barTintColor = barColorGray // Background color
        imagePicker.navigationBar.tintColor = .white // Cancel button ~ any UITabBarButton items
        imagePicker.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white] // Title color
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func saveImageToDocumentDirectory(img : UIImage, idType: ImageTypeOfID) -> URL {
        let documentUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(idType.rawValue).JPG" // UserDefaultKey.profileImageLocalName.rawValue
        let profileImgLocalUrl = documentUrl.appendingPathComponent(fileName)
        if let imgData = UIImageJPEGRepresentation(img, imageCompress) {
            try? imgData.write(to: profileImgLocalUrl, options: .atomic)
        }
        print("save image to DocumentDirectory: \(profileImgLocalUrl)")
        return profileImgLocalUrl
    }
    
    func removeImageWithUrlInLocalFileDirectory(fileName: String){
        let fileType = fileName.components(separatedBy: ".").first!
        if fileType == ImageTypeOfID.profile.rawValue { return }
        
        let fileManager = FileManager.default
        let documentUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        if let filePath = documentUrl.path {
            print("try to remove file from path: \(filePath), fileExistsAtPath==\(fileManager.fileExists(atPath: filePath))")
            do {
                try fileManager.removeItem(atPath: "\(filePath)/\(fileName)")
                print("OK remove file at path: \(filePath), fileName = \(fileName)")
            } catch let err {
                print("error : when trying to move file: \(fileName), from path = \(filePath), get err = \(err)")
            }
        }
    }

    // MARK: - AWS S3 storage for profile image
    
    private func uploadProfileImageToAws(assetUrl: URL, image: UIImage){
        
        guard let userId = ProfileManager.shared.getCurrentUser()?.id else { return }

        let assets = PHAsset.fetchAssets(withALAssetURLs: [assetUrl], options: nil)
        let fileName = PHAssetResource.assetResources(for: assets.firstObject!).first!.originalFilename
        
        // Configure aws cognito credentials:
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USWest2, identityPoolId: awsIdentityPoolId)
        let configuration = AWSServiceConfiguration(region:.USWest2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        // setup AWS Transfer Manager Request:
        guard let uploadRequest = AWSS3TransferManagerUploadRequest() else { return }
        uploadRequest.acl = .publicReadWrite
        uploadRequest.key = fileName // MUST NOT change this!!
        uploadRequest.body = userInfoMenuView.userProfileView.saveProfileImageToLocalFile(image: image)
        uploadRequest.bucket = "\(awsPublicBucketName)/userProfileImages/\(userId)" // no / at the end of bucket
        uploadRequest.contentType = "image/jpeg"
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(uploadRequest).continueWith { (task: AWSTask) -> Any? in
            
            if let err = task.error {
                print("performFileUpload(): task.error = \(err)")
                //self.activityIndicator.stopAnimating()
                self.displayAlert(title: "⛔️上传失败", message: "出现错误：\(err)， 请稍后重试。", action: "换个姿势再来一次")
                return nil
            }
            if task.result != nil {
                let url = AWSS3.default().configuration.endpoint.url
                
                if let bucket = uploadRequest.bucket,
                    let key = uploadRequest.key,
                    let publicURL = url?.appendingPathComponent(bucket).appendingPathComponent(key) {
                    ProfileManager.shared.updateUserInfo(.imageUrl, value: publicURL.absoluteString, completion: nil)
                }
            }else{
                print("errrorrr!!! task.result is nil, !!!! did not upload")
            }
            
            //DispatchQueue.main.async {
            //self.activityIndicator.stopAnimating()
            //let msg = "已成功上传您的证件照片，我们将尽快审核，谢谢！若有问题我们将会短信通知您。现在继续发现旅程吧😊"
            //self.displayAlert(title: "✅上传完成", message: msg, action: "朕知道了")
            //}
            return nil
        }
        
    }
    
    
}


// WECHAT lOGIN
extension HomePageController {

    func wechatButtonTapped(){
        let urlStr = "weixin://"
        if UIApplication.shared.canOpenURL(URL.init(string: urlStr)!) {
            let red = SendAuthReq.init()
            red.scope = "snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact"
            red.state = "\(arc4random()%100)"
            WXApi.send(red)
        }else{
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!, options: [:], completionHandler: nil)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(URL.init(string: "http://weixin.qq.com/r/qUQVDfDEVK0rrbRu9xG7")!)
            }
        }
    }
    
    /**  获取用户信息  */
    func getUserInfo(openid:String,access_token:String) {
        let requestUrl = "https://api.weixin.qq.com/sns/userinfo?access_token=\(access_token)&openid=\(openid)"
        
        DispatchQueue.global().async {
            
            let requestURL: URL = URL.init(string: requestUrl)!
            let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
            
            DispatchQueue.main.async {
                let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                print(jsonResult)
                if let imgUrl = jsonResult["headimgurl"] as? String {
                    ProfileManager.shared.updateUserInfo(.imageUrl, value: imgUrl, completion: { (success) in
                        if success {
                            self.userInfoMenuView.userProfileView.setupWechatImg()
                        }
                    })
                }
                
                if let realName = jsonResult["nickname"] as? String {
                    ProfileManager.shared.updateUserInfo(.realName, value: realName, completion: { (success) in
                        if success {
                            self.userInfoMenuView.userProfileView.setupWechatRealName()
                        }
                    })
                }
            }
        }
    }
    
}
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
}




