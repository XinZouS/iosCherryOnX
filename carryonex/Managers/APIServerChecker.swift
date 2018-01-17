//
//  APIServerChecker.swift
//  carryonex
//
//  Created by Zian Chen on 11/25/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class APIServerChecker: NSObject {
    
    static func testAPIServers() {
        //testDelivery()
        //testPostUserSos()
        //testPostUserInfo()
        //testPostTripActive(isActive: true)  //Test get also
        //testGetTripActive()
        //testGetUserInfo(info: .imageUrl)
        
        //Comments
        //testGetComments(userId: 7)
        //testPostComments(comment: "Hello world tester comment", commenteeId: 7, commenterId: 19, rank: 4)
        
//        testAliVerification()
    }
    
    static func testPostUserSos() {
        let phone = "6469279306"
        ApiServers.shared.postUserForgetPassword(phone: phone, password: "abc123") { (success, error) in
            DLog("Success: \(success)")
            if let error = error {
                DLog("Error: \(error)")
            }
        }
    }
    
    static func testPostUserInfo() {
        let userInfo: [String: Any] = [
            ProfileUserKey.userId.rawValue: 19,
            ProfileUserKey.realName.rawValue: "陈子安",
            ProfileUserKey.imageUrl.rawValue: "https://i.ytimg.com/vi/8BYa0U1h5Fs/hqdefault.jpg"
        ]
        
        ApiServers.shared.postUserUpdateInfo(info: userInfo) { (user, error) in
            if let realName = user?.realName {
                DLog("Update user info real name: \(realName)")
            }
            
            if let imageUrl = user?.imageUrl {
                DLog("Update user info imageUrl: \(imageUrl)")
            }
        }
    }
    
    static func testPostTripActive(isActive: Bool) {
        ApiServers.shared.postTripActive(tripId: "42", isActive: isActive) { (success, error) in
            DLog("Update success")
            self.testGetTripActive()
        }
    }
    
    static func testGetTripActive() {
        ApiServers.shared.getTripActive(tripId: "42") { (state, error) in
            if let error = error {
                DLog("Get trip error: \(error.localizedDescription)")
            }
            
            DLog("Trip active state: \(state)")
        }
    }
    
    static func testGetUserInfo(info: UsersInfoUpdate) {
        ApiServers.shared.getUserInfo(info) { (value, error) in
            if let value = value {
                DLog("Get user info \(info.rawValue): \(value)")
            }
        }
    }
    
    static func testGetComments(userId: Int) {
        ApiServers.shared.getUserComments(commenteeId: userId, offset: 0) { (userComments, error) in
            if let userComments = userComments {
                for comment in userComments.comments {
                    DLog("id: \(comment.id) Comment: \(comment.comment)")
                }
            }
        }
    }
    
    static func testPostComments(comment: String, commenteeId: Int, commenterId: Int, rank: Float, requestId: Int) {
        ApiServers.shared.postComment(comment: comment, commenteeId: commenteeId, commenterId: commenterId, rank: rank, requestId: requestId) { (success, error) in
            DLog("Is post comment success: \(success)")
        }
    }
    
    static func testAliVerification() {
        let urlPath = "carryonex://safepay/?%7B%22memo%22:%7B%22result%22:%22%7B%5C%22alipay_trade_app_pay_response%5C%22:%7B%5C%22code%5C%22:%5C%2210000%5C%22,%5C%22msg%5C%22:%5C%22Success%5C%22,%5C%22app_id%5C%22:%5C%222017111409922946%5C%22,%5C%22auth_app_id%5C%22:%5C%222017111409922946%5C%22,%5C%22charset%5C%22:%5C%22utf-8%5C%22,%5C%22timestamp%5C%22:%5C%222017-12-23%2009:50:02%5C%22,%5C%22total_amount%5C%22:%5C%220.10%5C%22,%5C%22trade_no%5C%22:%5C%222017122321001004700288259481%5C%22,%5C%22seller_id%5C%22:%5C%222088821540881344%5C%22,%5C%22out_trade_no%5C%22:%5C%22CO_55_0%5C%22%7D,%5C%22sign%5C%22:%5C%22Lr7fQd3AyQ%5C/sAht8A70HqPBaUI0lLeGW9veOCgSBvtVI9c%5C/vt6P1pOMDGFfM2fUgJe4hqKylopkykZTGON2U08etKdxAzoRorsObCqfZeped%5C/b6JoefjKOUNeOXQ0%5C/1vxgjWfjeTHRpz%5C/h8l6RvcCKfQLeKxLGtpq5UGLgU9NDGmAwmKG7RN+DJ4Zd9bKDwGrJJ4SqcrejUdZYVl%5C/9iBrtsyblpPORqO40P9ngnCBhHK07tD2JFQ1QLxOoc0P9f%5C/qjEQZNNus%5C/sDNU45+p%5C/mES3iWe6kCeYuu%5C/t7gTgtbC4LAVqEL%5C/KjwnXMgZ4OWz7J1EKzo7WY%5C/yabDk%5C/RD8GVJQ==%5C%22,%5C%22sign_type%5C%22:%5C%22RSA2%5C%22%7D%22,%22ResultStatus%22:%229000%22,%22memo%22:%22%22%7D,%22requestType%22:%22safepay%22%7D"
        if let url = URL(string: urlPath) {
            WalletManager.shared.aliPayHandleOrderUrl(url)
        }
    }
    
    static func testDelivery() {
        let companyCode = "huitongkuaidi"
        let tracking = "70118428554311"
        
        ApiServers.shared.checkDelivery(tracking: tracking, companyCode: companyCode) { (kuaidiObject, error) in
            if let error = error {
                DLog("Error: \(error.localizedDescription)")
                return
            }
            
            if let processObjects = kuaidiObject?.data {
                for object in processObjects {
                    print("\(object.context)\n")
                }
            }
        }
    }
}
