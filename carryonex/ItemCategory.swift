//
//  ItemCategory.swift
//  carryonex
//
//  Created by Xin Zou on 8/19/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Unbox
 

enum ItemNameEN: String {
    case mail       = "Mail"
    case clothes    = "Clothes"
    case shoes      = "Shoes"
    case handbag    = "Handbag"
    case food       = "Food"
    case healthCare = "Health Care"
    case electronics = "Electronics"
    case book       = "Book"
    case cosmetic   = "Cosmetics"
    case jewelry    = "Jewelry"
    case other      = "Other"
}

enum CategoryKeyInDB: String {
    case id = "id"
    case description = "description"
    case nameCN = "cn_name"
    case nameEN = "name"
    case price  = "price"
}


class ItemCategory: Unboxable {
    
    /// for Server API use. Local ID using nameEN for Dictionary key.
    var id : String!
    var description: String?
    var nameCN : String?
    var nameEN : String?
    var icon   : UIImage?
    var count : Int = 0 // for category page display and selection
    var price : Double = 1.0 // parse to Int when upload to server
    
    
    
    private init() {
        nameCN = "类别？"
        nameEN = "category?"
        icon = #imageLiteral(resourceName: "CarryonEx_Logo")
        count = 0
        price = 1.0
    }
    
    public init(nameCn: String, nameEn: String, iconImg: UIImage){
        nameCN = nameCn
        nameEN = nameEn
        icon = iconImg
        
        self.id = "id??"
    }
    
    /// for info init from DB
    public init(id: String, description: String, nameCn: String, nameEn: String, count: Int, price: Double){
        self.id = id
        self.description = description
        self.nameCN = nameCn
        self.nameEN = nameEn
        self.icon = CategoryManager.shared.ItemIconByNameEN[nameEn]
        self.count = count
        self.price = price
    }

    
    required init(unboxer: Unboxer) throws {
        self.id         = try? unboxer.unbox(key: CategoryKeyInDB.id.rawValue)
        self.description = try? unboxer.unbox(key: CategoryKeyInDB.id.rawValue)
        self.nameCN     = try? unboxer.unbox(key: CategoryKeyInDB.id.rawValue)
        self.nameEN     = try? unboxer.unbox(key: CategoryKeyInDB.id.rawValue)
        self.icon       = CategoryManager.shared.ItemIconByNameEN[(try? unboxer.unbox(key: CategoryKeyInDB.id.rawValue)) ?? "Mail"]
        self.count      = 0
        self.price      = (try? unboxer.unbox(key: CategoryKeyInDB.price.rawValue)) ?? 1.0
    }
}


