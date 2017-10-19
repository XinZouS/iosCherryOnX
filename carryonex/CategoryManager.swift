//
//  CategoryManager.swift
//  carryonex
//
//  Created by Xin Zou on 10/19/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation


struct CategoryManager {
    
    static var shared = CategoryManager()
    
    let ItemIconByNameEN: [String:UIImage] = [
        ItemNameEN.mail.rawValue       : #imageLiteral(resourceName: "CarryonEx_Mail"),
        ItemNameEN.clothes.rawValue    : #imageLiteral(resourceName: "CarryonEx_Clothes"),
        ItemNameEN.shoes.rawValue      : #imageLiteral(resourceName: "CarryonEx_Shoes"),
        ItemNameEN.handbag.rawValue    : #imageLiteral(resourceName: "CarryonEx_Handbags"),
        ItemNameEN.food.rawValue       : #imageLiteral(resourceName: "CarryonEx_Food"),
        ItemNameEN.healthCare.rawValue : #imageLiteral(resourceName: "CarryonEx_Medicine"),
        ItemNameEN.electronics.rawValue: #imageLiteral(resourceName: "CarryonEx_Electronics"),
        ItemNameEN.cosmetic.rawValue   : #imageLiteral(resourceName: "CarryonEx_Cosmetics"),
        ItemNameEN.jewelry.rawValue    : #imageLiteral(resourceName: "CarryonEx_Jewelry")
    ]

    
    public func getFullMapById() -> [String : UIImage] {
        var mapImg : [String : UIImage] = [:]
        let list = getFullList()
        
        for item in list {
            mapImg[item.nameEN!] = item.icon!
        }
        return mapImg
    }
    

    public func getFullList() -> [ItemCategory] {
        print("TODO: get full list from server ...")
        let mail        = ItemCategory(nameCn: "信件", nameEn: ItemNameEN.mail.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Mail"))
        let clothes     = ItemCategory(nameCn: "服装", nameEn: ItemNameEN.clothes.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Clothes"))
        let shoes       = ItemCategory(nameCn: "鞋子", nameEn: ItemNameEN.shoes.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Shoes"))
        let handbag     = ItemCategory(nameCn: "手袋", nameEn: ItemNameEN.handbag.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Handbags"))
        let food        = ItemCategory(nameCn: "食品", nameEn: ItemNameEN.food.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Food"))
        let healthCare  = ItemCategory(nameCn: "医疗保健品", nameEn: ItemNameEN.healthCare.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Medicine"))
        let electronics = ItemCategory(nameCn: "电子产品", nameEn: ItemNameEN.electronics.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Electronics"))
        let cosmetic    = ItemCategory(nameCn: "美妆用品", nameEn: ItemNameEN.cosmetic.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Cosmetics"))
        let jewelry     = ItemCategory(nameCn: "饰品", nameEn: ItemNameEN.jewelry.rawValue, iconImg: #imageLiteral(resourceName: "CarryonEx_Jewelry"))
        
        return [mail, clothes, shoes, handbag, food, healthCare, electronics, cosmetic, jewelry]
    }
    

}
