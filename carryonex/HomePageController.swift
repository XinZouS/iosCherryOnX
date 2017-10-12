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

extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            colorLiteralRed: Float(1.0) / Float(255.0) * Float(red),
            green: Float(1.0) / Float(255.0) * Float(green),
            blue: Float(1.0) / Float(255.0) * Float(blue),
            alpha: alpha)
    }
}
class HomePageController: UIViewController, UISearchResultsUpdating {

//    var delegate = HomePageControllerDelegate.self
 
//    var pageContainer: PageContainer?
        
    
    let items: [(icon: String, color: UIColor)] = [
        ("CarryonExIcon-29", UIColor(red:1, green:0.87, blue:00.7, alpha:0.8)),
        ("CarryonEx_B", UIColor(red:1, green:0.87, blue:0.7, alpha:0.8)),
        ("CarryonEx_A", UIColor(red:1, green:0.87, blue:0.7, alpha:0.8)),
        ]
    
    let mapView : MKMapView = {
        let m = MKMapView()
        m.translatesAutoresizingMaskIntoConstraints = false
        return m
    }()
    
    var selectedPin : MKPlacemark? = nil
    
    internal let locationManager = CLLocationManager()
    
    var searchController : UISearchController?
    
    var searchContainerView : UIView = {
        let v = UIView()
        //v.backgroundColor = .yellow
        //v.layer.borderColor = borderColorLightGray.cgColor
        //v.layer.borderWidth = 1
        //v.layer.cornerRadius = 5
        return v
    }()
    let searchContentTopMargin: CGFloat = 30
    let searchContentSideMargin: CGFloat = 40
    var searchContainerTopConstraint : NSLayoutConstraint!
    var searchContainerLeftConstraint: NSLayoutConstraint!
    var searchContainerRightConstraint:NSLayoutConstraint!
    
//    lazy var searchButton : UIButton = { // replaced by searchController
//        let b = UIButton()
//        b.backgroundColor = .white
//        b.setImage(#imageLiteral(resourceName: "CarryonEx_Search"), for: .normal)
//        b.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
//        return b
//    }()
    
    var tableViewHeightConstraint: NSLayoutConstraint?
    internal let tableViewHeigh : CGFloat = UIScreen.main.bounds.height / 2.0
    var tableView = UITableView() // for search results
    
    
    lazy var searchTextField : UITextField = {
        let t = UITextField()
//        t.placeholder = " 搜索地址"
//        t.delegate = self
//        t.returnKeyType = .go
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
//        //b.setTitle("send", for: .normal)
//        //b.titleLabel?.font = UIFont(name: buttonFont, size: 20)
//        b.setImage(#imageLiteral(resourceName: "CarryonEx_Logo"), for: .normal)
          b.backgroundColor = buttonColorWhite
          b.layer.borderColor = borderColorLightGray.cgColor
          b.layer.borderWidth = 1
          b.layer.shadowColor = UIColor(red:0,green:0,blue:0,alpha:0.3).cgColor
          b.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
          b.layer.shadowOpacity = 1.0
          b.layer.shadowRadius = 1.0
          b.layer.masksToBounds = false;
//        b.addTarget(self, action: #selector(callShipperButtonTapped), for: .touchUpInside)
        return b
    }()
    
    lazy var userInfoBarButtonView : UIButton = {
        let b = UIButton()
        b.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Profile"), for: .normal)
        b.addTarget(self, action: #selector(showUserInfoSideMenu), for: .touchUpInside)
        return b
    }()
    
    lazy var giftBarButtonView: UIButton = {
        let b = UIButton()
        b.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Invite"), for: .normal)
        b.addTarget(self, action: #selector(showGiftController), for: .touchUpInside)
        return b
    }()
    
    // MARK: - for development use only:
    lazy var gotoItemTypePageButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .cyan
        b.setTitle("gotoItemTypePage", for: .normal)
        b.addTarget(self, action: #selector(gotoItemTypePage), for: .touchUpInside)
        return b
    }()
    lazy var gotoIDPageButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .green
        b.setTitle("gotoIDPage", for: .normal)
        b.addTarget(self, action: #selector(gotoIDPage), for: .touchUpInside)
        return b
    }()
    lazy var gotoConfirmPageButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = .orange
        b.setTitle("gotoConfirmPage", for: .normal)
        b.addTarget(self, action: #selector(gotoConfirmPage), for: .touchUpInside)
        return b
    }()
    lazy var showNewRequestAlertButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = buttonColorPurple
        b.setTitle("你有新订单！", for: .normal)
        b.addTarget(self, action: #selector(showNewRequestAlert), for: .touchUpInside)
        return b
    }()
    lazy var showOnboardingPageButton: UIButton = {
        let b = UIButton()
        b.backgroundColor = buttonColorOrange
        b.setTitle("Onboarding!", for: .normal)
        b.addTarget(self, action: #selector(showOnboardingPage), for: .touchUpInside)
        return b
    }()
    lazy var targetCurrentLocationButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(targetCurrentLocBtnTapped), for: .touchUpInside)
        b.setImage(#imageLiteral(resourceName: "yadianwenqing"), for: .normal)
        return b
    }()
    

    
    // MARK: - setup UI
    override func viewDidLoad() {
        super.viewDidLoad()

        if UserDefaults.standard.bool(forKey: UserDefaultKey.OnboardingFinished.rawValue) == false {
            presentOnboardingPage()
        }
        fetchUserFromLocalDiskAndSetup()
        
//        isItHaveLogIn()
        
        setupNavigationBar()
        setupMapView()

        setupSearchContents()
        //setupTableView()  setup in LocationSearchTableController()
        setupCallShipperButton()
        
        setupSideButtonView()
        
        setupDevelopButtons() //TODO: remove this when going on line;
        setupTargetCurrentLocationButton()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "游箱" // for returning from UserInfoPage, change title back;
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        setupStatuesBar()
        setupUIContentsForUserIsShipperOrNot()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        saveUserIntoLocalDisk()
    }

    private func isItHaveLogIn(){
        if(User.shared.username == ""){
            let phoneNumberCtl = PhoneNumberController()
            self.navigationController?.present(phoneNumberCtl, animated: true)
        }
    }
    private func presentOnboardingPage(){
        self.present(OnboardingController(), animated: true, completion: nil)
    }

    private func setupSearchContents(){
        let h: CGFloat = 56
        
        view.addSubview(searchContainerView)
        searchContainerView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: h)
        // replace above line
//        searchContainerView.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: h)
//        searchContainerTopConstraint = searchContainerView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: searchContentTopMargin)
//        searchContainerTopConstraint.isActive = true
//        searchContainerLeftConstraint = searchContainerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: searchContentSideMargin)
//        searchContainerLeftConstraint.isActive = true
//        searchContainerRightConstraint = searchContainerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -searchContentSideMargin)
//        searchContainerRightConstraint.isActive = true
        
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
        //searchController?.searchBar.delegate = self
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true

        
        self.tableViewHeightConstraint = locationSearchTableViewController.tableViewHeightConstraint
        
//        view.addSubview(searchButton)
//        searchButton.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: nil, bottom: nil, leftConstent: margin+4, topConstent: 94, rightConstent: 0, bottomConstent: 0, width: h-8, height: h-8)
//        
        if let txfSearchField = searchController?.searchBar.value(forKey: "searchField") as? UITextField {
            self.searchTextField = txfSearchField
        }
//        view.addSubview(searchTextField)
//        searchTextField.addConstraints(left: searchButton.rightAnchor, top: searchButton.topAnchor, right: view.rightAnchor, bottom: searchButton.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: margin, bottomConstent: 0, width: 0, height: h)
        
    }
    
//    private func setupTableView(){
//        view.addSubview(tableView)
//        tableView.addConstraints(left: searchContainerView.leftAnchor, top: searchContainerView.bottomAnchor, right: searchContainerView.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 6, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
//        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 300)
//        tableViewHeightConstraint?.isActive = true
//     
//        tableView.keyboardDismissMode = .interactive
//    }

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

    private func setupNavigationBar(){
        UINavigationBar.appearance().tintColor = buttonColorWhite
        navigationController?.navigationBar.tintColor = buttonColorWhite
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: buttonColorWhite]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userInfoBarButtonView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: giftBarButtonView)
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
        targetCurrentLocationButton.addConstraints(left: nil, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 30, width: 40, height: 40)
    }
    

    
    /**
        for development use only
     */
    private func setupDevelopButtons(){
        view.addSubview(gotoItemTypePageButton)
        gotoItemTypePageButton.addConstraints(left: nil, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 210, rightConstent: 0, bottomConstent: 0, width: 160, height: 30)
        
        view.addSubview(gotoIDPageButton)
        gotoIDPageButton.addConstraints(left: nil, top: gotoItemTypePageButton.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 160, height: 30)
        
        view.addSubview(gotoConfirmPageButton)
        gotoConfirmPageButton.addConstraints(left: nil, top: gotoIDPageButton.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 180, height: 30)
        
        view.addSubview(showNewRequestAlertButton)
        showNewRequestAlertButton.addConstraints(left: nil, top: gotoConfirmPageButton.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 140, height: 30)
        
        view.addSubview(showOnboardingPageButton)
        showOnboardingPageButton.addConstraints(left: nil, top: showNewRequestAlertButton.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 140, height: 30)
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  
}

