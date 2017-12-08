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
    
    private let flickrKey = "c22c86842ebcfe756a2697225d13bcc7"
    private let flickrSecret = "8ae3a0ab3eb194ce"
    private var storedImageTripUrls: [URL]?
    private var storedImageRqstUrls: [URL]?
    private var tripIndex: Int = 0
    private var rqstIndex: Int = 0

    init() {
        FlickrKit.shared().initialize(withAPIKey: flickrKey, sharedSecret: flickrSecret)
    }
    
    func isStoreImageFilled(isTrip: Bool) -> Bool {
        if isTrip {
            if let urls = storedImageTripUrls {
                return urls.count > 0
            }
        } else {
            if let urls = storedImageRqstUrls {
                return urls.count > 0
            }
        }
        return false
    }
    
    func randomImageUrl(isTrip: Bool) -> URL? {
        if isTrip {
            if let storedImageTripUrls = storedImageTripUrls {
                let randomIndex = Int(arc4random_uniform(UInt32(storedImageTripUrls.count)))
                return randomIndex == 0 ? nil : storedImageTripUrls[randomIndex]
            }
        } else {
            if let urls = storedImageRqstUrls {
                let randomIndex = Int(arc4random_uniform(UInt32(urls.count)))
                return randomIndex == 0 ? nil : urls[randomIndex]
            }
        }
        return nil
    }
    
    func nextImageUrl(isTrip: Bool) -> URL? {
        if isTrip {
            if let urls = storedImageTripUrls, urls.count > 0 {
                tripIndex = (tripIndex + 1 >= urls.count) ? 0 : tripIndex + 1
                return urls[tripIndex]
            }
        } else {
            if let urls = storedImageRqstUrls, urls.count > 0 {
                rqstIndex = (rqstIndex + 1 >= urls.count) ? 0 : rqstIndex + 1
                return urls[rqstIndex]
            }
        }
        return nil
    }
    
    func getPhotoUrl(from place: String, isTrip: Bool, completion: @escaping ([URL]?) -> Void) {
        let photoSearch = FKFlickrPhotosSearch()
        photoSearch.per_page = "10"
        photoSearch.tags = place + ", city, famous" // [landmark, build, city, landscape]
        photoSearch.tag_mode = "all" // [all(and), any(or)]
        let fk = FlickrKit.shared()
        fk.call(photoSearch) { (response, error) in
            DispatchQueue.main.async(execute: {
                if let response = response, let photos = response["photos"] as? [String: Any], let photoDataArray = photos["photo"] as? [Any] {
                    //print(response)
                    //print(photos)
                    //print(photoDataArray)
                    var urlArray = [URL]()
                    photoDataArray.forEach({ (photoData) in
                        if let photoData = photoData as? [String: Any] {
                            let url = fk.photoURL(for: .medium800, fromPhotoDictionary: photoData)
                            urlArray.append(url)
                        }
                    })
                    if isTrip {
                        self.storedImageTripUrls = urlArray
                    } else {
                        self.storedImageRqstUrls = urlArray
                    }
                    completion(urlArray)
                }
            })
        }
    }
}
