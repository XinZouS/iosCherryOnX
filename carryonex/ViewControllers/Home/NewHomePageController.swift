//
//  NewHomePageController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/9.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class NewHomePageController: UIViewController {
    
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
    @IBOutlet weak var circle2: UIImageView!
    
    weak var userCardOne: UserCardViewController?
    weak var userCardTwo: UserCardViewController?
    weak var tripController: TripController?

    let ordersRequestDetailSegue = "OrdersRequestDetailSegue"
    
    //MARK: - View Cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO: Need to put this back
        //ApiServers.shared.getConfig()
        
        setupNowHour()
        addObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUserImageView()
        //checkForUpdate()
        setupSportlight() // put it here, instead of viewDidLoad, will get correct frame
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // TODO: what's the different of all these with the same id ???
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
    }
    
    
    //MARK - Helper
    
    private func setupNowHour(){
        let date = Date()
        let calendar = Calendar.current
        let nowHourInt = calendar.component(.hour, from: date)
        UIApplication.shared.statusBarStyle = .default
        if nowHourInt >= TimeEnum.night.rawValue || nowHourInt < TimeEnum.morning.rawValue { // night: 6pm->6am
            timeStatus = .night
            setupBackGroundColor(dayTime: .night)
            UIApplication.shared.statusBarStyle = .lightContent

        } else if nowHourInt >= TimeEnum.afternoon.rawValue {
            timeStatus = .afternoon
            setupBackGroundColor(dayTime: .afternoon)
            

        } else if nowHourInt >= TimeEnum.noon.rawValue{
            timeStatus = .noon
            setupBackGroundColor(dayTime: .noon)

        } else {
            timeStatus = .morning
            setupBackGroundColor(dayTime: .morning)
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
            beginColor = UIColor.MyTheme.noonBlue
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
            
            if let topRequests = TripOrderDataStore.shared.getCardItems(), topRequests.count > 0 {
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
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillEnterForeground, object: nil, queue: nil) { [weak self] _ in
            self?.setupNowHour()
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
            var greeting = L("home.ui.greeting.hello")
            //if let timeState = timeStatus { // AppDelegate.shared().mainTabViewController?.homeViewController?.timeStatus{
                switch timeStatus {
                case .night:
                    greeting = L("home.ui.greeting.night")
                case .afternoon:
                    greeting = L("home.ui.greeting.afternoon")
                case .noon:
                    greeting = L("home.ui.greeting.noon")
                default:
                    greeting = L("home.ui.greeting.morning")
                }
            //}
            let labelDisplay = greeting+currUserName
            helloLabel.text = labelDisplay
        }
    }
    
    private func setupSportlight(){
        if UserDefaults.getHasSoptlightHome() {
            return
        }
        let f1 = shiperButton.frame
        let f2 = senderButton.frame
        let f3 = CGRect(x: 20, y: view.bounds.maxY * 0.46, width: view.bounds.maxX - 40, height: view.bounds.maxY * 0.56)
        
        let s1 = Spotlight(withRect: f1, shape: .roundRectangle, text: L("home.ui.spotlight.trip"), isAllowPassTouchesThroughSpotlight: true)
        let s2 = Spotlight(withRect: f2, shape: .roundRectangle, text: L("home.ui.spotlight.send"), isAllowPassTouchesThroughSpotlight: true)
        let s3 = Spotlight(withRect: f3, shape: .roundRectangle, text: L("home.ui.spotlight.card"), isAllowPassTouchesThroughSpotlight: true)

        let spotlightView = SpotlightView(frame: UIScreen.main.bounds, spotlight: [s1,s2,s3])
        view.addSubview(spotlightView)
        spotlightView.start()
        UserDefaults.setHasSpotlighHome(isFinished: true)
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
            self.displayGlobalAlertActions(title: L("home.confirm.title.version"), message: L("home.confirm.message.version"), actions: [L("home.confirm.action.version")], completion: { (index) in
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
    
    private func setupUserImageView(){
        userProfileImageBtn.layer.masksToBounds = true
        userProfileImageBtn.layer.cornerRadius = CGFloat(Int(userProfileImageBtn.bounds.height)/2)
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = CGFloat(Int(circle.bounds.height)/2)
        circle.layer.borderColor = UIColor.white.cgColor
        circle.layer.borderWidth = 5
        
        circle2.layer.masksToBounds = true
        circle2.layer.cornerRadius = CGFloat(Int(circle2.bounds.height)/2)
        circle2.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        circle2.layer.borderWidth = 1
    }
    
    @IBAction func userProfileImageBtnTapped(_ sender: Any) {
        
    }
    
    @IBAction func shiperButtonTapped(_ sender: Any) {
        //performSegue(withIdentifier: "carrierSegue", sender: self)
        handleNavigation(segue: .addTrip, sender: nil)
    }
    
    @IBAction func senderButtonTapped(_ sender: Any) {
        AnalyticsManager.shared.startTimeTrackingKey(.senderDetailTotalTime)
        handleNavigation(segue: .addRequest, sender: nil)
    }
    
    
}

extension NewHomePageController: MainNavigationProtocol {
    
    func handleNavigation(segue: MainNavigationSegue, sender: Any?) {
        AppDelegate.shared().handleMainNavigation(navigationSegue: segue, sender: sender)
    }
    
}

extension NewHomePageController: UserCardDelegate {
    
    func userCardTapped(sender: UIButton, request: Request, category:TripCategory) {
        handleNavigation(segue: .requestDetail, sender: request)
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
