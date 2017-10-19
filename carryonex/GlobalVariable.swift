//
//  GlobalVariable.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/18.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import Foundation

protocol OrdersSenderPageCellDelegate {
    func registerCollectionView()
    func fetchRequests()
}

// if changes the key in this map, MUST change also in the flagsTitle array
// *** the order of flags in flagsTitle should NOT be change!!!
let codeOfFlag : [String:String] = ["🇨🇳 +86":"86", "🇺🇸  +1":"1", "🇭🇰 852":"852", "🇹🇼 886":"886", "🇦🇺 +61":"61", "🇬🇧 +44":"44", "🇩🇪 +49":"49"]
var flagsTitle : [String] = ["🇨🇳 +86", "🇺🇸  +1", "🇭🇰 852", "🇹🇼 886", "🇦🇺 +61", "🇬🇧 +44", "🇩🇪 +49"]
// save key from above
var isModifyPhoneNumber : Bool = false
var isUserAgree: Bool = false
var isRegister : Bool = false
var alreadyExist:Bool = false
var isOrderList : Bool = false

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
}

protocol PickerMenuViewDelegate: class {
    
    func setupMenuWith(hostView: UIView, targetPickerView: UIPickerView, leftBtn: UIButton, rightBtn: UIButton)
    func setupTitle(text: String)
    func showUpAnimation(withTitle: String)
    func dismissAnimation()
}

enum Payment {
    case applePay, paypal, creditCard, wechatPay
}

protocol ZipcodeCellDelegate: class {
    func setupTextField()
}


