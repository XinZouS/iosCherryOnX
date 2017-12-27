//
//  AddressSearchController.swift
//  carryonex
//
//  Created by Xin Zou on 8/31/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import MapKit



enum AddressSearchType {
    case requestStarting, requestDestination, tripStarting, tripDestination
}

class AddressSearchController : UIViewController, UISearchResultsUpdating, UIGestureRecognizerDelegate {
    
    // must setup the type when the controller init!!!
    var searchType : AddressSearchType! {
        didSet{
            setupSearchBarPlaceholder()
        }
    }
    
    var address = Address()
    
    var request: Request?
    var trip   : Trip?
    
    // its parent controller, for now we dont need it
//    weak var requestCtl : RequestController? {
//        didSet{
//            //self.request = requestCtl?.request
//        }
//    }
    
    let mapView : MKMapView = {
        let m = MKMapView()
        m.translatesAutoresizingMaskIntoConstraints = false
        m.isRotateEnabled = false
        m.showsCompass = false
        return m
    }()

    var selectedPin : MKPlacemark? = nil
    
    internal let locationManager = CLLocationManager()
    
    var searchContainerView = UIView()
    var searchBar : UISearchBar?
    var searchController : UISearchController?
    
    
    lazy var targetCurrentLocationButton : UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(targetCurrentLocBtnTapped), for: .touchUpInside)
        b.setImage(#imageLiteral(resourceName: "carryonex_locationIcon"), for: .normal)
        return b
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupLocationManager()
        setupMapView()
        setupSearchView()
        setupSearchBar()
        setupSearchBarPlaceholder()
        setupGestureRecognizer()
        setupTargetCurrentLocationButton()
        
        setupAddressReferences()
    }
    
    private func setupNavigationBar(){
        title = "搜索地址"
    }
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    private func setupSearchView(){
        let locationSearchTable = LocationSearchTableController()
        searchController = UISearchController(searchResultsController: locationSearchTable)
        searchController?.searchResultsUpdater = locationSearchTable
        searchController?.hidesNavigationBarDuringPresentation = false
        searchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        locationSearchTable.mapView = self.mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    private func setupSearchBar(){
        view.addSubview(searchContainerView)
        searchContainerView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 56)
        
        searchBar = searchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.setValue("取消", forKey:"_cancelButtonText")
        searchBar?.backgroundImage = UIImage() // this will make its background=.clear
        searchContainerView.addSubview((searchController?.searchBar)!)
    }
    
    private func setupSearchBarPlaceholder(){
        var placeholderStr = "placeholder"
        switch self.searchType {
        case .requestStarting:
            placeholderStr = "请选择您的发件地点"
        case .requestDestination:
            placeholderStr = "请选择货物目的地"
        case .tripStarting:
            placeholderStr = "请选择您的出发地"
        case .tripDestination:
            placeholderStr = "请选择旅行目的地"
        default:
            placeholderStr = "搜索地址"
        }
        searchBar?.placeholder = placeholderStr
    }

    
    private func setupMapView(){
        view.addSubview(mapView)
        mapView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        zoomToUserLocation()
    }
    
    private func setupGestureRecognizer(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnMap))
        tapRecognizer.delegate = self
        mapView.addGestureRecognizer(tapRecognizer)
    }
    
    private func setupTargetCurrentLocationButton(){
        view.addSubview(targetCurrentLocationButton)
        targetCurrentLocationButton.addConstraints(left: nil, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 20, bottomConstent: 20, width: 50, height: 50)
    }
    
    
}




