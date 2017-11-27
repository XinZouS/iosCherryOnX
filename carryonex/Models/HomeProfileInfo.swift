//
//  HomeProfileInfo.swift
//  carryonex
//
//  Created by Chen, Zian on 11/27/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Unbox

enum HomeProfileKey: String {
    case user = "user"
    case tripCount = "trip_count"
    case rating = "rating"
    case requestCount = "request_count"
    case request = "request"
    case trip = "trip"
}
    
struct HomeProfileInfo {
    let user: ProfileUser
    let tripCount: Int
    let rating: Int
    let requestCount: Int
    let request: HomeOrderCardInfo
    let trip: HomeOrderCardInfo
}

extension HomeProfileInfo: Unboxable {
    init(unboxer: Unboxer) throws {
        self.user = try unboxer.unbox(key: HomeProfileKey.user.rawValue)
        self.tripCount = try unboxer.unbox(key: HomeProfileKey.tripCount.rawValue)
        self.rating = try unboxer.unbox(key: HomeProfileKey.rating.rawValue)
        self.requestCount = try unboxer.unbox(key: HomeProfileKey.requestCount.rawValue)
        self.request = try unboxer.unbox(key: HomeProfileKey.request.rawValue)
        self.trip = try unboxer.unbox(key: HomeProfileKey.trip.rawValue)
    }
}


struct HomeOrderCardInfo {
    var id: Int
    var timestamp: Int
    var image: String
    var startAddress: Address
    var endAddress: Address
    var statusId: Int
}

extension HomeOrderCardInfo: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.timestamp = try unboxer.unbox(key: "timestamp")
        self.image = try unboxer.unbox(key: "image")
        self.startAddress = try unboxer.unbox(key: "start_address")
        self.endAddress = try unboxer.unbox(key: "end_address")
        self.statusId = try unboxer.unbox(key: "status_id")
    }
}
