//
//  UserProfileController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/13.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit
import AlamofireImage
import CoreLocation
import Stripe

class UserProfileController: NewHomePageController,CLLocationManagerDelegate,STPPaymentContextDelegate{
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userProfileImageBtn: UIButton!
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var shiperButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var circle: UIImageView!
    var locationManager : CLLocationManager!
    var currLocation : CLLocation!
    private let customerContext: STPCustomerContext
    private let paymentContext: STPPaymentContext
    
    private enum RideRequestState {
        case none
        case requesting
        case active(Ride)
    }
    private var rideRequestState: RideRequestState = .none {
        didSet {
//            reloadRequestRideButton()
        }
    }
    
    private var price = 0 {
        didSet {
            // Forward value to payment context
            paymentContext.paymentAmount = price
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        customerContext = STPCustomerContext(keyProvider: MainAPIClient.shared)
        paymentContext = STPPaymentContext(customerContext: customerContext)
        
        super.init(coder: aDecoder)
        
        paymentContext.delegate = self
        paymentContext.hostViewController = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserUpdateNotificationObservers()
        setupLocation()
        setupActivityIndicator()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUserImageView()
    }
    private func addUserUpdateNotificationObservers(){
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.loadUserProfile()
    }
    func loadUserProfile(){
        guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
        if let imageUrlString = currUser.imageUrl, let imgUrl = URL(string: imageUrlString) {
            URLCache.shared.removeAllCachedResponses()
            userProfileImageBtn.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "carryonex_UserInfo"), filter: nil, progress: nil, completion: nil)
        } else {
            userProfileImageBtn.setImage(#imageLiteral(resourceName: "carryonex_UserInfo"), for: .normal)
        }
        if let currUserName  = currUser.realName,currUserName != ""{
            var greeting = "你好"
            switch timeStatus {
            case "night":
                greeting = "晚上好，"
            case "afternoon":
                greeting = "下午好，"
            case "noon":
                greeting = "中午好，"
            default:
                greeting = "早上好，"
            }
            let labelDisplay = greeting+currUserName
            helloLabel.text = labelDisplay
        }
    private func addNotificationObservers() {
        
        /**  微信通知  */
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue:"WXLoginSuccessNotification"), object: nil, queue: nil) { [weak self] notification in
            
            let code = notification.object as! String
            let requestUrl = "https://api.weixin.qq.com/sns/oauth2/access_token?appid=\(WX_APPID)&secret=\(WX_APPSecret)&code=\(code)&grant_type=authorization_code"
            
            DispatchQueue.global().async {
                let requestURL: URL = URL.init(string: requestUrl)!
                let data = try? Data.init(contentsOf: requestURL, options: Data.ReadingOptions())
                DispatchQueue.main.async {
                    let jsonResult = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,Any>
                    let openid: String = jsonResult["openid"] as! String
                    let access_token: String = jsonResult["access_token"] as! String
                    switch wxloginStatus{
                    case "WXregister":
                        self?.loginViewCtl.makeUserRegister(openid: openid, access_token: access_token)
                    default:
                        self?.getUserInfo(openid: openid, access_token: access_token)
                    }
                }
            }
        }
    }
    
    private func setupLocation(){
        //初始化位置管理器
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //设备使用电池供电时最高的精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //精确到1000米,距离过滤器，定义了设备移动后获得位置信息的最小距离
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        if ios8() {
            //如果是IOS8及以上版本需调用这个方法
            locationManager.requestAlwaysAuthorization()
            //使用应用程序期间允许访问位置数据
            locationManager.requestWhenInUseAuthorization();
            //启动定位
            locationManager.startUpdatingLocation()
        }
    }
    //FIXME: CoreLocationManagerDelegate 中获取到位置信息的处理函数
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //取得locations数组的最后一个
        let location:CLLocation = locations[locations.count-1]
        currLocation = locations.last!
        //判断是否为空
        if(location.horizontalAccuracy > 0){
            let lat = Double(String(format: "%.1f", location.coordinate.latitude))
            let long = Double(String(format: "%.1f", location.coordinate.longitude))
            print("纬度:\(long!)")
            print("经度:\(lat!)")
            LonLatToCity()
            //停止定位
            locationManager.stopUpdatingLocation()
        }
    }
    
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            if(error == nil)
            {
                let array = placemark! as NSArray
                let mark = array.firstObject as! CLPlacemark
                //城市
                let city: String = (mark.addressDictionary! as NSDictionary).value(forKey: "City") as! String
                //国家
                let country: NSString = (mark.addressDictionary! as NSDictionary).value(forKey: "Country") as! NSString

                let State: String = (mark.addressDictionary! as NSDictionary).value(forKey: "State") as! String
                self.locationLabel.text = (country as String)+" "+State+" "+city
            }
            else
            {
                print(error ?? "")
            }
        }
    }
    
    //FIXME:  获取位置信息失败
    private func  locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    func ios8() -> Bool {
        let versionCode:String = UIDevice.current.systemVersion
        let version = NSString(string:  versionCode).doubleValue
        return version >= 8.0
    }

    private func setupUserImageView(){
        userProfileImageBtn.layer.masksToBounds = true
        userProfileImageBtn.layer.cornerRadius = CGFloat(Int(userProfileImageBtn.height)/2)
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = CGFloat(Int(circle.height)/2)
        circle.borderColor = .white
        circle.borderWidth = 2
        switch timeStatus {
        case "night":
            helloLabel.textColor = .white
        default:
            helloLabel.textColor = .black
        }
    }
    
    @IBAction func userProfileImageBtnTapped(_ sender: Any) {
        presentPaymentMethodsViewController()
    }
    @IBAction func shiperButtonTapped(_ sender: Any) {
    }
    @IBAction func senderButtonTapped(_ sender: Any) {
    }
    private func presentPaymentMethodsViewController() {
        guard !STPPaymentConfiguration.shared().publishableKey.isEmpty else {
            // Present error immediately because publishable key needs to be set
            let message = "Please assign a value to `publishableKey` before continuing. See `AppDelegate.swift`."
            present(UIAlertController(message: message), animated: true)
            return
        }
        
        guard !MainAPIClient.shared.baseURLString.isEmpty else {
            // Present error immediately because base url needs to be set
            let message = "Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`."
            present(UIAlertController(message: message), animated: true)
            return
        }
        
        // Present the Stripe payment methods view controller to enter payment details
        paymentContext.presentPaymentMethodsViewController()
    }
    private func animateActiveRide() {
        guard case .active(_) = rideRequestState else {
            // Missing active ride
            return
        }
    }
    private func reloadPaymentButtonContent() {
//                guard let selectedPaymentMethod = paymentContext.selectedPaymentMethod else {
                    // Show default image, text, and color
//                    paymentButton.setImage(#imageLiteral(resourceName: "Payment"), for: .normal)
//                    paymentButton.setTitle("Payment", for: .normal)
//                    paymentButton.setTitleColor(.riderGrayColor, for: .normal)
//                    return
//                }
        //
        //        // Show selected payment method image, label, and darker color
        //        paymentButton.setImage(selectedPaymentMethod.image, for: .normal)
        //        paymentButton.setTitle(selectedPaymentMethod.label, for: .normal)
        //        paymentButton.setTitleColor(.riderDarkBlueColor, for: .normal)
    }
    
    // MARK: STPPaymentContextDelegate
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        if let customerKeyError = error as? MainAPIClient.CustomerKeyError {
            switch customerKeyError {
            case .missingBaseURL:
                // Fail silently until base url string is set
                print("[ERROR]: Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`.")
            case .invalidResponse:
                // Use customer key specific error message
                print("[ERROR]: Missing or malformed response when attempting to `MainAPIClient.shared.createCustomerKey`. Please check internet connection and backend response formatting.");
                
                present(UIAlertController(message: "Could not retrieve customer information", retryHandler: { (action) in
                    // Retry payment context loading
                    paymentContext.retryLoading()
                }), animated: true)
            }
        }
        else {
            // Use generic error message
            print("[ERROR]: Unrecognized error while loading payment context: \(error)");
            
            present(UIAlertController(message: "Could not retrieve payment information", retryHandler: { (action) in
                // Retry payment context loading
                paymentContext.retryLoading()
            }), animated: true)
        }
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        // Reload related components
        reloadPaymentButtonContent()
//        reloadRequestRideButton()
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didCreatePaymentResult paymentResult: STPPaymentResult, completion: @escaping STPErrorBlock) {
        // Create charge using payment result
        let source = paymentResult.source.stripeID
        
        MainAPIClient.shared.requestRide(source: source, amount: price, currency: "usd") { [weak self] (ride, error) in
            guard let strongSelf = self else {
                // View controller was deallocated
                return
            }
            
            guard error == nil else {
                // Error while requesting ride
                completion(error)
                return
            }
            
            // Save ride info to display after payment finished
            strongSelf.rideRequestState = .active(ride!)
            completion(nil)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFinishWith status: STPPaymentStatus, error: Error?) {
        switch status {
        case .success:
            // Animate active ride
            animateActiveRide()
        case .error:
            // Present error to user
            if let requestRideError = error as? MainAPIClient.RequestRideError {
                switch requestRideError {
                case .missingBaseURL:
                    // Fail silently until base url string is set
                    print("[ERROR]: Please assign a value to `MainAPIClient.shared.baseURLString` before continuing. See `AppDelegate.swift`.")
                case .invalidResponse:
                    // Missing response from backend
                    print("[ERROR]: Missing or malformed response when attempting to `MainAPIClient.shared.requestRide`. Please check internet connection and backend response formatting.");
                    present(UIAlertController(message: "Could not request ride"), animated: true)
                }
            }
            else {
                // Use generic error message
                print("[ERROR]: Unrecognized error while finishing payment: \(String(describing: error))");
                present(UIAlertController(message: "Could not request ride"), animated: true)
            }
            
            // Reset ride request state
            rideRequestState = .none
        case .userCancellation:
            // Reset ride request state
            rideRequestState = .none
        }
    }
}
extension UIAlertController {
    
    /// Initialize an alert view titled "Oops" with `message` and single "OK" action with no handler
    convenience init(message: String?) {
        self.init(title: "Oops", message: message, preferredStyle: .alert)
        
        let dismissAction = UIAlertAction(title: "OK", style: .default)
        addAction(dismissAction)
        
        preferredAction = dismissAction
    }
    
    /// Initialize an alert view titled "Oops" with `message` and "Retry" / "Skip" actions
    convenience init(message: String?, retryHandler: @escaping (UIAlertAction) -> Void) {
        self.init(title: "Oops", message: message, preferredStyle: .alert)
        
        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: retryHandler)
        addAction(retryAction)
        
        let skipAction = UIAlertAction(title: "Skip", style: .default)
        addAction(skipAction)
        
        preferredAction = skipAction
    }
    
}
