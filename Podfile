# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'carryonex' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for carryonex

  pod 'Unbox', '2.5.0'
  pod 'Alamofire', '4.5.1'
  pod 'AlamofireImage'
  pod 'M13Checkbox', '3.1.1'
  pod 'SMSSDK', '3.0.1'
  pod 'ALCameraViewController', '2.0.3'

  # AWS S3 for image storage
  pod 'AWSCore', '2.6.4'
  pod 'AWSS3', '2.6.4'
  pod 'AWSCognito', '2.6.4'

  # Mob sharing: 主模块(必须)------------------------------------------
  pod 'ShareSDK3', '4.0.3'
  # Mob 公共库(必须) 如果同时集成SMSSDK iOS2.0:可看此注意事项：http://bbs.mob.com/thread-20051-1-1.html
  pod 'MOBFoundation', '3.0.6'

  # UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
  pod 'ShareSDK3/ShareSDKUI', '4.0.3'

  # 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
  #pod 'ShareSDK3/ShareSDKPlatforms/QQ'
  pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo', '4.0.3'
  pod 'ShareSDK3/ShareSDKPlatforms/WeChat', '4.0.3'
  # ShareSDKPlatforms模块其他平台，按需添加
  #pod 'ShareSDK3/ShareSDKPlatforms/RenRen'
  #pod 'ShareSDK3/ShareSDKPlatforms/AliPaySocial'
  #pod 'ShareSDK3/ShareSDKPlatforms/Kakao'
  #pod 'ShareSDK3/ShareSDKPlatforms/Yixin'
  #pod 'ShareSDK3/ShareSDKPlatforms/Facebook'
  #pod 'ShareSDK3/ShareSDKPlatforms/Copy'
  #pod 'ShareSDK3/ShareSDKPlatforms/Evernote'
  #pod 'ShareSDK3/ShareSDKPlatforms/GooglePlus'
  #pod 'ShareSDK3/ShareSDKPlatforms/Instagram'
  #pod 'ShareSDK3/ShareSDKPlatforms/Instapaper'
  #pod 'ShareSDK3/ShareSDKPlatforms/Line'
  #pod 'ShareSDK3/ShareSDKPlatforms/Mail'
  #pod 'ShareSDK3/ShareSDKPlatforms/SMS'
  #pod 'ShareSDK3/ShareSDKPlatforms/WhatsApp'
  #pod 'ShareSDK3/ShareSDKPlatforms/MeiPai'
  #pod 'ShareSDK3/ShareSDKPlatforms/DingTalk'
  #pod 'ShareSDK3/ShareSDKPlatforms/YouTube'
  #pod 'ShareSDK3/ShareSDKPlatforms/Twitter'
  #pod 'ShareSDK3/ShareSDKPlatforms/Dropbox'

  # 使用配置文件分享模块（非必需）
  pod 'ShareSDK3/ShareSDKConfigurationFile', '4.0.3'

  # 扩展模块（在调用可以弹出我们UI分享方法的时候是必需的）
  pod 'ShareSDK3/ShareSDKExtension'
  # Mob sharing -----------------------------------------------------

  # Facebook login and sharing
  pod 'FBSDKCoreKit', '4.22.1'
  pod 'FBSDKLoginKit', '4.22.1'
  pod 'FBSDKShareKit', '4.22.1'

  #UI design
  pod 'JXPhotoBrowser', '0.3.7'

  #Network connection detactor
  pod 'ReachabilitySwift'

  # Fabric install
  use_frameworks!
  pod 'Fabric'
  pod 'Crashlytics'

  # Zendesk SDK
  pod 'ZendeskSDK'
  
  # Flickr SDK: get image based on location
  pod 'FlickrKit', '1.0.9'

  # stripe
  pod 'Stripe'
  
  # indicator
  pod 'BPCircleActivityIndicator'
  pod 'TGRefreshSwift'
  
end
