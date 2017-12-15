//
//  AppDelegate.swift
//  carryonex
//
//  Created by Xin Zou on 8/8/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
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
    static var appToken : String? // singleton for app to login server
    static var timestamp: String?
    var mainNavigationController: UINavigationController?
    var mainTabViewController: MainTabBarController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         
        UIApplication.shared.statusBarStyle = .default
        
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
        ZDKConfig.instance()
            .initialize(withAppId: "9c9a18f374b6017ce85429d7576ebf68c84b42ad8399da76",
                        zendeskUrl: "https://carryonex.zendesk.com",
                        clientId: "mobile_sdk_client_fe7793872b8aa3992ec1")
        ZDKConfig.instance().userIdentity = ZDKAnonymousIdentity()
        
        //setup Flickr SDK
        FlickrKit.shared().initialize(withAPIKey: "de264bf38194171ee76392fba833bbab", sharedSecret: "2410000e87f5a329")
        
        //Setup Stripe
        //WalletManager.shared.initializeStripe()
        
        //Setup push notifications
        registerForPushNotifications()
        
        if let mainNavigationController = self.window?.rootViewController as? UINavigationController {
            self.mainNavigationController = mainNavigationController
            self.mainTabViewController = mainNavigationController.childViewControllers[0] as? MainTabBarController
        }
        return true
    }
    
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
        
        //Pull when app comes to foreground, refresh store
        TripOrderDataStore.shared.pullAll(completion: {
            print("Pull ALL completed")
        })
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
        print("Device Token: \(token)")
        
        UserDefaults.setDeviceToken(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for push notification: \(error.localizedDescription)")
    }
    
    /// WeChat API connection
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.scheme == "carryonex" {
            DeeplinkNavigator.handleDeeplink(url)
            
        } else if url.host == "safepay" {
            WalletManager.shared.aliPayHandleOrderUrl(url)
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        WXApi.handleOpen(url, delegate: WeChatAPIManager.shared)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        WXApi.handleOpen(url, delegate: WeChatAPIManager.shared)
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Remote notification: \(userInfo)")
        
        //Show alert when push notification is recieved
        if let mainViewController = self.mainTabViewController {
            if let page = userInfo["page"] as? String, let aps = userInfo["aps"] as? [String: Any], let title = aps["alert"] as? String {
                let category: TripCategory = (page == "carrier") ? .sender : .carrier
                mainViewController.displayGlobalAlert(title: "寄件状态更新", message: title, action: "好", completion: {
                    TripOrderDataStore.shared.pull(category: category, completion: nil)
                })
            }
        }
    }
    
    
    //MARK: - Push Notifications
    
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if let error = error {
                debugLog("APNS Permission Error: \(error.localizedDescription)")
            }
            //print("APNS Permission granted: \(granted)")
            self.getNotificationSettings()
        }
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            //print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else {
                debugLog("Bad Notification settings status: \(settings.authorizationStatus)")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    static public func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

