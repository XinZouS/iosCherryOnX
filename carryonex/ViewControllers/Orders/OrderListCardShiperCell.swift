//
//  OrderListCardCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/16/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


protocol OrderListCarrierCellDelegate: class {
    func orderListCarrierSenderProfileTapped()
    func orderListCarrierSenderPhoneTapped()
    func orderListCarrierMoreImagesTapped()
    func orderListCarrierCodeShareTapped()
}

class OrderListCardShiperCell: OrderListCardCell {
    
    // order card
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var orderCreditLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var sepratorImageView: UIImageView!
    // card expand
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderStarColorView: UIView!
    @IBOutlet weak var senderStarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemListImageView1: UIImageView!
    @IBOutlet weak var itemListImageView2: UIImageView!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var itemListImageMoreButton: UIButton!
    @IBOutlet weak var youxiangCodeShareButton: UIButton!
    
    weak var carrierDelegate: OrderListCarrierCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellCategory = .carrier
    }
    
    override func updateRequestInfoAppearance(request: Request) {
        super.updateRequestInfoAppearance(request: request)
    }
    
    override func updateButtonAppearance(status: RequestStatus) {
        //Carrier
        switch status {
        case .waiting, .paid, .pendingRefund, .inDelivery:
            buttonsToShow = .twoButtons
        case .accepted, .delivered:
            buttonsToShow = .oneButton
        default:
            buttonsToShow = .noButtons
        }
        
        switch status {
        case .waiting:
            finishButton.transaction = .carrierAccept
            finishButton2.transaction = .carrierReject
        case .accepted:
            finishButton.transaction = .carrierCancel
        case .paid:
            finishButton.transaction = .carrierReceive
            finishButton2.transaction = .carrierRefund
        case .pendingRefund:
            finishButton.transaction = .carrierRefund
            finishButton2.transaction = .carrierDeliver  //TODO: ASK.
        case .inDelivery:
            finishButton.transaction = .carrierShip
            finishButton2.transaction = .carrierRefund
        case .delivered:
            finishButton.setTitle("给与评价", for: .normal) //TODO: need to see how it fits in.
        default:
            break
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        sepratorImageView.isHidden = !selected
    }
    
    @IBAction func handleCarrierCellButton(sender: UIButton) {
        if sender == profileButton {
            carrierDelegate?.orderListCarrierSenderProfileTapped()
            
        } else if sender == phoneButton {
            carrierDelegate?.orderListCarrierSenderPhoneTapped()
            
        } else if sender == itemListImageMoreButton {
            carrierDelegate?.orderListCarrierMoreImagesTapped()
            
        } else if sender == youxiangCodeShareButton {
            carrierDelegate?.orderListCarrierCodeShareTapped()
        }
    }
}

/*
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

*/



class OrderListLockerCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lockSwitch: UISwitch!
    @IBOutlet weak var hintLabel: UILabel!
    
    @IBAction func lockerSwitchValueChanged(_ sender: Any) {
    }
    
    
}
