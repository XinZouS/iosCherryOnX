//
//  AddressDetailController++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/9/27.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit


extension AddressDetailCell{
    
     func textViewDidBeginEditing(_ textView: UITextView) {
        addressCtl.transparentView.isHidden = false
        textView.becomeFirstResponder()
    }
    
}
