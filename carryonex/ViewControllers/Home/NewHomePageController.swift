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

extension UIColor {
    struct MyTheme {
        static var darkGreen: UIColor  { return UIColor(red: 0.1549919546, green: 0.2931276262, blue: 0.3640816808, alpha: 1) }
        static var purple: UIColor { return UIColor(red: 0.8728510737, green: 0.758017838, blue: 0.8775048256, alpha: 1) }
        static var grey : UIColor{ return UIColor(red: 0.7805191875, green: 0.7680291533, blue: 0.8010284305, alpha: 1)}
        static var littleGreen : UIColor{ return UIColor(red: 0.7296996117, green: 0.8510946035, blue: 0.8725016713, alpha: 1)}
        static var mediumGreen : UIColor{ return UIColor(red: 0.2490211129, green: 0.277058661, blue: 0.4886234403, alpha: 1)}
        static var cyan : UIColor{ return UIColor(red: 0.261000365, green: 0.6704152226, blue: 0.7383304834, alpha: 1)}
        static var darkBlue : UIColor{ return UIColor(red: 0.2614160776, green: 0.2736201882, blue: 0.4685304761, alpha: 1)}
    }
}

class NewHomePageController: UIViewController,CLLocationManagerDelegate{
    
    enum timeEnum: Int{
        case morning = 6
        case noon = 12
        case afternoon = 14
        case night = 18
    }
    
    var nowHour :String = ""
    var timeStatus :String = "" //TODO: make it an enum
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
    var tripCtl:TripController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNowHour()
        setupBackGroundColor()
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "shiper"){
            if let destVC = segue.destination as? UserCardViewController {
                destVC.viewTag = 0
            }
        }
        if (segue.identifier == "sender"){
            if let destVC = segue.destination as? UserCardViewController {
                destVC.viewTag = 1
            }
        }
        if (segue.identifier == "sender"){
            if let destVC = segue.destination as? TripController {
                tripCtl = destVC
            }
        }
    }
    
    private func setupNowHour(){
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyyMMddHHmmssSSS"
        let strNowTime = timeFormatter.string(from: date) as String
        let StartIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 8)
        let endIndex = strNowTime.index(strNowTime.startIndex, offsetBy: 9)
        nowHour = String(strNowTime[StartIndex]) + String(strNowTime[endIndex])
        if let nowHourInt = Int(nowHour){
            if nowHourInt >= timeEnum.night.rawValue || nowHourInt < timeEnum.morning.rawValue { // night
                timeStatus = "night"
            } else if nowHourInt >= timeEnum.afternoon.rawValue {
                timeStatus = "afternoon"
            } else if nowHourInt >= timeEnum.noon.rawValue{
                timeStatus = "noon"
            } else {
                timeStatus = "morning"
            }
        }
    }
    
    private func setupBackGroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        switch timeStatus {
        case "night":
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            let beginColor :UIColor = UIColor.MyTheme.darkGreen
            let endColor :UIColor = UIColor.MyTheme.purple
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        default:
            let beginColor :UIColor = UIColor.MyTheme.grey
            let endColor :UIColor = UIColor.MyTheme.littleGreen
            gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        }
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func addObservers(){
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.loadUserProfile()
        }
        
        NotificationCenter.default.addObserver(forName: Notification.Name.TripOrderStore.StoreUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.isStoreUpdated = true
        }
    }
    
    func loadUserProfile(){
        guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
        if let imageUrlString = currUser.imageUrl, let imgUrl = URL(string: imageUrlString) {
            URLCache.shared.removeAllCachedResponses()
            userProfileImageBtn.af_setImage(for: .normal, url: imgUrl, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, completion: nil)
        } else {
            userProfileImageBtn.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
        }
        if let currUserName  = currUser.realName,currUserName != ""{
            var greeting = "你好"
            if let timeState = AppDelegate.shared().mainTabViewController?.homeViewController?.timeStatus{
                switch timeState {
                case "night":
                    greeting = "晚上好，"
                case "afternoon":
                    greeting = "下午好，"
                case "noon":
                    greeting = "中午好，"
                default:
                    greeting = "早上好，"
                }
            }
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
    }
    
    @IBAction func userProfileImageBtnTapped(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
    }
    
    @IBAction func shiperButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "carrierSegue", sender: self)
    }
    
    @IBAction func senderButtonTapped(_ sender: Any) {
        
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

