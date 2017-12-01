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
        //testPostUserSos()
        //testPostUserInfo()
        //testPostTripActive(isActive: true)  //Test get also
        //testGetTripActive()
        //testGetUserInfo(info: .imageUrl)
        
        //Comments
        //testGetComments(userId: 7)
        //testPostComments(comment: "Hello world tester comment", commenteeId: 7, commenterId: 19, rank: 4)
    }
    
    static func testPostUserSos() {
        let phone = "6469279306"
        ApiServers.shared.postUserForgetPassword(phone: phone, password: "abc123") { (success, error) in
            debugPrint("Success: \(success)")
            if let error = error {
                debugPrint("Error: \(error)")
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
                print("Update user info real name: \(realName)")
            }
            
            if let imageUrl = user?.imageUrl {
                print("Update user info imageUrl: \(imageUrl)")
            }
        }
    }
    
    static func testPostTripActive(isActive: Bool) {
        ApiServers.shared.postTripActive(tripId: "42", isActive: isActive) { (success, error) in
            print("Update success")
            self.testGetTripActive()
        }
    }
    
    static func testGetTripActive() {
        ApiServers.shared.getTripActive(tripId: "42") { (state, error) in
            if let error = error {
                print("Get trip error: \(error.localizedDescription)")
            }
            
            print("Trip active state: \(state)")
        }
    }
    
    static func testGetUserInfo(info: UsersInfoUpdate) {
        ApiServers.shared.getUserInfo(info) { (value, error) in
            if let value = value {
                print("Get user info \(info.rawValue): \(value)")
            }
        }
    }
    
    static func testGetComments(userId: Int) {
        ApiServers.shared.getUserComments(commenteeId: userId, offset: 0) { (userComments, error) in
            if let userComments = userComments {
                for comment in userComments.comments {
                    print("id: \(comment.id) Comment: \(comment.comment)")
                }
            }
        }
    }
    
    static func testPostComments(comment: String, commenteeId: Int, commenterId: Int, rank: Float) {
        ApiServers.shared.postComment(comment: comment, commenteeId: commenteeId, commenterId: commenterId, rank: rank) { (success, error) in
            print("Is post comment success: \(success)")
        }
    }
}
