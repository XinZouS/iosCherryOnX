//
//  Address.swift
//  carryonex
//
//  Created by Xin Zou on 8/29/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Unbox
import MapKit

enum Country: String, UnboxableEnum {
    case China = "中国大陆"
    case UnitedStates = "United States"
}

enum AddressKeyInDB : String {
    case id         = "id"
    case country    = "country"
    case state      = "state"
    case city       = "city"
    case detailAddr = "street"
    case zipcode    = "zipcode"
    case recipientName = "resident"
    case phoneNumber = "phone"
    case longtitude = "longitude"
    case latitude   = "latitude"
}



class Address : NSObject, Unboxable {
    
    var id : String?
    var country: Country?
    var state : String?
    var city  : String?
    var detailAddress: String?
    var zipcode: String?
    var recipientName: String?
    var phoneNumber: String?
    var coordinateLatitude: Double = 40.785091 // Central Park, New York
    var coordinateLongitude: Double = -73.968285 // Central Park, New York

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
    
    required init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: AddressKeyInDB.id.rawValue)
        self.country = try? unboxer.unbox(key: AddressKeyInDB.country.rawValue)
        self.state = try? unboxer.unbox(key: AddressKeyInDB.state.rawValue)
        self.city = try? unboxer.unbox(key: AddressKeyInDB.city.rawValue)
        self.detailAddress = try? unboxer.unbox(key: AddressKeyInDB.detailAddr.rawValue)
        self.zipcode = try? unboxer.unbox(key: AddressKeyInDB.zipcode.rawValue)
        self.recipientName = try? unboxer.unbox(key: AddressKeyInDB.recipientName.rawValue)
        self.phoneNumber = try? unboxer.unbox(key: AddressKeyInDB.phoneNumber.rawValue)
        self.coordinateLatitude = (try? unboxer.unbox(key: AddressKeyInDB.latitude.rawValue)) ?? 40.785091
        self.coordinateLongitude = (try? unboxer.unbox(key: AddressKeyInDB.longtitude.rawValue)) ?? -73.968285
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
        json[AddressKeyInDB.id.rawValue]       = id
        json[AddressKeyInDB.country.rawValue]  = self.country!.rawValue
        json[AddressKeyInDB.state.rawValue]    = state
        json[AddressKeyInDB.city.rawValue]     = city
        json[AddressKeyInDB.detailAddr.rawValue] = detailAddress
        json[AddressKeyInDB.zipcode.rawValue]  = zipcode
        json[AddressKeyInDB.recipientName.rawValue] = recipientName
        json[AddressKeyInDB.phoneNumber.rawValue] = phoneNumber
        json[AddressKeyInDB.longtitude.rawValue] = coordinateLongitude
        json[AddressKeyInDB.latitude.rawValue] = coordinateLatitude
        
        do {
            if let dt = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) as Data? {
                return dt
            }
        } catch let err {
            print("get error when try to JSONSerialization", err)
        }
        return nil
    }
    
    func setupByDictionaryFromDB(_ json: [String:Any]){
        id = json[AddressKeyInDB.id.rawValue] as? String ?? ""
        country = (json[AddressKeyInDB.country.rawValue] as? String ?? "") == Country.China.rawValue ? Country.China : Country.UnitedStates
        state = json[AddressKeyInDB.state.rawValue] as? String ?? ""
        city = json[AddressKeyInDB.city.rawValue] as? String ?? ""
        detailAddress = json[AddressKeyInDB.detailAddr.rawValue] as? String ?? ""
        zipcode = json[AddressKeyInDB.zipcode.rawValue] as? String ?? ""
        recipientName = json[AddressKeyInDB.recipientName.rawValue] as? String ?? ""
        phoneNumber = json[AddressKeyInDB.phoneNumber.rawValue] as? String ?? ""
        coordinateLongitude = json[AddressKeyInDB.longtitude.rawValue] as? Double ?? 0.0
        coordinateLatitude = json[AddressKeyInDB.latitude.rawValue] as? Double ?? 0.0
    }
    
    func packAsDictionaryForDB() -> [String: Any] {
        var json = [String: Any]()
        json[AddressKeyInDB.id.rawValue] = id
        json[AddressKeyInDB.country.rawValue] = country?.rawValue
        json[AddressKeyInDB.state.rawValue] = state
        json[AddressKeyInDB.city.rawValue] = city
        json[AddressKeyInDB.detailAddr.rawValue] = detailAddress
        json[AddressKeyInDB.zipcode.rawValue] = zipcode
        json[AddressKeyInDB.recipientName.rawValue] = recipientName
        json[AddressKeyInDB.phoneNumber.rawValue] = phoneNumber
        json[AddressKeyInDB.longtitude.rawValue] = coordinateLongitude
        json[AddressKeyInDB.latitude.rawValue] = coordinateLatitude
        return json
    }
}
