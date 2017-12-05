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
    @IBOutlet weak var finishButton: RequestTransactionButton!
    @IBOutlet weak var finishButton2: RequestTransactionButton!
    
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
    @IBAction func PhoneButtonTapped(_ sender: Any) {        
        if let PhoneNumberUrl = recipientPhoneLabel.text,let url = URL(string: PhoneNumberUrl) {
            //根据iOS系统版本，分别处理
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:],
                                          completionHandler: {
                                            (success) in
                })
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func requestStatusButtonHandler(sender: RequestTransactionButton) {
        let transaction = sender.transaction
        print("Transaction tapped: \(transaction.displayString())")
        let tripId = trip.id
        let requestId = request.id
        let requestCategory = category
        displayAlertOkCancel(title: "确认操作", message: transaction.confirmDescString()) { [weak self] (style) in
            if style == .default {
                ApiServers.shared.postRequestTransaction(requestId: requestId,
                                                         tripId: tripId,
                                                         transaction: transaction,
                                                         completion: { (success, error, statusId) in
                                                            if (success) {
                                                                if let statusId = statusId {
                                                                    print("New status: \(statusId)")
                                                                    TripOrderDataStore.shared.pull(category: requestCategory, completion: {
                                                                        self?.reloadData()
                                                                    })
                                                                } else {
                                                                    debugPrint("No status found, bad call")
                                                                }
                                                            }
                })
            }
        }
    }
    
    // MARK: - Data models
    var trip: Trip = Trip()
    
    var request: Request!
    var category: TripCategory = .carrier
    
    var buttonsToShow: OrderButtonToShow = .noButtons {
        didSet {
            switch buttonsToShow {
            case .noButtons:
                finishButton.isHidden = true
                finishButton2.isHidden = true
            case .oneButton:
                finishButton.isHidden = false
                finishButton2.isHidden = true
            case .twoButtons:
                finishButton.isHidden = false
                finishButton2.isHidden = false
            }
        }
    }
    
    
    // MARK: - VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"
        navigationController?.isNavigationBarHidden = false
        
        setupScrollView()
        setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toShipperViewSegue {
            //if let shipperInfoVC = segue.destination as? ShipperInfoViewController{
                
            //}
        }
    }

    private func setupScrollView(){
        scrollView.delegate = self
        scrollView.isDirectionalLockEnabled = true
        scrollView.alwaysBounceVertical = true
    }

    private func setupView() {
        updateRequestInfoAppearance(request: request)
        
        if let trip = TripOrderDataStore.shared.getTrip(category: category, id: request.tripId) {
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
        
        if let image = request.images.first?.imageUrl, let imageUrl = URL(string: image) {
            itemImage1.af_setImage(withURL: imageUrl)
        }
        
        itemImageMoreButton.isHidden = (request.images.count < 2)
        if request.images.count > 1 {
            itemImage2.isHidden = false
            let imageObj = request.images[1]
            if let imageUrl = URL(string: imageObj.imageUrl) {
                itemImage2.af_setImage(withURL: imageUrl)
            }
        } else {
            itemImage2.isHidden = true
        }
    }
    
    private func reloadData() {
        if let updatedRequest = TripOrderDataStore.shared.getRequest(category: category, requestId: self.request.id) {
            request = updatedRequest
            setupView()
        }
    }
}

extension OrdersRequestDetailViewController: OrderListCardCellProtocol {
    func updateButtonAppearance(status: RequestStatus) {
        if category == .carrier {
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
            
        } else {
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
    }
    
    func updateRequestInfoAppearance(request: Request) {
        //Override
        if let statusId = request.statusId, let status = RequestStatus(rawValue: statusId) {
            updateButtonAppearance(status: status)
            statusLabel.text = status.displayString()
            statusLabel.backgroundColor = status.displayColor(category: category)
        }
    }
}


extension OrdersRequestDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let maxY = scrollView.contentSize.height - self.view.bounds.height + 100
        if y < 0 || y > maxY {
            return
        }
        scrollView.setContentOffset(CGPoint(x:0, y: y), animated: true)
    }
    
    
    
}
