//
//  LocationSearchTableController.swift
//  carryonex
//
//  Created by Xin Zou on 9/21/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import MapKit


// reference: https://www.thorntech.com/2016/01/how-to-search-for-location-using-apples-mapkit/


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class LocationSearchTableController : UITableViewController {
    
//    weak var homePageController : HomePageController?
    weak var requestController  : RequestController?
//    weak var postTripController : PostTripController?
    
    var handleMapSearchDelegate : HandleMapSearch?
    
    var matchingItems: [MKMapItem] = [] {
        didSet{
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    var mapView: MKMapView? = nil

    
    var tableViewHeightConstraint: NSLayoutConstraint?
    let tableViewHeigh : CGFloat = UIScreen.main.bounds.height / 2.0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
    }
    
    
    private func setupTableView(){
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "mapSearchCellId")
//        tableView.addConstraints(left: view.leftAnchor, top: view.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 6, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
//        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 300)
//        tableViewHeightConstraint?.isActive = true
        //tableView.contentInset = UIEdgeInsetsMake(100, 70, 200, 70) this will NOT work!!! // t, l, b, r
        //tableView.layer.masksToBounds = true
        
        tableView.keyboardDismissMode = .interactive
        tableView.backgroundColor = .white
    }

    
    // MARK: - tableView func
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "mapSearchCellId")
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "reuseIdentifier")
        }
        let selectedItem = matchingItems[indexPath.row].placemark
        //print(selectedItem)
        cell!.textLabel?.text = selectedItem.name
        cell!.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
        cell!.backgroundColor = .white
        return cell!
    }
    
    
    // MARK: - update for search results
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row].placemark
        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem)
        dismiss(animated: true, completion: nil)
        
//        if let homePage = homePageController {
//            let loc = selectedItem.coordinate
//            let viewRegion = MKCoordinateRegionMakeWithDistance(loc, 200, 200)
//            homePage.mapView.setRegion(viewRegion, animated: false)
//        }
    }
    
}




