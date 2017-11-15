//
//  GlobalVariable.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/18.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import Foundation

// if changes the key in this map, MUST change also in the flagsTitle array
// *** the order of flags in flagsTitle should NOT be change!!!
let codeOfFlag : [String:String] = ["🇺🇸  +1":"1", "🇨🇳 +86":"86", "🇭🇰 852":"852", "🇹🇼 886":"886", "🇦🇺 +61":"61", "🇬🇧 +44":"44", "🇩🇪 +49":"49"]
var flagsTitle : [String] = ["🇺🇸  +1", "🇨🇳 +86", "🇭🇰 852", "🇹🇼 886", "🇦🇺 +61", "🇬🇧 +44", "🇩🇪 +49"]

//正则校验
struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
enum ImageTypeOfID : String {
    case passport = "passport"
    case idCardA = "idCardA"
    case idCardB = "idCardB"
    case profile = "profile"
    case requestImages = "requestImages"
}

protocol PickerMenuViewDelegate: class {
    
    func setupMenuWith(hostView: UIView, targetPickerView: UIPickerView, leftBtn: UIButton, rightBtn: UIButton)
    func setupTitle(text: String)
    func showUpAnimation(withTitle: String)
    func dismissAnimation()
}

protocol PhoneNumberDelegate: class {
    func dismissAndReturnToHomePage()
}

enum Payment {
    case applePay, paypal, creditCard, wechatPay
}

protocol ZipcodeCellDelegate: class {
    func setupTextField()
}

enum TripCategory: Int {
    case Carrier
    case Sender
    
    var stringValue: String {
        switch self {
        case .Carrier:
            return "carrier"
        case .Sender:
            return "sender"
        }
    }
}

/// Save user into disk by NSUserDefault
enum UserDefaultKey : String {
    case OnboardingFinished = "OnboardingFinished"
    case profileImageLocalUrl = "profileImageLocalUrl"
}

/// weixin SDK keys
let WX_APPID = "wx9dc6e6f4fe161a4f"
let WX_APPSecret = "360d1facd22ebe58ec58908728633432"

/// QQ SDK keys
let QQ_APPID = "100371282"
let QQ_APPKEY = "aed9b0303e3ed1e27bae87c33761161d"

/// Weibo SDK keys
let WB_APPKEY = "568898243"
let WB_APPSecret = "38a4f8204cc784f81f9f0daaf31e02e3"

/// AWS server keys
let awsIdentityPoolId = "us-west-2:08a19db5-a7cc-4e82-b3e1-6d0898e6f2b7" 
let awsBucketName = "carryoneximage"
let awsPublicBucketName = "carryonexpublicimage"

let imageCompress: CGFloat = 0.1

/// for more info display in MenuController
let userGuideWebHoster = "http://54.245.216.35:5000"


//MARK: - Helper Methods

func debugLog(_ message: String,
              function: String = #function,
              file: String = #file,
              line: Int = #line) {
    print("Message \"\(message)\" (File: \(file), Function: \(function), Line: \(line))")
}

func L(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

enum ErrorType: Int {
    case noError = 0
    case userRegisterErr = 1
    case userAlreadyExist = 2
    case userLoadLocalFail = 3
    case userInfoNull = 4
    
}
