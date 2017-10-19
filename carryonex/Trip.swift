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
    case airplane = "Airplane"
    case bus = "Bus"
    case car = "Car"
}

enum TripKeyInDB : String {
    case id             = "id"
    case travelerId     = "carrier_id"
    //case transportation = "" add this!
    //case flightInfo = "" add this???
    
    case startAddressId = "start_address_id"
    case endAddressId   = "end_address_id"
    
    case status         = "status_id"
    //case startTime = ""
    case pickupTimeStart = "pickup_start_time"
    case pickupTimeEnd  = "pickup_end_time"
}


class Trip : NSObject, Unboxable {
    
    var id:         String?
    var travelerId: String?
    var transportation: Transportation = .car
    var flightInfo: String?
    
    var startAddressId: String?
    var endAddressId:   String?
    
    // location is NOT for DB, bcz address contains these propertities
    var startLocation: CLLocationCoordinate2D?
    var endLocation  : CLLocationCoordinate2D?
    
    var status: RequestStatus = RequestStatus.waiting
    var startTime:       Double?
    var pickupTimeStart: Double?
    var pickupTimeEnd:   Double?
    
    let transportationCN : [String:String] = [
        Transportation.airplane.rawValue : "飞机", //"Airplane"
        Transportation.bus.rawValue : "巴士", //"Bus"
        Transportation.car.rawValue : "轿车" //"Car"
    ]
    
    override init() {
        super.init()
        
        self.id = "id"
        self.travelerId = "travelerId"
        self.transportation = .airplane
        
        self.startAddressId = "startAddress"
        self.endAddressId = "endAddress"
        
        self.startLocation = CLLocationCoordinate2DMake(40.785091, -73.968285) // Central Park, New York
        self.endLocation = CLLocationCoordinate2DMake(40.785091, -73.968285) // Central Park, New York
        
        self.status = RequestStatus.waiting
        self.startTime =        Date().timeIntervalSince1970
        self.pickupTimeStart =  Date().timeIntervalSince1970
        self.pickupTimeEnd =    Date().timeIntervalSince1970
        
    }
    
    required init(unboxer: Unboxer) {
        self.id             = try? unboxer.unbox(key: TripKeyInDB.id.rawValue)
        self.travelerId     = try? unboxer.unbox(key: TripKeyInDB.travelerId.rawValue)
        //self.transportation = try? unboxer.unbox(key: TripKeyInDB..rawValue)
        
        self.startAddressId = try? unboxer.unbox(key: TripKeyInDB.id.rawValue)
        self.endAddressId   = try? unboxer.unbox(key: TripKeyInDB.id.rawValue)
        
        self.startLocation  = CLLocationCoordinate2DMake(40.785091, -73.968285) // Central Park, New York
        self.endLocation    = CLLocationCoordinate2DMake(40.785091, -73.968285) // Central Park, New York

        self.status         = (try? unboxer.unbox(key: TripKeyInDB.status.rawValue)) ?? RequestStatus.waiting
        self.startTime      = try?  unboxer.unbox(key: TripKeyInDB.id.rawValue)
        self.pickupTimeStart = try? unboxer.unbox(key: TripKeyInDB.id.rawValue)
        self.pickupTimeEnd  = try?  unboxer.unbox(key: TripKeyInDB.id.rawValue)
    }
    
    func setupByDictionaryFromDB(_ json: [String:Any]){
        self.id             = json[TripKeyInDB.id.rawValue] as? String ?? ""
        self.travelerId     = json[TripKeyInDB.travelerId.rawValue] as? String ?? ""
        //        self.transportation = json[TripKeyInDB.transportation.rawValue] as? String ?? ""
        self.startAddressId = json[TripKeyInDB.startAddressId.rawValue] as? String ?? ""
        self.endAddressId   = json[TripKeyInDB.endAddressId.rawValue] as? String ?? ""
        //        self.startLocation  = json[TripKeyInDB.startLocation.rawValue] as? String ?? "" //(40.785091, -73.968285) Central Park, New York
        //        self.endLocation    = json[TripKeyInDB.endLocation.rawValue] as? String ?? ""
        //        self.startTime      = json[TripKeyInDB.startTime.rawValue] as? String ?? ""
        //        self.pickupTimeStart = json[TripKeyInDB.pickupTimeStart.rawValue] as? String ?? ""
        //        self.pickupTimeEnd  = json[TripKeyInDB.pickupTimeEnd.rawValue] as? String ?? ""
    }
    
    
}





