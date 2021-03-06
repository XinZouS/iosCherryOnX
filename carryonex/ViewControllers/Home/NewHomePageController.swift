//
//  NewHomePageController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/9.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class NewHomePageController: UIViewController {
    
    enum TimeEnum: Int{
        case morning = 4
        case noon = 10
        case afternoon = 16
        case evening = 19
    }
    
    var timeStatus: TimeEnum = TimeEnum.noon
    var gradientLayer: CAGradientLayer!
    // paramter to send to other field
    var imageurl = ""
    var realname = ""
    var isStoreUpdated: Bool = false
    // user contents
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userProfileImageBtn: UIButton!
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var shiperButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var circle: UIImageView!
    @IBOutlet weak var circle2: UIImageView!
    // youxiang cards
    @IBOutlet weak var orderTitleLabel: UILabel!
    @IBOutlet weak var orderPlaceholderView: UIView!
    @IBOutlet weak var orderPlaceholderLabel: UILabel!
    @IBOutlet weak var orderPlaceholderButton: UIButton!
    
    weak var mainTapBarVC: MainTabBarController?
    weak var userCardOne: UserCardViewController?
    weak var userCardTwo: UserCardViewController?
    @IBOutlet weak var userCardOneLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var userCardTwoRightConstraint: NSLayoutConstraint!
    weak var tripController: TripController?
    weak var userRecentInfoController: UserRecentInfoController?

    let ordersRequestDetailSegue = "OrdersRequestDetailSegue"
    let userRecentInfoVCId = "UserRecentInfoViewController"
    let userRecentInfoSegue = "UserRecentInfoSegue"
    
    //MARK: - View Cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiServers.shared.getConfig()
        
        addObservers()
        setupTextContents()
        setupCountButtons()
        setupPlaceholderView(toShow: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        
        setupNowHour()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.backItem?.title = " "
        setupUserImageView()
        //checkForUpdate()
        //setupSportlight() // put it here, instead of viewDidLoad, will get correct frame
        setupOnboarding()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.tabBarController?.tabBar.isHidden = true

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
        
        if (segue.identifier == userRecentInfoSegue) {
            if let destVC = segue.destination as? UserRecentInfoController {
                userRecentInfoController = destVC
                userRecentInfoController?.delegate = self
            }
        }
    }
    
    
    //MARK - Helper
    
    private func setupNowHour(){
        let date = Date()
        let calendar = Calendar.current
        let nowHourInt = calendar.component(.hour, from: date)
        if nowHourInt >= TimeEnum.evening.rawValue || nowHourInt < TimeEnum.morning.rawValue { // evening: 6pm->6am
            timeStatus = .evening
            setupBackGroundColor(dayTime: .evening)

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
    
    private func setupTextContents() {
        shiperButton.setTitle(L("home.ui.title.triper"), for: .normal)
        senderButton.setTitle(L("home.ui.title.sender"), for: .normal)
        orderTitleLabel.text = L("home.ui.card.title")
    }
    
    private func setupCountButtons(){
        if let userRecentInfoVC = storyboard?.instantiateViewController(withIdentifier: userRecentInfoVCId) as? UserRecentInfoController {
            userRecentInfoVC.delegate = self
        }
    }

    private func setupPlaceholderView(toShow: Bool){
        orderTitleLabel.text = L("home.ui.card.title")
        if toShow {
            orderPlaceholderLabel.text = L("home.ui.card.placeholder")
            orderPlaceholderLabel.textColor = colorTextDarkGray
            orderPlaceholderButton.layer.masksToBounds = true
            orderPlaceholderButton.layer.shadowColor = colorTheamRed.cgColor
            orderPlaceholderButton.layer.shadowOffset = CGSize(width: 1, height: 1)
            orderPlaceholderButton.layer.shadowOpacity = 0.7
            orderPlaceholderButton.layer.shadowRadius = 6
            orderPlaceholderButton.layer.masksToBounds = false
        }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.orderPlaceholderView.alpha = toShow ? 1 : 0
            }) { (complete) in
                self.orderPlaceholderView.isHidden = !toShow
            }
        }
    }
    
    private func setupBackGroundColor(dayTime: TimeEnum){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        var beginColor = UIColor.MyTheme.eveningA
        var endColor = UIColor.MyTheme.eveningB
        
        switch timeStatus {
        case .morning, .afternoon:
            helloLabel.textColor = .white
            beginColor = UIColor.MyTheme.morningA
            endColor = UIColor.MyTheme.morningB
            
        case .noon:
            helloLabel.textColor = .white
            beginColor = UIColor.MyTheme.noonA
            endColor = UIColor.MyTheme.noonB

        case .evening:
            helloLabel.textColor = .white
            beginColor = UIColor.MyTheme.eveningA
            endColor = UIColor.MyTheme.eveningB

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
        
        AppDelegate.shared().startLoading()
        NotificationCenter.default.addObserver(forName: Notification.Name.TripOrderStore.StoreUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.isStoreUpdated = true

            if let topRequests = TripOrderDataStore.shared.getCardItems(), topRequests.count > 0 {
                self?.userCardOne?.category = topRequests.first?.1
                self?.userCardOne?.request = topRequests.first?.0
                if topRequests.count == 1 {
                    let mid: CGFloat = (self?.view.bounds.midX ?? 20) - (self?.userCardOne?.view.bounds.midX ?? 0)
                    self?.userCardOneLeftConstraint.constant = mid
                    self?.userCardTwoRightConstraint.constant = -(self?.view.bounds.width ?? CGFloat(600))
                    self?.setupPlaceholderView(toShow: false)
                }
                if topRequests.count > 1 {
                    self?.userCardTwo?.category = topRequests[1].1
                    self?.userCardTwo?.request = topRequests[1].0
                    let isPhone = UIDevice.current.userInterfaceIdiom == .phone
                    self?.userCardOneLeftConstraint.constant = isPhone ? 20 : 60
                    self?.userCardTwoRightConstraint.constant = isPhone ? 20 : 60
                    self?.setupPlaceholderView(toShow: false)
                }
            } else {
                self?.setupPlaceholderView(toShow: true)
            }
            AppDelegate.shared().stopLoading()
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
            userProfileImageView.af_setImage(withURL: imgUrl)
            
        } else {
            userProfileImageView.image = #imageLiteral(resourceName: "blankUserHeadImage")
        }
        if let currUserName  = currUser.realName,currUserName != ""{
            var greeting = L("home.ui.greeting.hello")
            //if let timeState = timeStatus { // AppDelegate.shared().mainTabViewController?.homeViewController?.timeStatus{
                switch timeStatus {
                case .evening:
                    greeting = L("home.ui.greeting.evening")
                case .afternoon:
                    greeting = L("home.ui.greeting.afternoon")
                case .noon:
                    greeting = L("home.ui.greeting.noon")
                default:
                    greeting = L("home.ui.greeting.morning")
                }
            //}
            let labelDisplay = greeting + currUserName
            helloLabel.text = labelDisplay
            helloLabel.textColor = .white
        }
    }
    
    private func setupSportlight(){
        if UserDefaults.getHasSoptlightHome() {
            return // comment this line to show spotlight
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
    
    private func setupOnboarding() {
        if UserDefaults.getHasSoptlightHome() {
            return // TEST: comment this line to show onboarding always for testing
        }
        UserDefaults.setHasSpotlighHome(isFinished: true)
        let onboarding = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        present(onboarding, animated: true, completion: nil)
    }

    
    private func screenShotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(UIScreen.main.bounds.size, true, 1)
        self.view.drawHierarchy(in: UIScreen.main.bounds, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndPDFContext()
        return screenshot
    }

    
    private func checkForUpdate() {
        guard let updatedVersion = ApiServers.shared.configData?.config.iosVersion,
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            return
        }
        
        let currentVersion = version + "." + build
        if updatedVersion != currentVersion {
            DLog("Current: \(currentVersion), Updated to: \(updatedVersion)")
            self.displayGlobalAlertActions(title: L("home.confirm.title.version"),
                                           message: L("home.confirm.message.version"),
                                           actions: [L("home.confirm.action.version")],
                                           completion: { (index) in
                //TODO: Update to carryonex app URL
                let appStoreLink = "https://itunes.apple.com/us/app/apple-store/id1329637654?mt=8"
                if let url = URL(string: appStoreLink), UIApplication.shared.canOpenURL(url) {
                    // Attempt to open the URL.
                    UIApplication.shared.open(url, options: [:], completionHandler: {(success: Bool) in
                        if success {
                            DLog("Launching \(url) was successful")
                        }
                    })
                }
            })
        }
    }
    
    private func setupUserImageView(){
        userProfileImageView.layer.masksToBounds = true
        userProfileImageView.layer.cornerRadius = userProfileImageView.bounds.height / 2
        userProfileImageView.contentMode = .scaleAspectFill
        circle.layer.masksToBounds = true
        circle.layer.cornerRadius = circle.bounds.height / 2
        circle.layer.borderColor = UIColor.white.cgColor
        circle.layer.borderWidth = 5
        
        circle2.layer.masksToBounds = true
        circle2.layer.cornerRadius = circle2.bounds.height / 2
        circle2.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
        circle2.layer.borderWidth = 1
    }
    
    @IBAction func userProfileImageBtnTapped(_ sender: Any) {
        // For now, we NOT allow user to interact with the profile image - Xin
    }
    
    @IBAction func shiperButtonTapped(_ sender: Any) {
        //performSegue(withIdentifier: "carrierSegue", sender: self)
        handleNavigation(segue: .addTrip, sender: nil)
    }
    
    @IBAction func senderButtonTapped(_ sender: Any) {
        AnalyticsManager.shared.startTimeTrackingKey(.senderDetailTotalTime)
        handleNavigation(segue: .addRequest, sender: sender)
    }
        
}

extension NewHomePageController: MainNavigationProtocol {
    
    func handleNavigation(segue: MainNavigationSegue, sender: Any?) {
        self.tabBarController?.tabBar.isHidden = true
        AppDelegate.shared().handleMainNavigation(navigationSegue: segue, sender: sender)
    }
    
}

extension NewHomePageController: UserRecentInfoDelegate {
    
    func handleInfoButtonTapped(_ component: UserRecentInfoComponent) {
        switch component {
        case .tripCount:
            DeeplinkNavigator.navigateToOrderList(category: .carrier)
        case .deliveryCount:
            DeeplinkNavigator.navigateToOrderList(category: .sender)
        case .score:
            AppDelegate.shared().handleMainNavigation(navigationSegue: .historyComment, sender: nil)
        }
    }
    
}

extension NewHomePageController: UserCardDelegate {
    
    func userCardTapped(sender: UIButton, request: Request, category:TripCategory) {
        if category == .carrier {
            handleNavigation(segue: .requestDetail, sender: request)
        } else {
            handleNavigation(segue: .tripDetail, sender: request)
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
