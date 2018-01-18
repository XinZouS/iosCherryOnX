//
//  Address.swift
//  carryonex
//
//  Created by Xin Zou on 8/29/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox
import MapKit

enum AddressKeyInDB : String {
    case country = "country"
    case state = "state"
    case city = "city"
    case recipientName = "resident"
    case phoneNumber = "phone"
    case detailedAddress = "description"
}

class Address: NSObject, Unboxable {
    var country: String?
    var state: String?
    var city: String?
    var street: String?
    var zipcode: String?
    var recipientName: String?
    var phoneNumber: String?
    var detailedAddress: String?
    var coordinateLatitude: Double = 0 // Central Park, New York
    var coordinateLongitude: Double = 0 // Central Park, New York
    
    override init() {
        super.init()
    }
    
    required init(unboxer: Unboxer) throws {
        self.country = try? unboxer.unbox(key: AddressKeyInDB.country.rawValue)
        self.state = try? unboxer.unbox(key: AddressKeyInDB.state.rawValue)
        self.city = try? unboxer.unbox(key: AddressKeyInDB.city.rawValue)
        self.recipientName = try? unboxer.unbox(key: AddressKeyInDB.recipientName.rawValue)
        self.phoneNumber = try? unboxer.unbox(key: AddressKeyInDB.phoneNumber.rawValue)
        self.detailedAddress = try? unboxer.unbox(key: AddressKeyInDB.detailedAddress.rawValue)
    }
    
    func descriptionString() -> String {
        return detailedAddress ?? ""
    }
    
    func packAllPropertiesAsData() -> Data? {
        var json:[String: Any] =  [:]
        json[AddressKeyInDB.country.rawValue]  = country
        json[AddressKeyInDB.state.rawValue] = state
        json[AddressKeyInDB.city.rawValue] = city
        json[AddressKeyInDB.recipientName.rawValue] = recipientName
        json[AddressKeyInDB.phoneNumber.rawValue] = phoneNumber
        json[AddressKeyInDB.detailedAddress.rawValue] = detailedAddress
        
        do {
            if let dt = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) as Data? {
                return dt
            }
        } catch let err {
            DLog("get error when try to JSONSerialization: \(err.localizedDescription)")
        }
        return nil
    }
    
    func setupByDictionaryFromDB(_ json: [String:Any]){
        country = (json[AddressKeyInDB.country.rawValue] as? String ?? "")
        state = json[AddressKeyInDB.state.rawValue] as? String ?? ""
        city = json[AddressKeyInDB.city.rawValue] as? String ?? ""
        recipientName = json[AddressKeyInDB.recipientName.rawValue] as? String ?? ""
        phoneNumber = json[AddressKeyInDB.phoneNumber.rawValue] as? String ?? ""
        detailedAddress = json[AddressKeyInDB.detailedAddress.rawValue] as? String ?? ""
    }
    
    func packAsDictionaryForDB() -> [String: Any] {
        var json = [String: Any]()
        json[AddressKeyInDB.country.rawValue] = country
        json[AddressKeyInDB.state.rawValue] = state
        json[AddressKeyInDB.city.rawValue] = city
        json[AddressKeyInDB.recipientName.rawValue] = recipientName
        json[AddressKeyInDB.phoneNumber.rawValue] = phoneNumber
        json[AddressKeyInDB.detailedAddress.rawValue] = detailedAddress //This is actually going into description field
        return json
    }
    
    func shareCityString() -> String {
        if let city = city {
            return city
        }
        
        if let state = state {
            return state
        }
        
        if let country = country {
            return country
        }
        return ""
    }
    
    func fullAddressString() -> String {
        var address = [String]()
        if let country = country {
            address.append(country)
        }
        
        if let state = state, !state.isEmpty {
            address.append(state)
        }
        
        if let city = city, !city.isEmpty {
            address.append(city)
        }
        
        if address.count == 0 {
            return L("address.ui.description.empty")
        } else {
            return address.joined(separator: "·")
        }
    }
}

enum GPSKeyInDB : String {
    case longitude = "longitude"
    case latitude = "latitude"
}

struct GPS {
    let longitude: Double?
    let latitude: Double?
}

extension GPS: Unboxable {
    init(unboxer: Unboxer) throws {
        self.longitude = try? unboxer.unbox(key: "longitude")
        self.latitude = try? unboxer.unbox(key: "latitude")
    }
}
