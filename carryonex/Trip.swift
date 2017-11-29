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

enum TripActive {
    case active
    case inactive
    case notExist
    case error
}


enum TripKeyInDB : String {
    case id             = "id"
    case tripCode       = "trip_code"
    case username       = "username"
    case transportation = "transportation"
    
    case startAddress = "start_address"
    case endAddress   = "end_address"
    
    case statusId        = "status_id"
    case pickupDate     = "pickup_date"
    case pickupTimeStart = "pickup_start_time"
    case pickupTimeEnd  = "pickup_end_time"
    case timestamp = "timestamp"
    
    case note = "note"
    case tripId = "trip_id"
    case active = "active"
}


class Trip : NSObject, Unboxable {
    
    var id: Int?
    var tripCode: String?
    var transportation: Transportation = .trunk
    
    var totalLength: Double = 0.0
    var totalWidth:  Double = 0.0
    var totalWeight: Double = 0.0
    var totalHeight: Double = 0.0
    var eta: Double?
    
    var startAddress: Address?
    var endAddress: Address?

    // TODO: Break them up to long and lat
    var startLocation: CLLocationCoordinate2D?
    var endLocation  : CLLocationCoordinate2D?
    
    var statusId: Int = RequestStatus.waiting.rawValue
    var pickupDate:      Double? // travel starts
    var pickupTimeStart: Double?
    var pickupTimeEnd:   Double?
    var timestamp: Int?
    var note: String?
    
    override init() {
        super.init()
        
        self.id = 0
        self.tripCode = "tripCode"
        self.transportation = .trunk
        
        self.startAddress = Address()
        self.endAddress = Address()
        
        self.statusId = RequestStatus.waiting.rawValue
        self.pickupDate = Date().timeIntervalSince1970
        self.pickupTimeStart = Date().timeIntervalSince1970
        self.pickupTimeEnd = Date().timeIntervalSince1970
        
        self.timestamp = 0
    }
    
    required init(unboxer: Unboxer) {
        self.id = try? unboxer.unbox(key: TripKeyInDB.id.rawValue)
        self.tripCode = try? unboxer.unbox(key: TripKeyInDB.tripCode.rawValue)
        self.transportation = (try? unboxer.unbox(key: TripKeyInDB.transportation.rawValue)) ?? Transportation.trunk

        self.startAddress = try? unboxer.unbox(key: TripKeyInDB.startAddress.rawValue)
        self.endAddress = try? unboxer.unbox(key: TripKeyInDB.endAddress.rawValue)

        self.statusId = (try? unboxer.unbox(key: TripKeyInDB.statusId.rawValue)) ?? RequestStatus.waiting.rawValue
        
        self.pickupDate     = try? unboxer.unbox(key: TripKeyInDB.pickupDate.rawValue)
        self.pickupTimeStart = try? unboxer.unbox(key: TripKeyInDB.pickupTimeStart.rawValue)
        self.pickupTimeEnd  = try? unboxer.unbox(key: TripKeyInDB.pickupTimeEnd.rawValue)
        
        self.note = try? unboxer.unbox(key: TripKeyInDB.note.rawValue)
        self.timestamp = try? unboxer.unbox(key: TripKeyInDB.timestamp.rawValue)
    }
    
    func packAsDictionaryForDB() -> [String: Any] {
        var json = [String: Any]()
        
        json[TripKeyInDB.id.rawValue] = id
        json[TripKeyInDB.tripCode.rawValue] = tripCode
        json[TripKeyInDB.transportation.rawValue] = transportation.rawValue
        
        json[TripKeyInDB.startAddress.rawValue] = startAddress?.packAsDictionaryForDB()
        json[TripKeyInDB.endAddress.rawValue] = endAddress?.packAsDictionaryForDB()
        
        json[TripKeyInDB.statusId.rawValue] = statusId
        
        json[TripKeyInDB.pickupDate.rawValue] = Int(pickupDate ?? 0)
        json[TripKeyInDB.pickupTimeStart.rawValue] = Int(pickupTimeStart ?? 0)
        json[TripKeyInDB.pickupTimeEnd.rawValue] = Int(pickupTimeEnd ?? 0)
        
        json[TripKeyInDB.note.rawValue] = note ?? ""
        json[TripKeyInDB.timestamp.rawValue] = timestamp ?? 0
        
        return json
    }
    
    func packAsPostData() -> [String: Any] {
        
        var json = [String: Any]()
        json[TripKeyInDB.transportation.rawValue] = transportation.rawValue
        
        json[TripKeyInDB.startAddress.rawValue] = startAddress?.packAsDictionaryForDB()
        json[TripKeyInDB.endAddress.rawValue] = endAddress?.packAsDictionaryForDB()
        
        json[TripKeyInDB.statusId.rawValue] = statusId
        
        json[TripKeyInDB.pickupDate.rawValue]       = Int(pickupDate ?? 0)
        json[TripKeyInDB.pickupTimeStart.rawValue]  = Int(pickupTimeStart ?? 0)
        json[TripKeyInDB.pickupTimeEnd.rawValue]    = Int(pickupTimeEnd ?? 0)
        
        json[TripKeyInDB.note.rawValue] = note ?? ""
        json[TripKeyInDB.timestamp.rawValue] = timestamp ?? 0
        
        return json
    }
    
    func getStartAddress() -> Address {
        return self.startAddress ?? Address()
    }
    
    func getEndAddress() -> Address {
        return self.endAddress ?? Address()
    }
    
    func getDeliveryDateString() -> String {
        guard let fromTime = pickupTimeStart else {
            return "No Flight Date"
        }
        return getDateString(time: fromTime)
    }
    
    //MARK: - Date
    private func getDateString(time: TimeInterval) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date(timeIntervalSince1970: time))
    }
    
    private func getThreeLetterMonth(time: TimeInterval) -> String {
        let dateFormatter = DateFormatter.init()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "MMM"
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: Date(timeIntervalSince1970: time))
    }
}
