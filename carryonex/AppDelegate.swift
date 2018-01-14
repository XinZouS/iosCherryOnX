//
//  AppDelegate.swift
//  carryonex
//
//  Created by Xin Zou on 8/8/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import Fabric
import Crashlytics
import ZendeskSDK
import FlickrKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mainNavigationController: UINavigationController!
    var mainTabViewController: MainTabBarController!
    
    static var appToken : String? // singleton for app to login server
    static var timestamp: String?
    var deferredDeeplink: URL?
    private var loadingView: GlobalLoadingView!
    private var isLoading: Bool = false
    
    static public func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Set up reachability
        ReachabilityManager.shared.startObserving()
        
        setupMobSharingSDK()
        
        // setupFacebookSharingSDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // setup WeChatSDK
        WXApi.registerApp(WX_APPID, enableMTA: true)
        
        // setup Fabric
        Fabric.with([Crashlytics.self])

        //setup Zendesk
        ZDKConfig.instance().initialize(withAppId: "9c9a18f374b6017ce85429d7576ebf68c84b42ad8399da76",
                                        zendeskUrl: "https://carryonex.zendesk.com",
                                        clientId: "mobile_sdk_client_fe7793872b8aa3992ec1")
        ZDKConfig.instance().userIdentity = ZDKAnonymousIdentity()
        
        //setup Flickr SDK
        FlickrKit.shared().initialize(withAPIKey: "de264bf38194171ee76392fba833bbab", sharedSecret: "2410000e87f5a329")
        
        //Setup Stripe
        //WalletManager.shared.initializeStripe()
        
        //Setup push notifications
        registerForPushNotifications()
        
        //Setup navigation bar
        setupNavigationBar()
        
        if let mainNavigationController = self.window?.rootViewController as? UINavigationController {
            self.mainNavigationController = mainNavigationController
            self.mainTabViewController = mainNavigationController.childViewControllers[0] as? MainTabBarController
        }
        
        //Setup Loading View
        setupGlobalLoadingView()
        
        return true
    }
    
    /*
     private func handleDeeplinks(_ application: UIApplication, _ launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
     //TODO: in theory these should all be mutually exclusive
     FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
     TVEComponent.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
     
     //Handle launching app by remote push notification
     if let launchOptions = launchOptions {
     if let notificationPayload = launchOptions[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
     if let deeplink = notificationPayload["^d"] as? String, let deeplinkUrl = URL(string: deeplink) {
     let source = launchOptions[UIApplicationLaunchOptionsKey.sourceApplication] as? String
     DeepLinkDispatcher.handleDeepLink(deeplinkUrl, source: source)
     }
     }
     }
     }
     
     */
    
    /**
     *  初始化ShareSDK应用 http://wiki.mob.com/swift%E8%B0%83%E7%94%A8/
     *
     *  @param activePlatforms         使用的分享平台集合，如:@[@(SSDKPlatformTypeSinaWeibo), @(SSDKPlatformTypeTencentWeibo)];
     *  @param importHandler           导入回调处理，当某个平台的功能需要依赖原平台提供的SDK支持时，需要在此方法中对原平台SDK进行导入操作。具体的导入方式可以参考ShareSDKConnector.framework中所提供的方法。
     *  @param configurationHandler    配置回调处理，在此方法中根据设置的platformType来填充应用配置信息
     */
    private func setupMobSharingSDK(){
        ShareSDK.registerActivePlatforms(
            [
                SSDKPlatformType.typeSinaWeibo.rawValue,
                SSDKPlatformType.typeWechat.rawValue,
                SSDKPlatformType.typeQQ.rawValue
            ],
            onImport: {(platform : SSDKPlatformType) -> Void in
                switch platform
                {
                    case SSDKPlatformType.typeSinaWeibo:
                        ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                    case SSDKPlatformType.typeWechat:
                        ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                    default:
                        break
                }
                
        }, onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
                switch platform{
                case SSDKPlatformType.typeSinaWeibo:
                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: WB_APPKEY,
                                                appSecret: WB_APPSecret,
                                                redirectUri: "http://www.sharesdk.cn",
                                                authType: SSDKAuthTypeBoth)
                    
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息, appSecret we ONLY have this one, do NOT remove it !!!!!!!!!!
                    appInfo?.ssdkSetupWeChat(byAppId: WX_APPID,
                                             appSecret: WX_APPSecret) // "64020361b8ec4c99936c0e3999a9f249")
                case SSDKPlatformType.typeQQ:
                    //设置QQ应用信息
                    appInfo?.ssdkSetupQQ(byAppId: QQ_APPID,
                                         appKey: QQ_APPKEY,
                                         authType: SSDKAuthTypeWeb)
                default:
                    break
                }
        })
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        
        if ProfileManager.shared.isLoggedIn() {
            //Pull when app comes to foreground, refresh store
            TripOrderDataStore.shared.pullAll(completion: {
                DLog("Pull ALL completed")
            })
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        DLog("Device Token: \(token)")
        
        UserDefaults.setDeviceToken(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        DLog("Failed to register for push notification: \(error.localizedDescription)")
    }
    
    /// WeChat API connection
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme == "carryonex" {
            DeeplinkNavigator.handleDeeplink(url)
        }
        
        WalletManager.shared.aliPayHandleOrderUrl(url)
        
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        WXApi.handleOpen(url, delegate: WeChatAPIManager.shared)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        WXApi.handleOpen(url, delegate: WeChatAPIManager.shared)
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        DLog("Remote notification: \(userInfo)")
        
        guard let url = userInfo["url"] as? String,
            let deeplink = URL(string: url),
            let host = deeplink.host,
            let navPage = NavigationPage(rawValue: host) else {
                DLog("Invalid Deeplink")
                return
        }
        
        //Show alert when push notification is recieved
        if let mainViewController = self.mainTabViewController {
            if navPage == .requestDetail {
                if let page = userInfo["page"] as? String,
                    let aps = userInfo["aps"] as? [String: Any],
                    let title = aps["alert"] as? String {
                    let category: TripCategory = (page == "carrier") ? .sender : .carrier
                    mainViewController.displayGlobalAlert(title: "寄件状态已更新", message: title, action: L("action.ok"), completion: {
                        if let statusId = userInfo["request_status_id"] as? Int,
                            let url = userInfo["url"] as? String,
                            let requestIdString = URL.getQueryStringParameter(url: url, param: "request_id"),
                            let requestId = Int(requestIdString) {
                            
                            if statusId == RequestStatus.waiting.rawValue {    //New item
                                TripOrderDataStore.shared.pull(category: category, completion: {
                                    if let deeplinkUrl = URL(string: url) {
                                        DeeplinkNavigator.handleDeeplink(deeplinkUrl)
                                    }
                                    TripOrderDataStore.shared.updateRequestToStatus(category: category, requestId: Int(requestId), status: statusId)
                                })
                                
                            } else {
                                if let deeplinkUrl = URL(string: url) {
                                    DeeplinkNavigator.handleDeeplink(deeplinkUrl)
                                }
                                TripOrderDataStore.shared.updateRequestToStatus(category: category, requestId: Int(requestId), status: statusId)
                            }
                        }
                    })
                }
                
            } else if navPage == .comments {
                if let aps = userInfo["aps"] as? [String: Any],
                    let message = aps["alert"] as? String {
                    mainViewController.displayGlobalAlert(title: "收到新评价", message: message, action: L("action.ok"), completion: {
                        DeeplinkNavigator.handleDeeplink(deeplink)
                    })
                    ProfileManager.shared.loadLocalUser(completion: nil)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if let url = userActivity.webpageURL {
            if let newUrl = URL(string: url.absoluteString.replacingOccurrences(of: "https://www.carryonx.com/", with: "carryonex://")) {
                DeeplinkNavigator.handleDeeplink(newUrl)
            }
        }
        
        return true
    }
    
    //MARK: - UI
    private func setupNavigationBar() {
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        UINavigationBar.appearance().isTranslucent = false
    }
    
    
    //MARK: - Push Notifications
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if let error = error {
                debugLog("APNS Permission Error: \(error.localizedDescription)")
            }
            //DLog("APNS Permission granted: \(granted)")
            self.getNotificationSettings()
        }
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            //DLog("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else {
                debugLog("Bad Notification settings status: \(settings.authorizationStatus)")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    
    //MARK: Global Navigation
    public func handleMainNavigation(navigationSegue: MainNavigationSegue, sender: Any?) {
        mainTabViewController.handleMainNavigationSegue(segue: navigationSegue, sender: sender)
    }
    
    
    //Mark: Global Loading
    private func setupGlobalLoadingView() {
        let loadingBackground = GlobalLoadingView(frame: UIScreen.main.bounds)
        loadingBackground.backgroundColor = UIColor.carryon_loadingBackground
        
        let activityIndicator = BPCircleActivityIndicator()
        activityIndicator.center = loadingBackground.center
        loadingBackground.activityIndicator = activityIndicator
        
        loadingBackground.addSubview(activityIndicator)
        loadingView = loadingBackground
    }
    
    public func startLoading() {
        
        if isLoading {
            return
        }
        
        isLoading = true
        
        guard let topViewController = UIViewController.topViewController() else { return }
        
        var loadingViewController = topViewController
        //Exception Login View Controller,
        if !(topViewController is LoginViewController) {
            loadingViewController = mainNavigationController
        }
        
        DispatchQueue.main.async {
            loadingViewController.view.addSubview(self.loadingView)
            
            if let view = loadingViewController.view {
                self.loadingView.addConstraints(left: view.leftAnchor,
                                            top: view.topAnchor,
                                            right: view.rightAnchor,
                                            bottom: view.bottomAnchor,
                                            leftConstent: 0,
                                            topConstent: 0,
                                            rightConstent: 0,
                                            bottomConstent: 0,
                                            width: 0,
                                            height: 0)
                self.loadingView.activityIndicator.center = CGPoint(x: self.loadingView.center.x - 15, y: self.loadingView.center.y - 40)
            }
        
            self.loadingView.activityIndicator.animate()
        }
    }
    
    public func stopLoading() {
        DispatchQueue.main.async {
            self.loadingView.activityIndicator.stop()
            self.loadingView?.removeFromSuperview()
        }
        isLoading = false
    }
    
}

class GlobalLoadingView: UIView {
    var activityIndicator: BPCircleActivityIndicator!
}
