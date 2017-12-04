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

enum TripActive : Int, UnboxableEnum {
    case inactive = 0
    case active   = 1
    case notExist = 2
    case error    = 4 // 404 err
}


enum TripKeyInDB : String {
    case id             = "id"
    case tripCode       = "trip_code"
    case username       = "username"
    case transportation = "transportation"
    
    case startAddress   = "start_address"
    case endAddress     = "end_address"
    
    case statusId       = "status_id"
    case pickupDate     = "pickup_date"
    case pickupTimeStart = "pickup_start_time"
    case pickupTimeEnd  = "pickup_end_time"
    case timestamp      = "timestamp"
    
    case note   = "note"
    case tripId = "trip_id"
    case active = "active"

    case carrierId        = "carrier_id"
    case carrierUsername  = "carrier_username"
    case createdTimestamp = "created_timestamp"
    case carrierRealName  = "carrier_real_name"
    case carrierRating    = "carrier_rating"
    case carrierPhone     = "carrier_phone"
    case carrierImageUrl  = "carrier_image"
}

class Trip : NSObject, Unboxable, Identifiable {
    
    var id: Int = 0
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
    var timestamp: Int = -1
    var note: String?
    
    private var monthString: String?
    private var dayString: String?
    private var dateString: String?
    
    var carrierId: Int?
    var carrierUsername: String?
    var createdTimestamp: Int = Date.getTimestampNow()
    var active = TripActive.active
    var carrierRealName: String?
    var carrierRating: Double?
    var carrierPhone: String?
    var carrierImageUrl: String?
    
    
    override init() {
        super.init()
        
        self.tripCode = "tripCode"
        self.transportation = .trunk
        self.startAddress = Address()
        self.endAddress = Address()
        self.pickupDate = Date().timeIntervalSince1970
        self.pickupTimeStart = Date().timeIntervalSince1970
        self.pickupTimeEnd = Date().timeIntervalSince1970
    }
    
    required init(unboxer: Unboxer) {
        self.id = (try? unboxer.unbox(key: TripKeyInDB.id.rawValue)) ?? 0
        self.tripCode = try? unboxer.unbox(key: TripKeyInDB.tripCode.rawValue)
        self.transportation = (try? unboxer.unbox(key: TripKeyInDB.transportation.rawValue)) ?? Transportation.trunk

        self.startAddress = try? unboxer.unbox(key: TripKeyInDB.startAddress.rawValue)
        self.endAddress = try? unboxer.unbox(key: TripKeyInDB.endAddress.rawValue)

        self.statusId = (try? unboxer.unbox(key: TripKeyInDB.statusId.rawValue)) ?? RequestStatus.waiting.rawValue
        self.pickupDate     = try? unboxer.unbox(key: TripKeyInDB.pickupDate.rawValue)
        self.pickupTimeStart = try? unboxer.unbox(key: TripKeyInDB.pickupTimeStart.rawValue)
        self.pickupTimeEnd  = try? unboxer.unbox(key: TripKeyInDB.pickupTimeEnd.rawValue)
        self.timestamp = (try? unboxer.unbox(key: TripKeyInDB.timestamp.rawValue)) ?? -1
        self.note = try? unboxer.unbox(key: TripKeyInDB.note.rawValue)
        
        self.carrierId = try? unboxer.unbox(key: TripKeyInDB.carrierId.rawValue)
        self.carrierUsername = try? unboxer.unbox(key: TripKeyInDB.carrierUsername.rawValue)
        self.createdTimestamp = (try? unboxer.unbox(key: TripKeyInDB.createdTimestamp.rawValue)) ?? -1
        self.active = (try? unboxer.unbox(key: TripKeyInDB.active.rawValue)) ?? TripActive.error
        self.carrierRealName = try? unboxer.unbox(key: TripKeyInDB.carrierRealName.rawValue)
        self.carrierRating = try? unboxer.unbox(key: TripKeyInDB.carrierRating.rawValue)
        self.carrierPhone = try? unboxer.unbox(key: TripKeyInDB.carrierPhone.rawValue)
        self.carrierImageUrl = try? unboxer.unbox(key: TripKeyInDB.carrierImageUrl.rawValue)
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
        json[TripKeyInDB.timestamp.rawValue] = timestamp
        json[TripKeyInDB.note.rawValue] = note ?? ""
        
        json[TripKeyInDB.carrierId.rawValue] = carrierId
        json[TripKeyInDB.carrierUsername.rawValue] = carrierUsername
        json[TripKeyInDB.createdTimestamp.rawValue] = createdTimestamp
        json[TripKeyInDB.active.rawValue] = active // TODO: what value should pass to DB??
        json[TripKeyInDB.carrierRealName.rawValue] = carrierRealName
        json[TripKeyInDB.carrierRating.rawValue] = carrierRating
        json[TripKeyInDB.carrierPhone.rawValue] = carrierPhone
        json[TripKeyInDB.carrierImageUrl.rawValue] = carrierImageUrl

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
    
    func getDayString() -> String {
        if let dayString = dayString {
            return dayString
        }
        
        let day = Date.getTimeString(format: "dd", time: TimeInterval(timestamp))
        dayString = day
        return day
    }
    
    func getMonthString() -> String {
        if let monthString = monthString {
            return monthString
        }
        
        let month = Date.getTimeString(format: "MMM", time: TimeInterval(timestamp)).uppercased()
        monthString = month
        return month
    }
    
    //MARK: - Date
    private func getDateString(time: TimeInterval) -> String {
        if let dateString = dateString {
            return dateString
        }
        let date = Date.getTimeString(format: "yyyy-MM-dd", time: time)
        dateString = date
        return date
    }
}
