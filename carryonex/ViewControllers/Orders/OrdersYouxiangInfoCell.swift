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
    
    var cellCategory: TripCategory = .carrier
    
    fileprivate var status: RequestStatus = .invalid {
        didSet {
            updateButtonAppearance(status: status)
            statusLabel.text = status.displayString()
            statusLabel.backgroundColor = status.displayColor(category: cellCategory)
        }
    }
    
    var request: Request? {
        didSet{
            if let request = request {
                updateRequestInfoAppearance(request: request)
                incomeLabel.text = request.priceString()
                itemNumberLabel.text = "\(request.images.count) 张"
                senderNameLabel.text = request.ownerUsername    //update to real name
                //senderImageButton //TODO: add user image
            }
        }
    }
    var indexPath: IndexPath?
    
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
    
    var trip: Trip? 
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    
    }
}
