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
    case salt = "salt"
    case imageUrl = "imageurl"
    case passportUrl = "passporturl"
    case idAUrl = "idaurl"
    case idBUrl = "idburl"
    case email = "email"
    case realName = "realname"
    case phone = "phone"
    case wallet = "wallet"
}
enum ServerUserLogUrl : String {
    case myCarries = "requests"
    case myTrips = "trips"
}


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
    
    //private let host = "http://0.0.0.0:5000/api/1.0"       // local host on this laptop you are looking at
    //private let host = "http://192.168.0.119:5000/api/1.0" // local host on Siyuan's laptop
    private let host = "http://54.245.216.35:5000/api/1.0" // testing host on AWS
    
    private func getTimestampStr() -> String {
        //let t = Int(Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate)
        let t = Int(NSDate.timeIntervalSinceReferenceDate) // will this work ???????
        return "\(150000000)" // TODO: this is for test only.
        return "\(t)"
    }
    
    
    // MARK: - User APIs
    
    //Zian - The call back can be anything, i just use boolean to indicate register or not
    func registerUser(username: String, phone: String, password: String, email: String, callback: @escaping(Bool) -> Swift.Void) {
        let sessionStr = "/users/"
        let urlStr = host + sessionStr
        
        let parameters = [
            ServerKey.username.rawValue: username,
            ServerKey.password.rawValue: password,
            ServerKey.phone.rawValue:    phone,
            ServerKey.email.rawValue:    email
        ]
        
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken
        ]
        
        postDataToUrlString(urlStr, postData: parameters, httpHeaders: headers) { (response) in
            print("get response dictionary: \(response)")
            if let data = response[ServerKey.data.rawValue] as? [String: Any] {
                if let token = data[ServerKey.userToken.rawValue] as? String {
                    let profileUser = ProfileUser()
                    profileUser.setupByLocal(parameters)
                    profileUser.token = token
                    ProfileManager.shared.currentUser = profileUser
                    ProfileManager.shared.saveUser()
                    callback(true)
                } else {
                    //Display error message
                    callback(false)
                }
            } else {
                //Data package not found
                callback(false)
            }
        }
    }
    
    func loginUser(){
        let sessionStr = "/users/login/"
        let urlStr = "\(host)\(sessionStr)"
        let headers:[String:String] = [
            ServerKey.username.rawValue: (ProfileManager.shared.currentUser?.username) ?? "",
            ServerKey.password.rawValue: (ProfileManager.shared.currentUser?.password) ?? "",
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken
        ]
        if let dict = ProfileManager.shared.currentUser?.packAllPropertiesAsDictionary() {
            print("will loginUser with httpHeaders: \(headers)")
            postDataToUrlString(urlStr, postData: dict, httpHeaders: headers) { (responsDictionary) in
                print("get response dictionary: \(responsDictionary)")
                if let getToken = responsDictionary[ServerKey.data.rawValue] as? [String] {
                    ProfileManager.shared.currentUser?.token = getToken.first ?? ""
                    ProfileManager.shared.saveUser()
                    print("OKKKK get login token = \(getToken.first!)")
                }
            }
        }
    }
    func logoutUser(){
        if let dict = ProfileManager.shared.currentUser?.packAllPropertiesAsDictionary() {
            let sessionStr = "/users/logout/"
            let urlStr = "\(host)\(sessionStr)"
            let headers:[String:String] = [
                ServerKey.timestamp.rawValue: getTimestampStr(),
                ServerKey.appToken.rawValue : appToken,
                ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? ""
            ]
            postDataToUrlString(urlStr, postData: dict, httpHeaders: headers) { (responsDictionary) in
                print("get response dictionary: \(responsDictionary)")
                if let getStatus = responsDictionary[ServerKey.statusCode.rawValue] as? Int, getStatus == 200 {
                    print("OK logout success! clear user data!")
                    ProfileManager.shared.currentUser?.removeFromLocalDisk()
                    ProfileManager.shared.currentUser = nil
                }
            }
        }
    }
    func getUserInfo(_ propertyUrl: ServerUserPropUrl, handleInfo: @escaping (String) -> Void){
        let sessionStr = "/users/\(propertyUrl.rawValue)/"
//        let urlStr = "\(host)\(sessionStr)"
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.username.rawValue : ProfileManager.shared.currentUser?.username ?? ""
        ]
        print("will getUserInfo \(propertyUrl.rawValue), with headers = \(headers)")
        getDataWithUrlRoute(sessionStr, parameters: headers) { (responsDictionary) in
            print("get infoDictionary: \(responsDictionary)")
            if let getDict = responsDictionary["data"] as? [String:Any], getDict.count != 0 {
                let getStr = (getDict["string"] as? String) ?? ""
                handleInfo(getStr)
                print("returning getUserInfo string = \(getStr)")
            }
        }
    }
    func getUserInfoAll(handleInfo: @escaping ([String:Any]) -> Void){
        let sessionStr = "/users/info/"
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.username.rawValue : ProfileManager.shared.currentUser?.username ?? ""
        ]
        getDataWithUrlRoute(sessionStr, parameters: headers) { (responsDictionary) in
            if let data = responsDictionary["data"] as? [String : Any] {
                handleInfo(data)
                do {
                    print("getUserInfoAll, data = \(data)")
                    let getUser: User = try unbox(dictionary: data, atKey: "string") // TODO: change the key to "user"
                    print("getUserInfoAll, getUser = \(getUser)")
                }catch let err {
                    print("get errorrrr when getUserInfoAll, err = \(err)")
                }
            }
        }
    }
    func getUserLogsOf(type: ServerUserLogUrl, handleLogArray: @escaping ([Any]) -> Void){
        let sessionStr = "/users/\(type.rawValue)/"
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.username.rawValue : ProfileManager.shared.currentUser?.username ?? ""
        ]
        getDataWithUrlRoute(sessionStr, parameters: headers) { (responsDictionary) in
            if let data = responsDictionary["data"] as? [String : Any] {
                print("getUserLogsOf = \(data)")
                do {
                    if type == ServerUserLogUrl.myCarries {
                        let carries: [Request] = try unbox(dictionary: data, atKey: type.rawValue)
                        handleLogArray(carries)
                        print("get my requests = \(carries)")
                    }
                    else if type == ServerUserLogUrl.myTrips {
                        let trips : [Trip] = try unbox(dictionary: data, atKey: type.rawValue)
                        handleLogArray(trips)
                        print("get my trips = \(trips)")
                    }
                }catch let err  {
                    print("get errororrro when getUserLogsOf \(type.rawValue), err = \(err)")
                }
            }
        }
//        getDataWithUrlString(urlStr, httpHeaders: headers) { (infoDictionary) in //["data":[{json of log array}], "status_code":Int, "message":String]
//            print("getDataWithUrlString infoDictionary = \(infoDictionary)")
//            let arr = infoDictionary["data"] as? [Any] // ["data":[any], ..]
//            print("TODO: after get arr = \(arr)")
////            for i in 0..<arr?.count {
////                if let dict = arr?.first as? [String:AnyObject] {
////                    print("----------get arr.first, dict = \(dict)")
////                    handleLogArray(dict)
////                }
////            }
//        }
    }
    func updateUserInfo(_ propUrl: ServerUserPropUrl, newInfo: String, completion: @escaping ([String:AnyObject]?) -> Void){
        let sessionStr = "/users/\(ProfileManager.shared.currentUser?.username!)/\(propUrl.rawValue)/"
        let urlStr = "\(host)\(sessionStr)"
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: ProfileManager.shared.currentUser?.token ?? "",
            ServerKey.username.rawValue : ProfileManager.shared.currentUser?.username ?? ""
        ]
        //postDataToUrlString(<#T##urlStr: String##String#>, postData: <#T##[String : Any]#>, httpHeaders: <#T##[String : String]?#>, handleResponse: <#T##([String : AnyObject]) -> Void#>)
    }

    
    func getAllUsers(callback: @escaping(([User]?) -> Void)) {
        
        let route = "/users/allusers/"
        let timestamp = NSDate.timeIntervalSinceReferenceDate
        let parameters = [
            "app_token" : appToken, "username": "user0",
            "user_token": "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2",
            "timestamp" : Int(timestamp)] as [String: Any]
        
        getDataWithUrlRoute(route, parameters: parameters) { (responseValue) in
            if let data = responseValue["data"] as? [String: Any] {
                do {
                    let users : [User] = try unbox(dictionary: data, atKey:"users")
                    callback(users)
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    // MARK: - ItemCategory APIs
    
    /// TODO: get full list from server, then setup and present here
    func getFullItemCategoryListInDB() -> [ItemCategory] {
        print("TODO: get full list from server, then setup and return.")
        return []
    }
    

    
    
    // MARK: - Trip APIs
    
    func postTripInfo(trip: Trip){
        let sessionStr = "/trips/trips/"
        let urlStr = "\(host)\(sessionStr)"
        //        postDataToUrlString(urlStr, postData: trip.)
    }
    
    func getTripById(id: String){
        let userName = "user0"
        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        let sessionStr = "/trips/\(id)/info/"
        
        //let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        //getDataWithUrlString(urlStr)
    }
    
    
    func getTripByTripCode(_ tripCode: String){
        let userName = "user0"
        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        let sessionStr = "/trips/\(tripCode)/trips/"
        
        //let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        //getDataWithUrlString(urlStr)
    }
    
    
    
    //send order information to Server
    func sentOrderInformation(address:Address){
        let userName = "user0"
        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        let sessionStr = "/api/1.0/addresses/addresses/"
        //let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        let dataPackage = address.packAllPropertiesAsData()
        print(dataPackage)
        //        postDataWithUrlString(urlStr,dataPackage)
    }
    
    func sentRequestImageUrls(){
        let userName = "user0"
        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        let sessionStr = "/api/1.0/addresses/addresses/"
        //let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        //curl -F data='{"image_urls":[{"image_url":"http://1"}, {"image_url":"http://2"}, {"image_url":"http://3"}], "request_id":"2"}' -F app_token='0123456789012345678901234567890123456789012345678901234567890123' -F timestamp=`date -u +%s` -F username='user0' -F user_token='ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2' -X POST
        //let urlStr = "http://0.0.0.0:5000/api/1.0/requests/postimages/"
        //postDataToUrlString(<#T##urlStr: String##String#>, postData: Data)
    }
    
    
    
    
    // MARK: - basic GET and POST by url
    /**
     * ✅ get data with url string, return NULL, try with Alamofire and callback
     */
    private func getDataWithUrlRoute(_ route: String, parameters: [String: Any], getDictionary: @escaping(([String : Any]) -> Void)) {
        let requestUrlStr = host + route
        print("get requestUrlStr = \(requestUrlStr)")
        print("get parameters = \(parameters)")
        Alamofire.request(requestUrlStr, parameters: parameters).responseJSON { response in
            print("get response = \(response)")
            if let responseValue = response.value as? [String: Any] {
                print("get responseValue = \(responseValue)")
                getDictionary(responseValue)
            }
        }
        
    }
    /**
     * get data with url string, return NULL, try with completionHandler
     */
    private func getDataWithUrlString(_ urlStr:String, httpHeaders:[String:String]?, getInfoDictionary: @escaping ([String:AnyObject]) -> Void) {
        print("\n\r === URL: \(urlStr) ===")
        var urlStrHeaders: String = ""
        if let headers = httpHeaders { // this is NOT working !!!!!!
            for pair in headers {
                urlStrHeaders.append("\(pair.key)=\(pair.value)&")
            }
        }
        print("get urlStrHeaders = \(urlStrHeaders)")
        
        urlStrHeaders.remove(at: urlStrHeaders.index(before: urlStrHeaders.endIndex))
        let url = NSURL(string: "\(urlStr)?\(urlStrHeaders)")! as URL
        
        var request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0) as URLRequest
        request.httpMethod = "GET"
        
        let httpData = NSData(data: "{}".data(using: String.Encoding.utf8)! )
        request.httpBody = httpData as Data // get func will NOT have request.httpBody

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, err) in
            if err != nil {
                print("Errorrrr :: in ApiServers::fetchAllUsers(), dataTask err = \(err!)")
            }else{
                if let httpResponse = response as? HTTPURLResponse {
                    print("\r\n get response: \(httpResponse)")
                }
                guard let content = data else { return }
                do {
                    if let myJson = try JSONSerialization.jsonObject(with: content, options: .allowFragments) as? [String:AnyObject] {
                    //print("--- get myJson = \(myJson) \n\r")
                    getInfoDictionary(myJson)
//                    if let getData = myJson?["data"] as? [Any] {
//                        print("--- --- get myJson[data] = \n\r \(myJson?["data"]) \n\r")
//                        if let getDictionary = getData.first as? [String:AnyObject] {
//                            //print("--- --- --- get getDictionary: \n\r\(getDictionary)")
//                            //getInfoDictionary(getDictionary)
//                        }
//                    }else{
//                        print("--- ---Error in get jsonData: \n\r\(myJson?["data"])  \n\r")
//                    }
                    }
                }catch let jsonErr {
                    print("--- get Error when parsing JSON: err = \(jsonErr) \n\r")
                }
            }
        }
        dataTask.resume()
        
    }
    
    
    /**
     * POST data with url string, get the ID pass from server, using completing handler
     */
    private func postDataToUrlString(_ urlStr:String, postData: [String:Any], httpHeaders:[String:String]?, handleResponse: @escaping ([String:AnyObject]) -> Void) {
        print("\n\r === postDataToUrlString: \(urlStr) ===")
        let nsUrl = NSURL(string: urlStr)! as URL
        
        var request = NSMutableURLRequest(url: nsUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0) as URLRequest
        request.httpMethod = "POST"
        //this will NOT work: request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var httpData = Data()
        
        var httpBody : [String:Any] = [ServerKey.data.rawValue : postData]
        if let headers = httpHeaders {
            for pair in headers {
                httpBody[pair.key] = pair.value
            }
        }
        do {
            httpData = try JSONSerialization.data(withJSONObject: httpBody, options: []) as Data
        }catch let err {
            print("get errrorororor when parsing data: \(err)")
        }
        request.httpBody = httpData //postData
        
        var getId : String = ""
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, err) in
            if err != nil {
                print("--- Error!!! ApiServers::postDataToUrlString(), dataTask err = \(err!)")
            }else{
                //let httpResponse = response as? HTTPURLResponse // ????????????/
                print("get data from postDataToUrlString(): \(data)")
                guard let content = data else { return }
                do {
                    if let getDictionary = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as? [String:AnyObject] {
                        print("--- --- get myJson = \n\r \(getDictionary) \n\r")
                        handleResponse(getDictionary)
                    }else{
                        print("--- get eirirriir when recall haldler...Quite.")
                    }
//                    if let getData = myJson?["data"] as? [Any] {
//                        print("--- --- get myJson[data] = \n\r \(myJson?["data"]) \n\r")
//                        //if let getDictionary = getData.first as? [String:AnyObject] {
//                        //    print("--- --- --- get getDictionary and return: \n\r\(getDictionary)")
//                        //}
//                    }else{
//                        print("--- --- --- Error in get jsonData: \n\r\(myJson?["data"])  \n\r")
//                    }
                }catch let jsonErr {
                    print("--- --- get Error when parsing JSON: err = \(jsonErr) \n\r")
                }
            }
        }
        dataTask.resume()
    }
    
    
}




