//
//  YouxiangCell++.swift
//  carryonex
//
//  Created by Xin Zou on 8/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



extension YouxiangCell {
    
    
    func textFieldDidChange(_ textField: UITextField) {
        guard let tx = textField.text else { return }
        
        hintString = tx
        if tx == "666" {
            print("get 666!!!!!! then requestController?.getTripInfoBy(youxiangCode: tx)")
            requestController?.getTripInfoBy(youxiangCode: tx)
        }
        
    }
    
    func hintLabelAnimation(){
        UIView.animate(withDuration: 0.35) {
            self.layoutIfNeeded()
        }
    }
    
    
    
}
