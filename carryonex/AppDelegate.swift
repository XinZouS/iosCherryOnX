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
import AWSCognito
import ZendeskSDK
import FlickrKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?
    static var appToken : String? // singleton for app to login server
    static var timestamp: String?
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
        Fabric.with([Crashlytics.self, AWSCognito.self])

        //setup Zendesk
        ZDKConfig.instance()
            .initialize(withAppId: "9c9a18f374b6017ce85429d7576ebf68c84b42ad8399da76",
                        zendeskUrl: "https://carryonex.zendesk.com",
                        clientId: "mobile_sdk_client_fe7793872b8aa3992ec1")
        
        let identity = ZDKAnonymousIdentity()
        ZDKConfig.instance().userIdentity = identity
        
        //setup Flickr SDK
        FlickrKit.shared().initialize(withAPIKey: "de264bf38194171ee76392fba833bbab", sharedSecret: "2410000e87f5a329")
        
        //Setup Stripe
        WalletManager.shared.initializeStripe()
        
        //Setup push notifications
        registerForPushNotifications()
        
        if let mainNavigationController = self.window?.rootViewController {
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
                    //case SSDKPlatformType.typeQQ:
                //    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
                }
        },
            onConfiguration: {(platform : SSDKPlatformType , appInfo : NSMutableDictionary?) -> Void in
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

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        application.applicationIconBadgeNumber = 0
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
    
    

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    /// WeChat API connection
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url, standbyCallback: { (result) in
                if let result = result {
                    WalletManager.shared.aliPayProcessOrderCallbackHandler(result: result)
                    print("OpenURL callback result: \(result)")
                }
            })
            
            AlipaySDK.defaultService().processAuth_V2Result(url, standbyCallback: { (result) in
                var authCode: String? = nil
                if let resultValue = result?["result"] as? String {
                    if resultValue.count > 0 {
                        let resultArr = resultValue.components(separatedBy: "&")
                        for subResult in resultArr {
                            if subResult.count > 10 && subResult.hasPrefix("auth_code=") {
                                let index = subResult.index(subResult.endIndex, offsetBy: -10)
                                authCode = subResult.substring(from: index)
                                break
                            }
                        }
                    }
                }
                
                if let authCode = authCode {
                    print("Authorization result: \(authCode)")
                }
            })
        }
        
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        WXApi.handleOpen(url, delegate: self)
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        WXApi.handleOpen(url, delegate: self)

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
    
    
    // MARK: - WeChat Authentication Support
    
    // WXApiDelegate: [3] 现在，你的程序要实现和微信终端交互的具体请求与回应，因此需要实现WXApiDelegate协议的两个方法, 具体在此两方法中所要完成的内容由你定义.
    // from: https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN
    func onReq(_ req: BaseReq!) {
        print("TODO: 微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。")
    }
    
    func onResp(_ resp: BaseResp!) {
        if resp.errCode == 0  {
            if let resp = resp as? SendAuthResp {
                if wxloginStatus == "fillProfile"{
                    NotificationCenter.default.post(name: Notification.Name.WeChat.ChangeProfileImg, object: resp)
                }else{
                    NotificationCenter.default.post(name: Notification.Name.WeChat.Authenticated, object: resp)
                }
            }
        } else {
            NotificationCenter.default.post(name: Notification.Name.WeChat.AuthenticationFailed, object: resp)
        }
    }
    
    //MARK: - Push Notifications
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            if let error = error {
                debugLog("APNS Permission Error: \(error.localizedDescription)")
            }
            //print("APNS Permission granted: \(granted)")
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
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
    static func shared() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
}

