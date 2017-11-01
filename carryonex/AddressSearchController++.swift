//
//  AddressSearchController++.swift
//  carryonex
//
//  Created by Xin Zou on 9/3/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import MapKit


extension AddressSearchController : CLLocationManagerDelegate, HandleMapSearch {
    
    func zoomToUserLocation(){
        
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true
        mapView.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
        locationManager.requestLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        // zoom in to user location
        guard let loc = locationManager.location?.coordinate else { return }
        let viewRegion = MKCoordinateRegionMakeWithDistance(loc, 600, 600)
        mapView.setRegion(viewRegion, animated: false)
        
        // not yet setup any address, then show current GPS location
        if request?.departureAddress == nil && request?.destinationAddress == nil &&
            postTripCtl?.addressStarting == nil && postTripCtl?.addressDestinat == nil {
            DispatchQueue.main.async {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    

    // CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    // this will reset region every 1 sec:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.03, 0.03)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
            locationManager.stopUpdatingLocation()
        }
    }
    
    func targetCurrentLocBtnTapped(){
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("errorroro: AddressSearchController++: locationManager(didFailWithError), err = \(error)")
        displayAlert(title: "无法获取GPS", message: "定位失败，请打开您的GPS。错误信息：\(error)", action: "朕知道了")
    }
    // for UISearchResultsUpdating delegate
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    

    
    /// HandleMapSearch delegate:
    func dropPinZoomIn(placemark:MKPlacemark){
        locationManager.stopUpdatingLocation()
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        // save address info from placemark:
        address.coordinateLatitude  = placemark.coordinate.latitude
        address.coordinateLongitude = placemark.coordinate.longitude
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            saveAddressInfoBy(placemark)
            annotation.subtitle = address.country == .China ? "\(state) \(city)" : "\(city) \(state)"
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true) // show the detail view and button after drop pin
        }else{ // cannot get placemark dictionary, need to convert
            saveAddressDictionaryAt(coordinate: placemark.coordinate, toSet: annotation)
        }

        DispatchQueue.main.async {
            let span = MKCoordinateSpanMake(0.005, 0.005)
            let region = MKCoordinateRegionMake(placemark.coordinate, span)
            self.mapView.setRegion(region, animated: true)
        }
    }

    private func saveAddressInfoBy(_ placemark : MKPlacemark){
        guard let addressDictionary = placemark.addressDictionary else { return }
        
        address.country = (addressDictionary["CountryCode"] as! String) == "US" ? Country.UnitedStates : Country.China
        address.state = addressDictionary["State"] as? String
        address.city = addressDictionary["City"] as? String
        address.detailAddress = addressDictionary["Street"] as? String
        address.zipcode = addressDictionary["ZIP"] as? String
        address.recipientName = ""
        address.phoneNumber = ""
        address.coordinateLatitude  = placemark.coordinate.latitude
        address.coordinateLongitude = placemark.coordinate.longitude
        
        print("do saveAddressInfoBy placemark, add = ", address.descriptionString())
    }
    
    
    private func saveAddressDictionaryAt(coordinate: CLLocationCoordinate2D, toSet annotation: MKPointAnnotation){
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) -> Void in
            
            guard let placeArray = placemarks as [CLPlacemark]!, placeArray.count != 0 else {
                self.displayAlert(title: "‼️找不到地图信息", message: "地图加载失败。请确保手机有网络信号并打开GPS。", action: "OK")
                return
            }
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placeArray[0]
            
            // Address dictionary
            //print(placeMark.addressDictionary)
            
            //self.saveAddressInfoBy(placeMark as! MKPlacemark) --> this is an ERROR!!! Do it as following:
            let country = placeMark.addressDictionary?["CountryCode"] as? String ?? "US"
            let st = placeMark.addressDictionary?["State"] as? String ?? "state"
            let ct = placeMark.addressDictionary?["City"] as? String ?? "city"
            let zp = placeMark.addressDictionary?["ZIP"] as? String ?? "zip"
            let dt = placeMark.addressDictionary?["Thoroughfare"] as? String ?? "street" //street
            
            self.address.country = (country == "US") ? Country.UnitedStates : Country.China
            self.address.state = st
            self.address.city = ct
            self.address.zipcode = zp
            self.address.detailAddress = dt

            if let locationName = placeMark.addressDictionary?["Name"] as? String {
                self.address.detailAddress = locationName
                //print("get locationName = \(locationName), address.detailAddress = \(self.address.detailAddress)")
                annotation.title = (country == "US") ? locationName : dt // dt: detailAdd for China only
            }
            annotation.subtitle = (country == "US") ? "\(st) \(ct)" : "\(ct) \(st)"
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true) // show the detail view and button after drop pin
        }
    }

    func handleTapOnMap(_ gestureRecognizer: UITapGestureRecognizer){
        let locationInView = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(locationInView, toCoordinateFrom: mapView)
        let pm = MKPlacemark(coordinate: coordinate)
        // add annotation:
        dropPinZoomIn(placemark: pm)
    }
    // for returning to change location address, relocate to the last selected address;
    internal func setupCurrentAddress(_ currAdd: Address){
        self.address = currAdd
        locateMapTo(self.address)
    }
    internal func locateMapTo(_ add: Address){
        let pm = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: add.coordinateLatitude, longitude: add.coordinateLongitude))
        dropPinZoomIn(placemark: pm)
    }

    
}



// setup pin on the Map: MKMapViewDelegate
extension AddressSearchController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        if annotation is MKUserLocation {
            return nil //return nil so map view draws "blue dot" for standard user location
        }
        let reusePinId = "HomeMapPinId"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reusePinId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reusePinId)
            pinView?.canShowCallout = true
            pinView?.animatesDrop = true
            
            let calloutButton = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
            //calloutButton.setBackgroundImage(#imageLiteral(resourceName: "CarryonExIcon-29"), for: .normal)
            calloutButton.setTitle("🆗", for: .normal)
            pinView?.rightCalloutAccessoryView = calloutButton
            pinView?.sizeToFit()
        }else{
            pinView?.annotation = annotation
        }
        
        return pinView
        
        // add left button on info view of pin
//        let sz = CGSize(width: 30, height: 30)
//        let button = UIButton(frame: CGRect(origin: .zero, size: sz))
//        button.setBackgroundImage(#imageLiteral(resourceName: "CarryonEx_A"), for: .normal)
//        //button.addTarget(self, action: #selector(getDirections), for: .touchUpInside) // driving nav API
//        pinView?.leftCalloutAccessoryView = button

//        return pinView
    }
    
    /// pinView buttonTapped:
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            DispatchQueue.main.async(execute: {
                self.updateAddressInfoToParentController()
            })            
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func updateAddressInfoToParentController(){
        guard let currType = self.searchType else { return }
        
        let st = address.state!, ct = address.city!
        var dt = address.detailAddress!
        let placeNames = dt.components(separatedBy: ",")
        dt = placeNames.first ?? ""
        
        //let addShort = address.country == Country.China ? "\(st), \(ct)" : "\(ct), \(st)"
        let add = address.country == Country.China ? "\(st), \(ct), \(dt)" : "\(dt), \(ct), \(st)"
        //let add = UIDevice.current.userInterfaceIdiom == .phone ? addShort : addLong
        switch currType {
        case AddressSearchType.requestStarting:
            requestCtl?.request.departureAddress = self.address
            requestCtl?.setupStartingAddress(string: add)
        
        case AddressSearchType.requestDestination:
            requestCtl?.request.destinationAddress = self.address
            requestCtl?.setupDestinationAddress(string: add)
            
        case AddressSearchType.tripStarting:
            postTripCtl?.addressStarting = self.address
            postTripCtl?.setupStartingAddress(string: add)
            
        case AddressSearchType.tripDestination:
            postTripCtl?.addressDestinat = self.address
            postTripCtl?.setupEndAddress(string: add)
        }
    }
    
}



extension AddressSearchController {
    
    internal func setupAddressReferences(){
        guard let currType = self.searchType else { return }
        
        switch currType {
            case AddressSearchType.requestStarting:
                if let currAdd = request?.departureAddress {
                    setupCurrentAddress(currAdd)
                    // }else{ // connect reference when address annotation OK button tapped
                    // self.request?.destinationAddress = self.address
                }
            
            case AddressSearchType.requestDestination:
                if let currAdd = request?.destinationAddress {
                    setupCurrentAddress(currAdd)
                }
            
            case AddressSearchType.tripStarting:
                if let currAdd = postTripCtl?.addressStarting {
                    setupCurrentAddress(currAdd)
                    // }else{
                    // self.postTripCtl?.addressStarting = self.address
                }
            
            case AddressSearchType.tripDestination:
                if let currAdd = postTripCtl?.addressDestinat {
                    setupCurrentAddress(currAdd)
                    // }else{
                    // self.postTripCtl?.addressDestinat = self.address
                }
        }
    }
}
