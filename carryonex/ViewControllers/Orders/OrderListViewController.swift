//
//  OrderListViewController.swift
//  carryonex
//
//  Created by Zian Chen on 11/13/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderListViewController: UIViewController {
    
    var listType: TripCategory = .Carrier {
        didSet {
            dataSource = (listType == .Carrier) ? carrierDataSource : senderDataSource
            if let dataSource = dataSource, dataSource.count == 0 {
                fetchRequests()
            }
        }
    }
    
    var isFetching = false
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var dataSource: [TripOrder]? {
        didSet {
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    var carrierDataSource = [TripOrder]()
    var senderDataSource = [TripOrder]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        listType = .Carrier
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func handleDataSourceChanged(sender: UISegmentedControl) {
        if let category = TripCategory(rawValue: sender.selectedSegmentIndex) {
            listType = category
        }
    }
    
    func fetchRequests() {
        
        guard isFetching == false else { return }
        
        let offset = (listType == .Carrier) ? carrierDataSource.count : senderDataSource.count
        let page = 4
        
        isFetching = true
        ApiServers.shared.getUsersTrips(userType: listType, offset: offset, pageCount: page) { (tripOrders, error) in
            
            self.isFetching = false
            if let error = error {
                print("ApiServers.shared.getUsersTrips Error: \(error.localizedDescription)")
                return
            }
            
            if let tripOrders = tripOrders {
                if self.listType == .Carrier {
                    self.carrierDataSource.append(contentsOf: tripOrders)
                    self.dataSource = self.carrierDataSource
                } else {
                    self.senderDataSource.append(contentsOf: tripOrders)
                    self.dataSource = self.senderDataSource
                }
            }
        }
    }
    
}

extension OrderListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let requests = dataSource?[indexPath.section].requests else {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "OrderListCell", for: indexPath) as? OrderListCell {
            let request = requests[indexPath.row].request
            cell.request = request
            cell.cellType = listType
            request.printAllData()
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let tripOrders = dataSource else {
            return 0
        }
        return tripOrders.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let requests = dataSource?[section].requests else {
            return 0
        }
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableCell(withIdentifier: "OrderListHeaderCell") as? OrderListHeaderCell {
            headerView.trip = dataSource?[section].trip
            return headerView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}
