//
//  OrderListCell.swift
//  carryonex
//
//  Created by Zian Chen on 11/13/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderListCell: UITableViewCell {
    
    @IBOutlet var tripLabel: UILabel!
    @IBOutlet var ownerNameLabel: UILabel!
    @IBOutlet var endAddressLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var cellTypeLabel: UILabel!
    @IBOutlet var statusButton: UIButton!
    
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    
    weak var delegate: OrderListCellDelegate?
    var indexPath: NSIndexPath?
    
    var cellInfo: (TripCategory, Request?) = (.carrier, nil) {
        didSet {
            category = cellInfo.0
            request = cellInfo.1
        }
    }
    
    private var category: TripCategory = .carrier
    private var request: Request? {
        didSet {
            tripLabel.text = "\(request?.tripId ?? -999)"
            ownerNameLabel.text = request?.ownerUsername ?? "Unknown User"
            
            if let address = request?.endAddress {
                endAddressLabel.text = address.descriptionString()
            } else {
                endAddressLabel.text = "Bad address"
            }
            
            if let description = request?.description {
                descriptionLabel.text = description
            }
            
            if let price = request?.priceString() {
                priceLabel.text = price
            }
            
            //TODO: Update button
            statusButton.setTitle("更改状态", for: .normal)
            
            if let statusId = request?.statusId {
                statusLabel.text = "Status: \(statusId)"
            }
            
//            if let statusId = request?.status?.id, let newStatus = RequestStatus(rawValue: statusId) {
//                self.status = newStatus
//            }
        }
    }
    
    /*
     enum RequestStatus: Int {
     case invalid = -2
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
     
     
     (sender) 状态:等待接受(1) -> 请求匹配(0) -> 状态:等待接受(1)
     (sender) 状态:等待接受(1) -> 取消订单(3) -> 状态:已取消(4)
     (sender) 状态:已接收，等待付款(3) -> 取消订单(3) -> 状态:已取消(4)
     (sender) 状态:已接收，等待付款(3) -> 付款(4) -> 状态:已付款(5)
     (sender) 状态:已付款(5) -> 退款(5) -> 状态:等待退款(6)
     (sender) 状态:完成派送(8) -> 确认送达(9) -> 状态:确认派送(9)
     
     //Shipper
     1. 等待接受：请求匹配，取消订单
     3. 已接受：订单付款，取消订单
     5. 已付款：退款
     8. 完成派送：确认送达
     9. 已送达：给与评价
     
     下面的状态没有按钮
     2. 已拒绝
     4. 已取消
     6. 已退款
     10. 已退款
     
     
     //Carrier
     1. 等待接受：接受订单，拒绝订单
     3. 已接收：取消订单
     5. 已付款：接收物品，退款
     6. 等待退款：交付，退款（有问题，如果用户送到一半，货已经带到了，但是寄件人要求退款，应该就是不能退款）
     7. 正在派送：交付（当面、快递），退款
     9. 已送达: 给与评价
     
     下面的状态没有按钮
     2. 已拒绝
     4. 已取消
     8. 完成派送?? （是否需要加一个按钮去提醒寄件人确定派送）
     10. 已退款
     
     //
     */

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
