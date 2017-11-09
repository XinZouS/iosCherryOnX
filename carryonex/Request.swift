//
//  Request.swift
//  carryonex
//
//  Created by Xin Zou on 8/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import MapKit
import Unbox

enum RequestStatus: Int {
    case waiting = 0
    case shipping = 1
    case finished = 2
    case canceled = 3
} 

enum RequestKeyInDB : String {
    case id = "id"
    case name = "name"
    case length = "length"
    case width = "width"
    case height = "height"
    case weight = "weight"
    case pubDate =  "pub_date"
    case timestamp = "timestamp"
    case ownerId = "owner_id"
    case ownerUsername = "owner_username"
    case tripId = "trip_id"
    
    case startAddress = "start_address"
    case endAddress = "end_address"
    case items = "items"
    case status = "status"
    case images = "images"
}

class Request: Unboxable {
    var id: String?
    var name: String?
    var length: Int
    var width : Int
    var height: Int
    var weight: Double
    var cost: Double
    var ownerId: String?
    var ownerUsername: String?
    var tripId: String?
    
    var startAddress: Address?
    var endAddress: Address? // change to Address ID when uploading to server
    var items: [RequestCategoryItem]?
    var images: [RequestImage]?
    var status: RequestStatusDetail?
    
    required init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: RequestKeyInDB.id.rawValue)
        self.name = try? unboxer.unbox(key: RequestKeyInDB.name.rawValue)
        self.length = try unboxer.unbox(key: RequestKeyInDB.length.rawValue)
        self.width = try unboxer.unbox(key: RequestKeyInDB.width.rawValue)
        self.height = try unboxer.unbox(key: RequestKeyInDB.height.rawValue)
        self.weight = try unboxer.unbox(key: RequestKeyInDB.weight.rawValue)
        self.cost = 0.0
        
        self.ownerId = try? unboxer.unbox(key: RequestKeyInDB.ownerId.rawValue)
        self.ownerUsername = try? unboxer.unbox(key: RequestKeyInDB.ownerUsername.rawValue)
        self.tripId = try? unboxer.unbox(key: RequestKeyInDB.tripId.rawValue)
        
        self.startAddress = try? unboxer.unbox(key: RequestKeyInDB.startAddress.rawValue)
        self.endAddress = try? unboxer.unbox(key: RequestKeyInDB.endAddress.rawValue)
        self.items = try? unboxer.unbox(key: RequestKeyInDB.items.rawValue)
        self.images = try? unboxer.unbox(key: RequestKeyInDB.images.rawValue)
        self.status = try? unboxer.unbox(key: RequestKeyInDB.status.rawValue)
    }
}

struct RequestImage {
    let id: String?
    let requestId: String?
    let imageUrl: String?
}

extension RequestImage: Unboxable {
    init(unboxer: Unboxer) throws {
        id = try? unboxer.unbox(key: "id")
        requestId = try? unboxer.unbox(key: "request_id")
        imageUrl = try? unboxer.unbox(key: "image_url")
    }
}

struct RequestStatusDetail {
    let id: Int?
    let description: String?
}

extension RequestStatusDetail: Unboxable {
    init(unboxer: Unboxer) throws {
        id = try? unboxer.unbox(key: "id")
        description = try? unboxer.unbox(key: "description")
    }
}

struct RequestCategoryItem {
    let requestId: String?
    let category: ItemCategory?
    let itemAmount: Int
}

extension RequestCategoryItem: Unboxable {
    init(unboxer: Unboxer) throws {
        requestId = try? unboxer.unbox(key: "request_id")
        category = try? unboxer.unbox(key: "category")
        itemAmount = try unboxer.unbox(key: "item_amount")
    }
}
