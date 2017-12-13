//
//  NewHomePageController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/9.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import CoreLocation
import BPCircleActivityIndicator

class NewHomePageController: UIViewController, CLLocationManagerDelegate {
    
    enum TimeEnum: Int{
        case morning = 4
        case noon = 10
        case afternoon = 16
        case night = 20
    }
    
    var timeStatus: TimeEnum = TimeEnum.noon
    var gradientLayer: CAGradientLayer!
    // paramter to send to other field
    var imageurl = ""
    var realname = ""
    var isStoreUpdated: Bool = false
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userProfileImageBtn: UIButton!
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var shiperButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var circle: UIImageView!
    
    var locationManager : CLLocationManager!
    var currLocation : CLLocation!
    
    weak var userCardOne: UserCardViewController?
    weak var userCardTwo: UserCardViewController?
    weak var tripController: TripController?

    let ordersRequestDetailSegue = "OrdersRequestDetailSegue"
    
    //MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Need to put this back
        //ApiServers.shared.getConfig()
        
        setupNowHour()
        addObservers()
        setupLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        if (isStoreUpdated) {
            ProfileManager.shared.loadLocalUser(completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUserImageView()
        //checkForUpdate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "shiper"){
            if let destVC = segue.destination as? UserCardViewController {
                userCardOne = destVC
                userCardOne?.delegate = self
                destVC.category = .carrier
            }
        }
        
        if (segue.identifier == "sender"){
            if let destVC = segue.destination as? UserCardViewController {
                userCardTwo = destVC
                userCardTwo?.delegate = self
                destVC.category = .sender
            }
        }
        
        if (segue.identifier == "sender"){
            if let destVC = segue.destination as? TripController {
                tripController = destVC
            }
        }
        
        if (segue.identifier == ordersRequestDetailSegue) {
            if let viewController = segue.destination as? OrdersRequestDetailViewController {
                if let requestInfo = sender as? [String: Any] {
                    guard let request = requestInfo["request"] as? Request, let category = requestInfo["category"] as? TripCategory else { return }
                    viewController.request = request
                    viewController.category = category
                    if let trip = TripOrderDataStore.shared.getTrip(category: category, id: request.id) {
                        viewController.trip = trip
                    }
                }
            }
        }
    }
    
    
    //MARK - Helper
    
    private func setupNowHour(){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let strNowTime = timeFormatter.string(from: date) as String
        let StartIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 8)
        let endIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 9)
        let nowHour = String(strNowTime[StartIndex]) + String(strNowTime[endIndex])
        if let nowHourInt = Int(nowHour){
            if nowHourInt >= TimeEnum.night.rawValue || nowHourInt < TimeEnum.morning.rawValue { // night: 6pm->6am
                setupBackGroundColor(dayTime: .night)
                timeStatus = .night

            } else if nowHourInt >= TimeEnum.afternoon.rawValue {
                setupBackGroundColor(dayTime: .afternoon)
                timeStatus = .afternoon

            } else if nowHourInt >= TimeEnum.noon.rawValue{
                setupBackGroundColor(dayTime: .noon)
                timeStatus = .noon

            } else {
                setupBackGroundColor(dayTime: .morning)
                timeStatus = .morning
            }
        }
    }
    
    private func setupBackGroundColor(dayTime: TimeEnum){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        var beginColor = UIColor.MyTheme.nightBlue
        var endColor = UIColor.MyTheme.nightCyan
        
        switch timeStatus {
        case .morning, .afternoon:
            helloLabel.textColor = .white
            beginColor = UIColor.MyTheme.afternoonBlue
            endColor = UIColor.MyTheme.afternoonWhite
            
        case .noon:
            helloLabel.textColor = .black
            beginColor = UIColor.MyTheme.noonYellow
            endColor = UIColor.MyTheme.noonWhite

        case .night:
            helloLabel.textColor = .white
            beginColor = UIColor.MyTheme.nightBlue //darkGreen
            endColor = UIColor.MyTheme.nightCyan //purple
            
        }
        gradientLayer.startPoint = CGPoint(x: 0.1, y: 0.1)
        gradientLayer.endPoint = CGPoint(x: 1.4, y: 1.6)
        gradientLayer.colors = [beginColor.cgColor, endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.loadUserProfile()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.TripOrderStore.StoreUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.isStoreUpdated = true
            
            let topRequests = TripOrderDataStore.shared.getTopRequests()
            if topRequests.count > 0 {
                self?.userCardOne?.category = topRequests.first?.1
                self?.userCardOne?.request = topRequests.first?.0
                if topRequests.count > 1 {
                    self?.userCardTwo?.category = topRequests[1].1
                    self?.userCardTwo?.request = topRequests[1].0
                }
            }
        }
        
        NotificationCenter.default.addObserver(forName: .UserLoggedOut, object: nil, queue: nil) { [weak self] _ in
            self?.userCardOne?.category = .carrier
            self?.userCardOne?.request = nil
            
            self?.userCardTwo?.category = .carrier
            self?.userCardTwo?.request = nil
        }
    }
    
    func loadUserProfile(){
        guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
        if let imageUrlString = currUser.imageUrl, let imgUrl = URL(string: imageUrlString) {
            userProfileImageBtn.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, completion: nil)
        } else {
            userProfileImageBtn.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
        }
        if let currUserName  = currUser.realName,currUserName != ""{
            var greeting = "你好"
            //if let timeState = timeStatus { // AppDelegate.shared().mainTabViewController?.homeViewController?.timeStatus{
                switch timeStatus {
                case .night:
                    greeting = "晚上好，"
                case .afternoon:
                    greeting = "下午好，"
                case .noon:
                    greeting = "中午好，"
                default:
                    greeting = "早上好，"
                }
            //}
            let labelDisplay = greeting+currUserName
            helloLabel.text = labelDisplay
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
    
    private func checkForUpdate() {
        guard let updatedVersion = ApiServers.shared.config?.iosVersion,
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return
        }
        
        let currentVersion = version + "." + build
        if updatedVersion != currentVersion {
            print("Current: \(currentVersion), Updated to: \(updatedVersion)")
            self.displayGlobalAlertActions(title: "有新版本更新", message: "版本 \(updatedVersion) 已经推出，请往 AppStore 下载游箱最新版本。", actions: ["前往 AppStore"], completion: { (index) in
                //TODO: Update to carryonex app URL
                let appStoreLink = "https://itunes.apple.com/us/app/apple-store/id375380948?mt=8"
                if let url = URL(string: appStoreLink), UIApplication.shared.canOpenURL(url) {
                    // Attempt to open the URL.
                    UIApplication.shared.open(url, options: [:], completionHandler: {(success: Bool) in
                        if success {
                            print("Launching \(url) was successful")
                        }
                    })
                }
            })
        }
    }
    
    //MARK: - Location
    
    //FIXME: CoreLocationManagerDelegate 中获取到位置信息的处理函数
    func  locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //取得locations数组的最后一个
        if let location = locations.last {
            currLocation = location
        }
        
        if(currLocation.horizontalAccuracy > 0){
            //let lat = Double(String(format: "%.1f", location.coordinate.latitude))
            //let long = Double(String(format: "%.1f", location.coordinate.longitude))
            //print("纬度:\(long!)")
            //print("经度:\(lat!)")
            LonLatToCity()
            //停止定位
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    func LonLatToCity() {
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            if let error = error {
                print("Get location error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemark, placemark.count > 0 {
                var locationString = String()
                let mark = placemark[0]
                if let city = mark.addressDictionary?["City"] as? String {
                    locationString += city
                }
                
                if let state = mark.addressDictionary?["State"] as? String {
                    locationString += (" " + state)
                }
                
                if let country = mark.addressDictionary?["Country"] as? String {
                    locationString += (" " + country)
                }
                
                self.locationLabel.text = locationString
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
    }
    
    @IBAction func userProfileImageBtnTapped(_ sender: Any) {
    }
    
    @IBAction func shiperButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "carrierSegue", sender: self)
    }
    
    @IBAction func senderButtonTapped(_ sender: Any) {
        
    }
    
    
}

extension NewHomePageController: UserCardDelegate {
    
    func userCardTapped(sender: UIButton, request: Request, category:TripCategory) {
        let request: [String: Any] = ["request": request, "category": category]
        performSegue(withIdentifier: ordersRequestDetailSegue, sender: request)
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

