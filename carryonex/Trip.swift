//
//  Trip.swift
//  carryonex
//
//  Created by Xin Zou on 8/9/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import MapKit


enum Transportation : String {
    case airplane = "Airplane"
    case bus = "Bus"
    case car = "Car"
}


class Trip : NSObject {
    
    var id: String?
    var travelerId: String?
    var transportation: Transportation = .car
    var flightInfo: String?
    
    var startAddressId: String?
    var endAddressId: String?
    
    var startLocation: CLLocationCoordinate2D?
    var endLocation: CLLocationCoordinate2D?
    
    var status: RequestStatus = RequestStatus.waiting
    var startTime: Date?
    var pickupTimeStart: Date?
    var pickupTimeEnd: Date?
    
    enum PropInDB : String {
        case id = "id"
        case travelerId = "carrier_id"
        //case transportation = "" add this!
        //case flightInfo = "" add this???
        
        case startAddressId = "start_address_id"
        case endAddressId = "end_address_id"
        
        case status = "status_id"
        //case startTime = ""
        case pickupTimeStart = "pickup_start_time"
        case pickupTimeEnd = "pickup_end_time"
    }
    
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
        self.endLocation = CLLocationCoordinate2DMake(40.785091, -73.968285)
        
        self.status = RequestStatus.waiting
        self.startTime = Date()
        self.pickupTimeStart = Date()
        self.pickupTimeEnd = Date()
        
    }
    
    init(id:String, travelerId:String, transportation:Transportation, startAddress strAdd:String, endAddress endAdd: String, startLoc: CLLocationCoordinate2D?, endLoc: CLLocationCoordinate2D?, startTime srTi:Date, pickupTimeStart pkTiS:Date, pickupTimeEnd pkTiE: Date){
        self.id = id
        self.travelerId = travelerId
        self.transportation = transportation
        
        self.startAddressId = strAdd
        self.endAddressId = endAdd
        
        self.startLocation = startLoc
        self.endLocation = endLoc
        
        self.startTime = srTi
        self.pickupTimeStart = pkTiS
        self.pickupTimeEnd = pkTiE
    }
    
    func setupByDictionaryFromDB(_ json: [String:Any]){
        self.id             = json[PropInDB.id.rawValue] as? String ?? ""
        self.travelerId     = json[PropInDB.travelerId.rawValue] as? String ?? ""
        //        self.transportation = json[PropInDB.transportation.rawValue] as? String ?? ""
        self.startAddressId = json[PropInDB.startAddressId.rawValue] as? String ?? ""
        self.endAddressId   = json[PropInDB.endAddressId.rawValue] as? String ?? ""
        //        self.startLocation  = json[PropInDB.startLocation.rawValue] as? String ?? "" //(40.785091, -73.968285) Central Park, New York
        //        self.endLocation    = json[PropInDB.endLocation.rawValue] as? String ?? ""
        //        self.startTime      = json[PropInDB.startTime.rawValue] as? String ?? ""
        //        self.pickupTimeStart = json[PropInDB.pickupTimeStart.rawValue] as? String ?? ""
        //        self.pickupTimeEnd  = json[PropInDB.pickupTimeEnd.rawValue] as? String ?? ""
    }
    
    
}



