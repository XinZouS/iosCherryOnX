//
//  Address.swift
//  carryonex
//
//  Created by Xin Zou on 8/29/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import MapKit

enum Country: String {
    case China = "中国大陆"
    case UnitedStates = "United States"
}
 
class Address : NSObject {
    
    var id : String!
    
    var country: Country!
    var state : String!
    var city  : String!
    
    var detailAddress: String!
    
    var zipcode: String!
    
    var recipientName: String!
    var phoneNumber: String!
    
    var coordinateLongitude: Double = 0.0
    var coordinateLatitude: Double = 0.0

    
    
    override init() {
        super.init()
        
        self.id = "id"
        
        self.country = Country.China
        self.state = "广东省"
        self.city  = "广州市"

        self.detailAddress = "天河城，3号线客村，3号线客村，3号线客村"
        self.zipcode = "000000"
        
        self.recipientName = "马云"
        self.phoneNumber = "1376668888"
        
    }
    
    init(country cy: Country, state st: String, city ct: String, detailAddress ds: String, zipCode zc:String, recipient:String, phoneNum pn: String){
        
        self.id = "id"
        
        self.country = cy
        self.state = st
        self.city = ct
        
        self.detailAddress = ds
        
        self.zipcode = zc
        
        self.recipientName = recipient
        self.phoneNumber = pn
    }
    
    func descriptionString() -> String {
        if self.country == Country.China {
            return "\(state!), \(city!), \(detailAddress!), 邮编 \(zipcode!)"
        }else{
            return "\(detailAddress!), \(city!), \(state!), \(zipcode!)"
        }
    }
    
    func packageAllAddressData() -> Data{
        var jsonData  = Data()
        var json:[String:Any] =  [:]
        json["id"] = id
        json["country"] = country.rawValue
        json["state"] = state
        json["city"] = city
        json["detailAddress"] = detailAddress
        json["zipcode"] = zipcode
        json["recipientName"] = recipientName
        json["phoneNumber"] = phoneNumber
        json["coordinateLongitude"] = coordinateLongitude
        
        do {
            if let dt = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) as Data? {//as Data
                jsonData = dt
                print(jsonData.description)
            // here "jsonData" is the dictionary encoded in JSON data
            }
            let decoded = try JSONSerialization.jsonObject(with: jsonData as Data, options: [])
            // here "decoded" is of type `Any`, decoded from JSON data
            if let dc = decoded as? [String:Any] {
                for item in dc {
                    print("key = \(item.key), val = \(item.value)")
                }
            }
            // you can now cast it with the right type
//            if let decoded is [String:String] {
//                // use dictFromJSON
//                print(decoded)
//            }
        } catch let err {
            print(err)
        }
        return jsonData
    }
    
}
