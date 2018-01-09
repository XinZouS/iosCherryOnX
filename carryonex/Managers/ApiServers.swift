//
//  ApiServers.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation
import Alamofire
import Unbox
import Stripe

enum UsersInfoUpdate : String {
    case salt       = "salt"
    case phone      = "phone"
    case imageUrl   = "imageurl"
    case passportUrl = "passporturl"
    case idAUrl     = "idaurl"
    case idBUrl     = "idburl"
    case email      = "email"
    case realName   = "realname"
    case isExist    = "exist"
    case wallet     = "wallet"
    case isIdVerified = "idverified"
    case isPhoneVerified = "phoneverified"
}

let UsersInfoUpdateKey : [UsersInfoUpdate: ProfileUserKey] = [
    UsersInfoUpdate.salt : ProfileUserKey.salt,
    UsersInfoUpdate.phone : ProfileUserKey.phone,
    UsersInfoUpdate.imageUrl : ProfileUserKey.imageUrl,
    UsersInfoUpdate.passportUrl: ProfileUserKey.passportUrl,
    UsersInfoUpdate.idAUrl : ProfileUserKey.idAUrl,
    UsersInfoUpdate.idBUrl : ProfileUserKey.idBUrl,
    UsersInfoUpdate.email : ProfileUserKey.email,
    UsersInfoUpdate.realName  : ProfileUserKey.realName,
    UsersInfoUpdate.wallet : ProfileUserKey.walletId,
    UsersInfoUpdate.isIdVerified : ProfileUserKey.isIdVerified,
    UsersInfoUpdate.isPhoneVerified : ProfileUserKey.isPhoneVerified
]

enum ServerUserLogUrl : String {
    case myCarries = "requests"
    case myTrips = "trips"
}

/// component of url query
enum ServerTripUrl : String {
    case youxiangCode   = "trips"
    case infoById       = "info"
    case startState     = "startstate/list"
    case startCity      = "startcity/list"
    case startZipcode   = "startzipcode/list"
    case startCountry   = "startcountry/list"
    case startToEndCountry  = "startcountry/endcountry/list"
    case startToEndState    = "startstate/endstate/list"
    case startToEndCity = "startcity/endcity/list"
    case startToEndZip  = "startzipcode/endzipcode/list"
    case requests       = "trips/requests"
}

/// key of parameters in the query url
let ServerTripPropKey : [ServerTripUrl : String] = [
    ServerTripUrl.youxiangCode  : "trip_code",
    ServerTripUrl.infoById      : "id",
    ServerTripUrl.startState    : "query",
    ServerTripUrl.startCity     : "query",
    ServerTripUrl.startZipcode  : "query",
    ServerTripUrl.startCountry  : "query",
    ServerTripUrl.requests      : "id"
]


class ApiServers : NSObject {
    
    static let shared = ApiServers()
    
    enum ServerKey: String {
        case data = "data"
        case statusCode = "status_code"
        case message = "message"
        case appToken = "app_token"
        case userToken = "user_token"
        case username  = "username"
        case password  = "password"
        case countryCode = "country_code"
        case phone     = "phone"
        case email     = "email"
        case timestamp = "timestamp"
        case pageCount = "page_count"
        case offset = "offset"
        case userType = "user_type"
        case deviceToken = "device_token"
        case realName = "real_name"
        case tripId = "trip_id"
        case userId = "user_id"
        case sinceTime = "since_time"
    }
    
    
    private let appToken: String = "0123456789012345678901234567890123456789012345678901234567890123"

    let host = "https://www.carryonx.com"
    private let hostVersion = "/api/1.0"
    
    var config: Config?
    
    private override init() {
        super.init()
    }
    
    func validationHeader(userToken: String, username: String) -> [String: Any] {
        let params: [String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: userToken,
            ServerKey.username.rawValue: username
        ]
        return params
    }
    
    // MARK: - User APIs
    // NOTE: USE PROFILE MANAGER TO REGISTER AND LOGIN!!!
    func postRegisterUser(username: String, countryCode: String, phone: String, password: String, email: String, name: String, completion: @escaping(String?, Error?) -> Swift.Void) {
        
        let route = hostVersion + "/users"
        var postData = [
            ProfileUserKey.username.rawValue: username,
            ServerKey.password.rawValue: password,
            ProfileUserKey.countryCode.rawValue: countryCode,
            ProfileUserKey.realName.rawValue: name
        ]
        
        if phone.isEmpty {
            postData[ProfileUserKey.noPhone.rawValue] = ""
        } else {
            postData[ProfileUserKey.phone.rawValue] = phone
        }
        
        if !email.isEmpty {
            postData[ProfileUserKey.email.rawValue] = email
        }
        
        let parameters:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.data.rawValue : postData
        ]
        
        postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postRegisterUser response error: \(error.localizedDescription)")
                }
                completion(nil, error)
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                if let token = data[ServerKey.userToken.rawValue] as? String {
                    completion(token, nil)
                } else {
                    print("postRegisterUser - Unable to find token from user data")
                    completion(nil, nil)
                }
            } else {
                print("postRegisterUser - Unable to find user data")
                completion(nil, nil)
            }
        }
    }
    
    func getIsUserExisted(phoneInput: String, completion: @escaping (Bool, Error?) -> Void){
        
        let sessionStr = hostVersion + "/users/exist"
        let headers:[String: Any] = [
            ServerKey.username.rawValue: phoneInput,
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken
        ]
        
        getDataWithUrlRoute(sessionStr, parameters: headers) { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("getIsUserExisted response error: \(error.localizedDescription)")
                }
                completion(false, error)
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                if let isExists = data["isExists"] as? String {
                    print("getIsUserExisted: isExists field value \(isExists)")
                    completion(isExists.isTrue(), nil)
                } else {
                    print("getIsUserExisted: isExists field empty")
                    completion(false, nil)
                }
            } else {
                print("getIsUserExisted: Data field empty")
                completion(false, nil)
            }
        }
    }

    func postLoginUser(username: String? = nil,
                       phone: String? = nil,
                       password: String,
                       completion: @escaping ((String, String)?, Error?) -> Void) { //(token, username), error
        
        let deviceToken = UserDefaults.getDeviceToken() ?? ""
        
        let route = hostVersion + "/users/login"
        
        var data: [String: Any] = [
            ServerKey.password.rawValue: password,
            ServerKey.deviceToken.rawValue: deviceToken
        ]
        
        if let phone = phone {
            data[ServerKey.phone.rawValue] = phone
        }
        
        if let username = username {
            data[ServerKey.username.rawValue] = username
        }
        
        let parameter:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.data.rawValue : data
        ]
        
        postDataWithUrlRoute(route, parameters: parameter) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postLoginUser response error: \(error.localizedDescription)")
                }
                completion(nil, error)
                return
            }
            
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                    if let token = data[ServerKey.userToken.rawValue] as? String, let username = data[ServerKey.username.rawValue] as? String {
                        completion((token, username), nil)
                        
                    } else {
                        print("postLoginUser - Unable to find token from user data")
                        completion(nil, nil)
                    }
                    
                } else {
                    print("postLoginUser - Unable to find user data")
                    completion(nil, nil)
                }
            
            } else{
                print("Invalid credential")
                completion(nil, nil)
            }
        }
    }
    
    func postLogoutUser(completion: @escaping (Bool, Error?) -> Void) {
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("postLogoutUser: Profile user empty, please login in order to logout")
            completion(false, nil)
            return
        }
        
        let route = hostVersion + "/users/logout"
        let parms:[String:Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.data.rawValue : [
                ServerKey.username.rawValue : (profileUser.username) ?? ""
            ]
        ]
        
        postDataWithUrlRoute(route, parameters: parms) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postLogoutUser response error: \(error.localizedDescription)")
                }
                completion(false, error)
                return
            }
            
            if let message = response[ServerKey.message.rawValue] as? String {
                debugLog(message)
            }
            
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                completion(true, nil)
            }else{
                completion(false, nil)
            }
        }
    }
    
    func getUserInfo(username: String, userToken: String, completion: @escaping (HomeProfileInfo?, Error?) -> Void){
        
        let sessionStr = hostVersion + "/users/info"
        
        let headers:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.username.rawValue : username,
            ServerKey.userToken.rawValue: userToken
        ]
        
        getDataWithUrlRoute(sessionStr, parameters: headers) { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("GetUserInfo response error: \(error.localizedDescription)")
                }
                completion(nil, error)
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let profileInfo: HomeProfileInfo = try unbox(dictionary: data)
                    profileInfo.user.printAllData()
                    completion(profileInfo, nil)
                    
                } catch let error {
                    completion(nil, error)
                    print("Get error when getUserInfo. Error = \(error.localizedDescription)")
                }
                
            } else {
                print("GetUserInfo empty data")
                completion(nil, nil)
            }
        }
    }
    
    
    func getUserLogsOf(type: ServerUserLogUrl, completion: @escaping([Any]?) -> Void){
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getUserLogsOf: Profile user empty, please login to get user logs")
            completion(nil)
            return
        }
        
        let sessionStr = hostVersion + "/users/" + type.rawValue
        let headers:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue : profileUser.username ?? ""
        ]
        
        getDataWithUrlRoute(sessionStr, parameters: headers) { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("getUserLogsOf response error: \(error.localizedDescription)")
                }
                completion(nil)
                return
            }
            
            if let data = response["data"] as? [String : Any] {
                do {
                    if type == ServerUserLogUrl.myCarries {
                        let carries: [Request] = try unbox(dictionary: data, atKey: type.rawValue)
                        completion(carries)
                    
                    } else if type == ServerUserLogUrl.myTrips {
                        let trips : [Trip] = try unbox(dictionary: data, atKey: type.rawValue)
                        completion(trips)
                    }
                    
                } catch let err  {
                    print("get error when getUserLogsOf \(type.rawValue), err = \(err)")
                }
            }
        }
    }
    
    func getUserInfo(_ infoType: UsersInfoUpdate, userId: Int? = nil, completion: @escaping (Any?, Error?) -> Void) {
        guard ProfileManager.shared.isLoggedIn() else {
            print("getUserInfo (single) \(infoType.rawValue), please login to post update on user info")
            completion(false, nil)
            return
        }
        
        guard let username = ProfileManager.shared.username, let userToken = ProfileManager.shared.userToken else {
            print("getUserInfo (single) \(infoType.rawValue): Profile user empty, please login to post update on user info")
            completion(false, nil)
            return
        }
        
        let route = hostVersion + "/users/" + infoType.rawValue
        
        var params:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.username.rawValue : username,
            ServerKey.userToken.rawValue: userToken,
            ServerKey.timestamp.rawValue: Date.getTimestampNow()
        ]
        
        if let userId = userId {
            params["user_id"] = userId
        }
        
        getDataWithUrlRoute(route, parameters: params) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getUserInfo (single) \(infoType.rawValue) response error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any],
                let profileKey = UsersInfoUpdateKey[infoType]?.rawValue,
                let infoValue = data[profileKey] as Any? {
                completion(infoValue, nil)
                
            } else {
                print("getUserInfo (single) \(infoType.rawValue): No Data Field")
                completion(nil, nil)
            }
        }
    }
    
    func postUpdateUserInfo(_ updateType: UsersInfoUpdate, value: Any, completion: @escaping (Bool, Error?) -> Void) {
        
        guard ProfileManager.shared.isLoggedIn() else {
            print("postUpdateUserInfo: Profile user empty, please login to post update on user info")
            completion(false, nil)
            return
        }
        
        guard let username = ProfileManager.shared.username, let userToken = ProfileManager.shared.userToken else {
            print("postUpdateUserInfo: Profile user empty, please login to post update on user info")
            completion(false, nil)
            return
        }
        
        let route = hostVersion + "/users/" + updateType.rawValue
        
        var data: [String: Any] = [:]
        if let profileKey = UsersInfoUpdateKey[updateType]?.rawValue {
            data[profileKey] = value
            
        } else {
            print("Error in ApiServers: Update profile key for [\(updateType.rawValue)] not found, update failed.")
            completion(false, nil)
            return
        }
        
        let parms:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.username.rawValue : username,
            ServerKey.userToken.rawValue: userToken,
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue : data
        ]
        
        postDataWithUrlRoute(route, parameters: parms) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postUpdateUserInfo response error: \(error.localizedDescription)")
                    completion(false, error)
                }
                return
            }
            
            if let code = response[ServerKey.statusCode.rawValue] as? Int {
                if code == 200 {
                    print("Code 200, update \(updateType.rawValue) successful")
                    completion(true, nil)
                } else {
                    print("Code \(code), update \(updateType.rawValue) failed")
                    completion(false, nil)
                }
            } else {
                print("Code is missing, update \(updateType.rawValue) failed")
                completion(false, nil)
            }
        }
    }
    
    func postUserUpdateInfo(info: [String: Any], completion:@escaping (ProfileUser?, Error?) -> Void) {
        guard ProfileManager.shared.isLoggedIn() else {
            print("postUpdateUserInfo: Profile user empty, please login to post update on user info")
            completion(nil, nil)
            return
        }
        
        guard let username = ProfileManager.shared.username, let userToken = ProfileManager.shared.userToken else {
            print("postUpdateUserInfo: Profile user empty, please login to post update on user info")
            completion(nil, nil)
            return
        }
        
        let route = hostVersion + "/users/info"
        
        var userInfo = info
        if let email = userInfo[ProfileUserKey.email.rawValue] as? String, email.count == 0 {
            userInfo[ProfileUserKey.email.rawValue] = NSNull()
        }
        
        let parms:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.username.rawValue : username,
            ServerKey.userToken.rawValue: userToken,
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue : userInfo
        ]
        
        postDataWithUrlRoute(route, parameters: parms) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postUpdateUserInfo response error: \(error.localizedDescription)")
                    completion(nil, error)
                }
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let user: ProfileUser = try unbox(dictionary: data, atKey: "user")
                    user.printAllData()
                    completion(user, nil)
                    
                } catch let error {
                    completion(nil, error)
                    print("Get error when postUserUpdateInfo. Error = \(error.localizedDescription)")
                }
                
            } else {
                print("postUserUpdateInfo empty data")
                completion(nil, nil)
            }
        }
    }
    
    
    func getUsersTrips(userType: TripCategory, offset: Int = -1, pageCount: Int = -1, sinceTime: Int = -1, completion: @escaping(([TripOrder]?, Error?) -> Void)) {
        
        guard let username = ProfileManager.shared.username, let token = ProfileManager.shared.userToken else {
            print("getUsersTrips: Profile user empty, pleaes login to get user's trips")
            completion(nil, nil)
            return
        }
        
        let route = hostVersion + "/users/trips"
        var parameters : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.username.rawValue: username,
            ServerKey.userToken.rawValue: token,
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.userType.rawValue: userType.stringValue
        ]
        
        if offset > -1 { parameters[ServerKey.offset.rawValue] = offset }
        if pageCount > -1 { parameters[ServerKey.pageCount.rawValue] = pageCount }
        if sinceTime > -1 { parameters[ServerKey.sinceTime.rawValue] = sinceTime }
        
        getDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getUsersTrips response error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let tripOrders : [TripOrder] = try unbox(dictionary: data, atKey:"trips")
                    completion(tripOrders, nil)
                } catch let error as NSError {
                    print("getUsersTrips error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            } else {
                print("getUsersTrips: Empty data field")
                completion(nil, nil)
            }
        }
    }
    
    func postUserForgetPassword(phone: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let route = hostVersion + "/users/sos"
        
        let params : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue : [
                ServerKey.phone.rawValue: phone,
                ServerKey.password.rawValue: password
            ]
        ]
        
        postDataWithUrlRoute(route, parameters: params) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postUserForgetPassword response error: \(error.localizedDescription)")
                }
                completion(false, error)
                return
            }
            
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                print("Reset password success")
                completion(true, nil)
                
            } else{
                print("Bad Status, reset password failed")
                completion(false, nil)
            }
        }
    }
    
    func getUserGPS(userId: Int, completion: @escaping (GPS?, Error?) -> Void) {
        guard ProfileManager.shared.isLoggedIn() else {
            print("Please log in to get GPS for user id: \(userId)")
            completion(nil, nil)
            return
        }
        
        guard let username = ProfileManager.shared.username, let userToken = ProfileManager.shared.userToken else {
            print("Please get username and token to get GPS")
            completion(nil, nil)
            return
        }
        
        let route = hostVersion + "/users/gps"
        
        let params:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.username.rawValue : username,
            ServerKey.userToken.rawValue: userToken,
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.userId.rawValue: userId
        ]
        
        getDataWithUrlRoute(route, parameters: params) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getGPS response error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let gps:GPS = try unbox(dictionary: data)
                    completion(gps, nil)
                } catch let error as NSError {
                    print("getGPS error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            } else {
                print("getGPS: Empty data field")
                completion(nil, nil)
            }
        }
    }
    
    func postUserGPS(longitude: Double, latitude: Double, completion: ((Bool, Error?) -> Void)?) {
        
        guard ProfileManager.shared.isLoggedIn() else {
            print("Please log in to post GPS")
            completion?(false, nil)
            return
        }
        
        guard let username = ProfileManager.shared.username,
            let userToken = ProfileManager.shared.userToken,
            let userId = ProfileManager.shared.getCurrentUser()?.id else {
            print("Please get username and token to post GPS")
            completion?(false, nil)
            return
        }
        
        let route = hostVersion + "/users/gps"
        
        let params : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.username.rawValue: username,
            ServerKey.userToken.rawValue: userToken,
            ServerKey.data.rawValue : [
                ServerKey.userId.rawValue: userId,
                GPSKeyInDB.longitude.rawValue: longitude,
                GPSKeyInDB.latitude.rawValue: latitude,
            ]
        ]
        
        postDataWithUrlRoute(route, parameters: params) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postGPS response error: \(error.localizedDescription)")
                }
                completion?(false, error)
                return
            }
            
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                print("Post GPS success")
                completion?(true, nil)
                
            } else{
                print("Post GPS failed")
                completion?(false, nil)
            }
        }
    }
    
    
    //MARK: - Config API
    func getConfig() {
        let route = "/config"
        getDataWithUrlRoute(route, parameters: [:]) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getConfig response error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = response["data"] as? [String : Any] {
                do {
                    let config : Config = try unbox(dictionary: data, atKey: "config")
                    self.config = config
                    
                } catch let error as NSError {
                    print("getConfig error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    // MARK: - Trip APIs
    
    //TODO: UPDATE ID TO CODE IN SIGNATURE
    func getTripInfo(id: String, completion: @escaping (Bool, Trip?, Error?) -> Void) { //callback(success, trip object, error)
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getTripInfo: Profile user empty, pleaes login to get trip info")
            completion(false, nil, nil)
            return
        }
        
        let sessionStr = hostVersion + "/trips/info"
        
        let parameter:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            TripKeyInDB.tripCode.rawValue: id
        ]
        
        getDataWithUrlRoute(sessionStr, parameters: parameter) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getTrips response error: \(error.localizedDescription)")
                }
                completion(false, nil, error)
                return
            }
            
            if let statusCode = response[ServerKey.statusCode.rawValue] as? Int {
                if statusCode == 401 {
                    print("No trip is found")
                    completion(false, nil, nil)
                    
                } else {
                    if let data = response[ServerKey.data.rawValue] as? [String : Any] {
                        do {
                            let trip : Trip = try unbox(dictionary: data, atKey: "trip")
                            completion(true, trip, nil)
                            
                        } catch let err {
                            print("getTripInfo error: \(err.localizedDescription)")
                            completion(false, nil, err)
                        }
                        
                    } else {
                        print("No data is found")
                        completion(false, nil, nil)
                    }
                }
            }
        }
    }
    
    
    func postTripInfo(trip: Trip, completion: @escaping (Bool, String?, String?) -> Void){ //callBack(success,msg,id)
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            completion(false, "postTripInfo: Profile user empty, pleaes login to post trip info", "noTrip")
            return
        }
        
        let sessionStr = hostVersion + "/trips/trips"
        var tripDict = trip.packAsDictionaryForDB()
        tripDict[TripKeyInDB.carrierId.rawValue] = profileUser.id
        
        let parameter:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: tripDict
        ]
        
        postDataWithUrlRoute(sessionStr, parameters: parameter) { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("postTripInfo response error: \(error.localizedDescription)")
                }
                completion(false, error?.localizedDescription, nil)
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let trip: Trip = try unbox(dictionary: data, atKey: "trip")
                    completion(true, "Data post successful", trip.tripCode)
                    
                } catch let error as NSError {
                    completion(false, error.localizedDescription, nil)
                }
                
            } else {
                let msg = response[ServerKey.message.rawValue] as? String
                completion(false, msg, "noTrip")
            }
        }
    }
    
    func getTripActive(tripId: String, completion: @escaping (TripActive, Error?) -> Void) {
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getTripActive: Profile user empty, pleaes login to get trip active")
            completion(.error, nil)
            return
        }
        
        let route = hostVersion + "/trips/active"
        
        let params:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.tripId.rawValue: tripId
        ]
        
        getDataWithUrlRoute(route, parameters: params) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getTripActive response error: \(error.localizedDescription)")
                }
                completion(.error, error)
                return
            }
            
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                if let data = response[ServerKey.data.rawValue] as? [String: Any],
                    let active = data[TripKeyInDB.active.rawValue] as? Bool {
                    let isTripActive: TripActive = active ? .active : .inactive
                    completion(isTripActive, nil)
                    
                } else {
                    print("getTripActive no data from return")
                    completion(.error, nil)
                }
                
            } else {
                print("Bad Status, no trip found")
                completion(.notExist, nil)
            }
        }
    }
    
    func postTripActive(tripId: String, isActive: Bool, completion: @escaping (Bool, Error?) -> Void)  {
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("postTripActive: Profile user empty, pleaes login to post trip info")
            completion(false, nil)
            return
        }
        
        let route = hostVersion + "/trips/active"
        
        let data: [String: Any] = [
            TripKeyInDB.tripId.rawValue: tripId,
            TripKeyInDB.active.rawValue: isActive.hashValue
        ]
        
        let params : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue : profileUser.token ?? "",
            ServerKey.username.rawValue : profileUser.username ?? "",
            ServerKey.timestamp.rawValue : Date.getTimestampNow(),
            ServerKey.data.rawValue : data
        ]
        
        postDataWithUrlRoute(route, parameters: params) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("Post Trip Active response error: \(error.localizedDescription)")
                }
                completion(false, error)
                return
            }
            
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                print("Post Trip Active success")
                completion(true, nil)
                
            } else{
                print("Bad Status, Post Trip Active failed")
                completion(false, nil)
            }
        }
    }
    
    
    // MARK: - Request APIs
    
    /// completion: (success:Bool, error:Error, errCode:ServerErrorCode)
    func postRequest(totalValue: Double,
                     cost: Double,
                     stdPrice: Double,
                     destination: Address,
                     trip: Trip,
                     imageUrls: [String],
                     imageThumbnails: [String],
                     description: String,
                     completion: @escaping (Bool, Error?, ServerError) -> Void) {
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("postRequest: Unable to find profile user")
            completion(false, nil, .badRequest)
            return
        }
        
        let route = hostVersion + "/requests/create"
        var requestDict: [String: Any] = [
            RequestKeyInDB.endAddress.rawValue: destination.packAsDictionaryForDB(),
            RequestKeyInDB.tripId.rawValue: trip.id,
            RequestKeyInDB.totalValue.rawValue: Int(totalValue * 100),
            RequestKeyInDB.priceBySender.rawValue: Int(cost * 100),
            RequestKeyInDB.priceStd.rawValue: Int(stdPrice * 100),
            RequestKeyInDB.note.rawValue: description
        ]
        
        if imageUrls.count > 0 {
            var requestImages = [Any]() //as [Dictionary] = [item,item...] = [[img_url: url, thm_url: url], [img_url: url, thm_url: url]...]
            for i in 0..<imageUrls.count {
                let thumbnailUrl = (i < imageThumbnails.count ? imageThumbnails[i] : "")
                let item = ["image_url": imageUrls[i], "thumbnail_url": thumbnailUrl] //Use thumbnail url for thumbnail image
                requestImages.append(item)
            }
            requestDict[RequestKeyInDB.images.rawValue] = requestImages
        }
        
        let parameters: [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: requestDict
        ]
        
        postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postRequest response error: \(error.localizedDescription)")
                }
                completion(false, error, .notFound)
                return
            }
            //let statusCode = (response[ServerKey.statusCode.rawValue] as? Int) ?? 404
            if let statusCode = response[ServerKey.statusCode.rawValue] as? Int, statusCode == 200 {
                completion(true, nil, .ok)
            } else {
                print("postRequest - Unable to post request data")
                completion(false, nil, .notFound)
            } // TODO: temp usage, will replace by following after DB fixed:
            
            /*
             //If mengdi fix it and we need it in the future, we have the full request return.
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let request: Request = try unbox(dictionary: data, atKey: "request")
                    request.printAllData()
                    completion(true, nil, ServerError(rawValue: statusCode) ?? .ok)
                    
                } catch let error {
                    completion(false, error, ServerError(rawValue: statusCode) ?? .noResponse)
                    print("Get error when postRequest. Error = \(error.localizedDescription)")
                }
                
            } else {
                print("postRequest - Unable to post request data")
                completion(false, nil, ServerError(rawValue: statusCode) ?? .notFound)
            }
            */
        }
    }

    func postRequestTransaction(requestId: Int,
                                tripId: Int,
                                transaction: RequestTransaction,
                                completion: @escaping (Bool, Error?, Int?) -> Void) {   //success, error, status code
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("postRequest: Unable to find profile user")
            completion(false, nil, nil)
            return
        }
        
        let actionId = transaction.transaction().0
        let tripType = transaction.transaction().1
        
        if actionId == .invalid {
            debugLog("Invalid Transaction")
            completion(false, nil, nil)
            return
        }
        
        let route = hostVersion + "/requests/update"
        let requestDict: [String: Any] = [
            RequestKeyInDB.requestId.rawValue: requestId,
            RequestKeyInDB.action.rawValue: actionId.rawValue,
            RequestKeyInDB.userType.rawValue: tripType.stringValue,
            RequestKeyInDB.tripId.rawValue: tripId
        ]
        
        let parameters: [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: requestDict
        ]
        
        postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postRequest update response error: \(error.localizedDescription)")
                }
                completion(false, error, nil)
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                
                do {
                    let request: Request = try unbox(dictionary: data, atKey: "request")
                    completion(true, nil, request.statusId)
                    
                } catch let error {
                    completion(false, error, nil)
                    print("Get error when postRequestTransaction. Error = \(error.localizedDescription)")
                }
                
            } else {
                completion(false, nil, nil)
                print("postRequestTransaction no data error")
            }
        }
    }
    
    /// Completion: (success, msg, ["a":0.1,"b":500]), price = a * x + b
    func getRequestPrice(completion: @escaping (Bool, String?, [String:Double]?) -> Void){
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            let m = "Profile user empty, pleaes login to post request info"
            print("getRequestPrice: \(m)")
            completion(false, m, nil)
            return
        }
        
        let route = hostVersion + "/admin/price"
        
        let params : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue : profileUser.token ?? "",
            ServerKey.username.rawValue : profileUser.username ?? "",
            ServerKey.timestamp.rawValue : Date.getTimestampNow(),
        ]
        
        getDataWithUrlRoute(route, parameters: params) { (response, error) in
            guard let response = response else {
                if let error = error {
                    completion(false, error.localizedDescription, nil)
                    print("getRequestPrice response error: \(error.localizedDescription)")
                }
                return
            }
            guard let statusCode = response[ServerKey.statusCode.rawValue] as? Int, statusCode == 200 else {
                completion(false, error?.localizedDescription, nil)
                return
            }
            guard let data = response[ServerKey.data.rawValue] as? [String: Double] else {
                completion(false, "Unable to wrap data from server.", nil)
                return
            }
            completion(true, "", data)
        }


    }
    
    
    //MARK: - Comments
    func postComment(comment: String,
                     commenteeId: Int,
                     commenterId: Int,
                     rank: Float,
                     requestId: Int,
                     completion: @escaping (Bool, Error?) -> Void) {
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("postRequest: Unable to find profile user")
            completion(false, nil)
            return
        }
        
        let route = hostVersion + "/comments/comments"
        let requestDict: [String: Any] = [
            CommentKey.comment.rawValue: comment,
            CommentKey.commenteeId.rawValue: commenteeId,
            CommentKey.commenterId.rawValue: commenterId,
            CommentKey.rank.rawValue: rank,
            "request_id": requestId
        ]
        
        let parameters: [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: requestDict
        ]
        
        postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postComment update response error: \(error.localizedDescription)")
                }
                completion(false, error)
                return
            }
            
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                debugLog("Comment success")
                completion(true, nil)
            } else {
                debugLog("Unable to get data")
                completion(false, nil)
            }
        }
    }
    
    // let defaultPageCount = 4 for pageCount BUG: Cannot use instance member 'defaultPageCount' as a default parameter
    func getUserComments(commenteeId: Int, offset: Int, pageCount: Int = 4, completion: @escaping((UserComments?, Error?) -> Void)) {
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getUserComments: Profile user empty, pleaes login to get user's comments")
            completion(nil, nil)
            return
        }
        
        let route = hostVersion + "/comments/comments"
        let parameters : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.offset.rawValue: offset,
            ServerKey.pageCount.rawValue: pageCount,
            CommentKey.commenteeId.rawValue: commenteeId
        ]
        
        getDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getUserComments response error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let userComments : UserComments = try unbox(dictionary: data)
                    completion(userComments, nil)
                    
                } catch let error as NSError {
                    print("getUserComments error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            } else {
                print("getUserComments: Empty data field")
                completion(nil, nil)
            }
        }
    }
    
    
    //MARK: - Wallet API
    
    func getWallet(completion: @escaping((Wallet?, Error?) -> Void)) {
        guard let profileUser = ProfileManager.shared.getCurrentUser(), let walletId = profileUser.walletId else {
            print("getWallet: Profile user empty, pleaes login to get user's comments")
            completion(nil, nil)
            return
        }
        
        let route = hostVersion + "/wallets/wallet"
        let parameters : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ProfileUserKey.walletId.rawValue: walletId
        ]
        
        getDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getWallet response error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let wallet: Wallet = try unbox(dictionary: data)
                    completion(wallet, nil)
                    
                } catch let error as NSError {
                    print("getWallet error: \(error.localizedDescription)")
                    completion(nil, error)
                }
            } else {
                print("getWallet: Empty data field")
                completion(nil, nil)
            }
        }
    }
    
    func getWalletStripeEphemeralKey(apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            debugLog("Profile user empty, pleaes login to get user's stripe id")
            completion(nil, nil)
            return
        }
        
        let route = hostVersion + "/wallets/stripe/ephemeralkey"
        let parameters : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.username.rawValue: profileUser.username ?? "",
            WalletKeyInDB.userId.rawValue: profileUser.id ?? "",
            ProfileUserKey.walletId.rawValue: profileUser.walletId ?? "",
            WalletKeyInDB.apiVersion.rawValue: apiVersion
        ]
        
        getDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    debugLog("Response error: \(error.localizedDescription)")
                }
                completion(nil, error)
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any],
                let keyPayload = data[WalletKeyInDB.ephemeralKey.rawValue] as? [String: Any] {
                //debugPrint("Payload: \(keyPayload)")
                completion(keyPayload, nil)
            } else {
                debugPrint("Unable to find key payload at ephemeralkey")
                completion(nil, nil)
            }
        }
    }
    
    func postWalletStripeCompleteCharge(_ result: STPPaymentResult,
                                        amount: Int,
                                        currency: String,
                                        completion: @escaping STPErrorBlock) {
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            debugLog("Profile user empty, pleaes login to get user's stripe id")
            completion(nil)
            return
        }
        
        guard amount >= 50 else {
            debugLog("Amount at least 50 cents")
            return
        }
        
        let route = hostVersion + "/wallets/stripe/charge"
        
        let requestDict: [String: Any] = [
            "source": "tok_visa",
            "amount": amount,
            WalletKeyInDB.userId.rawValue: profileUser.id ?? -999,
            WalletKeyInDB.currency.rawValue: currency,
            ProfileUserKey.walletId.rawValue: profileUser.walletId ?? -999
        ]
        
        let parameters: [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: requestDict
        ]
        
        postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            if let error = error {
                print("postWalletStripeCompleteCharge update response error: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            //Zian: Is it good enough??
            completion(nil)
        }
    }
    
    //Ali
    func postWalletAliPay(totalAmount: String, userId: String, requestId: String, completion: ((String?, Error?) -> Void)?) {
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            debugLog("Profile user empty, pleaes login to get user's id")
            completion?(nil, nil)
            return
        }
        
        let route = hostVersion + "/wallets/alipay/pay"
        
        let requestDict: [String: Any] = [
            "total_amount": totalAmount,
            "user_id": userId,
            "request_id": requestId
        ]
        
        let parameters: [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: requestDict
        ]
        
        postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("postWalletAliPay update response error: \(error.localizedDescription)")
                }
                completion?(nil, nil)
                return
            }
            
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any],
                let orderString = data[WalletKeyInDB.orderString.rawValue] as? String {
                debugPrint("Order String: \(orderString)")
                completion?(orderString, nil)
            } else {
                debugPrint("Unable to get order string")
                completion?(nil, nil)
            }
        }
    }
    
    func postWalletAliPayValidation(response: [String: Any], isSuccess: Bool, completion: ((Bool, Error?) -> Void)?) {
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            debugLog("Profile user empty, pleaes login to get user's id")
            completion?(false, nil)
            return
        }
        
        let route = hostVersion + "/wallets/alipay/verify"
        
        var requestDict: [String: Any] = response
        
        if isSuccess {
            requestDict["trade_status"] = "TRADE_SUCCESS"
        } else {
            requestDict["trade_status"] = "TRADE_FINISHED"
        }
        
        let parameters: [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: requestDict
        ]
        
        postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("postWalletAliPayValidation update response error: \(error.localizedDescription)")
                    completion?(false, error)
                } else {
                    completion?(false, nil)
                }
                return
            }
            
            if let statusCode = response[ServerKey.statusCode.rawValue] as? Int, statusCode != 200 {
                completion?(true, nil)
            } else {
                completion?(false, nil)
            }
        }
    }
    
    
    //TODO fix this...need to put in user's payee account. Here default as XingJiu's payout account
    func postWalletAliPayout(logonId: String, amount: String, completion: ((Bool, Error?) -> Void)?) {
        guard let profileUser = ProfileManager.shared.getCurrentUser(), let userId = profileUser.id else {
            debugLog("Profile user empty, pleaes login to get user's id")
            completion?(false, nil)
            return
        }
        
        let route = hostVersion + "/wallets/alipay/payout"
        
        let requestDict: [String: Any] = [
            "amount": amount,
            "user_id": userId,
            "payee_type": "ALIPAY_LOGONID",
            "payee_account": logonId
        ]
        
        let timestamp = Date.getTimestampNow()
        let parameters: [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: timestamp,
            ServerKey.data.rawValue: requestDict
        ]
        
        postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("postWalletAliPay update response error: \(error.localizedDescription)")
                    completion?(false, error)
                }
                return
            }
            
            if let statusCode = response[ServerKey.statusCode.rawValue] as? Int, statusCode != 200 {
                completion?(true, nil)
            } else {
                completion?(false, nil)
            }
        }
    }
    
    
    //WXPay
    func postWalletWXPay(totalAmount: Int, userId: Int, requestId: Int, completion: ((WXOrder?, Error?) -> Void)?) {
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            debugLog("Profile user empty, please login to get user's id")
            completion?(nil, nil)
            return
        }
        
        let route = hostVersion + "/wallets/wxpay/pay"
        
        let requestDict: [String: Any] = [
            "total_amount": totalAmount,
            "user_id": userId,
            "request_id": requestId
        ]
        
        let timestamp = Date.getTimestampNow()
        let parameters: [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: timestamp,
            ServerKey.data.rawValue: requestDict
        ]
        
        postDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("postWalletAliPay update response error: \(error.localizedDescription)")
                    completion?(nil, error)
                }
                return
            }
            
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let order: WXOrder = try unbox(dictionary: data)
                    completion?(order, nil)
                    
                } catch let error {
                    completion?(nil, error)
                    print("Get error when postWalletWXPay. Error = \(error.localizedDescription)")
                }
            } else {
                debugPrint("Unable to get data")
                completion?(nil, nil)
            }
        }
    }
    
    // MARK: - basic GET and POST by url
    /**
     * ✅ get data with url string, return NULL, try with Alamofire and callback
     */
    private func getDataWithUrlRoute(_ route: String, parameters: [String: Any], completion: @escaping(([String : Any]?, Error?) -> Void)) {
        let requestUrlStr = host + route
        
        Alamofire.request(requestUrlStr, parameters: parameters).responseJSON { response in
            
            if let urlRequest = response.request?.url {
                let printText: String = """
                =========================
                [GET ROUTE] \(route)
                [REQUEST] \(urlRequest)
                """
                print(printText)
            }
            
            if let responseValue = response.value as? [String: Any] {
                if let statusCode = responseValue[ServerKey.statusCode.rawValue] as? Int, statusCode != 200 {
                    let message = responseValue[ServerKey.message.rawValue] ?? ""
                    let printText: String = """
                    =========================
                    [STATUS_CODE] \(statusCode)
                    [MESSAGE]: \(message)
                    """
                    print(printText)
                    
                    self.handleAbnormalStatusCode(statusCode)
                }
                
                completion(responseValue, nil)
            } else {
                completion(nil, response.result.error)
            }
        }
    }
    
    /**
     * ✅ POST data with url string, using Alamofire
     */
    private func postDataWithUrlRoute(_ route: String, parameters: [String: Any], completion: @escaping(([String : Any]?, Error?) -> Void)) {
        let requestUrlStr = host + route
        Alamofire.request(requestUrlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            if let requestBody = response.request?.httpBody, let body = NSString(data: requestBody, encoding: String.Encoding.utf8.rawValue) {
                let printText: String = """
                =========================
                [POST ROUTE] \(route)
                [PARAMETERS] \(parameters)
                [BODY] \(body)
                """
                print(printText)
            }
            
            if let responseValue = response.value as? [String: Any] {
                
                if let statusCode = responseValue[ServerKey.statusCode.rawValue] as? Int, statusCode != 200 {
                    let message = responseValue[ServerKey.message.rawValue] ?? ""
                    let printText: String = """
                    =========================
                    [STATUS_CODE] \(statusCode)
                    [MESSAGE]: \(message)
                    """
                    print(printText)
                    
                    self.handleAbnormalStatusCode(statusCode)
                }
                completion(responseValue, nil)
                
            } else {
                completion(nil, response.result.error)
            }
        }
    }
}

extension ApiServers {
    func handleAbnormalStatusCode(_ statusCode: Int) {
        switch statusCode {
        case 401:
            NotificationCenter.default.post(name: NSNotification.Name.Network.Invalid, object: nil)
        default:
            print("[Status Code] Not handled: \(statusCode)")
        }
    }
}
