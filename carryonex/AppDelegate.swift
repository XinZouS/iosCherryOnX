//
//  AppDelegate.swift
//  carryonex
//
//  Created by Xin Zou on 8/8/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import CoreData
import FBSDKCoreKit
 

let awsIdentityPoolId = "us-west-2:08a19db5-a7cc-4e82-b3e1-6d0898e6f2b7"

let WX_APPID = "wx9dc6e6f4fe161a4f"
let WX_APPSecret = "360d1facd22ebe58ec58908728633432"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate {

    var window: UIWindow?
   
    static var appToken : String? // singleton for app to login server
    static var timestamp: String?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
         
         //change navigation bar color
        UINavigationBar.appearance().barTintColor = barColorGray.withAlphaComponent(0.1)
        //UINavigationBar.appearance().isTranslucent = true
        UIApplication.shared.statusBarStyle = .lightContent
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        //window?.rootViewController = PageContainer()
        window?.rootViewController = HomePageController() //UINavigationController(rootViewController: HomePageController())
        
        // setup MOB msm verification
        let smAppkey = "202b81354d75e"
        let app_secrect = "15e6f9dae82927d06568db03f133d75c"
        //SMSSDK.registerApp(smAppkey, withSecret: app_secrect) // no func regisiterApp() ?????
        
        setupMobSharingSDK()
        
        // setupFacebookSharingSDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        // setup WeChatSDK
        WXApi.registerApp(WX_APPID, enableMTA: true)
        
        
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
                    appInfo?.ssdkSetupSinaWeibo(byAppKey: "568898243",
                                                appSecret: "38a4f8204cc784f81f9f0daaf31e02e3",
                                                redirectUri: "http://www.sharesdk.cn",
                                                authType: SSDKAuthTypeBoth)
                    
                case SSDKPlatformType.typeWechat:
                    //设置微信应用信息, appSecret we ONLY have this one, do NOT remove it !!!!!!!!!!
                    appInfo?.ssdkSetupWeChat(byAppId: WX_APPID,
                                             appSecret: WX_APPSecret) // "64020361b8ec4c99936c0e3999a9f249")
                case SSDKPlatformType.typeQQ:
                    //设置QQ应用信息
                    appInfo?.ssdkSetupQQ(byAppId: "100371282",
                                         appKey: "aed9b0303e3ed1e27bae87c33761161d",
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
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    /// WeChat API connection
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        WXApi.handleOpen(url, delegate: self)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        WXApi.handleOpen(url, delegate: self)
        return true
    }
    
    // WXApiDelegate: [3] 现在，你的程序要实现和微信终端交互的具体请求与回应，因此需要实现WXApiDelegate协议的两个方法, 具体在此两方法中所要完成的内容由你定义.
    // from: https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN
    func onReq(_ req: BaseReq!) {
        print("TODO: 微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。")
    }
    
    func onResp(_ resp: BaseResp!) {
        if resp.errCode == 0 && resp.type == 0 {//授权成功
            if let response = resp as? SendAuthResp {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "WXLoginSuccessNotification"), object: response.code)
            }
        }
    }

    
    // MARK: - facebook sdk support
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey:Any] = [:]) -> Bool {
//        // get reference from https://developers.facebook.com/docs/facebook-login/ios, then do it in swift:
//        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
//    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "carryonex")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

