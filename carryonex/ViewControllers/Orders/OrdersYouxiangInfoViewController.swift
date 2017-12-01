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
    }
    
    var tripOrder: TripOrder? {
        didSet{
            setupUIforTripOrder()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView() // remove empty lines
    }
    
    private func setupUIforTripOrder(){
        guard let t = tripOrder else { return }
        setupTripDateLabels(t.trip.pickupDate)
        setupTripCodeAddressLabels(trip: t.trip)
    }
    
    private func setupTripDateLabels(_ d: Double?){
        guard let d = d else { return }
        let date = Date(timeIntervalSince1970: d)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd YYYY"
        
        let userCalendar = Calendar.current
        let requestdComponents: Set<Calendar.Component> = [.year, .month, .day]
        let dateComponents = userCalendar.dateComponents(requestdComponents, from: date)
        //BUG: nil
        //dateMonthLabel.text = formatter.shortMonthSymbols.first
        //dateDayLabel.text = "\(dateComponents.day ?? 0)"
    }
    
    private func setupTripCodeAddressLabels(trip: Trip){
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
    
}

