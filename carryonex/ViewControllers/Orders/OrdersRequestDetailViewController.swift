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
    @IBOutlet weak var recipientPhoneCallButton: UIButton!
    @IBOutlet weak var recipientAddressLabel: UILabel!
    // done buttons
    @IBOutlet weak var finishedButton: RequestTransactionButton!
    @IBOutlet weak var cancelButton: RequestTransactionButton!
    
    
    @IBAction func senderPhoneButtonTapped(_ sender: Any) {
    }
    
    @IBAction func senderImageButtonTapped(_ sender: Any) {
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
    var trip: Trip?
    
    fileprivate var status: RequestStatus = .invalid {
        didSet {
            updateButtonAppearance(status: status)
            statusLabel.text = status.displayString()
            statusLabel.backgroundColor = status.displayColor(category: .carrier)
        }
    }
    
    var request: Request? {
        didSet {
            if let request = request {
                updateRequestInfoAppearance(request: request)
            }
        }
    }
    

    // MARK: - VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详情"
        navigationController?.isNavigationBarHidden = false
        cancelButton.isHidden = true
        setupScrollView()
        setupTripInfo()
        setupRequestInfo()
    }
    
    private func setupScrollView(){
        scrollView.delegate = self
    }
    
    private func setupTripInfo(){
        guard let t = trip else { return }
        setupTripDateLabels(t.timestamp)
        setupTripAddressLabels(trip: t)
    }
    
    private func setupRequestInfo(){
        
    }
    
    private func setupTripDateLabels(_ i: Int?){
        guard let i = i else { return }
        let date = Date(timeIntervalSince1970: Double(i))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd YYYY"
        
        let userCalendar = Calendar.current
        let requestdComponents: Set<Calendar.Component> = [.year, .month, .day]
        let dateComponents = userCalendar.dateComponents(requestdComponents, from: date)
        
        dateMonthLabel.text = formatter.shortMonthSymbols.first
        dateDayLabel.text = "\(dateComponents.day ?? 0)"
    }
    
    private func setupTripAddressLabels(trip: Trip){
        if let endCountry = trip.endAddress?.country?.rawValue,
            let endState = trip.endAddress?.state,
            let endCity = trip.endAddress?.city,
            let startCountry = trip.startAddress?.country?.rawValue,
            let startState = trip.startAddress?.state,
            let startCity = trip.startAddress?.city {
            
            endAddressLabel.text = endCountry + "，" + endState + "，" + endCity
            startAddressLabel.text = startCountry + "，" + startState + "，" + startCity
        }
    }
    
    private func setupTripStatus(trip: Trip){
        //???
    }
    

    
}

extension OrdersRequestDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
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



