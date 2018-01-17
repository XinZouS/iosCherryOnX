//
//  ApiServers+Venders.swift
//  carryonex
//
//  Created by Zian Chen on 1/16/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import Foundation
import Alamofire
import Kingfisher

extension ApiServers {
    
    func checkDelivery() {
        
        let companyCode = "huitongkuaidi"
        let tracking = "70118428554311"
        let key = "DCCZOjyX846"
        let customer = "CF58D30E34CBC0767762E17E91B27342"
        
        let data = "{\"com\":\"\(companyCode)\",\"num\":\"\(tracking)\",\"from\":\"\",\"to\":\"\"}"
        let sign = (data + key + customer).md5().uppercased()
        
//        DLog("Return sign: \(sign). Correct sign: E2661ADB2D65675BFF5B2770D5D68BD2")
        
        let params:[String: Any] = [
            "customer": customer,
            "param" : data,
            "sign": sign
        ]
        
        if let url = URL(string: "https://poll.kuaidi100.com/poll/query.do") {
            Alamofire.request(url, parameters: params).responseJSON { response in
                
                if let urlRequest = response.request?.url {
                    let printText: String = """
                    =========================
                    [GET ROUTE] \(url.absoluteString)
                    [REQUEST] \(urlRequest)
                    """
                    DLog(printText)
                }
                
//                print("PRINT Data: \(response.value)")
            }
        }
    }
}
