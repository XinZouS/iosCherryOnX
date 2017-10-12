//
//  ItemCategory.swift
//  carryonex
//
//  Created by Xin Zou on 8/19/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

 

enum ItemIdEnums: String {
    case mail       = "Mail"
    case clothes    = "Clothes"
    case shoes      = "Shoes"
    case handbag    = "Handbag"
    case food       = "Food"
    case healthCare = "Health Care"
    case electronics = "Electronics"
    case cosmetic   = "Cosmetics"
    case jewelry    = "Jewelry"
}



class ItemCategory: NSObject {
    
    /// for Server API use. Local ID using nameEN for Dictionary key.
    var id : String!
    
    var nameCN : String?
    var nameEN : String?
    
    var isEnable: Bool?
    
    var icon   : UIImage?
    
    var count : Int = 0 // for category page display and selection
    var prize : Double = 1.0 // parse to Int when upload to server
    
    
    
    // use: ItemCategory.sharedInstance.xxx
    static var sharedInstance = ItemCategory()  // This is singleton
    
    
    private override init() {
        super.init()
        
        nameCN = "类别？"
        nameEN = "category?"
        isEnable = true
        icon = #imageLiteral(resourceName: "CarryonEx_Logo")
        count = 0
        prize = 1.0
    }
    
    private init(nameCn: String, nameEn: String, iconImg: UIImage){
        nameCN = nameCn
        nameEN = nameEn
        icon = iconImg
        
        self.id = "id??"
    }
    
    
    /// TODO: get full list from server, then setup and present here

    public func getFullList() -> [ItemCategory] {
        print("TODO: get full list from server ...")
        let mail        = ItemCategory(nameCn: "信件", nameEn: ItemIdEnums.mail.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Mail"))
        let clothes     = ItemCategory(nameCn: "服装", nameEn: ItemIdEnums.clothes.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Clothes"))
        let shoes       = ItemCategory(nameCn: "鞋子", nameEn: ItemIdEnums.shoes.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Shoes"))
        let handbag     = ItemCategory(nameCn: "手袋", nameEn: ItemIdEnums.handbag.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Handbags"))
        let food        = ItemCategory(nameCn: "食品", nameEn: ItemIdEnums.food.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Food"))
        let healthCare  = ItemCategory(nameCn: "医疗保健品", nameEn: ItemIdEnums.healthCare.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Medicine"))
        let electronics = ItemCategory(nameCn: "电子产品", nameEn: ItemIdEnums.electronics.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Electronics"))
        let cosmetic    = ItemCategory(nameCn: "美妆用品", nameEn: ItemIdEnums.cosmetic.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Cosmetics"))
        let jewelry     = ItemCategory(nameCn: "饰品", nameEn: ItemIdEnums.jewelry.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Jewelry"))
        
        return [mail, clothes, shoes, handbag, food, healthCare, electronics, cosmetic, jewelry]
    }
    
    
    public func getFullMapById() -> [String : UIImage] {
        var mapImg : [String : UIImage] = [:]
        let list = getFullList()
        
        for item in list {
            mapImg[item.nameEN!] = item.icon!
        }
        return mapImg
    }
    
}


