//
//  MainTabBarController.swift
//  carryonex
//
//  Created by Zian Chen on 11/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Reachability
import BPCircleActivityIndicator
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
}

protocol MainNavigationProtocol {
    func handleNavigation(segue: MainNavigationSegue, sender: Any?)
}

class MainTabBarController: UITabBarController {
    
    var activityIndicator: UIActivityIndicatorCustomizeView! // UIActivityIndicatorView!
    var homeViewController: NewHomePageController?
    var personInfoController: PersonalPageViewController?
    var loginViewController: LoginViewController?
    var circleIndicator: BPCircleActivityIndicator!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        setupActivityIndicator()
        if let viewControllers = self.viewControllers as? [UINavigationController] {
            for navigationController in viewControllers {
                if let homeController = navigationController.childViewControllers.first as? NewHomePageController {
                    homeViewController = homeController
                }
                if let personController = navigationController.childViewControllers.last as? PersonalPageViewController {
                    personInfoController = personController
                }
            }
        }
        
        isItHaveLogIn(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadingDisplay()
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
                    if let trip = TripOrderDataStore.shared.getTrip(category: category, id: request.id) {
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
        default:
            print("Others")
        }
    }
    
    //MARK: - Helpers
    
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
            //showLogin(animated)   TODO: PUT LOGIN BACK!!!!!
        }
    }
    
    private func loadingDisplay(){
        if !appDidLaunch {
            self.circleIndicator.isHidden = false
            DispatchQueue.main.async(execute: {
                self.circleIndicator.animate()
            })
            ProfileManager.shared.loadLocalUser(completion: { (isSuccess) in
                if isSuccess {
                    APIServerChecker.testAPIServers()
                    TripOrderDataStore.shared.pullAll(completion: {
                        print("Pull ALL completed")
                    })
                }
                self.circleIndicator.stop()
                self.circleIndicator.isHidden = true
                appDidLaunch = true
            })
        }
    }
    
    private func showLogin(_ animated: Bool) {
        if let loginViewContainer = UIStoryboard.init(name: "Login", bundle: nil).instantiateInitialViewController() {
            self.present(loginViewContainer, animated: animated) { [weak self]_ in
                self?.selectedIndex = 0
                self?.circleIndicator.stop()
                appDidLaunch = false
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
        
        //登录异常（如改变设备）
        NotificationCenter.default.addObserver(forName: Notification.Name.Network.Invalid, object: nil, queue: nil) { [weak self] notification in
            self?.displayAlert(title: "登录异常", message: "登录设备曾经变更，请重新登录", action: "重新登录") {
                ProfileManager.shared.logoutUser()
            }
        }
        
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: nil, queue: nil) { [weak self] notification in
            guard let reachabilityObject = notification.object as? Reachability, let strongSelf = self else { return }
            if !reachabilityObject.isReachable {
                strongSelf.displayAlert(title: "网络连接出错", message: "由于网络连接有问题，您的请求无法发送，请重试", action: "重试")
            }
        }
    }
}
