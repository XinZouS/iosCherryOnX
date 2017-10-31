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

enum ServerUserPropUrl : String {
    case salt       = "salt"
    case imageUrl   = "imageurl"
    case phone      = "phone"
    case passportUrl = "passporturl"
    case idAUrl     = "idaurl"
    case idBUrl     = "idburl"
    case email      = "email"
    case realName   = "realname"
    case isExist    = "exist"
    case wallet     = "wallet"
}
/// response dictionary key group
let ServerUserPropKey : [ServerUserPropUrl:String] = [
    ServerUserPropUrl.salt      : "salt",
    ServerUserPropUrl.phone     : "phone",
    ServerUserPropUrl.imageUrl  : "image_url",
    ServerUserPropUrl.passportUrl:"passport_url",
    ServerUserPropUrl.idAUrl    : "ida_url",
    ServerUserPropUrl.idBUrl    : "idb_url",
    ServerUserPropUrl.email     : "email",
    ServerUserPropUrl.realName  : "real_name",
    ServerUserPropUrl.isExist   : "exist",
    ServerUserPropUrl.wallet    : "wallet"
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
        case phone     = "phone"
        case email     = "email"
        case timestamp = "timestamp"
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
    
    //Zian - The call back can be anything, i just use boolean to indicate register or not
    func postRegisterUser(username: String, phone: String, password: String, email: String, callback: @escaping(Bool, String?) -> Swift.Void) {
        
        let route = hostVersion + "/users"
        let postData = [
            ServerKey.username.rawValue: username,
            ServerKey.password.rawValue: password,
            ServerKey.phone.rawValue:    phone,
            ServerKey.email.rawValue:    email
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
                callback(false, error?.localizedDescription)
                return
            }
            
            let msg = (response[ServerKey.message.rawValue] as? String) ?? ""
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                if let token = data[ServerKey.userToken.rawValue] as? String {
                    
                    let profileUser = ProfileUser()
                    profileUser.token = token
                    ProfileManager.shared.login(user: profileUser)
                    
                } else {
                    print("Unable to find token...")
                    callback(false, "Unable to find token")
                }
                
                do {
                    let user: ProfileUser = try unbox(dictionary: data)
                    ProfileManager.shared.login(user: user)
                    callback(true, msg)
                    
                } catch let error as NSError {
                    callback(false, error.localizedDescription)
                }
                
            } else {
                //Data package not found
                callback(false, msg)
            }
        }
    }
    
    //user existed
    func getIsUserExisted(handleInfo: @escaping (Bool) -> Void){
        let sessionStr = hostVersion + "/users/exist"
        let headers:[String: Any] = [
            ServerKey.username.rawValue: phoneInput,
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken
        ]
        getDataWithUrlRoute(sessionStr, parameters: headers) { (responsDictionary) in
            if let isExist = responsDictionary["status_code"] as? Int {
                handleInfo(isExist != 200)
            }else{
                handleInfo(false)
            }
        }
    }

    func postLoginUser(password: String, completion: @escaping (String?) -> Void) {
        let route = hostVersion + "/users/login"
        let parameter:[String:Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.data.rawValue     : [
                ServerKey.username.rawValue: phoneInput,
                ServerKey.password.rawValue: password
            ]
        ]
        postDataWithUrlRoute(route, parameters: parameter) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postLoginUser response error: \(error.localizedDescription)")
                }
                completion(error?.localizedDescription)
                return
            }
            
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                if let token = data[ServerKey.userToken.rawValue] as? String {
                    
                    let profileUser = ProfileUser()
                    profileUser.token = token
                    profileUser.printAllData()
                    ProfileManager.shared.login(user: profileUser)
                    
                    completion(token)
                    
                } else {
                   completion(nil)
                }
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
    
    func getUserInfo(_ propertyUrl: ServerUserPropUrl, handleInfo: @escaping (String) -> Void){
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getUserInfo: Profile user empty, please login to get user info")
            handleInfo("")
            return
        }
        
        let sessionStr = hostVersion + "/users/" + propertyUrl.rawValue
        let headers:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue : profileUser.username ?? ""
        ]
        
        getDataWithUrlRoute(sessionStr, parameters: headers) { (responsDictionary) in
            if let getDict = responsDictionary["data"] as? [String:Any], getDict.count != 0 {
                let getStr = (getDict["string"] as? String) ?? ""
                handleInfo(getStr)
            }
        }
    }
    
    
    /// DO NOT merge this into getUserInfo->String, too much setup and different returning object!
    func getUserInfoAll(handleInfo: @escaping ([String: Any]?) -> Void) {
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getUserInfoAll: Profile user empty, please login to get user info all")
            handleInfo(nil)
            return
        }
        
        let sessionStr = hostVersion + "/users/info"
        let headers:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue : profileUser.username ?? ""
        ]
        
        let currToken = profileUser.token ?? ""
        
        getDataWithUrlRoute(sessionStr, parameters: headers) { (responseDictionary) in
            if let data = responseDictionary["data"] as? [String : Any] {
                handleInfo(data)
                do {
                    // TODO: change the key to "user"
                    let user: ProfileUser = try unbox(dictionary: data, atKey: "user")
                    user.token = currToken
                    ProfileManager.shared.updateCurrentUser(user)
                } catch let err {
                    print("get error when getUserInfoAll, err = \(err)")
                }
            }
        }
    }
    
    func getUserLogsOf(type: ServerUserLogUrl, handleLogArray: @escaping ([Any]?) -> Void){
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getUserLogsOf: Profile user empty, please login to get user logs")
            handleLogArray(nil)
            return
        }
        
        let sessionStr = hostVersion + "/users/" + type.rawValue
        let headers:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.username.rawValue : profileUser.username ?? ""
        ]
        getDataWithUrlRoute(sessionStr, parameters: headers) { (responsDictionary) in
            if let data = responsDictionary["data"] as? [String : Any] {
                do {
                    if type == ServerUserLogUrl.myCarries {
                        let carries: [Request] = try unbox(dictionary: data, atKey: type.rawValue)
                        handleLogArray(carries)
                    
                    } else if type == ServerUserLogUrl.myTrips {
                        let trips : [Trip] = try unbox(dictionary: data, atKey: type.rawValue)
                        handleLogArray(trips)
                    }
                    
                } catch let err  {
                    print("get error when getUserLogsOf \(type.rawValue), err = \(err)")
                }
            }
        }
    }
    
    func postUpdateUserInfo(_ propUrl: ServerUserPropUrl, newInfo:String, completion: @escaping (Bool, String) -> Void){
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("postUpdateUserInfo: Profile user empty, please login to post update on user info")
            completion(false, "")
            return
        }
        
        let route = hostVersion + "/users/" + propUrl.rawValue
        let data: [String: String] = [
            ServerKey.username.rawValue : profileUser.username ?? "",
            ServerUserPropKey[propUrl]! : newInfo
        ]
        let parms:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue     : data
        ]
        
        postDataWithUrlRoute(route, parameters: parms) { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("postUpdateUserInfo response error: \(error.localizedDescription)")
                }
                return
            }
            
            let msg = (response[ServerKey.message.rawValue] as? String) ?? ""
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                if let userPropKey = ServerUserPropKey[propUrl], userPropKey != "" {
                    
                    if let profileUser = ProfileManager.shared.getCurrentUser() {
                        profileUser.setupByDictionaryFromDB([userPropKey:newInfo])
                        ProfileManager.shared.updateCurrentUser(profileUser)
                    }
                }
                completion(true, msg)
            
            } else {
                completion(false, msg)
            }
        }
    }
    
    func getAllUsers(callback: @escaping(([User]?) -> Void)) {
        
        guard let profileUser = ProfileManager.shared.getCurrentUser() else {
            print("getAllUsers: Profile user empty, pleaes login to get all users list")
            callback(nil)
            return
        }
        
        let route = hostVersion + "/users/allusers"
        let parameters : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: profileUser.token ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow()
        ]
        getDataWithUrlRoute(route, parameters: parameters) { (responseValue) in
            if let data = responseValue["data"] as? [String: Any] {
                do {
                    let users : [User] = try unbox(dictionary: data, atKey:"users")
                    callback(users)
                } catch let error as NSError {
                    print("getAllUsers error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    //MARK: - Config API
    func getConfig() {
        let route = "/config"
        getDataWithUrlRoute(route, parameters: [:]) { (responseValue) in
            if let data = responseValue["data"] as? [String : Any] {
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
    func getTrips(queryRoute: ServerTripUrl, query: String, query2: String?, completion: @escaping (String,[Trip]?) -> Void){
        
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
        
        getDataWithUrlRoute(route, parameters: headers) { (response) in
            let msg = response["message"] as! String
            if let data = response["data"] as? [String:Any] {
                do {
                    let trips : [Trip] = try unbox(dictionary: data, atKey: "trip")
                    completion(msg, trips)
                } catch let err {
                    print("getTrips = \(err.localizedDescription)")
                }
            }else{
                completion(msg, nil)
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
    private func getDataWithUrlRoute(_ route: String, parameters: [String: Any], completion: @escaping(([String : Any]) -> Void)) {
        let requestUrlStr = host + route
        Alamofire.request(requestUrlStr, parameters: parameters).responseJSON { response in
            if let responseValue = response.value as? [String: Any] {
                completion(responseValue)
            }
        }
        
    }
    
    /**
     * ✅ POST data with url string, using Alamofire
     */
    private func postDataWithUrlRoute(_ route: String, parameters: [String: Any], completion: @escaping(([String : Any]?, Error?) -> Void)) {
        let requestUrlStr = host + route
        Alamofire.request(requestUrlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            
            print(NSString(data: (response.request?.httpBody)!, encoding: String.Encoding.utf8.rawValue) as Any)
            
            if let responseValue = response.value as? [String: Any] {
                completion(responseValue, nil)
            } else {
                completion(nil, response.result.error)
            }
        }
        
    }
    
}




