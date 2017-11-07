//
//  ApiServers.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

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

/*
 let UsersInfoUpdateKey : [UsersInfoUpdate: ProfileUserKey] = [
 UsersInfoUpdate.salt : ProfileUserKey.salt,
 UsersInfoUpdate.phone : ProfileUserKey.phone,
 UsersInfoUpdate.imageUrl  : ProfileUserKey.imageUrl,
 UsersInfoUpdate.passportUrl:"passport_url",
 UsersInfoUpdate.idAUrl    : "ida_url",
 UsersInfoUpdate.idBUrl    : "idb_url",
 UsersInfoUpdate.email     : "email",
 UsersInfoUpdate.realName  : "real_name",
 UsersInfoUpdate.isExist   : "exist",
 UsersInfoUpdate.wallet    : "wallet"
 ]
 */

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
        case phone     = "phone"
        case email     = "email"
        case timestamp = "timestamp"
        case pageCount = "page_count"
        case offset = "offset"
        case userType = "user_type"
    }
    
    
    private let appToken: String = "0123456789012345678901234567890123456789012345678901234567890123"
    
    //private let host = "http://0.0.0.0:5000"       // local host on this laptop you are looking at
    //private let host = "http://192.168.0.119:5000"  //  /api/1.0" // local host on Siyuan's laptop
    private let host = "http://54.245.216.35:5000"  // testing host on AWS
    
    private let hostVersion = "/api/1.0"
    
    var config: Config?
    
    private override init() {
        super.init()
    }
    
    
    // MARK: - User APIs
    // NOTE: USE PROFILE MANAGER TO REGISTER AND LOGIN!!!
    func postRegisterUser(username: String, phone: String, password: String, email: String, completion: @escaping(String?, Error?) -> Swift.Void) {
        
        let route = hostVersion + "/users"
        let postData = [
            ServerKey.username.rawValue: username,
            ServerKey.password.rawValue: password,
            ServerKey.phone.rawValue: phone,
            ServerKey.email.rawValue: email
        ]
        let parameters:[String:Any] = [
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
            
            /*
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                do {
                    let profileUser: ProfileUser = try unbox(dictionary: data)
                    profileUser.printAllData()
                    completion(profileUser, nil)
                    
                } catch let error as NSError {
                    print("postRegisterUser unbox error: \(error.localizedDescription)")
                    completion(nil, error)
                }
                
            } else {
                let msg = (response[ServerKey.message.rawValue] as? String) ?? ""
                print("postRegisterUser - Data package not found. Response message: \(msg)")
                completion(nil, nil)
            }*/
        }
    }
    
    func getIsUserExisted(completion: @escaping (Bool, Error?) -> Void){
        
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

    func postLoginUser(username: String, password: String, completion: @escaping (String?, Error?) -> Void) {
        
        let route = hostVersion + "/users/login"
        let parameter:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.data.rawValue     : [
                ServerKey.username.rawValue: username,
                ServerKey.password.rawValue: password
            ]
        ]
        
        postDataWithUrlRoute(route, parameters: parameter) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postLoginUser response error: \(error.localizedDescription)")
                }
                completion(nil, error)
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                if let token = data[ServerKey.userToken.rawValue] as? String {
                    completion(token, nil)
                } else {
                    print("postLoginUser - Unable to find token from user data")
                    completion(nil, nil)
                }
            } else {
                print("postLoginUser - Unable to find user data")
                completion(nil, nil)
            }
        }
    }
    
    func postLogoutUser(completion: @escaping (Bool, String?) -> Void){
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
                completion(false, error?.localizedDescription)
                return
            }
            
            let msg = response[ServerKey.message.rawValue] as? String
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                ProfileManager.shared.logoutUser()
                completion(true, msg)
            }else{
                completion(false, msg)
            }
        }
    }
    
    func getUserInfo(username: String, userToken: String, completion: @escaping (ProfileUser?, Error?) -> Void){
        
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
                    let user: ProfileUser = try unbox(dictionary: data, atKey: "user")
                    user.printAllData()
                    completion(user, nil)
                    
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
    
    func postUpdateUserInfo(_ updateType: UsersInfoUpdate, value: String, completion: @escaping (Bool, Error?) -> Void){
        
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
        
        
        var data: [String: String] = [:]
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
    
    func getAllUsers(completion: @escaping(([User]?) -> Void)) {
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getAllUsers: Profile user empty, pleaes login to get all users list")
            completion(nil)
            return
        }
        
        let route = hostVersion + "/users/allusers"
        let parameters : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow()
        ]
        
        getDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getAllUsers response error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = response["data"] as? [String: Any] {
                do {
                    let users : [User] = try unbox(dictionary: data, atKey:"users")
                    completion(users)
                } catch let error as NSError {
                    print("getAllUsers error: \(error.localizedDescription)")
                }
            } else {
                print("getAllUsers: Empty data field")
                completion(nil)
            }
        }
    }
    
    
    //Todo: Change UserGuideTabSection
    func getUsersTrips(userType: UserGuideTabSection, offset: Int, pageCount: Int, completion: @escaping(([TripOrder]?, Error?) -> Void)) {
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getUsersTrips: Profile user empty, pleaes login to get user's trips")
            completion(nil, nil)
            return
        }
        
        let route = hostVersion + "/users/trips"
        let parameters : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue: profileUser.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.offset.rawValue: offset,
            ServerKey.pageCount.rawValue: pageCount,
            ServerKey.userType.rawValue: userType.stringValue
        ]
        
        getDataWithUrlRoute(route, parameters: parameters) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getUsersTrips response error: \(error.localizedDescription)")
                }
                return
            }
            
            if let data = response["data"] as? [String: Any] {
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
    
    
    // MARK: - ItemCategory APIs
    // TODO: get full list from server, then setup and present here
    func getFullItemCategoryListInDB() -> [ItemCategory] {
        return []
    }
    
    
    // MARK: - Trip APIs
    func getTrips(queryRoute: ServerTripUrl, query: String, query2: String?, completion: @escaping (String, [Trip]?) -> Void){
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getTrips: Profile user empty, pleaes login to get trips")
            completion("", nil)
            return
        }
        
        let route = hostVersion + "/trips/\(queryRoute.rawValue)"
        var headers: [String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue : profileUser.username ?? ""
        ]
        
        if query2 == nil, let route = ServerTripPropKey[queryRoute] {
            headers[route] = query
            
        } else if let q2 = query2 {
            headers["start"] = query
            headers["end"] = q2
        }
        
        getDataWithUrlRoute(route, parameters: headers) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getTrips response error: \(error.localizedDescription)")
                }
                return
            }
            
            //TODO: REDO THIS CHECK
            let msg = response["message"] as! String
            if let data = response["data"] as? [String:Any] {
                do {
                    let trips : [Trip] = try unbox(dictionary: data, atKey: "trip")
                    completion(msg, trips)
                    
                } catch let err {
                    print("getTrips = \(err.localizedDescription)")
                }
                
            } else{
                completion(msg, nil)
            }
        }
    }
    
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
            "id": id
        ]
        
        getDataWithUrlRoute(sessionStr, parameters: parameter) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("getTrips response error: \(error.localizedDescription)")
                }
                completion(false, nil, error)
                return
            }
            
            if let statusCode = response["status_code"] as? Int {
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
            completion(false, "postTripInfo: Profile user empty, pleaes login to post trip info", "")
            return
        }
        
        let sessionStr = hostVersion + "/trips/trips"
        let tripDict = trip.packAsPostData()
        
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
                    completion(true, "Data post successful", trip.id)
                    
                } catch let error as NSError {
                    completion(false, error.localizedDescription, nil)
                }
                
            } else {
                let msg = response[ServerKey.message.rawValue] as? String
                completion(false, msg, "Unable to post trip data")
            }
        }
    }
    
    
    // MARK: - Address APIs
    func postAddressInfo(address: Address, completion: @escaping (Bool, String?, String?) -> Void){ //callBack(success, msg, id)
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            completion(false, "postAddressInfo: Profile user empty, pleaes login to get the address info", "")
            return
        }
        
        let route = hostVersion + "/addresses/addresses"
        var addDict = address.packAsDictionaryForDB()
        addDict.removeValue(forKey: "id")
        
        let parameter:[String : Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: addDict,
            ServerKey.username.rawValue: profileUser.username ?? ""
        ]
        
        postDataWithUrlRoute(route, parameters: parameter) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postAddressInfo response error: \(error.localizedDescription)")
                }
                completion(false, error?.localizedDescription, nil)
                return
            }
            
            if response.count > 0 {
                //TODO:postAddressInfo
                completion(true, "TODO: testing...", "get id,,,")
            } else {
                completion(false, "TODO: testing...", "get id,,,")
            }
        }
    }
    
    
    // MARK: - Request APIs
    
    //TODO: sentOrderInformation
    func sentOrderInformation(address:Address){
        //let userName = "user0"
        //let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        //let sessionStr = "/api/1.0/addresses/addresses/"
        //let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        //let dataPackage = address.packAllPropertiesAsData()
        //print(dataPackage)
        //        postDataWithUrlString(urlStr,dataPackage)
    }
    
    //TODO: sentRequestImageUrls
    func sentRequestImageUrls(){
//        let userName = "user0"
//        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
//        let sessionStr = "/api/1.0/addresses/addresses/"
        //let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        //curl -F data='{"image_urls":[{"image_url":"http://1"}, {"image_url":"http://2"}, {"image_url":"http://3"}], "request_id":"2"}' -F app_token='0123456789012345678901234567890123456789012345678901234567890123' -F timestamp=`date -u +%s` -F username='user0' -F user_token='ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2' -X POST
        //let urlStr = "http://0.0.0.0:5000/api/1.0/requests/postimages/"
        //postDataToUrlString(<#T##urlStr: String##String#>, postData: Data)
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
                [ROUTE] \(route)
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
                    [ROUTE]: \(route)"
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
                [ROUTE] \(route)
                [PARAMETERS] \(parameters)
                [BODY] \(body))
                 _
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
                    [ROUTE]: \(route)"
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
    func postNonceToServer(paymentMethodNonce: String) {
        // Update URL with your server
        let paymentURL = URL(string: "https://your-server.example.com/payment-methods")!
        var request = URLRequest(url: paymentURL)
        request.httpBody = "payment_method_nonce=\(paymentMethodNonce)".data(using: String.Encoding.utf8)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            }.resume()
    }
}
