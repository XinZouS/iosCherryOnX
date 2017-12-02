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
        
    }
    
    @IBAction func lockerButtonTapped(_ sender: Any) {
        setTripLockerStatus()
    }
    
    var trip: Trip!
    var requests = [Request]()
    var category: TripCategory = .carrier
    
    var isLocked: Bool = false
    
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

    static func storyboardViewController() -> OrdersYouxiangInfoViewController? {
        let storyboard = UIStoryboard.init(name: "OrdersYouxiangInfo", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "") as? OrdersYouxiangInfoViewController
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "游箱信息"
        navigationController?.isNavigationBarHidden = false
        
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
            self?.tableView.reloadData()
        }
    }
    
    func loadData() {
        requests = TripOrderDataStore.shared.getRequestsByTripId(category: .carrier, tripId: trip.id)
        
        //TODO: use trip.active parameter.
        self.isLocked = true
        self.lockerImageView.image = self.isLocked ? #imageLiteral(resourceName: "LockClosed") : #imageLiteral(resourceName: "LockOpened")
        self.lockerHintLabel.isHidden = !self.isLocked
        
        dateMonthLabel.text = trip.getMonthString()
        dateDayLabel.text = trip.getDayString()
        startAddressLabel.text = trip.startAddress?.fullAddressString()
        endAddressLabel.text = trip.endAddress?.fullAddressString()
        youxiangCodeLabel.text = trip.tripCode
    }
    
    private func setupLocker() {
        ApiServers.shared.getTripActive(tripId: "\(trip.id)") { (tripActiveStatus, error) in
            self.isLoading = false
            if tripActiveStatus == .error || tripActiveStatus == .notExist {
                let m = "您的账户登陆信息已过期，为保障您的数据安全，请重新登入以修改您的行程。"
                self.displayGlobalAlert(title: "⛔️锁定失败", message: m, action: "重新登陆", completion: {
                    self.navigationController?.popToRootViewController(animated: false)
                    ProfileManager.shared.logoutUser()
                })
            }
            self.isLocked = tripActiveStatus == TripActive.inactive
            self.lockerImageView.image = self.isLocked ? #imageLiteral(resourceName: "LockClosed") : #imageLiteral(resourceName: "LockOpened")
            self.lockerHintLabel.isHidden = !self.isLocked
        }
    }
    
    private func setTripLockerStatus(){
        lockerButton.isEnabled = false
        isLoading = true
        
        ApiServers.shared.postTripActive(tripId: "\(trip.id)", isActive: !isLocked) { (success, error) in
            self.lockerButton.isEnabled = true
            if let err = error {
                self.isLoading = false
                let m = "哎呀暂时无法设置锁定状态，请保持网络连接，稍后再试。错误信息：\(err.localizedDescription)"
                self.displayGlobalAlert(title: "⚠️锁定失败", message: m, action: "朕知道了", completion: nil)
                return
            }
            if success {
                // isLoading=F in setupLockerForTrip()
                self.isLocked = !self.isLocked
                self.setupLocker()
            }
        }
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersYouxiangInfoCell", for: indexPath) as? OrdersYouxiangInfoCell {
                cell.selectionStyle = .none
                cell.cellCategory = category
                cell.request = requests[indexPath.row]
                return cell
            }
            
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersYouxiangInfoEmptyCell", for: indexPath) as? OrdersYouxiangInfoEmptyCell {
                cell.selectionStyle = .none
                cell.trip = trip
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
}

extension OrdersYouxiangInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if requests.count == 0 { return }
        performSegue(withIdentifier: "gotoOrdersRequestDetailSegue", sender: requests[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? OrdersRequestDetailViewController, let request = sender as? Request {
            detailVC.trip = trip
            detailVC.request = request
            detailVC.category = category
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if requests.count == 0 {
            return 233 // empty cell
        }
        return 170 // request cell
    }
    
}

