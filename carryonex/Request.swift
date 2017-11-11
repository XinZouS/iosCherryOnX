//
//  Request.swift
//  carryonex
//
//  Created by Xin Zou on 8/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Unbox

enum RequestStatus: Int {
    case waiting = 0
    case shipping = 1
    case finished = 2
    case canceled = 3
} 

enum RequestKeyInDB : String {
    case id = "id"
    case timestamp = "timestamp"
    case ownerId = "owner_id"
    case ownerUsername = "owner_username"
    case tripId = "trip_id"
    case endAddress = "end_address"
    case status = "status"
    case images = "images"
    case priceBySender = "price_by_sender"
    case totalValue = "total_value"
    case description = "description"
}

class Request: Unboxable {
    var id: Int?
    var ownerId: Int?
    var ownerUsername: String?
    var tripId: Int?
    var priceBySender: Int?
    var totalValue: Int?
    var description: String?
    
    var endAddress: Address?
    var images: [RequestImage]?
    var status: RequestStatusDetail?
    
    required init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: RequestKeyInDB.id.rawValue)
        self.ownerId = try? unboxer.unbox(key: RequestKeyInDB.ownerId.rawValue)
        self.ownerUsername = try? unboxer.unbox(key: RequestKeyInDB.ownerUsername.rawValue)
        self.tripId = try? unboxer.unbox(key: RequestKeyInDB.tripId.rawValue)
        self.priceBySender = try? unboxer.unbox(key: RequestKeyInDB.priceBySender.rawValue)
        self.totalValue = try? unboxer.unbox(key: RequestKeyInDB.totalValue.rawValue)
        self.description = try? unboxer.unbox(key: RequestKeyInDB.description.rawValue)
        
        self.endAddress = try? unboxer.unbox(key: RequestKeyInDB.endAddress.rawValue)
        self.images = try? unboxer.unbox(key: RequestKeyInDB.images.rawValue)
        self.status = try? unboxer.unbox(key: RequestKeyInDB.status.rawValue)
    }
    
    func printAllData() {
        let allData = """
        id = \(id ?? 0)
        totalValue = \(totalValue ?? 0)
        ownerId = \(ownerId ?? 0)
        ownerUsername = \(ownerUsername ?? "")
        tripId = \(tripId ?? 0),
        description = \(description ?? "")"
        """
        //endAddress = \(endAddress ?? "")
        //images = \(images ?? "")
        //status = \(status ?? "")
        print(allData)
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
