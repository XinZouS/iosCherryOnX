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
}
    
struct HomeProfileInfo {
    let user: ProfileUser
    let tripCount: Int
    let rating: Float
    let requestCount: Int
}

extension HomeProfileInfo: Unboxable {
    init(unboxer: Unboxer) throws {
        self.user = try unboxer.unbox(key: HomeProfileKey.user.rawValue)
        self.tripCount = try unboxer.unbox(key: HomeProfileKey.tripCount.rawValue)
        self.rating = try unboxer.unbox(key: HomeProfileKey.rating.rawValue)
        self.requestCount = try unboxer.unbox(key: HomeProfileKey.requestCount.rawValue)
    }
}

