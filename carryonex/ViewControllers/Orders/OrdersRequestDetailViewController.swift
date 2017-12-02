//
//  OrdersRequestDetailViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/29/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class OrdersRequestDetailViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    // trip info
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var incomeLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // request info
    @IBOutlet weak var senderPhoneButton: UIButton!
    @IBOutlet weak var senderImageButton: UIButton!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderScoreWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemImage1: UIImageView!
    @IBOutlet weak var itemImage2: UIImageView!
    @IBOutlet weak var itemImageMoreButton: UIButton!
    @IBOutlet weak var itemValueLabel: UILabel!
    @IBOutlet weak var itemMessageTextView: UITextView!
    
    // recipient info
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var recipientPhoneLabel: UILabel!
    @IBOutlet weak var recipientAddressLabel: UILabel!
    @IBOutlet weak var recipientPhoneCallButton: UIButton!
    
    // done buttons
    @IBOutlet weak var finishedButton: RequestTransactionButton!
    @IBOutlet weak var cancelButton: RequestTransactionButton!
    
    let toShipperViewSegue = "toOtherShipperView"
    
    @IBAction func senderPhoneButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func senderImageButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: toShipperViewSegue, sender: self)
    }
    
    @IBAction func itemImageMoreButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func recipientPhoneCallButtonTapped(_ sender: Any) {
    
    }
    
    // done buttons
    @IBAction func finishedButtonTapped(_ sender: Any) {
    
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
    
    }
    
    // MARK: - Data models
    var trip: Trip = Trip()
    
    fileprivate var status: RequestStatus = .invalid {
        didSet {
            updateButtonAppearance(status: status)
            statusLabel.text = status.displayString()
            statusLabel.backgroundColor = status.displayColor(category: self.category)
        }
    }
    
    var request: Request!
    var category: TripCategory = .carrier
    
    // MARK: - VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"
        navigationController?.isNavigationBarHidden = false
        cancelButton.isHidden = true
        
        updateRequestInfoAppearance(request: request)
        if let trip = TripOrderDataStore.shared.getSenderTripById(id: request.id) {
            self.trip = trip
        }
        
        incomeLabel.text = "$" + request.priceString()
        recipientNameLabel.text = request.endAddress?.recipientName
        recipientPhoneLabel.text = request.endAddress?.phoneNumber
        recipientAddressLabel.text = request.endAddress?.detailedAddress
        
        itemValueLabel.text = "$" + request.itemValue()
        itemMessageTextView.text = request.note
        
        dateMonthLabel.text = trip.getMonthString()
        dateDayLabel.text = trip.getDayString()
        startAddressLabel.text = trip.startAddress?.fullAddressString()
        endAddressLabel.text = trip.endAddress?.fullAddressString()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toShipperViewSegue {
            //if let shipperInfoVC = segue.destination as? ShipperInfoViewController{
                
            //}
        }
    }
    
    private func setupTripStatus(trip: Trip){
        
    }
}

extension OrdersRequestDetailViewController: OrderListCardCellProtocol {
    func updateButtonAppearance(status: RequestStatus) {
        //Override
    }
    
    func updateRequestInfoAppearance(request: Request) {
        //Override
        if let statusId = request.statusId, let newStatus = RequestStatus(rawValue: statusId) {
            status = newStatus
        }
    }
}
