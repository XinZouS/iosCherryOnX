//
//  AddressBaseCell++.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension AddressBaseCell {
    
    
    
    func buttonTapped(){
        switch(addressCtl.indexOfCountry){
        case 0:
            addressCtl.indexOfCountry = 1;
            selectedLabel.text = "United State"
            addressCtl.selectCountry()
        case 1:
            addressCtl.indexOfCountry = 0;
            selectedLabel.text = "中国大陆"
            addressCtl.selectCountry()
        default:
            break;
        }
    }
}
