//
//  RegisterMainController++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/13.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

extension RegisterMainController: UITextFieldDelegate {
    
    func textFieldsInAllCellResignFirstResponder(){
        let phoneNumberCtl = PhoneNumberController()
        navigationController?.pushViewController(phoneNumberCtl, animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard touches.first != nil else { return }
        
        textFieldsInAllCellResignFirstResponder()
        
    }
}
