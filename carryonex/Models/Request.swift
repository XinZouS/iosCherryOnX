//
//  Request.swift
//  carryonex
//
//  Created by Xin Zou on 8/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Unbox

enum CommentStatus: Int {
    case NoComment = 0
    case CarrierCommented = 1
    case SenderCommented = 2
    case Completed = 3
}

class Request: Unboxable, Identifiable {
    var id: Int = 0
    var tripId: Int = -1
    var priceBySender: Int
    var totalValue: Int
    var description: String?
    var note: String?
    var startAddress: Address?
    var endAddress: Address?
    var statusId: Int?
    var commentStatus: Int
    
    var name: String?
    var timestamp: Int?
    var requestEta: Int?
    var priceStd: Int?
    var currency: String?
    var createdTimestamp: Int
    var images: [RequestImage] = []
    
    let ownerId: Int
    let ownerUsername: String
    let ownerRating: Double
    var ownerImageUrl: String?
    var ownerRealName: String?

    required init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: RequestKeyInDB.id.rawValue)
        self.ownerId = try unboxer.unbox(key: RequestKeyInDB.ownerId.rawValue)
        self.ownerUsername = try unboxer.unbox(key: RequestKeyInDB.ownerUsername.rawValue)
        self.tripId = try unboxer.unbox(key: RequestKeyInDB.tripId.rawValue)
        self.priceBySender = try unboxer.unbox(key: RequestKeyInDB.priceBySender.rawValue)
        self.totalValue = try unboxer.unbox(key: RequestKeyInDB.totalValue.rawValue)
        self.description = try? unboxer.unbox(key: RequestKeyInDB.description.rawValue)
        self.note = try? unboxer.unbox(key: RequestKeyInDB.note.rawValue)
        self.startAddress = try? unboxer.unbox(key: RequestKeyInDB.startAddress.rawValue)
        self.endAddress = try? unboxer.unbox(key: RequestKeyInDB.endAddress.rawValue)
        self.statusId = try? unboxer.unbox(keyPath: "status.id")
        
        self.name = try? unboxer.unbox(key: RequestKeyInDB.name.rawValue)
        self.requestEta = try? unboxer.unbox(key: RequestKeyInDB.requestEta.rawValue)
        self.priceStd = try? unboxer.unbox(key: RequestKeyInDB.priceStd.rawValue)
        self.currency = try? unboxer.unbox(key: RequestKeyInDB.currency.rawValue)
        self.createdTimestamp = try unboxer.unbox(key: RequestKeyInDB.createdTimestamp.rawValue)
        self.images = try unboxer.unbox(key: RequestKeyInDB.images.rawValue)
        self.commentStatus = try unboxer.unbox(key: RequestKeyInDB.commentStatus.rawValue)
        
        self.ownerRating = try! unboxer.unbox(key: RequestKeyInDB.ownerRating.rawValue)
        self.ownerImageUrl = try? unboxer.unbox(key: RequestKeyInDB.ownerImageUrl.rawValue)
        self.ownerRealName = try? unboxer.unbox(key: RequestKeyInDB.ownerRealName.rawValue)
    }
    
    func printAllData() {
        let allData = """
        id = \(id)
        totalValue = \(totalValue)
        price = \(priceBySender)
        ownerId = \(ownerId)
        ownerUsername = \(ownerUsername)
        tripId = \(tripId),
        description = \(description ?? "")"
        endAddress = \(endAddress?.descriptionString() ?? "")
        note = \(note ?? "")"
        """
        //images = \(images ?? "")
        //status = \(status ?? "")
        print(allData)
    }
    
    func priceString() -> String {
        return String(format:"%.2f", Double(priceBySender) / 100)
    }
    
    func itemValue() -> String {
        return String(format:"%.2f", Double(totalValue) / 100)
    }
    
    func statusString() -> String {
        if let statusId = statusId, let status = RequestStatus(rawValue: statusId) {
            return status.displayString()
        } else {
            return "错误状态"
        }
    }
    
    func status() -> RequestStatus {
        if let statusId = statusId, let status = RequestStatus(rawValue: statusId) {
            return status
        }
        return .invalid
    }
    
    func category() -> TripCategory? {
        guard let userId = ProfileManager.shared.getCurrentUser()?.id else {
            return nil
        }
        return (userId == ownerId) ? .sender : .carrier
    }
}

enum RequestKeyInDB : String {
    case id = "id"
    case timestamp = "timestamp"
    case ownerId = "owner_id"
    case ownerUsername = "owner_username"
    case tripId = "trip_id"
    case startAddress = "start_address"
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
    case name = "name"
    case requestEta = "request_eta"
    case priceStd = "price_std"
    case currency = "currency"
    case createdTimestamp = "created_timestamp"
    case commentStatus = "is_commented"
    
    //case items = [String]? TODO = do we still need this?? BUG: Expected element type
    case ownerRating = "owner_rating"
    case ownerImageUrl = "owner_image"
    case ownerRealName = "owner_real_name"
    
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
 0: 再次提醒
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
 [-1, -1, -1, -1, -1, -1,  7, -1, -1, -1, -1],  # 5 cs_payed
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
    case invalid = -2
    case badId = -1
    case initiate = 20
    case waiting = 21
    case rejected = 22
    case accepted = 23
    case cancelled = 24
    case paid = 25
    //case pendingRefund = 26
    case inDelivery = 27
    case delivered = 28
    case deliveryConfirmed = 29
//    case refundCompleted = 30
    
    func displayString() -> String {
        switch self {
        case .waiting:
            return "等待接受"
        case .rejected:
            return "已拒绝"
        case .accepted:
            return "等待付款"
        case .cancelled:
            return "已取消"
        case .paid:
            return "已付款"
        case .inDelivery:
            return "正在派送"
        case .delivered:
            return "已交付"
        case .deliveryConfirmed:
            return "已确认送达"
        case .invalid:
            return "状态无效"
        case .badId:
            return "错误单号"
        case .initiate:
            return "寄件创建"
        }
    }
    
    func prioritySortIndex(category: TripCategory) -> Int {
        if category == .carrier {
            switch self {
            case .waiting:
                return 2
            case .rejected:
                return -1
            case .accepted:
                return 1
            case .cancelled:
                return -1
            case .paid:
                return 2
            case .inDelivery:
                return 1
            case .delivered:
                return -1
            case .deliveryConfirmed:
                return 0
            case .invalid:
                return -2
            case .badId:
                return -2
            case .initiate:
                return -2
            }
            
        } else {
            switch self {
            case .waiting:
                return 1
            case .rejected:
                return 0
            case .accepted:
                return 2
            case .cancelled:
                return -1
            case .paid:
                return -1
            case .inDelivery:
                return 1
            case .delivered:
                return 2
            case .deliveryConfirmed:
                return 0
            case .invalid:
                return -1
            case .badId:
                return -1
            case .initiate:
                return -1
            }
        }
    }
    
    /*
     出行人
     High Priority = waiting, accepted,
     */
    
    func displayColor(category: TripCategory) -> UIColor {
        switch self {
        case .waiting:
            return category == .carrier ? UIColor.carryon_aciveStatus : UIColor.carryon_passiveStatus
        case .accepted:
            return category == .carrier ? UIColor.carryon_passiveStatus : UIColor.carryon_aciveStatus
        case .delivered:
            return category == .carrier ? UIColor.carryon_normalStatus : UIColor.carryon_aciveStatus
        case .paid, .inDelivery, .initiate, .deliveryConfirmed:  //.refundCompleted
            return UIColor.carryon_normalStatus
        case .rejected, .cancelled, .invalid, .badId:
            return UIColor.carryon_endedStatus
        }
    }
    
    func displayTextColor(category: TripCategory) -> UIColor {
        switch self {
        case .waiting:
            return category == .carrier ? UIColor.carryon_textActiveStatus : UIColor.carryon_textPassiveStatus
        case .accepted:
            return category == .carrier ? UIColor.carryon_textPassiveStatus : UIColor.carryon_textActiveStatus
        case .delivered:
            return category == .carrier ? UIColor.carryon_textNormalStatus : UIColor.carryon_textActiveStatus
        case .paid, .inDelivery, .initiate, .deliveryConfirmed:  //.refundCompleted
            return UIColor.carryon_textNormalStatus
        case .rejected, .cancelled, .invalid, .badId:
            return UIColor.carryon_textEndedStatus
        }
    }
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

 (sender) 状态:等待接受(1) -> 再次提醒(0) -> 状态:等待接受(1)
 (sender) 状态:等待接受(1) -> 取消订单(3) -> 状态:已取消(4)
 (sender) 状态:已接收，等待付款(3) -> 取消订单(3) -> 状态:已取消(4)
 (sender) 状态:已接收，等待付款(3) -> 付款(4) -> 状态:已付款(5)
 (sender) 状态:已付款(5) -> 退款(5) -> 状态:等待退款(6)
 (sender) 状态:完成派送(8) -> 确认送达(9) -> 状态:确认派送(9)
 */
enum RequestTransaction {
    case invalid
    case allowRating
    
    case carrierReject
    case carrierAccept
    case carrierCancel
    case carrierReceive
    case carrierDeliver
    case carrierShip
    
    case shipperPairing
    case shipperCancel
    case shipperPay
    case shipperConfirm
    
    func displayString() -> String {
        switch self {
        case .carrierReject:
            return "拒绝订单"
        case .carrierAccept:
            return "接受订单"
        case .carrierCancel:
            return "取消订单"
        case .carrierReceive:
            return "已揽件"
        case .carrierDeliver:
            return "当面交付"
        case .carrierShip:
            return "快递交付"
        case .shipperPairing:
            return "再次提醒"
        case .shipperCancel:
            return "取消订单"
        case .shipperPay:
            return "订单付款"
        case .shipperConfirm:
            return "确认收货"
        case .allowRating:
            return "给与评价"
        default:
            return "错误行动"
        }
    }
    
    func confirmDescString() -> String {
        switch self {
        case .carrierReject:
            return "确认拒绝订单？"
        case .carrierAccept:
            return "确认接受订单？"
        case .carrierCancel:
            return "确认取消订单？"
        case .carrierReceive:
            return "确认已揽件？"
        case .carrierDeliver:
            return "确认当面交付？"
        case .carrierShip:
            return "确认快递交付？"
        case .shipperPairing:
            return "确认再次提醒？"
        case .shipperCancel:
            return "确认取消订单？"
        case .shipperPay:
            return "确认订单付款？"
        case .shipperConfirm:
            return "确认收货？"
        case .allowRating:
            return "确认给与评价?"
        default:
            return "出现错误"
        }
    }
    
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
        case .shipperConfirm:
            return (status == .delivered)
        default:
            return false
        }
    }
}
