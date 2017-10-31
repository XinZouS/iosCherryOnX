//
//  TripOrder.swift
//  carryonex
//
//  Created by Zian Chen on 10/31/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Unbox

struct TripOrder {
    let trip: Trip
    let requests: [Request]?
}

extension TripOrder: Unboxable {
    init(unboxer: Unboxer) throws {
        self.trip = try unboxer.unbox(key: "trip")
        self.requests = try? unboxer.unbox(key: "requests")
    }
}

