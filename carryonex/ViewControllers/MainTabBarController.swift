//
//  MainTabBarController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import CoreLocation
import Reachability
import ZendeskSDK

enum TabViewIndex: Int {
    case home = 0
    case order
    case settings
}

enum MainNavigationSegue: String {
    case addTrip = "AddTripSegue"
    case addRequest = "AddRequestSegue"
    case requestDetail = "RequestDetailSegue"
    case orderTripInfo = "OrderTripInfoSegue"
    case historyComment = "HistoryCommentSegue"
    case creditView = "CreditViewSegue"
    case settings = "SettingsSegue"
    case helpCenter = "HelpCenterSegue"
    case shipperProfile = "ShipperProfileSegue"
}

protocol MainNavigationProtocol {
    func handleNavigation(segue: MainNavigationSegue, sender: Any?)
}

class MainTabBarController: UITabBarController {
    
    var homeViewController: NewHomePageController?
    var personInfoController: PersonalPageViewController?
    var loginViewController: LoginViewController?
    var circleIndicator: BPCircleActivityIndicator!
    var locationManager : CLLocationManager!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        setupActivityIndicator()
        initialDataLoad()
        setupLocationManager()
        
        if let viewControllers = self.viewControllers as? [UINavigationController] {
            for navigationController in viewControllers {
                if let homeController = navigationController.childViewControllers.first as? NewHomePageController {
                    homeViewController = homeController
                    homeViewController?.mainTapBarVC = self
                }
                if let personController = navigationController.childViewControllers.last as? PersonalPageViewController {
                    personInfoController = personController
                }
            }
        }
        
        isItHaveLogIn(false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier, let navigationSegue = MainNavigationSegue(rawValue: segueId) else { return }
        
        switch navigationSegue {
        case .addTrip:
            print("Add Trip")
            
        case .addRequest:
            print("Add Request")
            
        case .requestDetail:
            print("Open user detail")
            if let viewController = segue.destination as? OrdersRequestDetailViewController {
                if let request = sender as? Request, let category = request.category() {
                    viewController.request = request
                    viewController.category = category
                    if let trip = TripOrderDataStore.shared.getTrip(category: category, id: request.tripId) {
                        viewController.trip = trip
                    }
                }
            }
        case .orderTripInfo:
            if let tripInfoViewController = segue.destination as? OrdersYouxiangInfoViewController, let trip = sender as? Trip {
                tripInfoViewController.trip = trip
                tripInfoViewController.category = .carrier
            }
            print("Open trip list")
        case .creditView:
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            print("Credit View")
        case .historyComment:
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            print("History Comment")
        case .settings:
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            print("Settings")
        case .shipperProfile:
            print("Shipper Profile")
            if let shipperInfoViewController = segue.destination as? ShipperInfoViewController, let trip = sender as? Trip {
                shipperInfoViewController.commenteeId = trip.carrierId
                shipperInfoViewController.commenteeRealName = trip.carrierRealName ?? trip.carrierUsername
                shipperInfoViewController.commenteeImage = trip.carrierImageUrl
                shipperInfoViewController.phoneNumber = trip.carrierPhone
            }
        default:
            print("Others")
        }
    }
    
    
    //MARK: - Helpers
    
    private func initialDataLoad() {
        self.circleIndicator.isHidden = false
        self.circleIndicator.animate()
        ProfileManager.shared.loadLocalUser(completion: { (isSuccess) in
            if isSuccess {
                APIServerChecker.testAPIServers()
                self.locationManager.startUpdatingLocation()
            }
        })
        
        TripOrderDataStore.shared.pullAll(completion: {
            print("Pull ALL completed")
            self.circleIndicator.isHidden = true
            self.circleIndicator.stop()
        })
    }
    
    public func selectTabIndex(index: TabViewIndex) {
        self.selectedIndex = index.rawValue
    }
    
    public func handleMainNavigationSegue(segue: MainNavigationSegue, sender: Any?) {
        
        //Special Handle for Zen Help Center
        if segue == .helpCenter {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            let helpCenterContentModel = ZDKHelpCenterOverviewContentModel.defaultContent()
            ZDKHelpCenter.pushOverview(self.navigationController, with:helpCenterContentModel)
            return
        }
        
        self.performSegue(withIdentifier: segue.rawValue, sender: sender)
        
    }
    
    private func setupActivityIndicator(){
        circleIndicator = BPCircleActivityIndicator()
        circleIndicator.frame = CGRect(x:view.center.x - 15, y:view.center.y - 20, width: 0, height: 0)
        circleIndicator.isHidden = true
        view.addSubview(circleIndicator)
    }
    
    private func isItHaveLogIn(_ animated: Bool){
        if (!ProfileManager.shared.isLoggedIn()){
            showLogin(animated)
        }
    }
    
    private func showLogin(_ animated: Bool) {
        if let loginViewContainer = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() {
            self.present(loginViewContainer, animated: animated) { [weak self]_ in
                self?.selectedIndex = 0
                self?.circleIndicator.stop()
            }
        } else {
            debugLog("Something is wrong with the Login storyboard, please check.")
        }
    }
    
    func dismissLogin(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Notification
    private func addObservers() {
        NotificationCenter.default.addObserver(forName: .UserLoggedOut, object: nil, queue: nil) { [weak self] _ in
            self?.showLogin(true)
        }
        
        NotificationCenter.default.addObserver(forName: .UserDidUpdate, object: nil, queue: nil) { [weak self] _ in
            self?.circleIndicator.stop()
            self?.circleIndicator.isHidden = true
            self?.locationManager.startUpdatingLocation()
        }
        
        //登录异常（如改变设备）
        NotificationCenter.default.addObserver(forName: Notification.Name.Network.Invalid, object: nil, queue: nil) { [weak self] notification in
            UIApplication.shared.endIgnoringInteractionEvents()
            self?.displayAlert(title: L("maintapbar.error.title.login"), message: L("maintapbar.error.message.login"), action: L("maintapbar.error.action.login")) {
                ProfileManager.shared.logoutUser()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: nil, queue: nil) { [weak self] notification in
            UIApplication.shared.endIgnoringInteractionEvents()
            guard let reachabilityObject = notification.object as? Reachability, let strongSelf = self else { return }
            if !reachabilityObject.isReachable {
                strongSelf.displayAlert(title: L("maintapbar.error.title.network"), message: L("maintapbar.error.message.network"), action: L("maintapbar.error.action.network"))
            }
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil) { [weak self] (notification) in
            self?.locationManager.startUpdatingLocation()
        }
        
    }
}

extension MainTabBarController: CLLocationManagerDelegate {
    
    fileprivate func setupLocationManager(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        locationManager.requestAlwaysAuthorization()
    }
    
    
    //MARK: - Location
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //取得locations数组的最后一个
        guard let currentLocation = locations.last else {
            print("Unable to obtain location")
            return
        }
        
        if (currentLocation.horizontalAccuracy > 0){
            //let lat = Double(String(format: "%.1f", location.coordinate.latitude))
            //let long = Double(String(format: "%.1f", location.coordinate.longitude))
            
            CLGeocoder().reverseGeocodeLocation(currentLocation) { (placemark, error) -> Void in
                if let error = error {
                    print("Get location error: \(error.localizedDescription)")
                    self.homeViewController?.locationLabel.text = L("home.ui.location.message.unknown")
                    return
                }
                
                if let placemark = placemark, placemark.count > 0 {
                    var locationString = String()
                    let mark = placemark.first!
                    
                    if let district = mark.subLocality {
                        locationString += district
                    }
                    
                    if let city = mark.locality {
                        if locationString.count > 0 {
                            locationString += (", " + city)
                        } else {
                            locationString += city
                        }
                    }
                    
                    self.homeViewController?.locationLabel.text = locationString
                
                } else {
                    self.homeViewController?.locationLabel.text = L("home.ui.location.message.unknown")
                }
            }
            
            ApiServers.shared.postUserGPS(longitude: currentLocation.coordinate.longitude,
                                          latitude: currentLocation.coordinate.latitude,
                                          completion: nil)
            
            locationManager.stopUpdatingLocation()
        }
    }
    
    //FIXME:  获取位置信息失败
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location failed: \(error.localizedDescription)")
    }
}

