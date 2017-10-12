//
//  ItemTypeListCell++.swift
//  carryonex
//
//  Created by Xin Zou on 9/25/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension ItemTypeListCell {
    
    func buttonMinusTapped(){
        guard let cnt = itemCategory?.count, cnt > 0 else { return }
        itemCategory.count -= 1
        countLabel.text = "\(itemCategory.count)"
        
        validateItemCategoryForSbmBtn()
    }
    
    func buttonAddTapped(){
        guard let cnt = itemCategory?.count, cnt < 10 else { return }
        itemCategory.count += 1
        countLabel.text = "\(itemCategory.count)"
        
        validateItemCategoryForSbmBtn()
    }
    

    private func validateItemCategoryForSbmBtn() {
        guard let currListOfItem = itemTypeListController.itemCategoryList else { return }

        var validate = false
        if currListOfItem.count == 0 { validate = false }
        for item in currListOfItem {
            if item.count > 0 {
                validate = true
                break
            }
        }
        
        itemTypeListController.submitButton.isEnabled = validate
        itemTypeListController.submitButton.backgroundColor = validate ? buttonThemeColor : UIColor.lightGray
    }
    
    
    
}
