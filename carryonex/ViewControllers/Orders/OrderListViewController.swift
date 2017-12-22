//
//  OrderListViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/13/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import TGRefreshSwift

class OrderListViewController: UIViewController {
    
//    let tripInfoSegue = "gotoOrdersYouxiangInfo"
    let requestDetailSegue = "gotoOrdersRequestDetail"
    let shiperCellId = "OrderListCardShiperCell"
    let senderCellId = "OrderListCardSenderCell"
    
    /// Flickr Image operator
    var imageTimer: Timer?
    
    // UI contents
    @IBOutlet weak var imageTitleView: UIImageView!
    @IBOutlet weak var imageTitleTransitionView: UIImageView!
    @IBOutlet weak var tableViewShiper: UITableView!
    @IBOutlet weak var tableViewSender: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint! // default == 400
    @IBOutlet weak var tableViewLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var listButtonShiper: UIButton!
    @IBOutlet weak var listButtonSender: UIButton!
    @IBOutlet weak var sliderBar: UIView!
    @IBOutlet weak var sliderBarCenterConstraint: NSLayoutConstraint!
    
    var listType: TripCategory = .carrier {
        didSet {
            loadImageUrlsOfCurrentCity()
            TripOrderDataStore.shared.pullNextPage(category: listType) { [weak self] _ in
                self?.reloadData()
            }
        }
    }
    
    var activityIndicator: BPCircleActivityIndicator!
    var isFetching: Bool = false {
        didSet{
            if isFetching {
                activityIndicator.isHidden = false
                activityIndicator.animate()
            } else {
                activityIndicator.stop()
                activityIndicator.isHidden = true
            }
        }
    }
    
    var lastCarrierFetchTime: Int = -1
    var lastShipperFetchTime: Int = -1
    
    var sharingAlertVC: UIAlertController?

    var selectedIndexPath: IndexPath?
    enum tableViewRowHeight: CGFloat {
        case carrierCard = 240
        case requestCard = 155
    }

    var carrierTrips = [Trip]() {
        didSet {
            DispatchQueue.main.async {
                self.tableViewShiper.reloadData()
            }
        }
    }
    
    var senderRequests = [Request]() {
        didSet {
            DispatchQueue.main.async {
                self.tableViewSender.reloadData()
            }
        }
    }
    
    var refreshShipperControl: TGRefreshSwift!
    var refreshSenderControl: TGRefreshSwift!

    
    //MARK: - View Cycle
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSwipeGestureRecognizer()
        
        //FIXME: Find out why table view constraint is wrong
        //TODO: constraints are ok, if nothing wrong then remove both lines when you see this; - Xin
        tableViewLeftConstraint.constant = 0
        sliderBarCenterConstraint.constant = 0
        setupTableViews()
        setupRefreshController()
        //Setup activity indicator
        activityIndicator = BPCircleActivityIndicator()
        activityIndicator.frame = CGRect(x:view.center.x-15,y:view.center.y-64,width:0,height:0)
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
        reloadData()
        
        loadImageUrlsOfCurrentCity()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.TripOrderStore.StoreUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        TripOrderDataStore.shared.pull(category: listType, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if listType == .sender {
            animateListMoveRight()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        invalidateImageTimer()
    }
    
    
    //MARK: - Helper Methods
    
    private func setupRefreshController(){
        //添加刷新
        refreshShipperControl = TGRefreshSwift()
        refreshShipperControl.addTarget(self, action: #selector(refreshData),
                                 for: .valueChanged)
        tableViewShiper.addSubview(refreshShipperControl)
        
        refreshSenderControl = TGRefreshSwift()
        refreshSenderControl.addTarget(self, action: #selector(refreshData),
                                        for: .valueChanged)
        tableViewSender.addSubview(refreshSenderControl)
    }
    
    func refreshData(){
        if listType == .carrier {
            refreshShipperControl.beginRefreshing()
        } else {
            refreshSenderControl.beginRefreshing()
        }
        TripOrderDataStore.shared.pull(category: listType, completion: {
            let time: TimeInterval = 1.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                if self.listType == .carrier {
                    self.refreshShipperControl.endRefreshing()
                } else {
                    self.refreshSenderControl.endRefreshing()
                }
            }
        })
    }
    
    func reloadData() {
        carrierTrips = TripOrderDataStore.shared.getCarrierTrips()
        senderRequests = TripOrderDataStore.shared.getSenderRequests()
        if carrierTrips.count != 0{
            tableViewShiper.tableFooterView = nil
        }
        if senderRequests.count != 0{
            tableViewSender.tableFooterView = nil
        }
    }
    
    @IBAction func handleDataSourceChanged(sender: UISegmentedControl) {
        if let category = TripCategory(rawValue: sender.selectedSegmentIndex) {
            listType = category
        }
    }
    
    private func setupNavigationBar(){
        title = L("orders.ui.title.orderlist") //"出行订单"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    private func setupTableViews(){
        tableViewShiper.separatorStyle = .none
        tableViewSender.separatorStyle = .none
        tableViewShiper.tableFooterView = setupLoadMoreView(tableView: tableViewShiper,tag:0)
        tableViewSender.tableFooterView = setupLoadMoreView(tableView: tableViewSender,tag:1)
    }
    
    private func setupLoadMoreView(tableView:UITableView,tag:Int) ->UIView{
        let footView = UIView(frame: CGRect(x: 0, y:tableView.contentSize.height,
                                        width:tableView.bounds.size.width, height: 150))
        let BlankNotice = UIImageView()
        let hintLabel = UILabel()
        footView.addSubview(BlankNotice)
        BlankNotice.frame = CGRect(x:footView.center.x-50,y:footView.center.y-30,width:100,height:60)
        BlankNotice.image = #imageLiteral(resourceName: "EmptyOrder")
        footView.addSubview(hintLabel)
        switch tag {
        case 0:
            hintLabel.text = L("orders.ui.placeholder.trip")
        default:
            hintLabel.text = L("orders.ui.placeholder.send")
        }
        hintLabel.addConstraints(left: nil, top: BlankNotice.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        hintLabel.centerXAnchor.constraint(equalTo: BlankNotice.centerXAnchor).isActive = true
        return footView
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
    
    func animateListMoveRight(){
        if tableViewLeftConstraint.constant == 0 {
            tableViewLeftConstraint.constant = -(self.view.bounds.width)
            sliderBarCenterConstraint.constant = listButtonShiper.bounds.width
            listType = .sender
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func animateListMoveLeft(){
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

extension OrderListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height) {
            if !isFetching {
                print("Hit bottom 1: scrollViewDidEndDecelerating")
                isFetching = true
                TripOrderDataStore.shared.pullNextPage(category: listType, completion: {
                    self.reloadData()
                    self.isFetching = false
                })
            }
        }
    }
    
    private func currentTableView() -> UITableView {
        return (listType == .carrier) ? tableViewShiper : tableViewSender
    }
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == TripCategory.carrier.rawValue {
            guard let cell = tableViewShiper.dequeueReusableCell(withIdentifier: shiperCellId, for: indexPath) as? OrderListCardShiperCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellCategory = .carrier
            cell.carrierDelegate = self
            
            let trip: Trip = carrierTrips[indexPath.row]
            cell.trip = trip
            cell.indexPath = indexPath
            return cell
            
        } else {
            guard let cell = tableViewSender.dequeueReusableCell(withIdentifier: senderCellId, for: indexPath) as? OrderListCardSenderCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellCategory = .sender
            cell.indexPath = indexPath
            
            let request: Request = senderRequests[indexPath.row]
            cell.request = request
            cell.itemNumLabel.text = "\(request.images.count)" + L("orders.ui.message.request-image-count")
            
            if let image = request.images.first?.imageUrl, let imageUrl = URL(string: image) {
                cell.itemImageButton.af_setImage(for: .normal, url: imageUrl)
            }
            
            if let trip = TripOrderDataStore.shared.getTrip(category: .sender, id: request.tripId) {
                cell.startAddressLabel.text = trip.startAddress?.fullAddressString()
                cell.endAddressLabel.text = trip.endAddress?.fullAddressString()
                cell.dateMonthLabel.text = trip.getMonthString()
                cell.dateDayLabel.text = trip.getDayString()
            }
            
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
            //let trip = TripOrderDataStore.shared.getTrip(category: .sender, id: request.tripId)
            //performSegue(withIdentifier: requestDetailSegue, sender: (trip, request))
            AppDelegate.shared().handleMainNavigation(navigationSegue: .requestDetail, sender: request)
        }
    }
}

extension OrderListViewController: OrderListCarrierCellDelegate {
    
    func orderListCarrierGotoTripDetailButtonTapped(indexPath: IndexPath){
        let trip = carrierTrips[indexPath.row]  //Fix just pass trip id
        AppDelegate.shared().handleMainNavigation(navigationSegue: .orderTripInfo, sender: trip)
    }
    
    func orderListCarrierCodeShareTapped(indexPath: IndexPath) {
        guard let cell = tableViewShiper.cellForRow(at: indexPath) as? OrderListCardShiperCell else { return }
        guard cell.isActive else {
            displayGlobalAlertActions(title: L("orders.error.title.share"),
                                      message: L("orders.error.message.share"),
                                      actions: [L("orders.error.action.share-lock"), L("orders.error.action.share-unlock")],
                                      completion: { [weak self] (tag) in
                if tag == 1 { // unlock and share
                    self?.orderListCarrierLockerButtonTapped(indexPath: indexPath, completion: {
                        self?.orderListCarrierCodeShareTapped(indexPath: indexPath)
                    })
                }
            })
            return
        }
        
        let trip = carrierTrips[indexPath.row]
        sharingAlertVC = ShareViewFactory().setupShare(self, trip: trip)
        
        if UIDevice.current.userInterfaceIdiom != .phone {
            sharingAlertVC?.popoverPresentationController?.sourceView = cell.shareYouxiangButton
        }
        
        self.present(self.sharingAlertVC!, animated: true, completion:{})
    }
    
    func orderListCarrierLockerButtonTapped(indexPath: IndexPath, completion: (() -> Void)?) {
        guard let cell = tableViewShiper.cellForRow(at: indexPath) as? OrderListCardShiperCell else { return }
        guard let id = cell.trip?.id else { return }
        let isActive = (carrierTrips[indexPath.row].active == TripActive.active.rawValue)

        if isActive {
            displayGlobalAlertActions(title: L("orders.confirm.title.lock"),
                                      message: L("orders.confirm.message.lock"),
                                      actions: [L("orders.confirm.action.lock"), L("action.cancel")],
                                      completion: { (tag) in
                if tag == 0 { // do lock;
                    self.setYouxiangLockStatusAt(cell, id: id, true, completion: completion)
                } else {
                    return // cancel to lock;
                }
            })
        } else { // do unlock;
            setYouxiangLockStatusAt(cell, id: id, false, completion: completion)
        }
    }
    private func setYouxiangLockStatusAt(_ cell: OrderListCardShiperCell, id: Int, _ isActive: Bool, completion: (() -> Void)?) {
        cell.lockButton.isEnabled = false
        isFetching = true
        ApiServers.shared.postTripActive(tripId: "\(id)", isActive: !isActive, completion: { (success, error) in
            cell.lockButton.isEnabled = true
            self.isFetching = false
            if let err = error {
                print("error: cannot postTripActive by id, error = \(err.localizedDescription)")
                self.displayGlobalAlert(title: L("orders.error.title.lock-fail"),
                                        message: L("orders.error.message.lock-fail-network"),
                                        action: L("action.ok"), completion: nil)
                return
            }
            ApiServers.shared.getTripActive(tripId: "\(id)", completion: { (tripActive, error) in
                if let err = error {
                    print("get error when get TripActive: err = \(err.localizedDescription)")
                    self.displayGlobalAlert(title: L("orders.error.title.lock-fail"),
                                            message: L("orders.error.message.lock-fail-account"),
                                            action: L("orders.error.action.lock-fail-account"),
                                            completion: { [weak self] _ in
                        self?.navigationController?.popToRootViewController(animated: false)
                        ProfileManager.shared.logoutUser()
                    })
                    return
                }
                let active = (tripActive == TripActive.active)
                cell.trip?.active = tripActive.rawValue
                cell.isActive = active
                completion?()
            })
        })
    }
}

/**
 * Set up title image for city > state
 */
extension OrderListViewController {
    
    fileprivate func loadImageUrlsOfCurrentCity() {
        
        var place: String
        if listType == .carrier {
            place = self.carrierTrips.first?.endAddress?.state ?? ""
        } else {
            place = self.senderRequests.first?.endAddress?.state ?? ""
        }
        
        if !place.isEmpty && !FlickrImageManager.shared.isStoreImageFilled(category: listType) {
            FlickrImageManager.shared.getPhotoUrl(from: place, category: listType) { (urls) in
                //Only trigger it when timer is off, so we could smooth out the transition
                if self.imageTimer == nil {
                    self.performSelector(onMainThread: #selector(self.startImageTimer), with: nil, waitUntilDone: false)
                    self.animateTitleImageTransition()
                }
            }
        }
    }
    
    @objc fileprivate func animateTitleImageTransition(){
        guard let newUrl = FlickrImageManager.shared.nextImageUrl(category: listType) else {
            return
        }
        
        DispatchQueue.main.async(execute: {
            self.imageTitleTransitionView.image = self.imageTitleView.image
            self.imageTitleTransitionView.alpha = 1
            self.imageTitleTransitionView.isHidden = false
            self.imageTitleView.af_setImage(withURL: newUrl)
            UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.imageTitleTransitionView.alpha = 0
            }) { (finished) in
                self.imageTitleTransitionView.isHidden = true
            }
        })
    }
    
    @objc fileprivate func startImageTimer() {
        if imageTimer != nil {
            invalidateImageTimer()
        }
        imageTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(animateTitleImageTransition), userInfo: nil, repeats: true)
    }
    
    fileprivate func invalidateImageTimer() {
        imageTimer?.invalidate()
        imageTimer = nil
    }
}
