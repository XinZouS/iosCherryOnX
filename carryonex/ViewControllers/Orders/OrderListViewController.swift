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
    
    let cityStringDefault = "New York"
    var cityStringForImage: String = "New York" {
        didSet{
            loadImageUrlsOfCurrentCity()
        }
    }
    var imageTimer: Timer?
    @IBOutlet weak var imageTitleView: UIImageView!
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
            TripOrderDataStore.shared.pullNextPage(category: listType) { [weak self] _ in
                self?.reloadData()
                self?.setCityStringForImage()
            }
        }
    }
    
    var activityIndicator: UIActivityIndicatorCustomizeView!
    var isFetching: Bool = false {
        didSet{
            if isFetching {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
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
            self.tableViewShiper.reloadData()
            setCityStringForImage()
        }
    }
    
    var senderRequests = [Request]() {
        didSet {
            self.tableViewSender.reloadData()
            setCityStringForImage()
        }
    }
    
    var isStoreUpdated = false
    
    //MARK: - View Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCityStringForImage()
        loadImageUrlsOfCurrentCity()
        setupImageTimer()
        setupSwipeGestureRecognizer()
        
        //FIXME: Find out why table view constraint is wrong
        //TODO: constraints are ok, if nothing wrong then remove both lines when you see this; - Xin
        tableViewLeftConstraint.constant = 0
        sliderBarCenterConstraint.constant = 0
        setupTableViews()
        
        //Setup activity indicator
        activityIndicator = UIActivityIndicatorCustomizeView()
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
        reloadData()
        NotificationCenter.default.addObserver(forName: Notification.Name.TripOrderStore.StoreUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.isStoreUpdated = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        if !isStoreUpdated {
            TripOrderDataStore.shared.pull(category: listType, completion: nil)
        } else {
            self.reloadData()
        }
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
    
    //MARK: - Helper Methods
    
    func reloadData() {
        carrierTrips = TripOrderDataStore.shared.getCarrierTrips()
        senderRequests = TripOrderDataStore.shared.getSenderRequests()
        if carrierTrips.count != 0{
            tableViewShiper.tableFooterView = nil
        }
        if senderRequests.count != 0{
            tableViewSender.tableFooterView = nil
        }
        isStoreUpdated = false  //reset
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
            hintLabel.text = "你还没有出行记录，快发布你的行程吧"
        default:
            hintLabel.text = "你还没有寄件记录，快寄送些东西吧"
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

extension OrderListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge >= scrollView.contentSize.height) {
            if !isFetching {
                print("Hit bottom")
                isFetching = true
                TripOrderDataStore.shared.pullNextPage(category: listType, completion: {
                    self.reloadData()
                    self.isFetching = false
                })
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
            if (bottomEdge >= scrollView.contentSize.height) {
                if !isFetching {
                    print("Hit bottom")
                    isFetching = true
                    TripOrderDataStore.shared.pullNextPage(category: listType, completion: {
                        self.reloadData()
                        self.isFetching = false
                    })
                }
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
            guard let cell = tableViewShiper.dequeueReusableCell(withIdentifier: "OrderListCardShiperCell", for: indexPath) as? OrderListCardShiperCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.cellCategory = .carrier
            cell.carrierDelegate = self
            
            let trip = carrierTrips[indexPath.row]
            cell.trip = trip
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
            if let image = request.images.first?.imageUrl, let imageUrl = URL(string: image) {
                cell.itemImageButton.af_setImage(for: .normal, url: imageUrl)
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
    
    func orderListCarrierCodeShareTapped(indexPath: IndexPath) {
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        sharingAlertVC = ShareManager.shared.setupShareFrame()
        setupShareInformation(trip: carrierTrips[indexPath.row])
        if !isPhone {
            if let cell = tableViewShiper.cellForRow(at: indexPath) as? OrderListCardShiperCell {
                sharingAlertVC?.popoverPresentationController?.sourceView = cell.shareYouxiangButton
            }
        }
        DispatchQueue.main.async {
            self.present(self.sharingAlertVC!, animated: true, completion:{})
        }
    }
    
    private func setupShareInformation(trip: Trip){
        if let beginLocation = trip.startAddress?.fullAddressString(),
            let endLocation = trip.endAddress?.fullAddressString() {
            let dateMonth = trip.getMonthString()
            let dateDay = trip.getDayString()
            let monthAndDayString = "\(dateMonth), \(dateDay)"
            
        // sharing info:
            let tripCode = trip.tripCode
            let title = "我的游箱号:\(tripCode)"
            let msg = "我的游箱号:\(tripCode) \n【\(monthAndDayString)】 \n【\(beginLocation)-\(endLocation)】"
            let url = "www.carryonex.com" // TODO: change this for link to appstore or inside app page;
            ShareManager.shared.SetupShareInfomation(shareMessage: msg, shareTitle:title, shareUrl:url)
        }
    }
    
    func orderListCarrierLockerButtonTapped(indexPath: IndexPath) {
        guard let cell = tableViewShiper.cellForRow(at: indexPath) as? OrderListCardShiperCell else { return }
        guard let id = cell.trip?.id else { return }
        cell.lockButton.isEnabled = false
        isFetching = true
        
        let isActive = (carrierTrips[indexPath.row].active == TripActive.active.rawValue)
        ApiServers.shared.postTripActive(tripId: "\(id)", isActive: !isActive, completion: { (success, error) in
            cell.lockButton.isEnabled = true
            self.isFetching = false
            if let err = error {
                print("error: cannot postTripActive by id, error = \(err)")
                let m = "哎呀暂时无法设置锁定状态，请保持网络连接，稍后再试。错误信息：\(err.localizedDescription)"
                self.displayGlobalAlert(title: "⚠️锁定失败", message: m, action: "朕知道了", completion: nil)
                return
            }
            ApiServers.shared.getTripActive(tripId: "\(id)", completion: { (tripActive, error) in
                if let err = error {
                    print("get error when get TripActive: err = \(err)")
                    let m = "您的账户登陆信息已过期，为保障您的数据安全，请重新登入以修改您的行程。"
                    self.displayGlobalAlert(title: "⛔️锁定失败", message: m, action: "重新登陆", completion: {
                        self.navigationController?.popToRootViewController(animated: false)
                        ProfileManager.shared.logoutUser()
                    })
                    return
                }
                let active = (tripActive == TripActive.active)
                cell.trip?.active = tripActive.rawValue
                cell.setupYouxiangLokcerStatus(isActive: active)
            })
        })
    }
}

/**
 * Set up title image for city > state > country
 */
extension OrderListViewController {
    
    fileprivate func setCityStringForImage(){
        if listType == .carrier {
            if let ct = carrierTrips.first?.endAddress?.city {
                cityStringForImage = (ct == "" ? cityStringDefault : ct)
                return
            }
        }
        if listType == .sender {
            if let ct = senderRequests.first?.endAddress?.city {
                cityStringForImage = (ct == "" ? cityStringDefault : ct)
                return
            }
        }
    }
    fileprivate func setStateStringForImage(){
        if listType == .carrier {
            if let st = carrierTrips.first?.endAddress?.state {
                cityStringForImage = (st == "" ? cityStringDefault : st)
            }else{
                cityStringForImage = cityStringDefault
            }
        }
        if listType == .sender {
            if let st = senderRequests.first?.endAddress?.state {
                cityStringForImage = (st == "" ? cityStringDefault : st)
            }else{
                cityStringForImage = cityStringDefault
            }
        }
    }
    
    public func setTitleImage(){
        guard FlickrImageManager.shared.isStoreImageFilled() else {
            setCityStringForImage()
            loadImageUrlsOfCurrentCity()
            return
        }
        if let url = FlickrImageManager.shared.randomImageUrl() {
            imageTitleView.af_setImage(withURL: url)
        }
    }
    public func loadImageUrlsOfCurrentCity(){
        print(" ---- load image for: \(cityStringForImage)")
        FlickrImageManager.shared.getPhotoUrl(from: cityStringForImage) { (urls) in
            guard let urls = urls, let url = urls.first else {
                self.setStateStringForImage() // if unable to load city, try use state;
                print("----------- !!! load city failed, will set State..")
                return
            }
            self.imageTitleView.af_setImage(withURL: url)
        }
    }
    
    fileprivate func setupImageTimer(){
        if FlickrImageManager.shared.isStoreImageFilled(), (imageTimer?.isValid ?? false) { return }
        imageTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(setTitleImage), userInfo: nil, repeats: true)
    }

    
}

