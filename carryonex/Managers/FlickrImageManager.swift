//
//  FlickrImageManager.swift
//  carryonex
//
//  Created by Xin Zou on 11/16/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import MapKit
import FlickrKit
import AlamofireImage

class FlickrImageManager {
    
    static let shared = FlickrImageManager()
    
    private let flickrInterestingList = FKFlickrInterestingnessGetList()
    
    
    private init(){
        flickrInterestingList.per_page = "15"
    }
    
//    public func loadFlickrImagesFromLocation(bottomLeft: CLLocationCoordinate2D, topRight: CLLocationCoordinate2D, complection: (Bool, NSArray) -> Void){ // success, entries
//        let baseUrl = buildFlickrSearchUrl()
//    }
//    
//    private func buildFlickrSearchUrl(from startLoc: CLLocationCoordinate2D, to endLoc: CLLocationCoordinate2D) -> NSString {
//        
//    }
    
    public func getPhotoUrl(){
        /*
        FlickrKit.shared().call(flickrInterestingList) { (resopnse, error) in
            DispatchQueue.main.async(execute: {
                if let response = resopnse {
                    guard let topPhotos = resopnse!["photos"] as? [String: AnyObject],
                        let photoArray = topPhotos["photo"] as? [[NSObject: AnyObject]] else { return }
                    if photoArray.count > 0 {
                        let photoUrl = FlickrKit.shared().photoURL(for: FKPhotoSize.large1600, fromPhotoDictionary: photoArray[0])
                    }
                }
            })
        }
         */
    }
    
}
