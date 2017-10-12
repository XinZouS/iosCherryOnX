//
//  getCityPlist.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/9/27.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

@objc class Place: NSObject {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    
    static func getPlaces() -> [Place] {
        guard let path = Bundle.main.path(forResource: "city", ofType: "plist"), let array = NSArray(contentsOfFile: path) else { return [] }
        
        var province = [province]()
        
        for item in array {
            let dictionary = item as? [String : Any]
            
            let province = Place(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2DMake(latitude, longitude))
            places.append(place)
        }
        
        return places as [Place]
    }
}
