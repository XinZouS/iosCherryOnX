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

class UserProfileController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userProfileImageBtn: UIButton!
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var shiperButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var circle: UIImageView!
    var locationManager : CLLocationManager!
    var currLocation : CLLocation!
    var newHomeCtl: NewHomePageController!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addUserUpdateNotificationObservers()
        setupLocation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUserImageView()
    }
    
    private func addUserUpdateNotificationObservers(){
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.loadUserProfile()
        }
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
        
    }
    
    @IBAction func shiperButtonTapped(_ sender: Any) {
        
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
