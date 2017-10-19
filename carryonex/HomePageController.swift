//
//  ViewController.swift
//  carryonex
//
//  Created by Xin Zou on 8/8/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//
/**
 智能物流运输，
 */


import UIKit
import MapKit
import paper_onboarding
import CircleMenu

class HomePageController: UIViewController, UISearchResultsUpdating,UICollectionViewDelegateFlowLayout {

        
    
    let items: [(icon: String, color: UIColor)] = [
        ("CarryonExIcon-29", UIColor(red:1, green:0.87, blue:00.7, alpha:0.8)),
        ("CarryonEx_B", UIColor(red:1, green:0.87, blue:0.7, alpha:0.8)),
        ("CarryonEx_A", UIColor(red:1, green:0.87, blue:0.7, alpha:0.8)),
        ]
    
    let mapView : MKMapView = {
        let m = MKMapView()
        m.translatesAutoresizingMaskIntoConstraints = false
        m.isRotateEnabled = false
        m.showsCompass = false
        return m
    }()
    
    var selectedPin : MKPlacemark? = nil
    
    internal let locationManager = CLLocationManager()
    
    var searchController : UISearchController?
    
    var searchContainerView : UIView = {
        let v = UIView()
        return v
    }()
    let searchContentTopMargin: CGFloat = 30
    let searchContentSideMargin: CGFloat = 40
    var searchContainerTopConstraint : NSLayoutConstraint!
    var searchContainerLeftConstraint: NSLayoutConstraint!
    var searchContainerRightConstraint:NSLayoutConstraint!
    
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    internal let tableViewHeigh : CGFloat = UIScreen.main.bounds.height / 2.0
    var tableView = UITableView() // for search results
    
    
    lazy var searchTextField : UITextField = {
        let t = UITextField()
        return t
    }()

    
    internal let btnTitleShipForMe : String = "成为发件人"
    internal let btnTitleShipForYou: String = "成为揽件人"
    
    internal var isSideBtnViewShowing : Bool = false
    internal let sideBtnW : CGFloat = 40
    internal let sideBtnViewH: CGFloat = 40
    internal let sideButtonContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 20 // bcz w,h = 40
        v.layer.borderColor = buttonThemeColor.cgColor
        v.layer.borderWidth = 2
        v.layer.masksToBounds = true
        return v
    }()
    internal var sideBtnCtnViewLeftConstraint: NSLayoutConstraint? // for moving side buttonView
    
    lazy var pullSideBtnViewButton : UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Logo"), for: .normal)
        b.addTarget(self, action: #selector(pullSideButtonTapped), for: .touchUpInside)
        return b
    }()
    
    let switchUserTypeAttributes : [String:Any] = [ // for button title setting
        NSFontAttributeName: UIFont.systemFont(ofSize: 14),
        NSForegroundColorAttributeName: UIColor.black
    ]
    
    lazy var switchUserTypeButton : UIButton = {
        let b = UIButton()
        b.backgroundColor = .white
//        b.addTarget(self, action: #selector(switchUserType), for: .touchUpInside)
        return b
    }()
    
    lazy var callShipperButton : CircleMenu = {
        let b = CircleMenu(
            frame: CGRect(x: 200, y: 200, width: 50, height: 50),
            normalIcon:"CarryonEx_Logo",
            selectedIcon:"CarryonEx_Close",
            buttonsCount: 3,
            duration: 1,
            distance: 100)
            b.layer.cornerRadius = 30
            b.layer.masksToBounds = true
          b.backgroundColor = buttonColorWhite
          b.layer.borderColor = borderColorLightGray.cgColor
          b.layer.borderWidth = 1
          b.layer.shadowColor = UIColor(red:0,green:0,blue:0,alpha:0.3).cgColor
          b.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
          b.layer.shadowOpacity = 1.0
          b.layer.shadowRadius = 1.0
          b.layer.masksToBounds = false;
        return b
    }()
    
    lazy var userInfoBarButtonView : UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "carryonex_userInfomation"), for: .normal)
        b.addTarget(self, action: #selector(showUserInfoSideMenu), for: .touchUpInside)
        return b
    }()
    
    lazy var giftBarButtonView: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Invite"), for: .normal)
        b.backgroundColor = barColorGray
        b.addTarget(self, action: #selector(showGiftController), for: .touchUpInside)
        return b
    }()
    
    lazy var targetCurrentLocationButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(targetCurrentLocBtnTapped), for: .touchUpInside)
        b.setImage(#imageLiteral(resourceName: "carryonex_locationIcon"), for: .normal)
        return b
    }()
    
    
    // for User info view
    internal let backgroundBlackView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8)
        v.isUserInteractionEnabled = true
        v.isHidden = true
        return v
    }()
    let userInfoMenuView = UserInfoMenuView()
    var userInfoMenuRightConstraint : NSLayoutConstraint?

    
    
    // MARK: - setup UI
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.bool(forKey: UserDefaultKey.OnboardingFinished.rawValue) == false {
            presentOnboardingPage()
        }
        fetchUserFromLocalDiskAndSetup()
        
        //setupNavigationBar()
        setupMapView()

        setupSearchContents()

        setupCallShipperButton()
        
        setupSideButtonView()
        
        setupTargetCurrentLocationButton()
        setupTopButtons()

        setupBlackBackgroundView()
        setupUserInfoMenuView()

        testApiServers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "游箱" // for returning from UserInfoPage, change title back;
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        isItHaveLogIn()
        setupStatuesBar()
        setupUIContentsForUserIsShipperOrNot()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveUserIntoLocalDisk()
    }

    private func isItHaveLogIn(){
        if(User.shared.username == ""){
            let registerMainCtl = RegisterMainController()
            isModifyPhoneNumber = false
            let registerRootCtl = UINavigationController(rootViewController: registerMainCtl)
            self.present(registerRootCtl, animated: false, completion: nil)
        }
    }
    private func presentOnboardingPage(){
        self.present(OnboardingController(), animated: true, completion: nil)
    }

    private func setupSearchContents(){
        let h: CGFloat = 56
        
        view.addSubview(searchContainerView)

        searchContainerView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 70, rightConstent: 0, bottomConstent: 0, width: 0, height: h)
    
        let locationSearchTableViewController = LocationSearchTableController()
        locationSearchTableViewController.homePageController = self
        locationSearchTableViewController.handleMapSearchDelegate = self
        locationSearchTableViewController.mapView = self.mapView

        searchController = UISearchController(searchResultsController: locationSearchTableViewController)
        if let searchBar = searchController?.searchBar {
            
            searchContainerView.addSubview(searchBar)
            searchBar.sizeToFit() // sizeThatFits(searchContainerView.frame.size)
            searchBar.placeholder = "搜索附近的地点"
            searchBar.backgroundColor = .clear
            searchBar.backgroundImage = UIImage() // this will make its background=.clear
            searchBar.setValue("取消", forKey:"_cancelButtonText")
        }
        searchController?.searchResultsUpdater = locationSearchTableViewController
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

        
        self.tableViewHeightConstraint = locationSearchTableViewController.tableViewHeightConstraint
        
        if let txfSearchField = searchController?.searchBar.value(forKey: "searchField") as? UITextField {
            self.searchTextField = txfSearchField
        }
    }

    private func setupMapView(){
        view.addSubview(mapView)
        mapView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        zoomToUserLocation()
    }
    
    private func setupCallShipperButton(){
        let sz : CGFloat = 60
        view.addSubview(callShipperButton)
        callShipperButton.addConstraints(left: nil, top: nil, right: nil, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 80, width: sz, height: sz)
        callShipperButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        callShipperButton.delegate = self
    }
    func circleMenu(_ circleMenu: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage  = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.3)
    }
    func circleMenu(_ circleMenu: CircleMenu, buttonWillSelected button: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        switch atIndex{
        case 0:
            callShipperButtonTapped()
        case 1:
            switchToSender()
        case 2:
            switchToShiper()
        default:
            break;
        }
    }
    
    private func setupStatuesBar(){
        UIApplication.shared.statusBarStyle = .lightContent
    }


    private func setupSideButtonView(){
        view.addSubview(sideButtonContainerView)
        sideButtonContainerView.addConstraints(left: nil, top: view.topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 160, rightConstent: 0, bottomConstent: 0, width: 144, height: sideBtnViewH)
        sideBtnCtnViewLeftConstraint = sideButtonContainerView.leftAnchor.constraint(equalTo: view.rightAnchor, constant: -sideBtnW)
        sideBtnCtnViewLeftConstraint?.isActive = true

        
        sideButtonContainerView.addSubview(pullSideBtnViewButton)
        pullSideBtnViewButton.addConstraints(left: sideButtonContainerView.leftAnchor, top: sideButtonContainerView.topAnchor, right: nil, bottom: sideButtonContainerView.bottomAnchor, leftConstent: 2, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: sideBtnW, height: 0)
        
        sideButtonContainerView.addSubview(switchUserTypeButton)
        switchUserTypeButton.addConstraints(left: pullSideBtnViewButton.rightAnchor, top: sideButtonContainerView.topAnchor, right: sideButtonContainerView .rightAnchor, bottom: sideButtonContainerView.bottomAnchor, leftConstent: -3, topConstent: 0, rightConstent: sideBtnW / 2 + 10, bottomConstent: 0, width: 0, height: 0)
        setupSwitchUserTypeBtnTitle(str: btnTitleShipForYou)
        
        setupSwipGestureRecognizer()
    }

    private func setupTargetCurrentLocationButton(){
        view.addSubview(targetCurrentLocationButton)
        targetCurrentLocationButton.addConstraints(left: nil, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 30, bottomConstent: 50, width: 50, height: 50)
    }
    
    private func setupTopButtons(){
        let sz : CGFloat = 30
        let topMargin: CGFloat = 36
        let sideMargin:CGFloat = 20
        view.addSubview(userInfoBarButtonView)
        userInfoBarButtonView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: nil, bottom: nil, leftConstent: sideMargin, topConstent: topMargin, rightConstent: 0, bottomConstent: 0, width: sz, height: 20)
        
        view.addSubview(giftBarButtonView)
        giftBarButtonView.addConstraints(left: nil, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: topMargin, rightConstent: sideMargin, bottomConstent: 0, width: sz, height: sz)
    }

    private func setupBlackBackgroundView(){
        view.addSubview(backgroundBlackView)
        backgroundBlackView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userInfoMenuViewAnimateHide))
        backgroundBlackView.addGestureRecognizer(tapGesture)
    }
    private func setupUserInfoMenuView(){
        userInfoMenuView.homePageCtl = self
        let w : CGFloat = 270
        view.addSubview(userInfoMenuView)
        userInfoMenuView.addConstraints(left: nil, top: view.topAnchor, right: nil, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: 0)
        userInfoMenuRightConstraint = userInfoMenuView.rightAnchor.constraint(equalTo: view.leftAnchor)
        userInfoMenuRightConstraint?.isActive = true
    }

    
    private func testApiServers(){
        print("\r\n ------ Server connection (HomePageController) ------\r\n")
        //ApiServers.shared.fetchAllUsers()
        //ApiServers.shared.getUserSaltByUsername("user0")
        
        //let userId = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        //ApiServers.shared.registerUser()
        //User.shared.username = "user0"
        //User.shared.password = "73dbe388246aa5ee6d71d98371bfb292"
        //ApiServers.shared.loginUser()
        //ApiServers.shared.logoutUser()
        /*
        ApiServers.shared.getUserInfo(.salt) { (getSalt) in
            print("get salt: \(getSalt)")
            if let getSalt = getSalt as? String {
            }
        }
        ApiServers.shared.getUserInfo(.imageUrl) { (imageUrl) in
            print("get imageUrl = \(imageUrl)")
            if let url = imageUrl as? String {
                User.shared.imageUrl = url
                User.shared.saveIntoLocalDisk()
            }
        }
        ApiServers.shared.getUserInfo(.passportUrl) { passporturl in
            print("get passportUrl = \(passporturl)")
            if let url = passporturl as? String {
                User.shared.passportUrl = url
                User.shared.saveIntoLocalDisk()
            }
        }
        ApiServers.shared.getUserInfo(.idAUrl) { idaUrl in
            print("get idA url = \(idaUrl)")
            if let url = idaUrl as? String {
                User.shared.idCardA_Url = url
                User.shared.saveIntoLocalDisk()
            }
        }
        ApiServers.shared.getUserInfo(.idBUrl) { idbUrl in
            if let url = idbUrl as? String {
                print("get idB url = \(idbUrl)")
                User.shared.idCardB_Url = url
                User.shared.saveIntoLocalDisk()
            }
        }
        ApiServers.shared.getUserInfo(.email) { email in
            if let e = email as? String {
                print("get email = \(email)")
                User.shared.email = e
                User.shared.saveIntoLocalDisk()
            }
        }
        ApiServers.shared.getUserInfo(.realName) { realname in
            if let name = realname as? String {
                print("get realName = \(realname)")
                User.shared.nickName = name
                User.shared.saveIntoLocalDisk()
            }
        }
        ApiServers.shared.getUserInfo(.phone) { phone in
            if let p = phone as? String {
                print("get Phone = \(phone)")
                let arr = p.components(separatedBy: "-")
                User.shared.phoneCountryCode = arr.first!
                User.shared.phone = arr.last!
                User.shared.saveIntoLocalDisk()
            }
        }
        ApiServers.shared.getUserInfoAll { (dictionary) in
            if let props = dictionary as? [String:AnyObject] {
                print("OK!!! get user info will setup the model: \(props)")
                /* props = [
                 "real_name": <null>, "email": testEmail@carryonex.com, "salt": fa72f1deee7b7c4fe74a6518d5953b71,
                 "token": 299a79d77aaac250192336d063855a23f30f646b46707f585e8eddadaddea99d, "idb_url": <null>,
                 "pub_date": 2017-10-12 19:51:52.121448, "username": testUsername, "passport_url": <null>,
                 "status": {
                     description = inactive;
                     id = 1;
                 }, "id": 3, "stamp": 150000000, "phone": -1234567890, "wallet_id": <null>, "image_url": <null>,
                 "password_hash": testPassword, "ida_url": <null>
                 ]
                 */
            }
        }
        ApiServers.shared.getUserLogsOf(type: .myCarries) { (dictionary) in
            if let logArr = dictionary as? [String : AnyObject] {
                print("okkk!! get logArr = \(logArr)")
            }
        }
        ApiServers.shared.getUserLogsOf(type: .myTrips) { (dictionary) in
            if let logArr = dictionary as? [String : AnyObject] {
                print("okkk!! get logArr = \(logArr)")
            }
        }
         */
        
        

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}

/// for UserInfoMenu view at the left side of Home page
extension HomePageController {
    
    
    
}

