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
    private var storedImageUrls: [URL]?
    
    init() {
        FlickrKit.shared().initialize(withAPIKey: flickrKey, sharedSecret: flickrSecret)
    }
    
    func isStoreImageFilled() -> Bool {
        if let storedImageUrls = storedImageUrls {
            return storedImageUrls.count > 0
        }
        return false
    }
    
    func randomImageUrl() -> URL? {
        if let storedImageUrls = storedImageUrls {
            let randomIndex = Int(arc4random_uniform(UInt32(storedImageUrls.count)))
            return randomIndex == 0 ? nil : storedImageUrls[randomIndex]
        }
        return nil
    }
    
    func getPhotoUrl(from place: String, completion: @escaping ([URL]?) -> Void) {
        let photoSearch = FKFlickrPhotosSearch()
        photoSearch.per_page = "10"
        photoSearch.tags = place + ",landmark,city" // [landmark, build, street, city, landscape]
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
                    self.storedImageUrls = urlArray
                    completion(urlArray)
                }
            })
        }
    }
}
