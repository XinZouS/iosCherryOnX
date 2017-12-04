//
//  OrderListCardCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/16/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


protocol OrderListCarrierCellDelegate: class {
    func orderListCarrierGotoTripDetailButtonTapped(indexPath: IndexPath)
    func orderListCarrierCodeShareTapped(indexPath: IndexPath)
}

class OrderListCardShiperCell: OrderListCardCell {
    
    // order card
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var sepratorImageView: UIImageView!
    @IBOutlet weak var gotoTripDetailButton: UIButton!
    @IBOutlet weak var shareYouxiangButton: UIButton!
    @IBOutlet weak var lockButton: UIButton!
    @IBOutlet weak var lockImageView: UIImageView!
    @IBOutlet weak var lockLabel: UILabel!
    
    // card expand
    @IBOutlet weak var cardDetailView: UIView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderStarColorView: UIView!
    @IBOutlet weak var senderStarViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemListImageView1: UIImageView!
    @IBOutlet weak var itemListImageView2: UIImageView!
    //@IBOutlet weak var youxiangCodeLabel: UILabel!
    
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var itemListImageMoreButton: UIButton!
    
    weak var carrierDelegate: OrderListCarrierCellDelegate?
    
    var trip: Trip? {
        didSet{
            let isActive: Bool = (trip?.active == TripActive.active)
            youxiangCodeLabel.text = trip?.tripCode
            setupYouxiangLokcerStatus(isActive: isActive)
            startAddressLabel.text = trip?.startAddress?.fullAddressString()
            endAddressLabel.text = trip?.endAddress?.fullAddressString()
            dateMonthLabel.text = trip?.getMonthString()
            dateDayLabel.text = trip?.getDayString()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellCategory = .carrier
        setupYouxiangLokcerStatus(isActive: true)
    }

    private func setupYouxiangLokcerStatus(isActive: Bool){
        lockLabel.isHidden = isActive
        lockImageView.image = isActive ? #imageLiteral(resourceName: "LockOpened") : #imageLiteral(resourceName: "LockClosed")
    }
    
    override func updateRequestInfoAppearance(request: Request) {
        super.updateRequestInfoAppearance(request: request)
        youxiangCodeLabel.text = request.priceString()
        youxiangCodeLabel.text = "\(request.tripId)"
        
        if let shipperAddress = request.endAddress {
            senderNameLabel.text = shipperAddress.recipientName
        }
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
        if sender == gotoTripDetailButton {
            carrierDelegate?.orderListCarrierGotoTripDetailButtonTapped(indexPath: indexPath)
            
        } else if sender == shareYouxiangButton {
            carrierDelegate?.orderListCarrierCodeShareTapped(indexPath: indexPath)
            
        } else if sender == lockButton {
            lockButtonTapped()
            
        }
    }
    
    private func lockButtonTapped(){
        guard let id = trip?.id else { return }
        let isActive = (trip?.active == TripActive.active)
        ApiServers.shared.postTripActive(tripId: "\(id)", isActive: !isActive, completion: { (success, error) in
            if let err = error {
                print("error: cannot postTripActive by id, error = \(err)")
                return
            }
            ApiServers.shared.getTripActive(tripId: "\(id)", completion: { (tripActive, error) in
                if let err = error {
                    print("get error when get TripActive: err = \(err)")
                    return
                }
                let active = (tripActive == TripActive.active)
                self.trip?.active = tripActive
                self.setupYouxiangLokcerStatus(isActive: active)
            })
        })

    }

  
}
