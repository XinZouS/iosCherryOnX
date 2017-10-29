//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

#import <SMS_SDK/SMSSDK.h>

#import "FSCalendar/FSCalendar.h"


// MOB sharing SDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯SDK头文件
//#import <TencentOpenAPI/TencentOAuth.h>
//#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

//人人SDK头文件
//#import <RennSDK/RennSDK.h>

//Kakao SDK头文件
//#import <KakaoOpenSDK/KakaoOpenSDK.h>

//支付宝SDK
//#import "APOpenAPI.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

