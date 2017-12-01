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
    
    @IBOutlet weak var tableView: UITableView!
    

    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func lockerButtonTapped(_ sender: Any) {
        setTripLockerStatus()
    }
    
    var tripOrder: TripOrder?
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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "游箱信息"
        navigationController?.isNavigationBarHidden = false
        setupTableView()
        setupUIforTripOrder()
        setupActivityIndicator()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // remove empty lines
    }
    
    private func setupUIforTripOrder(){
        guard let t = tripOrder else { return }
        setupTripDateLabels(t.trip.pickupDate)
        setupTripCodeAddressLabels(t.trip)
        setupLockerForTrip(t.trip)
    }
    
    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorCustomizeView()
        activityIndicator.center = view.center
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        view.addSubview(activityIndicator)
    }
    
    private func setupTripDateLabels(_ d: Double?){
        guard let d = d else { return }
        let date = Date(timeIntervalSince1970: d)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd YYYY"
        
        let userCalendar = Calendar.current
        let requestdComponents: Set<Calendar.Component> = [.year, .month, .day]
        let dateComponents = userCalendar.dateComponents(requestdComponents, from: date)
        dateMonthLabel.text = formatter.shortMonthSymbols.first
        dateDayLabel.text = "\(dateComponents.day ?? 0)"
    }
    
    private func setupTripCodeAddressLabels(_ trip: Trip){
        if let endCountry = trip.endAddress?.country?.rawValue,
            let endState = trip.endAddress?.state,
            let endCity = trip.endAddress?.city,
            let startCountry = trip.startAddress?.country?.rawValue,
            let startState = trip.startAddress?.state,
            let startCity = trip.startAddress?.city {
            
            endAddressLabel.text = endCountry + "，" + endState + "，" + endCity
            startAddressLabel.text = startCountry + "，" + startState + "，" + startCity
        }
        youxiangCodeLabel.text = String(trip.id)
    }
    
    private func setupLockerForTrip(_ t: Trip){
        ApiServers.shared.getTripActive(tripId: "\(t.id)") { (tripActiveStatus, error) in
            self.isLoading = false
            if tripActiveStatus == .error || tripActiveStatus == .notExist {
                let m = "您的账户登陆信息已过期，为保障您的数据安全，请重新登入以修改您的行程。"
                self.displayGlobalAlert(title: "⛔️锁定失败", message: m, action: "重新登陆", completion: {
                    self.navigationController?.popToRootViewController(animated: false)
                    ProfileManager.shared.logoutUser()
                })
            }
            self.isLocked = tripActiveStatus == TripActive.inactive
            let icon: UIImage = self.isLocked ? #imageLiteral(resourceName: "locker") : #imageLiteral(resourceName: "locker_unlock")
            self.lockerButton.setImage(icon, for: .normal)
        }
    }
    
    private func setTripLockerStatus(){
        guard let t = tripOrder else { return }
        lockerButton.isEnabled = false
        isLoading = true
        ApiServers.shared.postTripActive(tripId: "\(t.trip.id)", isActive: !isLocked) { (success, error) in
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
                self.setupLockerForTrip(t.trip)
            }
        }
    }

}



extension OrdersYouxiangInfoViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let t = tripOrder else {
            return 1 // for empty cell
        }
        guard let requests = t.requests, requests.count != 0 else {
            return 1 // for empty cell
        }
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tr = tripOrder else {
            return UITableViewCell()
        }
        if let requests = tr.requests, requests.count > 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersYouxiangInfoCell", for: indexPath) as? OrdersYouxiangInfoCell {
                cell.selectionStyle = .none
                cell.ordersYouxiangInfoVC = self
                cell.tripRequest = requests[indexPath.row]
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "OrdersYouxiangInfoEmptyCell", for: indexPath) as? OrdersYouxiangInfoEmptyCell {
                cell.selectionStyle = .none
                cell.ordersYouxiangInfoVC = self
                cell.trip = tripOrder?.trip
                return cell
            }
        }
        return UITableViewCell()
    }
    
}

extension OrdersYouxiangInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let requests = tripOrder?.requests, requests.count > 0 else { return }
        performSegue(withIdentifier: "gotoOrdersRequestDetailSegue", sender: requests[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? OrdersRequestDetailViewController,
            let req = sender as? Request,
            let trip = tripOrder?.trip {
            detailVC.trip = trip
            detailVC.request = req
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tripOrder == nil || tripOrder?.requests?.count == 0 {
            return 233 // empty cell
        }
        return 170 // request cell
    }
    
}

