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
    
    let orderRequestDetailSegueId = "gotoOrdersRequestDetailSegue"

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
        
        let active: Bool = (trip.active == TripActive.active)
        lockerImageView.image = active ? #imageLiteral(resourceName: "LockOpened") : #imageLiteral(resourceName: "LockClosed")
        lockerHintLabel.isHidden = active
        
        dateMonthLabel.text = trip.getMonthString()
        dateDayLabel.text = trip.getDayString()
        startAddressLabel.text = trip.startAddress?.fullAddressString()
        endAddressLabel.text = trip.endAddress?.fullAddressString()
        youxiangCodeLabel.text = trip.tripCode
    }
    
    private func setupYouxiangLokcerStatus(isActive: Bool){
        lockerImageView.image = isActive ? #imageLiteral(resourceName: "LockOpened") : #imageLiteral(resourceName: "LockClosed")
        lockerHintLabel.isHidden = isActive
    }
    
    private func setTripLockerStatus(){
        lockerButton.isEnabled = false
        isLoading = true
        
        let id = trip.id
        let isActive = (trip.active == TripActive.active)
        ApiServers.shared.postTripActive(tripId: "\(id)", isActive: !isActive, completion: { (success, error) in
            self.isLoading = false
            self.lockerButton.isEnabled = true
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
                self.trip?.active = tripActive
                self.setupYouxiangLokcerStatus(isActive: active)
            })
        })
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
                
                let request = requests[indexPath.row]
                
                cell.request = request
                if let reqImage = request.images.first,
                    let imageUrl = URL(string: reqImage.imageUrl) {
                    
                    cell.itemImageButton.af_setImage(for: .normal, url: imageUrl)
                }
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
        performSegue(withIdentifier: orderRequestDetailSegueId, sender: requests[indexPath.row])
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

