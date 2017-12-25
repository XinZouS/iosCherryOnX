//
//  TripRequest.swift
//  carryonex
//
//  Created by Zian Chen on 11/14/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct TripRequest {
    var request: Request
}

extension TripRequest: Unboxable {
    init(unboxer: Unboxer) throws {
        self.request = try unboxer.unbox(key: "request")
    }
}

struct RequestImage {
    let id: String?
    let requestId: String?
    let imageUrl: String
    let thumbnailUrl: String?
}

extension RequestImage: Unboxable {
    init(unboxer: Unboxer) throws {
        id = try? unboxer.unbox(key: "id")
        requestId = try? unboxer.unbox(key: "request_id")
        imageUrl = try unboxer.unbox(key: "image_url")
        thumbnailUrl = try? unboxer.unbox(key: "thumbnail")
    }
}
