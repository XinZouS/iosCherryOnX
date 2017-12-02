//
//  OrderListCardSenderCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/18/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

protocol OrderListSenderCellDelegate: class {
    func orderListSenderItemImageTapped()
    func orderListSenderCarrierProfileImageTapped()
    func orderListSenderCarrierPhoneTapped()
}

class OrderListCardSenderCell: OrderListCardCell {
    
    @IBOutlet weak var itemImageFrame2: UIImageView!
    
    @IBOutlet weak var itemNumLabel: UILabel!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var sepratorImageView: UIImageView!
    
    // card expand
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var shiperStarColorView: UIView!
    @IBOutlet weak var shiperNameLabel: UILabel!
    @IBOutlet weak var shiperScoreTitleLabel: UILabel!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var orderCodeLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var shiperStarColorConstraint: NSLayoutConstraint!
    
    //Buttons
    @IBOutlet weak var itemImageButton: UIButton!
    @IBOutlet weak var shiperProfileImageButton: UIButton!
    @IBOutlet weak var shiperPhoneCallButton: UIButton!
    
    weak var senderDelegate: OrderListSenderCellDelegate?
    
    @IBAction func handleSenderCellButton(sender: UIButton) {
        if sender == itemImageButton {
            senderDelegate?.orderListSenderItemImageTapped()
            
        } else if sender == shiperProfileImageButton {
            senderDelegate?.orderListSenderCarrierProfileImageTapped()
            
        } else if sender == shiperPhoneCallButton {
            senderDelegate?.orderListSenderCarrierPhoneTapped()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellCategory = .sender
        statusLabel.textColor = UIColor.darkGray
    }
    
    override func updateRequestInfoAppearance(request: Request) {
        super.updateRequestInfoAppearance(request: request)
        
        shippingCostLabel.text = request.priceString()
        itemPriceLabel.text = request.itemValue()
        orderCodeLabel.text = "\(request.tripId ?? -999)"
        
        if let shipperAddress = request.endAddress {
            shiperNameLabel.text = shipperAddress.recipientName
        }
        
        //TODO: Add phone call method
    }
    
    override func updateButtonAppearance(status: RequestStatus) {
        //Carrier
        switch status {
        case .waiting, .accepted:
            buttonsToShow = .twoButtons
        case .delivered, .deliveryConfirmed:
            buttonsToShow = .oneButton
        default:
            buttonsToShow = .noButtons
        }
        
        switch status {
        case .waiting:
            finishButton.transaction = .shipperCancel
            finishButton2.transaction = .shipperPairing
        case .accepted:
            finishButton.transaction = .shipperPay
            finishButton2.transaction = .shipperCancel
        case .delivered:
            finishButton.transaction = .shipperConfirm
        case .deliveryConfirmed:
            finishButton.setTitle("给与评价", for: .normal) //TODO: need to see how it fits in.
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        sepratorImageView.isHidden = !selected
    }
}

/*
 sender
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
 9. 已確認送达：给与评价
 
 下面的状态没有按钮
 2. 已拒绝
 4. 已取消
 6. 已退款
 10. 已退款
 */

