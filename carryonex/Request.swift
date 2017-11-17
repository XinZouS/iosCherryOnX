//
//  Request.swift
//  carryonex
//
//  Created by Xin Zou on 8/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Unbox

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
    case initiate = 0
    case waiting = 1
    case rejected = 2
    case accepted = 3
    case cancelled = 4
    case paid = 5
    case pendingRefund = 6
    case inDelivery = 7
    case delivered = 8
    case deliveryConfirmed = 9
    case refundCompleted = 10
}

enum RequestAction: Int {
    case waitForAccept = 0
    case reject = 1
    case accept = 2
    case cancel = 3
    case pay = 4
    case refund = 5
    case received = 6
    case delivered = 7
    case shipped = 8
    case confirm = 9
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
