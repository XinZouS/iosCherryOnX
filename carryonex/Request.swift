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
    case numberOfItem = "name"
    case youxiangId = "youxiang_id"
    case statusId = "status_id"
    
    case departureAddressId = "start_address_id"
    case destinationAddressId = "end_address_id"
    
    case length = "length"
    case width = "width"
    case height = "height" // volum = l * w * h
    case weight = "weight"
    case imageUrls = "image_urls"
    
    //case sendingTimes = "" // date: [start, end, start, end, ...]
    //case expectDeliveryTime = "request_eta"
    //case realDeliveryTime = "" in trip, with
    
    case cost = ""
    
    case owner = "owner_id" // sender id
    //case shipper = "" // carrier id, will get from tripId;
    case tripId = "trip_id"
    case startShippingTimeStamp = "TODO:std"
    case endShippingTimeStamp = "TODO:etd"
}


class Request: NSObject, Unboxable {
    
    var id:         String?
    var numberOfItem: [String : Int] = [:] // [ItemIdEnum : num]
    
    var youxiangId: String?
    var statusId: Int = RequestStatus.waiting.rawValue
    
    var departureAddressId: String?
    var departureAddress:   Address? // change to Address ID when uploading to server
    var destinationAddressId: String?
    var destinationAddress: Address? // change to Address ID when uploading to server
    
    var length: Int = 0
    var width : Int = 0
    var height: Int = 0 // volum = l * w * h
    var weight: Double = 0.0
    var imageUrls = [String]()
    
    var cost: Double = 0.0
    
    var owner : String? // sender id
    var tripId: String?
    var startShippingTimeStamp: Double?
    var endShippingTimeStamp:   Double?
    
    
    
    override init(){
        super.init()
        
    }
    
    required init(unboxer: Unboxer) {
        self.id = try? unboxer.unbox(key: RequestKeyInDB.id.rawValue)
        self.numberOfItem = [:] // [ItemIdEnum : num]
        
        self.youxiangId = try? unboxer.unbox(key: RequestKeyInDB.youxiangId.rawValue)
        self.statusId = (try? unboxer.unbox(key: RequestKeyInDB.statusId.rawValue)) ?? RequestStatus.waiting.rawValue
        
        self.departureAddressId = try? unboxer.unbox(key: RequestKeyInDB.departureAddressId.rawValue)
        self.departureAddress   = nil // change to Address ID when uploading to server
        self.destinationAddressId = try? unboxer.unbox(key: RequestKeyInDB.destinationAddressId.rawValue)
        self.destinationAddress = nil // change to Address ID when uploading to server
        
        self.length = (try? unboxer.unbox(key: RequestKeyInDB.length.rawValue)) ?? 0
        self.width = (try? unboxer.unbox(key: RequestKeyInDB.width.rawValue)) ?? 0
        self.height = (try? unboxer.unbox(key: RequestKeyInDB.height.rawValue)) ?? 0
        self.weight = (try? unboxer.unbox(key: RequestKeyInDB.weight.rawValue)) ?? 0
        self.imageUrls = (try? unboxer.unbox(key: RequestKeyInDB.imageUrls.rawValue)) ?? []
        
        self.cost = 0.0 //try? unboxer.unbox(key: RequestKeyInDB.cost.rawValue)
        
        self.owner = try? unboxer.unbox(key: RequestKeyInDB.owner.rawValue)
        self.tripId = try? unboxer.unbox(key: RequestKeyInDB.tripId.rawValue)
        self.startShippingTimeStamp = Date().timeIntervalSinceNow //try? unboxer.unbox(key: RequestKeyInDB.youxiangId.rawValue)
        self.endShippingTimeStamp = Date().timeIntervalSinceNow //try? unboxer.unbox(key: RequestKeyInDB.youxiangId.rawValue)
    }
    
    
    
    static func fakeRequestDemo() -> Request {
        let add1 = Address(country: Country.UnitedStates, state: "NY", city: "New York", detailAddress: "424 Broadway", zipCode: "10013", recipient: "carryonex", phoneNum: "8886668888")
        let add2 = Address(country: Country.China, state: "北京", city: "北京", detailAddress: "三里屯胡同88号", zipCode: "100006", recipient: "马云", phoneNum: "13866668888")
        let r = Request()
        r.id = "requestID666"
        r.numberOfItem = ["Mail":3, "Electronics":1]
        r.youxiangId = "123"
        r.statusId = RequestStatus.waiting.rawValue
        
        r.departureAddress = add1
        r.destinationAddress = add2
        r.length = 2
        r.width = 3
        r.height = 4
        r.weight = 3.6
        r.imageUrls = []
        
        r.cost = 88.8
        
        r.owner = "123"
        r.tripId = "888"
        r.startShippingTimeStamp = Date().timeIntervalSince1970
        r.endShippingTimeStamp = Date().timeIntervalSince1970
        
        return r
    }
    
    func setupByDictionaryFromDB(_ json: [String:Any]){
        id = json[RequestKeyInDB.id.rawValue] as? String ?? ""
        numberOfItem = json[RequestKeyInDB.numberOfItem.rawValue] as? [String:Int] ?? [:]
        youxiangId = json[RequestKeyInDB.youxiangId.rawValue] as? String ?? ""
        statusId = json[RequestKeyInDB.statusId.rawValue] as? Int ?? 0
        departureAddressId = json[RequestKeyInDB.departureAddressId.rawValue] as? String ?? ""
        destinationAddressId = json[RequestKeyInDB.destinationAddressId.rawValue] as? String ?? ""
        length = json[RequestKeyInDB.length.rawValue] as? Int ?? 0
        width = json[RequestKeyInDB.weight.rawValue] as? Int ?? 0
        height = json[RequestKeyInDB.height.rawValue] as? Int ?? 0
        weight = json[RequestKeyInDB.weight.rawValue] as? Double ?? 0.0
        //imageUrls = json[RequestKeyInDB.imageUrls.rawValue] as? [String] ?? []
        //cost = json[RequestKeyInDB.cost.rawValue] as? Float ?? 0
        owner = json[RequestKeyInDB.owner.rawValue] as? String ?? ""
        //shipper = json[RequestKeyInDB.shipper.rawValue] as? String ?? ""
        tripId = json[RequestKeyInDB.tripId.rawValue] as? String ?? ""
        //startShippingTimeStamp = json[RequestKeyInDB.startShippingTimeStamp.rawValue] as? Date
        //endShippingTimeStamp = json[RequestKeyInDB.endShippingTimeStamp.rawValue] as? Date
    }

    
    func printAll(){
        print("-------------")
        print("Current Request : ")
        print("id = ", id ?? "")
        print("numberOfItem = ", numberOfItem)
        print("youxiangId = ", youxiangId ?? "")
        print("statusId = ", statusId)
        print("departure address = ", departureAddress ?? "")
        print("destination address = ", destinationAddress ?? "")
        print("length = \(length), width = \(width), height = \(height)")
        print("weight = \(weight)")
        print("imageUrls = \(imageUrls)")

        print("cost = $ ", cost)
        
        print("owner = ", owner ?? "")
        print("tripId = \(tripId ?? "")")
        print("startShippingTimeStamp = ", startShippingTimeStamp ?? "")
        print("endShippingTimeStamp = ", endShippingTimeStamp ?? "")
        print(" ---------- ")
    }
    

    
}






