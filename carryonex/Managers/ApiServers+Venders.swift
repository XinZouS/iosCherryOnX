//
//  ApiServers+Venders.swift
//  carryonex
//
//  Created by Zian Chen on 1/16/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import Foundation
import Alamofire
import Unbox

let deliveryCheckErrorDomain: String = "com.carryonex.error.kuaidi"

extension ApiServers {
    
    func checkDelivery(tracking:String, companyCode: String, completion: ((KuaidiObject?, Error?) -> Void)?)   //Kuaidi object, error
    {
        let key:String = "DCCZOjyX846"
        let customer:String = "CF58D30E34CBC0767762E17E91B27342"
        
        let data:String = "{\"com\":\"\(companyCode)\",\"num\":\"\(tracking)\",\"from\":\"\",\"to\":\"\"}"
        let sign:String = (data + key + customer).md5().uppercased()
        
//        DLog("Return sign: \(sign). Correct sign: E2661ADB2D65675BFF5B2770D5D68BD2")
        
        let params:[String: Any] = [
            "customer": customer,
            "param" : data,
            "sign": sign
        ]
        
        if let url = URL(string: "https://poll.kuaidi100.com/poll/query.do") {
            Alamofire.request(url, parameters: params).responseJSON { response in
                
                if let urlRequest:URL = response.request?.url {
                    let printText: String = """
                    =========================
                    [GET ROUTE] \(url.absoluteString)
                    [REQUEST] \(urlRequest)
                    """
                    DLog(printText)
                }
                
                
                if let responseValue = response.value as? [String: Any] {
                    if let code = responseValue["status"] as? String, code == "200" {
                        do {
                            let object: KuaidiObject = try unbox(dictionary: responseValue)
                            completion?(object, nil)
                            
                        } catch let error {
                            DLog("Get error when checkDelivery. Error = \(error.localizedDescription)")
                            completion?(nil, error)
                        }
                        return
                    }
                    
                    if let code = responseValue["returnCode"] as? String, let codeNum = Int(code), let message = responseValue["message"] as? String {
                        let error = NSError.init(domain: deliveryCheckErrorDomain, code: codeNum, userInfo: ["message": message])
                        completion?(nil, error)
                        return
                    }
                    
                    completion?(nil, nil)
                }
            }
        }
    }
}
