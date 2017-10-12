//
//  Request.swift
//  carryonex
//
//  Created by Xin Zou on 8/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import MapKit


enum RequestStatus: String {
    case waiting = "waiting"
    case shipping = "shipping"
    case finished = "finished"
    case canceled = "canceled"
} 


class Request: NSObject {
    
    var id: String = ""
    var numberOfItem: [String : Int] = [:] // [ItemIdEnum : num]
    
    var youxiangId: String?
    var status : String = RequestStatus.waiting.rawValue
    
    var departureAddressId: String = ""
    var departureAddress : Address? // change to Address ID when uploading to server
    var destinationAddressId: String = ""
    var destinationAddress : Address? // change to Address ID when uploading to server
    
    var length: Int = 0
    var width : Int = 0
    var height: Int = 0 // volum = l * w * h
    var weight: Float = 0.0
    var imageUrls = [String]()
    
    var sendingTimes: [Date] = [] // date: [start, end, start, end, ...]
    var expectDeliveryTime: Date?
    var realDeliveryTime  : Date?
    
    var cost: Float = 0.0
    
    
    var owner : String? // sender id
    var shipper:String? // carrier id
    var tripId: String?
    var startShippingTimeStamp: Date?
    var endShippingTimeStamp: Date?
    
    enum PropInDB : String {
        case id = "id"
        case numberOfItem = "name"
        case youxiangId = ""
        case status = "status_id"
        
        case departureAddressId = "start_address_id"
        case destinationAddressId = "end_address_id"
        
        case length = "length"
        case width = "width"
        case height = "height" // volum = l * w * h
        case weight = "weight"
        //case imageUrls = ""
        
        //case sendingTimes = "" // date: [start, end, start, end, ...]
        case expectDeliveryTime = "request_eta"
        //case realDeliveryTime = "" in trip, with
        
        //case cost = ""
        
        case owner = "owner_id" // sender id
        //case shipper = "" // carrier id
        case tripId = "trip_id"
        //case startShippingTimeStamp = ""
        //case endShippingTimeStamp = ""
    }
    
    override init(){
        super.init()
        
    }
    
    func expectDeliveryTimeDescriptionString() -> String {
        let isCN: Bool = false //destinationAddress.country == Country.China
        let formatter = DateFormatter()
        formatter.dateFormat = isCN ? "yyyy-MM-dd" : "MM/dd/yyyy"
        
        return "\( formatter.string(from: expectDeliveryTime!) )"
    }
    
    
    
    
    static func fakeRequestDemo() -> Request {
        let add1 = Address(country: Country.UnitedStates, state: "NY", city: "New York", detailAddress: "424 Broadway", zipCode: "10013", recipient: "carryonex", phoneNum: "8886668888")
        let add2 = Address(country: Country.China, state: "北京", city: "北京", detailAddress: "三里屯胡同88号", zipCode: "100006", recipient: "马云", phoneNum: "13866668888")
        let r = Request()
        r.id = "requestID666"
        r.numberOfItem = ["Mail":3, "Electronics":1]
        r.youxiangId = "123"
        r.status = RequestStatus.waiting.rawValue
        
        r.departureAddress = add1
        r.destinationAddress = add2
        r.length = 2
        r.width = 3
        r.height = 4
        r.weight = 3.6
        r.imageUrls = []
        
        r.sendingTimes = [Date()]
        r.expectDeliveryTime = Date(timeIntervalSinceNow: 3 * 86400) // 3 days later
        r.realDeliveryTime = Date(timeIntervalSinceNow: 3 * 86406) // 3 days later
        
        r.cost = 88.8
        
        r.owner = "123"
        r.tripId = "888"
        r.startShippingTimeStamp = Date(timeIntervalSinceNow: 1)
        r.endShippingTimeStamp = Date(timeIntervalSinceNow: 86406)
        
        return r
    }
    
    func setupByDictionaryFromDB(_ json: [String:Any]){
        id = json[PropInDB.id.rawValue] as? String ?? ""
        numberOfItem = json[PropInDB.numberOfItem.rawValue] as? [String:Int] ?? [:]
        youxiangId = json[PropInDB.youxiangId.rawValue] as? String ?? ""
        status = json[PropInDB.status.rawValue] as? String ?? ""
        departureAddressId = json[PropInDB.departureAddressId.rawValue] as? String ?? ""
        destinationAddressId = json[PropInDB.destinationAddressId.rawValue] as? String ?? ""
        length = json[PropInDB.length.rawValue] as? Int ?? 0
        width = json[PropInDB.weight.rawValue] as? Int ?? 0
        height = json[PropInDB.height.rawValue] as? Int ?? 0
        weight = json[PropInDB.weight.rawValue] as? Float ?? 0
        //imageUrls = json[PropInDB.imageUrls.rawValue] as? [String] ?? []
        //sendingTimes = json[PropInDB.sendingTimes.rawValue] as? [Date] ?? []
        expectDeliveryTime = json[PropInDB.expectDeliveryTime.rawValue] as? Date
        //cost = json[PropInDB.cost.rawValue] as? Float ?? 0
        owner = json[PropInDB.owner.rawValue] as? String ?? ""
        //shipper = json[PropInDB.shipper.rawValue] as? String ?? ""
        tripId = json[PropInDB.tripId.rawValue] as? String ?? ""
        //startShippingTimeStamp = json[PropInDB.startShippingTimeStamp.rawValue] as? Date
        //endShippingTimeStamp = json[PropInDB.endShippingTimeStamp.rawValue] as? Date
    }

    
    func printAll(){
        print("-------------")
        print("Current Request : ")
        print("id = ", id)
        print("numberOfItem = ", numberOfItem)
        print("youxiangId = ", youxiangId)
        print("status = ", status)
        print("departure address = ", departureAddress)
        print("destination address = ", destinationAddress)
        print("length = \(length), width = \(width), height = \(height)")
        print("weight = \(weight)")
        print("imageUrls = \(imageUrls)")
        print("sendingTimes = ", sendingTimes)
        print("expectDeliveryTime = ", expectDeliveryTime)
        print("realdeliverytime = ", realDeliveryTime)
        print("cost = $ ", cost)
        
        print("owner = ", owner)
        print("shipper = ", shipper)
        print("tripId = \(tripId)")
        print("startShippingTimeStamp = ", startShippingTimeStamp)
        print("endShippingTimeStamp = ", endShippingTimeStamp)
        print(" ---------- ")
    }
    

    
}






