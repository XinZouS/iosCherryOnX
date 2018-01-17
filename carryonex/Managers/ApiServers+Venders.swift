//
//  ApiServers+Venders.swift
//  carryonex
//
//  Created by Zian Chen on 1/16/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import Foundation
import Alamofire

extension ApiServers {
    
    func checkDelivery() {
        
        
        let data = "{\"com\":\"huitongkuaidi\",\"num\":\"70118428554311\",\"from\":\"\",\"to\":\"\"}"
        
        let params:[String: Any] = [
            "customer": "CF58D30E34CBC0767762E17E91B27342",
            "param" : data,
            "sign": "E2661ADB2D65675BFF5B2770D5D68BD2"
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
                
                print("PRINT Data: \(response.value)")
            }
        }
    }
}
