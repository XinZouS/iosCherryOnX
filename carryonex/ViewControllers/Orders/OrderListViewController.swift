//
//  OrderListViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/13/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController {
    
    let tripInfoSegue = "gotoOrdersYouxiangInfo"
    let requestDetailSegue = "gotoOrdersRequestDetail"
    
    @IBOutlet weak var tableViewShiper: UITableView!
    @IBOutlet weak var tableViewSender: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! // default == 400
    @IBOutlet weak var tableViewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var listButtonShiper: UIButton!
    @IBOutlet weak var listButtonSender: UIButton!
    @IBOutlet weak var sliderBar: UIView!
    @IBOutlet weak var sliderBarCenterConstraint: NSLayoutConstraint!
    
    var listType: TripCategory = .carrier
    
    var isFetching = false
    var lastCarrierFetchTime: Int = -1
    var lastShipperFetchTime: Int = -1
    
    var selectedIndexPath: IndexPath?
    enum tableViewRowHeight: CGFloat {
        case carrierCard = 240
        case requestCard = 160
    }

    var carrierTrips = [Trip]() {
        didSet {
            self.tableViewShiper.reloadData()
        }
    }
    
    var senderRequests = [Request]() {
        didSet {
            self.tableViewSender.reloadData()
        }
    }
    
    //MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwipeGestureRecognizer()
        
        //FIXME: Find out why table view constraint is wrong
        tableViewLeftConstraint.constant = 0
        sliderBarCenterConstraint.constant = 0
        setupTableViews()
        
        listType = .carrier
        
        reloadData()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.TripOrderStore.StoreUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == tripInfoSegue {
            if let tripInfoViewController = segue.destination as? OrdersYouxiangInfoViewController, let trip = sender as? Trip {
                tripInfoViewController.trip = trip
                tripInfoViewController.category = .carrier
            }
            
        } else if segue.identifier == requestDetailSegue {
            if let requestDetailViewController = segue.destination as? OrdersRequestDetailViewController, let tripRequest = sender as? (Trip, Request) {
                requestDetailViewController.trip = tripRequest.0
                requestDetailViewController.request = tripRequest.1
                requestDetailViewController.category = .sender
            }
        }
    }
    
    
    func reloadData() {
        carrierTrips = TripOrderDataStore.shared.getCarrierTrips()
        senderRequests = TripOrderDataStore.shared.getSenderRequests()
    }
    
    @IBAction func handleDataSourceChanged(sender: UISegmentedControl) {
        if let category = TripCategory(rawValue: sender.selectedSegmentIndex) {
            listType = category
        }
    }
    
    private func setupNavigationBar(){
        title = "出行订单"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    private func setupTableViews(){
        tableViewShiper.separatorStyle = .none
        tableViewSender.separatorStyle = .none
    }
    
    private func setupSwipeGestureRecognizer(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }

    func respondToSwipe(_ gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .right:
                animateListMoveRight()
            case .left:
                animateListMoveLeft()
            default:
                break
            }
        }
    }
    
    @IBAction func listButtonShiperTapped(_ sender: Any) {
        animateListMoveLeft()
    }
    
    @IBAction func listButtonSenderTapped(_ sender: Any) {
        animateListMoveRight()
    }
    
    private func animateListMoveRight(){
        if tableViewLeftConstraint.constant == 0 {
            tableViewLeftConstraint.constant = -(self.view.bounds.width)
            sliderBarCenterConstraint.constant = listButtonShiper.bounds.width
            listType = .sender
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    private func animateListMoveLeft(){
        if tableViewLeftConstraint.constant < 0 {
            tableViewLeftConstraint.constant = 0
            sliderBarCenterConstraint.constant = 0
            listType = .carrier
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == TripCategory.carrier.rawValue {
            guard let cell = tableViewShiper.dequeueReusableCell(withIdentifier: "OrderListCardShiperCell", for: indexPath) as? OrderListCardShiperCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellCategory = .carrier
            cell.carrierDelegate = self
            
            let trip = carrierTrips[indexPath.row]
            cell.orderCreditLabel.text = trip.tripCode
            cell.startAddressLabel.text = trip.startAddress?.fullAddressString()
            cell.endAddressLabel.text = trip.endAddress?.fullAddressString()
            cell.dateMonthLabel.text = trip.getMonthString()
            cell.dateDayLabel.text = trip.getDayString()
            cell.indexPath = indexPath
            return cell
            
        } else {
            guard let cell = tableViewSender.dequeueReusableCell(withIdentifier: "OrderListCardSenderCell", for: indexPath) as? OrderListCardSenderCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellCategory = .sender
            cell.indexPath = indexPath
            
            let request = senderRequests[indexPath.row]
            cell.request = request
            
            let trip = TripOrderDataStore.shared.getTrip(category: .sender, id: request.tripId)
            cell.startAddressLabel.text = trip?.startAddress?.fullAddressString()
            cell.endAddressLabel.text = trip?.endAddress?.fullAddressString()
            cell.dateMonthLabel.text = trip?.getMonthString()
            cell.dateDayLabel.text = trip?.getDayString()
            cell.itemNumLabel.text = "\(request.images.count)件"
            cell.shiperNameLabel.text = request.ownerUsername
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == TripCategory.carrier.rawValue {
            return TripOrderDataStore.shared.getCarrierTrips().count
        } else {
            return TripOrderDataStore.shared.getSenderRequests().count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.tag == TripCategory.carrier.rawValue) ? tableViewRowHeight.carrierCard.rawValue : tableViewRowHeight.requestCard.rawValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == TripCategory.sender.rawValue {
            let request = senderRequests[indexPath.row]
            let trip = TripOrderDataStore.shared.getTrip(category: .sender, id: request.tripId)
            performSegue(withIdentifier: requestDetailSegue, sender: (trip, request))
        }
    }
}

extension OrderListViewController: OrderListCarrierCellDelegate {
    
    func orderListCarrierGotoTripDetailButtonTapped(indexPath: IndexPath){
        let trip = carrierTrips[indexPath.row]  //Fix just pass trip id
        performSegue(withIdentifier: tripInfoSegue, sender: trip)
    }
    
    func orderListCarrierLockButtonTapped(indexPath: IndexPath) {
        print("Carrier Lock Tapped")
    }
    
    func orderListCarrierCodeShareTapped(indexPath: IndexPath) {
        print("Carrier Share Tapped")
    }
}

