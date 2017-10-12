//
//  ProvinceAndCityCell++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/9/28.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit


extension ProvinceAndCityCell:UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        addressCtl.transparentView.isHidden = false
        addressCtl.view.endEditing(true)
        addressCtl.areaPickerMenu?.showUpAnimation(withTitle: "选择市区")
    }
    
}
