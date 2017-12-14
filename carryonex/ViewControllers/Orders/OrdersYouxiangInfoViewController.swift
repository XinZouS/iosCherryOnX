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
        lockerButton.isEnabled = false
        isLoading = true
        
        let id = trip.id
        //isActive = (trip.active == TripActive.active.rawValue)
        ApiServers.shared.postTripActive(tripId: "\(id)", isActive: toLock, completion: { (success, error) in
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
            displayGlobalAlertActions(title: "⚠️分享游箱？", message: "您的游箱已锁，请先解锁再分享。", actions: ["保持锁定","解锁并分享"], completion: { (tag) in
                if tag == 1 { // unlock and share
                    self.setTripToLocked(true, completion: {
                        self.shareYouxiangCode()
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
