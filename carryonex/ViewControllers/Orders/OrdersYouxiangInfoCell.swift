//
//  OrdersYouxiangInfoCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/29/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrdersYouxiangInfoCell: UITableViewCell {
    
    @IBOutlet weak var imageDuplicateFrameView: UIImageView!
    @IBOutlet weak var itemImageButton: UIButton!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    @IBOutlet weak var senderImageButton: UIButton!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    
    fileprivate var status: RequestStatus = .invalid {
        didSet {
            updateButtonAppearance(status: status)
            statusLabel.text = status.displayString()
            statusLabel.backgroundColor = status.displayColor(category: .sender)
        }
    }
    var tripRequest: TripRequest? {
        didSet{
            if let req = tripRequest?.request {
                updateRequestInfoAppearance(request: req)
            }
        }
    }
    var indexPath: IndexPath?
    var ordersYouxiangInfoVC: OrdersYouxiangInfoViewController?
    
    
    @IBAction func itemImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func senderImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func detailButtonTapped(_ sender: Any) {
    }
    
    
}


extension OrdersYouxiangInfoCell: OrderListCardCellProtocol {
    
    func updateButtonAppearance(status: RequestStatus) {
        // no button for update;
    }
    
    func updateRequestInfoAppearance(request: Request) {
        if let statusId = request.statusId, let newStatus = RequestStatus(rawValue: statusId) {
            status = newStatus
        }
    }
    
    
    
    
}



class OrdersYouxiangInfoEmptyCell: UITableViewCell {
    
    var ordersYouxiangInfoVC: OrdersYouxiangInfoViewController?
    var trip: Trip? 
    
    @IBOutlet weak var shareButton: RequestTransactionButton!
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    
    
}
