//
//  OrdersYouxiangInfoViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/29/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class OrdersYouxiangInfoViewController: UIViewController {
    
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var dateDayLabel: UILabel!
    @IBOutlet weak var youxiangCodeLabel: UILabel!
    @IBOutlet weak var startAddressLabel: UILabel!
    @IBOutlet weak var endAddressLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var lockerButton: UIButton!
    @IBOutlet weak var lockerImageView: UIImageView!
    @IBOutlet weak var lockerHintLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        shareYouxiangCode()
    }
    
    @IBAction func lockerButtonTapped(_ sender: Any) {
        setTripToLocked(!isActive, completion: nil)
    }
    
    var trip: Trip!
    var requests = [Request]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    var isActive = true
    var category: TripCategory = .carrier
    
    var activityIndicator: UIActivityIndicatorCustomizeView!
    var isLoading: Bool = false {
        didSet{
            if isLoading {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    var sharingAlertVC: UIAlertController?
    
    let infoCellId = "OrdersYouxiangInfoCell"
    let emptyCellId = "OrdersYouxiangInfoEmptyCell"
    let orderRequestDetailSegueId = "gotoOrdersRequestDetailSegue"
    let emptyCellDelegate = self

    static func storyboardViewController() -> OrdersYouxiangInfoViewController? {
        let storyboard = UIStoryboard.init(name: "OrdersYouxiangInfo", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "") as? OrdersYouxiangInfoViewController
        return viewController
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = L("orders.ui.title.youxiang-info")
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black] // Title color
        
        //Setup table view
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // remove empty lines
        
        //Setup activity indicator
        activityIndicator = UIActivityIndicatorCustomizeView()
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
        
        loadData()
        
        NotificationCenter.default.addObserver(forName: Notification.Name.TripOrderStore.StoreUpdated, object: nil, queue: nil) { [weak self] _ in
            self?.loadData()
        }
    }
    
    func loadData() {
        requests = TripOrderDataStore.shared.getRequestsByTripId(category: .carrier, tripId: trip.id)
        
        print("Number of requests in trip \(trip.id): \(requests.count)")
        
        isActive = (trip.active == TripActive.active.rawValue)
        lockerImageView.image = isActive ? #imageLiteral(resourceName: "LockOpened") : #imageLiteral(resourceName: "LockClosed")
        lockerHintLabel.isHidden = isActive
        
        dateMonthLabel.text = trip.getMonthString()
        dateDayLabel.text = trip.getDayString()
        startAddressLabel.text = trip.startAddress?.fullAddressString()
        endAddressLabel.text = trip.endAddress?.fullAddressString()
        youxiangCodeLabel.text = trip.tripCode
    }
    
    private func setTripToLocked(_ toLock: Bool, completion: (() -> Void)?){
        if isActive {
            displayGlobalAlertActions(title: L("orders.confirm.title.lock"), message: L("orders.confirm.message.lock"), actions: [L("orders.confirm.action.lock"),L("action.cancel")], completion: { (tag) in
                if tag == 0 { // do lock;
                    self.setYouxiangLockStatusAt(id: self.trip.id, toActive: false, completion: completion)
                } else {
                    return // cancel to lock;
                }
            })
        } else { // do unlock;
            setYouxiangLockStatusAt(id: trip.id, toActive: true, completion: completion)
        }
    }
    
    private func setYouxiangLockStatusAt(id: Int, toActive: Bool, completion: (() -> Void)?) {
        lockerButton.isEnabled = false
        isLoading = true

        ApiServers.shared.postTripActive(tripId: "\(id)", isActive: toActive, completion: { (success, error) in
            self.isLoading = false
            self.lockerButton.isEnabled = true
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
                self.isActive = (tripActive == TripActive.active)
                self.trip?.active = tripActive.rawValue
                self.lockerImageView.image = self.isActive ? #imageLiteral(resourceName: "LockOpened") : #imageLiteral(resourceName: "LockClosed")
                self.lockerHintLabel.isHidden = self.isActive
                completion?()
            })
        })
    }
    
    
    func shareYouxiangCode() {
        guard isActive else {
            self.displayGlobalAlertActions(title: L("orders.error.title.share"),
                                           message: L("orders.error.message.share"),
                                           actions: [L("orders.error.action.share-lock"), L("orders.error.action.share-unlock")],
                                           completion: { [weak self] (tag) in
                if tag == 1 { // unlock and share
                    self?.setTripToLocked(true, completion: {
                        self?.shareYouxiangCode()
                    })
                }
            })
            return
        }
        
        sharingAlertVC = ShareViewFactory().setupShare(self, trip: trip)
        
        if UIDevice.current.userInterfaceIdiom != .phone {
            sharingAlertVC?.popoverPresentationController?.sourceView = self.startAddressLabel
        }
        
        self.present(self.sharingAlertVC!, animated: true, completion:{})
    }

}


extension OrdersYouxiangInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if requests.count == 0 {
            return 1
        }
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if requests.count > 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: infoCellId, for: indexPath) as? OrdersYouxiangInfoCell {
                cell.selectionStyle = .none
                cell.cellCategory = category
                
                let request = requests[indexPath.row]
                
                cell.request = request
                if let reqImage = request.images.first,
                    let imageUrl = URL(string: reqImage.imageUrl) {
                    
                    cell.itemImageButton.af_setImage(for: .normal, url: imageUrl)
                }
                return cell
            }
            
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: emptyCellId, for: indexPath) as? OrdersYouxiangInfoEmptyCell {
                cell.selectionStyle = .none
                cell.trip = trip
                cell.emptyCellDelegate = self
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}

extension OrdersYouxiangInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if requests.count == 0 { return }
        performSegue(withIdentifier: orderRequestDetailSegueId, sender: requests[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? OrdersRequestDetailViewController, let request = sender as? Request {
            detailVC.trip = trip
            detailVC.request = request
            detailVC.category = .carrier
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if requests.count == 0 {
            return 233 // empty cell
        }
        return 170 // request cell
    }
    
}

extension OrdersYouxiangInfoViewController: OrdersYouxiangInfoEmptyCellDelegate {
    
    func shareButtonInPageTapped(){
        shareYouxiangCode()
    }
    
}
