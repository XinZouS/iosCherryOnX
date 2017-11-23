//
//  Request.swift
//  carryonex
//
//  Created by Xin Zou on 8/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Unbox

class Request: Unboxable {
    var id: Int?
    var ownerId: Int?
    var ownerUsername: String?
    var tripId: Int?
    var priceBySender: Int?
    var totalValue: Int?
    var description: String?
    var note: String?
    
    var endAddress: Address?
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
        self.status = try? unboxer.unbox(key: RequestKeyInDB.status.rawValue)
        self.note = try? unboxer.unbox(key: RequestKeyInDB.note.rawValue)
    }
    
    func printAllData() {
        let allData = """
        id = \(id ?? 0)
        totalValue = \(totalValue ?? 0)
        price = \(priceBySender ?? 0)
        ownerId = \(ownerId ?? 0)
        ownerUsername = \(ownerUsername ?? "")
        tripId = \(tripId ?? 0),
        description = \(description ?? "")"
        endAddress = \(endAddress?.descriptionString() ?? "")
        note = \(note ?? "")"
        """
        //images = \(images ?? "")
        //status = \(status ?? "")
        print(allData)
    }
    
    func priceString() -> String {
        guard let price = priceBySender else {
            return "No Price"
        }
        return String(format:"%.2f", Double(price) / 100)
    }
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
    case action = "action"
    case userType = "user_type"
    case note = "note"
    
    //update call
    case requestId = "request_id"
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


/*
 //SET UP ON SERVER
 '''
 状态 status
 0： 发送请求
 1： 等待接受
 2： 已拒绝
 3： 已接收，等待付款
 4： 已取消
 5： 已付款
 6： 等待退款
 7： 正在派送
 8： 完成派送
 9： 确认派送
 10： 已退款
 '''
 '''
 Actions:
 0: 请求匹配
 1: 拒绝匹配
 2: 接受匹配
 3: 取消订单
 4: 付款
 5: 退款
 6: 接受物品
 7: 当面交付
 8: 快递交付
 9: 确认送达
 '''
 
 # B 出行人 根据当前状态根据事件编号，查找转以后的状态 EventsForShipper[当前状态][事件编号] = 下一个状态
 EventsForShipper = [
 # 0   1   2   3   4   5   6   7   8   9   10
 [-1,  2,  3, -1, -1, -1, -1, -1, -1, -1, -1],  # 1 cs_wait_for_accept
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],  # 2 cs_rejected
 [-1, -1, -1,  4, -1, -1, -1, -1, -1, -1, -1],  # 3 cs_accepted
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],  # 4 cs_cancelled
 [-1, -1, -1, -1, -1,  6,  7, -1, -1, -1, -1],  # 5 cs_payed
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 10],  # 6 cs_wait_for_refunded
 [-1, -1, -1, -1, -1,  6, -1,  8,  8, -1, -1],  # 7 cs_in_delivery
 [-1, -1, -1, -1, -1, -1, -1,  8, -1, -1, -1],  # 8 cs_deliver_completed
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],  # 9 cs_deliver_confirmed
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1], # 10 cs_refund_completed //only be sent by carryonEx
 ]
 
 # A 寄件人 根据当前状态根据事件编号，查找转以后的状态 EventsForSender[当前状态][事件编号] = 下一个状态
 EventsForSender = [
 # 0   1   2   3   4   5   6   7   8   9   10
 [ 1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],  # 0 cs_init
 [-1, -1, -1,  4, -1, -1, -1, -1, -1, -1, -1],  # 1 cs_wait_for_accept
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],  # 2 cs_rejected
 [-1, -1, -1,  4,  5, -1, -1, -1, -1, -1, -1],  # 3 cs_accepted
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],  # 4 cs_cancelled
 [-1, -1, -1, -1, -1,  6,  7, -1, -1, -1, -1],  # 5 cs_payed
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 10],  # 6 cs_wait_for_refunded
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],  # 7 cs_in_delivery
 [-1, -1, -1, -1, -1, -1, -1, -1, -1,  9, -1],  # 8 cs_deliver_completed
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],  # 9 cs_deliver_confirmed
 [-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],  # 10 cs_refund_completed //only be sent by carryonEx
 ]
 
 # user_type:
 #   0: carrier
 #   1: sender
 */

enum RequestStatus: Int {
    case badId = -1
    case initiate = 20
    case waiting = 21
    case rejected = 22
    case accepted = 23
    case cancelled = 24
    case paid = 25
    case pendingRefund = 26
    case inDelivery = 27
    case delivered = 28
    case deliveryConfirmed = 29
    case refundCompleted = 30
}

enum RequestAction: Int {
    case invalid = -1
    case pairing = 0
    case reject = 1
    case accept = 2
    case cancel = 3
    case pay = 4
    case refund = 5
    case receive = 6
    case deliver = 7
    case ship = 8
    case confirm = 9
}

/*
 (carrier) 状态:等待接受(1) -> 拒绝匹配(1) -> 状态:已拒绝(2)
 (carrier) 状态:等待接受(1) -> 接受匹配(2) -> 状态:已接收，等待付款(3)
 (carrier) 状态:已接收，等待付款(3) -> 取消订单(3) -> 状态:已取消(4)
 (carrier) 状态:已付款(5) -> 退款(5) -> 状态:等待退款(6)
 (carrier) 状态:正在派送(7) -> 退款(5) -> 状态:等待退款(6)
 (carrier) 状态:已付款(5) -> 接受物品(6) -> 状态:正在派送(7)
 (carrier) 状态:正在派送(7) -> 当面交付(7) -> 状态:完成派送(8)
 (carrier) 状态:完成派送(8) -> 当面交付(7) -> 状态:完成派送(8)
 (carrier) 状态:正在派送(7) -> 快递交付(8) -> 状态:完成派送(8)

 (sender) 状态:等待接受(1) -> 请求匹配(0) -> 状态:等待接受(1)
 (sender) 状态:等待接受(1) -> 取消订单(3) -> 状态:已取消(4)
 (sender) 状态:已接收，等待付款(3) -> 取消订单(3) -> 状态:已取消(4)
 (sender) 状态:已接收，等待付款(3) -> 付款(4) -> 状态:已付款(5)
 (sender) 状态:已付款(5) -> 退款(5) -> 状态:等待退款(6)
 (sender) 状态:完成派送(8) -> 确认送达(9) -> 状态:确认派送(9)
 */
enum RequestTransaction {
    case invalid
    
    case carrierReject
    case carrierAccept
    case carrierCancel
    case carrierRefund
    case carrierReceive
    case carrierDeliver
    case carrierShip
    
    case shipperPairing
    case shipperCancel
    case shipperPay
    case shipperRefund
    case shipperConfirm
    
    func validatedTransaction(for status: RequestStatus) -> (RequestAction, TripCategory) {
        if !isValid(for: status) {
            debugPrint("Invalid Combo: Status - \(status) and Action \(self)")
            return (.invalid, .carrier)
        }
        return transaction()
    }
    
    func transaction() -> (RequestAction, TripCategory) {
        switch self {
        case .carrierReject:
            return (.reject, .carrier)
        case .carrierAccept:
            return (.accept, .carrier)
        case .carrierCancel:
            return (.cancel, .carrier)
        case .carrierRefund:
            return (.refund, .carrier)
        case .carrierReceive:
            return (.receive, .carrier)
        case .carrierDeliver:
            return (.deliver, .carrier)
        case .carrierShip:
            return (.ship, .carrier)
        case .shipperPairing:
            return (.pairing, .sender)
        case .shipperCancel:
            return (.cancel, .sender)
        case .shipperPay:
            return (.pay, .sender)
        case .shipperRefund:
            return (.refund, .sender)
        case .shipperConfirm:
            return (.confirm, .sender)
        default:
            return (.invalid, .carrier) //.carrier here is just a filler
        }
    }
    
    func isValid(for status: RequestStatus) -> Bool {
        switch self {
        case .carrierReject:
            return (status == .waiting)
        case .carrierAccept:
            return (status == .waiting)
        case .carrierCancel:
            return (status == .accepted)
        case .carrierRefund:
            return (status == .paid || status == .inDelivery)
        case .carrierReceive:
            return (status == .paid)
        case .carrierDeliver:
            return (status == .inDelivery || status == .delivered)
        case .carrierShip:
            return (status == .inDelivery)
        case .shipperPairing:
            return (status == .initiate || status == .waiting)
        case .shipperCancel:
            return (status == .waiting || status == .accepted)
        case .shipperPay:
            return (status == .accepted)
        case .shipperRefund:
            return (status == .paid)
        case .shipperConfirm:
            return (status == .delivered)
        default:
            return false
        }
    }
}
