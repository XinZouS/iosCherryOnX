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
        case mainCard = 160
        case detailCard = 300
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
            }
            
        } else if segue.identifier == requestDetailSegue {
            if let requestDetailViewController = segue.destination as? OrdersRequestDetailViewController, let tripRequest = sender as? (Trip, Request) {
                requestDetailViewController.trip = tripRequest.0
                requestDetailViewController.request = tripRequest.1
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
    
    /*
    fileprivate func fetchRequests(category: TripCategory) {
        
        guard !isFetching else { return }
        
        isFetching = true
        
        let offset = (category == .carrier) ? dataSourceCarrier.count : dataSourceSender.count
        let page = 4
        
        ApiServers.shared.getUsersTrips(userType: listType, offset: offset, pageCount: page) { (tripOrders, error) in
            self.isFetching = false
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }

            if let tripOrders = tripOrders, tripOrders.count != 0 {
                if category == .carrier {
                    self.lastCarrierFetchTime = Date.getTimestampNow()
                    self.dataSourceCarrier.append(contentsOf: tripOrders)
                } else {
                    self.lastShipperFetchTime = Date.getTimestampNow()
                    self.dataSourceSender.append(contentsOf: tripOrders)
                }
            }
        }
    }
    */
    
    /*
    private func updateRequests(category: TripCategory) {
        
        guard !isFetching else { return }
        
        isFetching = true
        
        let offset = 0
        let page = (category == .carrier) ? dataSourceCarrier.count : dataSourceSender.count
        let lastFetchTime = (category == .carrier) ? lastCarrierFetchTime : lastShipperFetchTime
        let currentDataSource = (category == .carrier) ? self.dataSourceCarrier : self.dataSourceSender
        
        ApiServers.shared.getUsersTrips(userType: listType, offset: offset, pageCount: page, sinceTime: lastFetchTime) { (tripOrders, error) in
            self.isFetching = false
                                            
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            
            if let tripOrders = tripOrders {
                self.updateDataSource(currentDataSource, updatedData: tripOrders)
                
                if self.listType == .carrier {
                    self.lastCarrierFetchTime = Date.getTimestampNow()
                    self.tableViewShiper.reloadData()
                } else {
                    self.lastShipperFetchTime = Date.getTimestampNow()
                    self.tableViewSender.reloadData()
                }
            }
        }
    }
    */
 
    /*
    private func updateDataSource(_ dataSource: [TripOrder], updatedData: [TripOrder]) {
        var updatedRequests = [Request]()
        
        //Extract all the requests
        for tripOrder in updatedData {
            if let requests = tripOrder.requests {
                for tripRequest in requests {
                    updatedRequests.append(tripRequest.request)
                }
            } else {
                print("No requests in trip: \(tripOrder.trip.id)")
            }
        }
        
        //Update data source
        for request in updatedRequests {
            for tripOrder in dataSource {
                if let requests = tripOrder.requests {
                    for tripRequest in requests {
                        if tripRequest.request.id == request.id {
                            tripRequest.request.statusId = request.statusId
                        }
                    }
                } else {
                    print("No requests in trip: \(tripOrder.trip.id)")
                }
            }
        }
    }
    */
    
    /*
    func updateRequestAtIndexPath(indexPath: IndexPath, statusId: Int) {
        if (listType == .carrier) {
            dataSourceCarrier[indexPath.section].requests?[indexPath.row].request.statusId = statusId
            self.tableViewShiper.reloadRows(at: [indexPath], with: .fade)
        } else {
            dataSourceSender[indexPath.section].requests?[indexPath.row].request.statusId = statusId
            self.tableViewSender.reloadRows(at: [indexPath], with: .fade)
        }
    }
    */
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == TripCategory.carrier.rawValue {
            guard let cell = tableViewShiper.dequeueReusableCell(withIdentifier: "OrderListCardShiperCell", for: indexPath) as? OrderListCardShiperCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            let trip = carrierTrips[indexPath.row]
            cell.orderCreditLabel.text = trip.tripCode
            cell.startAddressLabel.text = trip.startAddress?.fullAddressString()
            cell.endAddressLabel.text = trip.endAddress?.fullAddressString()
            return cell
            
        } else {
            guard let cell = tableViewSender.dequeueReusableCell(withIdentifier: "OrderListCardSenderCell", for: indexPath) as? OrderListCardSenderCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            
            let request = senderRequests[indexPath.row]
            cell.request = request
            
            let trip = TripOrderDataStore.shared.getSenderTripById(id: request.tripId)
            cell.startAddressLabel.text = trip?.startAddress?.fullAddressString()
            cell.endAddressLabel.text = trip?.endAddress?.fullAddressString()
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
        return tableViewRowHeight.mainCard.rawValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == TripCategory.carrier.rawValue {
            let trip = carrierTrips[indexPath.row]  //Fix just pass trip id
            performSegue(withIdentifier: tripInfoSegue, sender: trip)
            
        } else {
            let request = senderRequests[indexPath.row]
            let trip = TripOrderDataStore.shared.getSenderTripById(id: request.tripId)
            performSegue(withIdentifier: requestDetailSegue, sender: (trip, request))
        }
    }
}

/*
extension OrderListViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
////        print("scroll y: \(scrollView.contentOffset.y), LIMIT: \(Float(scrollView.contentSize.height - scrollView.frame.size.height))")
////        print("scroll content height: \(scrollView.contentSize.height), scroll frame height: \(scrollView.frame.size.height)")
//
//        //Fetching
//        if Float(scrollView.contentOffset.y) > Float(scrollView.contentSize.height - scrollView.frame.size.height) {
//            fetchRequests(category: listType)
//        }
//    }
    
//    fileprivate func animateImageForTableScrolling(){
//        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn, animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
}
*/

/*
extension OrderListViewController: OrderListCellDelegate {
    
    func orderCellButtonTapped(request: Request, category: TripCategory, transaction: RequestTransaction, indexPath: IndexPath) {
        
        print("Transaction tapped: \(transaction.displayString())")
        
        let currentDataSource = (category == .carrier) ? self.dataSourceCarrier : self.dataSourceSender
        displayAlertOkCancel(title: "确认操作", message: transaction.confirmDescString()) { [weak self] (style) in
            if style == .default {
                let tripOrder = currentDataSource[indexPath.section]
                let trip = tripOrder.trip
                ApiServers.shared.postRequestTransaction(requestId: request.id,
                                                         tripId: trip.id,
                                                         transaction: transaction,
                                                         completion: { (success, error, statusId) in
                    if (success) {
                        if let statusId = statusId {
                            self?.updateRequestAtIndexPath(indexPath: indexPath, statusId: statusId)
                            print("New status: \(statusId)")
                        } else {
                            debugPrint("No status found, bad call")
                        }
                    }
                })
            }
        }
    }
}
*/

extension OrderListViewController: OrderListCarrierCellDelegate {
    
    func orderListCarrierSenderProfileTapped() {
        print("Carrier Sender Profile Tapped")
    }
    
    func orderListCarrierSenderPhoneTapped() {
        print("Carrier Sender Phone Tapped")
    }
    
    func orderListCarrierMoreImagesTapped() {
        print("Carrier More Images Tapped")
    }
    
    func orderListCarrierCodeShareTapped() {
        print("Carrier Share Tapped")
    }
}

extension OrderListViewController: OrderListSenderCellDelegate {
    
    func orderListSenderItemImageTapped() {
        print("Sender Item Image Tapped")
    }
    
    func orderListSenderCarrierProfileImageTapped() {
        print("Sender Carrier Profile Image Tapped")
    }
    
    func orderListSenderCarrierPhoneTapped() {
        print("Sender Carrier Phone Tapped")
    }
}

