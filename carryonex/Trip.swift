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
    case airplane = "飞机" //"Airplane"
    case bus = "巴士" //"Bus"
    case car = "轿车" //"Car"
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
    
    var startTime: Date?
    var pickupTimeStart: Date?
    var pickupTimeEnd: Date?
    
    
    override init() {
        super.init()
        
        self.id = "id"
        self.travelerId = "travelerId"
        self.transportation = .airplane
        
        self.startAddressId = "startAddress"
        self.endAddressId = "endAddress"
        
        self.startLocation = CLLocationCoordinate2DMake(40.785091, -73.968285) // Central Park, New York
        self.endLocation = CLLocationCoordinate2DMake(40.785091, -73.968285)
        
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
    
    
}



