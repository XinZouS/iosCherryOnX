//
//  ApiServers.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

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
    case myCarries = "carries"
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
        case timestamp = "timestamp"
    }
    
    
    private let appToken: String = "0123456789012345678901234567890123456789012345678901234567890123"
    
    //private let baseUrl = "http://0.0.0.0:5000/api/1.0"
    private let baseUrl = "http://192.168.0.119:5000/api/1.0"
    
    private func getTimestampStr() -> String {
        let t = Int(Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate)
        return "\(150000000)" // TODO: this is for test only.
        return "\(t)"
    }
    
    
    // MARK: - User APIs
    
    func registerUser(){
        let sessionStr = "/users/"
        let urlStr = "\(baseUrl)\(sessionStr)"
        User.shared.username = "testUsername"
        User.shared.phone = "1234567890"
        User.shared.password = "testPassword"
        User.shared.email = "testEmail@carryonex.com"
        let dictionary = User.shared.packAllPropertiesAsDictionary()
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken
        ]
        postDataToUrlString(urlStr, postData: dictionary, httpHeaders: headers) { (responsDictionary) in
            print("get response dictionary: \(responsDictionary)")
            if let getToken = responsDictionary[ServerKey.data.rawValue] as? [String] {
                User.shared.token = getToken.first ?? ""
                User.shared.saveIntoLocalDisk()
            }
        }
    }
    func loginUser(){
        let sessionStr = "/users/login/"
        let urlStr = "\(baseUrl)\(sessionStr)"
        let dict = User.shared.packAllPropertiesAsDictionary()
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken
        ]
        postDataToUrlString(urlStr, postData: dict, httpHeaders: headers) { (responsDictionary) in
            print("get response dictionary: \(responsDictionary)")
            if let getToken = responsDictionary[ServerKey.data.rawValue] as? [String] {
                User.shared.token = getToken.first ?? ""
                User.shared.saveIntoLocalDisk()
                print("OKKKK get login token = \(getToken.first!)")
            }
        }
    }
    
    ///////////////// url demo todo!!!!!!!!!!!!!
    func getTrip(tripCode: String) {
        let urlComponents = URLComponents.init()
    }
    
    
    
    
    func logoutUser(){
        let sessionStr = "/users/logout/"
        let urlStr = "\(baseUrl)\(sessionStr)"
        let dict = User.shared.packAllPropertiesAsDictionary()
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: User.shared.token ?? ""
        ]
        postDataToUrlString(urlStr, postData: dict, httpHeaders: headers) { (responsDictionary) in
            print("get response dictionary: \(responsDictionary)")
            if let getStatus = responsDictionary[ServerKey.statusCode.rawValue] as? Int, getStatus == 200 {
                print("OK logout success! clear user data!")
                User.shared.clearCurrentData()
                User.shared.saveIntoLocalDisk()
            }
        }
    }
    func getUserInfo(_ propertyUrl: ServerUserPropUrl, handleInfo: @escaping (String) -> Void){
        let sessionStr = "/users/\(User.shared.username!)/\(propertyUrl.rawValue)/"
        let urlStr = "\(baseUrl)\(sessionStr)"
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: User.shared.token ?? "",
            ServerKey.username.rawValue : User.shared.username ?? ""
        ]
        getDataWithUrlString(urlStr, httpHeaders: headers) { (infoDictionary) in //["data":[{nil}], "status_code":Int, "message":String]
            print("get infoDictionary: \(infoDictionary)")
            if let infoObj = infoDictionary[ServerKey.data.rawValue] as? [String] {
                handleInfo(infoObj.first ?? "")
            }
        }
    }
    func getUserInfoAll(handleInfo: @escaping ([String:AnyObject]) -> Void){
        let sessionStr = "/users/\(User.shared.username!)/info/"
        let urlStr = "\(baseUrl)\(sessionStr)"
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: User.shared.token ?? "",
            ServerKey.username.rawValue : User.shared.username ?? ""
        ]
        getDataWithUrlString(urlStr, httpHeaders: headers) { (infoDictionary) in //["data":[{User}], "status_code":Int, "message":String]
            let arr = infoDictionary["data"] as? [Any] // ["data":[any], ..]
            if let dict = arr?.first as? [String:AnyObject] {
                //print("----------get arr.first, dict = \(dict)")
                handleInfo(dict)
            }
        }
    }
    func getUserLogsOf(type: ServerUserLogUrl, handleLogArray: @escaping ([String:AnyObject]) -> Void){
        let sessionStr = "/users/\(User.shared.username!)/\(type.rawValue)/"
        let urlStr = "\(baseUrl)\(sessionStr)"
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: User.shared.token ?? "",
            ServerKey.username.rawValue : User.shared.username ?? ""
        ]
        getDataWithUrlString(urlStr, httpHeaders: headers) { (infoDictionary) in //["data":[{json of log array}], "status_code":Int, "message":String]
            print("getDataWithUrlString infoDictionary = \(infoDictionary)")
            let arr = infoDictionary["data"] as? [Any] // ["data":[any], ..]
            print("TODO: after get arr = \(arr)")
//            for i in 0..<arr?.count {
//                if let dict = arr?.first as? [String:AnyObject] {
//                    print("----------get arr.first, dict = \(dict)")
//                    handleLogArray(dict)
//                }
//            }
        }
    }
    func updateUserInfo(_ propUrl: ServerUserPropUrl, newInfo: String, completion: @escaping ([String:AnyObject]?) -> Void){
        let sessionStr = "/users/\(User.shared.username!)/\(propUrl.rawValue)/"
        let urlStr = "\(baseUrl)\(sessionStr)"
        let headers:[String:String] = [
            ServerKey.timestamp.rawValue: getTimestampStr(),
            ServerKey.appToken.rawValue : appToken,
            ServerKey.userToken.rawValue: User.shared.token ?? "",
            ServerKey.username.rawValue : User.shared.username ?? ""
        ]
        //postDataToUrlString(<#T##urlStr: String##String#>, postData: <#T##[String : Any]#>, httpHeaders: <#T##[String : String]?#>, handleResponse: <#T##([String : AnyObject]) -> Void#>)
    }

    
    
    
    func getUserRequestsLog(_ id: String) -> [Request] {
        let userName = "user0"
        let sessionStr = "/users/\(userName)/requests/"
        let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(getTimestampStr())&username=\(userName)&user_token=\(id)"
        var requests = [Request]()
        //        getDataWithUrlString(urlStr) { (dictionary) in
        //            print("TODO: get dictionary and make a Request list: \(dictionary)")
        //        }
        return requests
    }
    func getUserTripsLog(_ id: String) -> [Trip] {
        let userName = "user0"
        let sessionStr = "/users/\(userName)/trips/"
        let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(getTimestampStr())&username=\(userName)&user_token=\(id)"
        var trips = [Trip]()
        //        getDataWithUrlString(urlStr) { (dictionary) in
        //            print("TODO: get dictionary and make a Trip list: \(dictionary)")
        //        }
        return trips
    }
    
    
    func getAllUsers(){
        let userName = "user0"
        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        let sessionStr = "/api/1.0/users/allusers/"
        //let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        //getDataWithUrlString(urlStr)
    }
    
    
    // MARK: - Trip APIs
    
    func postTripInfo(trip: Trip){
        let sessionStr = "/trips/trips/"
        let urlStr = "\(baseUrl)\(sessionStr)"
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




