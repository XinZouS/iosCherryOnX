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
        
        //TODO: for test use only, remove this before launch;
//        ProfileManager.shared.currentUser?.phone = "1-2016662333"
//        ProfileManager.shared.currentUser?.token = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
    }
    
    
    // MARK: - User APIs
    
    //Zian - The call back can be anything, i just use boolean to indicate register or not
    func postRegisterUser(username: String, phone: String, password: String, email: String, callback: @escaping(Bool, String) -> Swift.Void) {
        
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
        postDataWithUrlRoute(route, parameters: parameters) { (response) in
            print("get response dictionary: \(response)")
            let msg = (response[ServerKey.message.rawValue] as? String) ?? ""
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                if let token = data[ServerKey.userToken.rawValue] as? String {
                    ProfileManager.shared.currentUser = ProfileUser()
                    ProfileManager.shared.currentUser?.token = token
                }else{
                    print("失败")
                }
                print("get data = \(data)")
                do {
                    let user: ProfileUser = try unbox(dictionary: data)
                    ProfileManager.shared.login(user: user)
                    callback(true, msg)
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    callback(false, msg)
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
        postDataWithUrlRoute(route, parameters: parameter) { (response) in
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                if let token = data[ServerKey.userToken.rawValue] as? String {
                    ProfileManager.shared.currentUser = ProfileUser()
                    ProfileManager.shared.currentUser?.token = token
                    ProfileManager.shared.saveUser()
                    completion(token)
                    ProfileManager.shared.currentUser?.printAllData()
                }else{
                   completion("error")
                }
            }
        }
    }
    
    func postLogoutUser(completion: @escaping (Bool, String?) -> Void){
        let route = hostVersion + "/users/logout"
        let parms:[String:Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.data.rawValue : [
                ServerKey.username.rawValue : (ProfileManager.shared.currentUser?.username) ?? ""
            ]
        ]
        postDataWithUrlRoute(route, parameters: parms) { (response) in
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
        let sessionStr = hostVersion + "/users/" + propertyUrl.rawValue
        let headers:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.username.rawValue : ProfileManager.shared.currentUser?.username ?? ""
        ]
        getDataWithUrlRoute(sessionStr, parameters: headers) { (responsDictionary) in
            if let getDict = responsDictionary["data"] as? [String:Any], getDict.count != 0 {
                let getStr = (getDict["string"] as? String) ?? ""
                handleInfo(getStr)
            }
        }
    }
    /// DO NOT merge this into getUserInfo->String, too much setup and different returning object!
    func getUserInfoAll(handleInfo: @escaping ([String:Any]) -> Void){
        let sessionStr = hostVersion + "/users/info"
        let headers:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.username.rawValue : ProfileManager.shared.currentUser?.username ?? ""
        ]
        let currToken = ProfileManager.shared.currentUser?.token ?? ""
        
        getDataWithUrlRoute(sessionStr, parameters: headers) { (responsDictionary) in
            if let data = responsDictionary["data"] as? [String : Any] {
                handleInfo(data)
                do {
                    // TODO: change the key to "user"
                    let getUser: ProfileUser = try unbox(dictionary: data, atKey: "user")
                    getUser.token = currToken
                    ProfileManager.shared.currentUser = getUser
                    ProfileManager.shared.saveUser()
                } catch let err {
                    print("get error when getUserInfoAll, err = \(err)")
                }
            }
        }
    }
    
    func getUserLogsOf(type: ServerUserLogUrl, handleLogArray: @escaping ([Any]) -> Void){
        let sessionStr = hostVersion + "/users/" + type.rawValue
        let headers:[String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.username.rawValue : ProfileManager.shared.currentUser?.username ?? ""
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
        let route = hostVersion + "/users/" + propUrl.rawValue
        let data: [String: String] = [
            ServerKey.username.rawValue : (ProfileManager.shared.currentUser?.username)!,
            ServerUserPropKey[propUrl]! : newInfo
        ]
        let parms:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue     : data
        ]
        postDataWithUrlRoute(route, parameters: parms) { (response) in
            let msg = (response[ServerKey.message.rawValue] as? String) ?? ""
            if let status = response[ServerKey.statusCode.rawValue] as? Int, status == 200 {
                if let userPropKey = ServerUserPropKey[propUrl], userPropKey != "" {
                    ProfileManager.shared.currentUser?.setupByDictionaryFromDB([userPropKey:newInfo])
                    ProfileManager.shared.saveUser()
                }
                completion(true, msg)
            
            } else {
                completion(false, msg)
            }
        }
    }
    
    func getAllUsers(callback: @escaping(([User]?) -> Void)) {
        let route = hostVersion + "/users/allusers"
        let parameters : [String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
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
        let route = hostVersion + "/trips/\(queryRoute.rawValue)"
        var headers: [String: Any] = [
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.username.rawValue : ProfileManager.shared.currentUser?.username ?? ""
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
    
    func postTripInfo(trip: Trip, completion: @escaping (Bool, String, String) -> Void){ //callBack(success,msg,id)
        let sessionStr = hostVersion + "/trips/trips"
        var tripDict = trip.packAsPostData()
        
        //TODO: Remove them
        tripDict[TripKeyInDB.carrierId.rawValue] = 4
        tripDict[TripKeyInDB.startAddressId.rawValue] = 1509137387
        tripDict[TripKeyInDB.endAddressId.rawValue] = 1509137387
        
        let parameter:[String: Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.username.rawValue: ProfileManager.shared.currentUser?.username ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: tripDict
        ]
        
        postDataWithUrlRoute(sessionStr, parameters: parameter) { (dictionary) in
            print("Dictionary \(dictionary)")
            if dictionary.count > 0 {
                completion(true, "TODO: testing...", "get id,,,")
                
            } else {
                completion(false, "TODO: testing...", "get id,,,")
            }
        }
    }
    
    
    // MARK: - Address APIs
    func postAddressInfo(address: Address, completion: @escaping (Bool, String, String) -> Void){ //callBack(success,msg,id)
        let route = hostVersion + "/addresses/addresses"
        var addDict = address.packAsDictionaryForDB()
        addDict.removeValue(forKey: "id")
        
        let parameter:[String : Any] = [
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.timestamp.rawValue: Date.getTimestampNow(),
            ServerKey.data.rawValue: addDict,
            ServerKey.username.rawValue: ProfileManager.shared.currentUser?.username ?? ""
        ]
        
        postDataWithUrlRoute(route, parameters: parameter) { (dictionary) in
            if dictionary.count > 0 {
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
    private func postDataWithUrlRoute(_ route: String, parameters: [String: Any], completion: @escaping(([String : Any]) -> Void)) {
        let requestUrlStr = host + route
        Alamofire.request(requestUrlStr, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            if let responseValue = response.value as? [String: Any] {
                completion(responseValue)
            }
        }
        
    }
    
}




