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
    
    enum PropInDB : String {
        case id         = "id"
        case country    = "country"
        case state      = "state"
        case city       = "city"
        case detailAddr = "street"
        case zipcode    = "zipcode"
        case recipientName = "resident"
        case phoneNumber = "phone"
        case longtitude = "longtitude"
        case latitude   = "latitude"
    }
    
    
    
    override init() {
        super.init()
        
        self.id = ""
        
        self.country = Country.China
        self.state = ""
        self.city  = ""
        
        self.detailAddress = ""
        self.zipcode = ""
        
        self.recipientName = ""
        self.phoneNumber = ""
        
    }
    
    init(country cy: Country, state st: String, city ct: String, detailAddress ds: String, zipCode zc:String, recipient:String, phoneNum pn: String){
        
        self.id = ""
        
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
    
    func packAllPropertiesAsData() -> Data? {
        var json:[String:Any] =  [:]
        // the [key] is NOT allow to change! MUST the same as in DB;
        json[PropInDB.id.rawValue]       = id
        json[PropInDB.country.rawValue]  = country.rawValue
        json[PropInDB.state.rawValue]    = state
        json[PropInDB.city.rawValue]     = city
        json[PropInDB.detailAddr.rawValue] = detailAddress
        json[PropInDB.zipcode.rawValue]  = zipcode
        json[PropInDB.recipientName.rawValue] = recipientName
        json[PropInDB.phoneNumber.rawValue] = phoneNumber
        json[PropInDB.longtitude.rawValue] = coordinateLongitude
        json[PropInDB.latitude.rawValue] = coordinateLatitude
        
        do {
            if let dt = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) as Data? {
                //                let decoded = try JSONSerialization.jsonObject(with: dt as Data, options: [])
                //                // here "decoded" is of type `Any`, decoded from JSON data
                //                if let dc = decoded as? [String:Any] {
                //                    for item in dc {
                //                        print("key = \(item.key), val = \(item.value)")
                //                    }
                //                }
                return dt
            }
            
        } catch let err {
            print("get eerorroor when try to JSONSerialization", err)
        }
        return nil
    }
    
    func setupByDictionaryFromDB(_ json: [String:Any]){
        id          = json[PropInDB.id.rawValue] as? String ?? ""
        country     = (json[PropInDB.country.rawValue] as? String ?? "") == Country.China.rawValue ? Country.China : Country.UnitedStates
        state       = json[PropInDB.state.rawValue] as? String ?? ""
        city        = json[PropInDB.city.rawValue] as? String ?? ""
        detailAddress = json[PropInDB.detailAddr.rawValue] as? String ?? ""
        zipcode     = json[PropInDB.zipcode.rawValue] as? String ?? ""
        recipientName = json[PropInDB.recipientName.rawValue] as? String ?? ""
        phoneNumber = json[PropInDB.phoneNumber.rawValue] as? String ?? ""
        coordinateLongitude = json[PropInDB.longtitude.rawValue] as? Double ?? 0.0
        coordinateLatitude  = json[PropInDB.latitude.rawValue] as? Double ?? 0.0
    }
    
}

