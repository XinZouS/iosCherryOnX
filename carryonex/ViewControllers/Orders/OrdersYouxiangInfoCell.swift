//
//  OrdersYouxiangInfoCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/29/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrdersYouxiangInfoCell: UITableViewCell {
    
    @IBOutlet weak var incomeTitleLabel: UILabel!
    @IBOutlet weak var imageDuplicateFrameView: UIImageView!
    @IBOutlet weak var itemImageButton: UIButton!
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    
    @IBOutlet weak var senderImageButton: UIButton!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    var cellCategory: TripCategory = .carrier
    var isCommented: Bool = false
    
    fileprivate var status: RequestStatus = .invalid {
        didSet {
            statusLabel.text = status.displayString(isCommented: isCommented, isByExpress: request?.isInExpress() ?? false)
            statusLabel.textColor = status.displayTextColor(category: cellCategory)
            statusLabel.backgroundColor = status.displayColor(category: cellCategory)
        }
    }
    
    var request: Request? {
        didSet {
            if let request = request {
                isCommented = request.isCommented(cellCategory)
                updateRequestInfoAppearance(request: request)
                incomeLabel.text = L("orders.ui.title.currency-type") + request.priceString()
                itemNumberLabel.text = "\(request.getImages().count) " + L("orders.ui.message.request-image-count") // "张"
                senderNameLabel.text = request.ownerRealName    //update to real name
                
                if let urlString = request.ownerImageUrl,let url = URL(string:urlString){
                    senderImageButton.af_setImage(for: .normal, url: url)
                
                } else{
                    senderImageButton.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
                }
            }
        }
    }
    
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        incomeTitleLabel.text = L("orders.ui.title.youxiang-code")
        detailButton.setTitle(L("orders.ui.title.youxianginfo-order-detail"), for: .normal)
    }
    
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
    var emptyCellDelegate: OrdersYouxiangInfoEmptyCellDelegate?
    
    @IBOutlet weak var hintTitleLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        emptyCellDelegate?.shareButtonInPageTapped()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        hintTitleLabel.text = L("orders.ui.message.empty-trip-hint")
        shareButton.setTitle(L("orders.ui.title.share-trip"), for: .normal)
    }
}
