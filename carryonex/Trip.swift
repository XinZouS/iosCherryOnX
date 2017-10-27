//
//  Trip.swift
//  carryonex
//
//  Created by Xin Zou on 8/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import MapKit
import Unbox

enum Transportation : String, UnboxableEnum {
    case trunk = "Trunk"
    case luggage = "Luggage"
    
    func rawValueCN() -> String {
        switch self {
        case .trunk:
            return "后备箱"
        case .luggage:
            return "行李箱"
        }
    }
}

enum TripKeyInDB : String {
    case id             = "id"
    case tripCode       = "trip_code"
    case username       = "username"
    case carrierId      = "carrier_id"
    case transportation = "transportation"
    
    case totalLength    = "total_length"
    case totalWidth     = "total_width"
    case totalWeight    = "total_weight"
    case totalHeight    = "total_height"
    case eta            = "eta" //eta = "1503988470" pickup start time
    
    case startAddressId = "start_address_id"
    case endAddressId   = "end_address_id"
    
    case statusId        = "status_id"
    case pickupDate     = "pickup_date"
    case pickupTimeStart = "pickup_start_time"
    case pickupTimeEnd  = "pickup_end_time"
}


class Trip : NSObject, Unboxable {
    
    var id: String?
    var tripCode: String?
    var carrierId: String?  //TODO: DELETE THIS
    var transportation: Transportation = .trunk
    
    var totalLength: Double = 0.0
    var totalWidth:  Double = 0.0
    var totalWeight: Double = 0.0
    var totalHeight: Double = 0.0
    var eta: Double?
    
    var startAddressId: String?
    var endAddressId:   String?

    // TODO: Break them up to long and lat
    var startLocation: CLLocationCoordinate2D?
    var endLocation  : CLLocationCoordinate2D?
    
    var statusId: Int = RequestStatus.waiting.rawValue
    var pickupDate:      Double? // travel starts
    var pickupTimeStart: Double?
    var pickupTimeEnd:   Double?
    
    override init() {
        super.init()
        
        self.id = "id"
        self.tripCode = "tripCode"
        self.carrierId = "carrierId"
        self.transportation = .trunk
        
        self.eta = Date().timeIntervalSince1970
        
        self.startAddressId = "startAddress"
        self.endAddressId = "endAddress"
        
        self.startLocation = CLLocationCoordinate2DMake(40.785091, -73.968285) // Central Park, New York
        self.endLocation = CLLocationCoordinate2DMake(40.785091, -73.968285) // Central Park, New York
        
        self.statusId = RequestStatus.waiting.rawValue
        self.pickupDate =       Date().timeIntervalSince1970
        self.pickupTimeStart =  Date().timeIntervalSince1970
        self.pickupTimeEnd =    Date().timeIntervalSince1970
        
    }
    
    required init(unboxer: Unboxer) {
        self.id             = try? unboxer.unbox(key: TripKeyInDB.id.rawValue)
        self.tripCode   = try? unboxer.unbox(key: TripKeyInDB.tripCode.rawValue)
        self.carrierId      = try? unboxer.unbox(key: TripKeyInDB.carrierId.rawValue)
        self.transportation = (try? unboxer.unbox(key: TripKeyInDB.transportation.rawValue)) ?? Transportation.trunk
        
        self.totalLength = (try? unboxer.unbox(key: TripKeyInDB.totalLength.rawValue)) ?? 0.0
        self.totalWidth  = (try? unboxer.unbox(key: TripKeyInDB.totalWidth.rawValue)) ?? 0.0
        self.totalWeight = (try? unboxer.unbox(key: TripKeyInDB.totalWeight.rawValue)) ?? 0.0
        self.totalHeight = (try? unboxer.unbox(key: TripKeyInDB.totalHeight.rawValue)) ?? 0.0
        self.eta         =  try? unboxer.unbox(key: TripKeyInDB.eta.rawValue)

        self.startAddressId = try? unboxer.unbox(key: TripKeyInDB.id.rawValue)
        self.endAddressId   = try? unboxer.unbox(key: TripKeyInDB.id.rawValue)
        
        self.startLocation  = CLLocationCoordinate2DMake(40.785091, -73.968285) // Central Park, New York
        self.endLocation    = CLLocationCoordinate2DMake(40.785091, -73.968285) // Central Park, New York

        self.statusId = (try? unboxer.unbox(key: TripKeyInDB.statusId.rawValue)) ?? RequestStatus.waiting.rawValue
        self.pickupDate     = try?  unboxer.unbox(key: TripKeyInDB.pickupDate.rawValue)
        self.pickupTimeStart = try? unboxer.unbox(key: TripKeyInDB.pickupTimeStart.rawValue)
        self.pickupTimeEnd  = try?  unboxer.unbox(key: TripKeyInDB.pickupTimeEnd.rawValue)
    }
    
    func setupByDictionaryFromDB(_ json: [String:Any]){
        self.id             = json[TripKeyInDB.id.rawValue] as? String ?? ""
        self.tripCode       = json[TripKeyInDB.tripCode.rawValue] as? String ?? ""
        self.carrierId      = json[TripKeyInDB.carrierId.rawValue] as? String ?? ""
        self.transportation = json[TripKeyInDB.transportation.rawValue] as? Transportation ?? .trunk
        
        self.totalLength = json[TripKeyInDB.totalLength.rawValue] as? Double ?? 0.0
        self.totalWidth  = json[TripKeyInDB.totalWidth.rawValue]  as? Double ?? 0.0
        self.totalWeight = json[TripKeyInDB.totalWeight.rawValue] as? Double ?? 0.0
        self.totalHeight = json[TripKeyInDB.totalHeight.rawValue] as? Double ?? 0.0
        self.eta         = json[TripKeyInDB.eta.rawValue] as? Double
        
        self.startAddressId = json[TripKeyInDB.startAddressId.rawValue] as? String ?? ""
        self.endAddressId   = json[TripKeyInDB.endAddressId.rawValue] as? String ?? ""

        self.statusId        = json[TripKeyInDB.statusId.rawValue] as? Int ?? RequestStatus.waiting.rawValue
        self.pickupDate     = json[TripKeyInDB.pickupDate.rawValue] as? Double
        self.pickupTimeStart = json[TripKeyInDB.pickupTimeStart.rawValue] as? Double
        self.pickupTimeEnd  = json[TripKeyInDB.pickupTimeEnd.rawValue] as? Double
    }
    
    func packAsDictionaryForDB() -> [String: Any] {
        var json = [String: Any]()
        
        json[TripKeyInDB.id.rawValue] = id
        json[TripKeyInDB.tripCode.rawValue] = tripCode
        json[TripKeyInDB.transportation.rawValue] = transportation.rawValue
        
        json[TripKeyInDB.totalLength.rawValue] = totalLength
        json[TripKeyInDB.totalWidth.rawValue]  = totalWidth
        json[TripKeyInDB.totalWeight.rawValue] = totalWeight
        json[TripKeyInDB.totalHeight.rawValue] = totalHeight
        json[TripKeyInDB.eta.rawValue] = Int(eta ?? 0)
        
        json[TripKeyInDB.startAddressId.rawValue] = startAddressId
        json[TripKeyInDB.endAddressId.rawValue]   = endAddressId
        
        json[TripKeyInDB.statusId.rawValue] = statusId
        
        json[TripKeyInDB.pickupDate.rawValue] = Int(pickupDate ?? 0)
        json[TripKeyInDB.pickupTimeStart.rawValue] = Int(pickupTimeStart ?? 0)
        json[TripKeyInDB.pickupTimeEnd.rawValue] = Int(pickupTimeEnd ?? 0)
        
        return json
    }
    
    func packAsPostData() -> [String: Any] {
        
        var json = [String: Any]()
        json[TripKeyInDB.transportation.rawValue] = transportation.rawValue
        
        json[TripKeyInDB.totalLength.rawValue] = totalLength
        json[TripKeyInDB.totalWidth.rawValue]  = totalWidth
        json[TripKeyInDB.totalWeight.rawValue] = totalWeight
        json[TripKeyInDB.totalHeight.rawValue] = totalHeight
        json[TripKeyInDB.eta.rawValue] = Int(eta ?? 0)
        
        json[TripKeyInDB.startAddressId.rawValue] = startAddressId
        json[TripKeyInDB.endAddressId.rawValue]   = endAddressId
        
        json[TripKeyInDB.statusId.rawValue] = statusId
        
        json[TripKeyInDB.pickupDate.rawValue]       = Int(pickupDate ?? 0)
        json[TripKeyInDB.pickupTimeStart.rawValue]  = Int(pickupTimeStart ?? 0)
        json[TripKeyInDB.pickupTimeEnd.rawValue]    = Int(pickupTimeEnd ?? 0)
        
        return json
    }
    
    func getStartAddress() -> Address {
        print("TODO: get start address by id from DB")
        return Address()
    }
    
    func getEndAddress() -> Address {
        print("TODO: get end address by id from DB")
        return Address()
    }

    
}





