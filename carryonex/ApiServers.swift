//
//  ApiServers.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation


class ApiServers : NSObject {
    
    static let shared = ApiServers()
    
    
    private let timeStamp = 150000000 // Date.timeIntervalSinceReferenceDate + Date.timeIntervalBetween1970AndReferenceDate

    private let appToken: String = "0123456789012345678901234567890123456789012345678901234567890123"
    
    private let baseUrl = "http://192.168.0.119:5000/api/1.0" // "http://0.0.0.0:5000/api/1.0"
    
    
    
    // base request func model
    
    func fetchRequests(completion: @escaping ([Request]) -> () ) {
        
        // real network server fetch: 
//        fetchRequestsForUrlString(urlSession: "/connect to url!!") { (requests) in
//            completion(requests)
//        }
    }
    
    
    
    /// TODO: fix completion func for JSON parsing
    private func fetchRequestsForUrlString(urlSession: String, completion: @escaping ([Request]) -> () ) {
        let url = NSURL(string: "\(baseUrl)\(urlSession)")
        let request = URLRequest(url: url as! URL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error::: get error when fetchRequiresForUrlString:ApiServers !!!")
                return
            }
            
            do{
                if let unwarppedData = data,
                    let jsonDictionarys = try JSONSerialization.jsonObject(with: unwarppedData, options: .mutableContainers) as? [[String:AnyObject]] {
                    
                    DispatchQueue.main.async(execute: {
                        print("TODO: convert request into Request object!!!!!!")
                        //completion(jsonDictionarys.map({ return Request(dictionary: $0) }))
                    })
                    
                }
            }catch let jsonErr {
                print("Error::: get error when fetchRequiresForUrlString:ApiServers, jsonErr: \(jsonErr)")
            }
            
        }
        
        
        
    }
    
    
    /// MARK: - test in AppDelegate.swift
    
    func getUserSaltByUsername(_ userName:String){
        let sessionStr = "/users/\(userName)/salt/"
        
        let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)"
        getDataWithUrlString(urlStr)
    }
    
    
    func getUserInfoById(_ id: String){
        let userName = "user0"
        let sessionStr = "/users/\(userName)/info/"
        
        let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(id)"
        getDataWithUrlString(urlStr)
    }
    
    
    func postTripInfo(trip: Trip){
        let sessionStr = "/trips/trips/"
        let urlStr = "\(baseUrl)\(sessionStr)"
        postDataToUrlString(urlStr, object: trip)
    }
    
    func getTripById(id: String){
        let userName = "user0"
        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        let sessionStr = "/trips/\(id)/info/"
        
        let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        getDataWithUrlString(urlStr)
    }
    
    
    func getTripByTripCode(_ tripCode: String){
        let userName = "user0"
        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        let sessionStr = "/trips/\(tripCode)/trips/"
        
        let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        getDataWithUrlString(urlStr)
    }
    
    
    
    
    
    // session: /api/1.0/users/allusers/ GET
    func fetchAllUsers(){
        
        let userName = "user0"
        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        
        let sessionStr = "/api/1.0/users/allusers/"
        
        
        let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        getDataWithUrlString(urlStr)
    }
    
    
    
    /**
     * get data with url string, return NULL
     */
    private func getDataWithUrlString(_ urlStr:String) {
        print("\n\r === URL: \(urlStr) ===")
        let nsUrl = NSURL(string: urlStr)! as URL
        
        let postData = NSData(data: "{}".data(using: String.Encoding.utf8)! )
        var request = NSMutableURLRequest(url: nsUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0) as URLRequest
        request.httpMethod = "GET"
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, err) in
            if err != nil {
                print("--- Error :: in ApiServers::fetchAllUsers(), dataTask err = \(err!)")
            }else{
                //let httpResponse = response as? HTTPURLResponse // ????????????/
                
                guard let content = data else { return }
                do {
                    let myJson = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as? [String:Any]
                    //print("--- --- get myJson[data] = \n\r \(myJson?["data"]) \n\r")
                    if let getData = myJson?["data"] as? [Any] {
                        //print("--- --- get myJson[data] = \n\r \(myJson?["data"]) \n\r")
                        if let getDictionary = getData.first as? [String:AnyObject] {
                            print("--- --- --- get getDictionary: \n\r\(getDictionary)")
                        }
                    }else{
                        print("--- --- --- Error in get jsonData: \n\r\(myJson?["data"])  \n\r")
                    }
                }catch let jsonErr {
                    print("--- --- get Error when parsing JSON: err = \(jsonErr) \n\r")
                }
            }
        }
        dataTask.resume()
        
    }
    
    
    /**
     * POST data with url string, get the ID pass from server
     */
    private func postDataToUrlString(_ urlStr:String, object: AnyObject) -> String {
        print("\n\r === URL: \(urlStr) ===")
        let nsUrl = NSURL(string: urlStr)! as URL
        
        var request = NSMutableURLRequest(url: nsUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0) as URLRequest
        request.httpMethod = "POST"
        //request.httpBody = ObjectToPrint.getJSON(obj: object, options: JSONSerialization.WritingOptions.prettyPrinted)
        
        var getId : String = ""
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { (data, response, err) in
            if err != nil {
                print("--- Error :: in ApiServers::fetchAllUsers(), dataTask err = \(err!)")
            }else{
                //let httpResponse = response as? HTTPURLResponse // ????????????/
                
                guard let content = data else { return }
                do {
                    let myJson = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as? [String:Any]
                    print("--- --- get myJson[data] = \n\r \(myJson?["data"]) \n\r")
                    if let getData = myJson?["data"] as? [Any] {
                        print("--- --- get myJson[data] = \n\r \(myJson?["data"]) \n\r")
                        if let getDictionary = getData.first as? [String:AnyObject] {
                            print("--- --- --- get getDictionary: \n\r\(getDictionary)")
                        }
                    }else{
                        print("--- --- --- Error in get jsonData: \n\r\(myJson?["data"])  \n\r")
                    }
                }catch let jsonErr {
                    print("--- --- get Error when parsing JSON: err = \(jsonErr) \n\r")
                }
            }
        }
        dataTask.resume()
        
        return getId
    }
    
    /**
     * post data with url string, return NULL
     */
////    private func postDataWithUrlString(_ urlStr:String,_ dataPackage:Data) {
////        print("\n\r === URL: \(urlStr) ===")
////        let nsUrl = NSURL(string: urlStr)! as URL
////
////        var request = NSMutableURLRequest(url: nsUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0) as URLRequest
////        request.httpMethod = "POST"
////        request.httpBody = dataPackage
////
////        let session = URLSession.shared
////        let dataTask = session.dataTask(with: request) { (data, response, err) in
////            if err != nil {
////                print("--- Error :: in ApiServers::fetchAllUsers(), dataTask err = \(err!)")
////            }else{
////                //let httpResponse = response as? HTTPURLResponse // ????????????/
////
////                guard let content = data else { return }
////                do {
////                    let myJson = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as? [String:Any]
////                    //                    print("--- --- get json: \n\r \(myJson?["data"]) \n\r")
////                    if let getData = myJson?["data"] as? [Any] {
////                        if let getDictionary = getData.first as? [String:AnyObject] {
////                            print("--- --- --- get jsonData: \n\r\(getDictionary)")
////                        }
////                    }else{
////                        print("--- --- --- Error in get jsonData: \n\r\(myJson?["data"])  \n\r")
////                    }
////                }catch let jsonErr {
////                    print("--- --- get Error when parsing JSON: err = \(jsonErr) \n\r")
////                }
////            }
////        }
////        dataTask.resume()
////
//    }
    
    //send order information to Python
    func sentOrderInformation(address:Address){
        let userName = "user0"
        let userToken = "ade1214f40dbb8b35563b1416beca94f4a69eac6167ec0d8ef3eed27a64fd5a2"
        let sessionStr = "/api/1.0/addresses/addresses/"
        let urlStr = "\(baseUrl)\(sessionStr)?app_token=\(appToken)&timestamp=\(timeStamp)&username=\(userName)&user_token=\(userToken)"
        let dataPackage = address.packageAllAddressData()
        print(dataPackage)
//        postDataWithUrlString(urlStr,dataPackage)
    }
    
}




/*
// MARK: -
/// for parsing class object --> Json
class ObjectToPrint : NSObject {
    
    class func getJSON(obj: AnyObject, options: JSONSerialization.WritingOptions) -> Data {
        var data = Data()
        do{
            data = try JSONSerialization.data(withJSONObject: self.getObjectDictionary(obj: obj), options: options)
        }
        catch let err {
            print("get error when getJSON from obj, err = \(err)")
        }
        return data
    }
    
    class func getObjectDictionary(obj: AnyObject) -> NSMutableDictionary {
        let dic = NSMutableDictionary()
        var propsCount: UInt32 = 0
        let props = class_copyPropertyList(obj.classForCoder, &propsCount)
        
        for i in 0..<propsCount {
            let prop = props?[Int(i)]
            let propName = String.init(utf8String: property_getName(prop))
            print("get propName = \(propName)") //BUG- get tooooooooo much properties, only few is we need...
            guard let ppName = propName else { continue }
            var value = obj.value(forKey: ppName)
            if let val = value {
                value = self.getObjectInternal(obj: val as AnyObject)
            }else{
                value = NSNull()
            }
            dic.setValue(value, forKey: propName!)
        }
        return dic
    }
    
    class func getObjectInternal(obj: AnyObject) -> AnyObject {
        if obj.isKind(of: NSString.self) || obj.isKind(of: NSNumber.self) || obj.isKind(of: NSNull.self) {
            return obj
        }
        if obj.isKind(of: NSArray.self) {
            let arr = NSArray.init(array: obj as! [Any])
            let objArr = NSMutableArray.init(capacity: arr.count)
            for i in 0..<arr.count {
                objArr[i] = self.getObjectInternal(obj: arr[i] as AnyObject)
            }
            return objArr
        }
        if obj.isKind(of: NSDictionary.self){
            let dic = NSMutableDictionary.init(capacity: (obj as! NSDictionary).count)
            for key in (obj as! NSDictionary).allKeys {
                let getObj = (obj as! NSDictionary).value(forKey: key as! String) as AnyObject
                dic.setObject(self.getObjectInternal(obj: getObj), forKey: key as! NSString)
            }
            return dic
        }
        return self.getObjectDictionary(obj: obj) // ???????????? will infini loop ????????
    }
    
}
*/

