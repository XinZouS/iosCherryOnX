//
//  RegisterEmailController++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit


extension RegisterEmailController: UITextFieldDelegate {
     func okButtonTapped(){
        let registerPasswordCtl = RegisterPasswordController()
        navigationController?.pushViewController(registerPasswordCtl, animated: true)
    }
    
//    public func textFieldDidEndEditing(_ textField: UITextField) {
//        (textField as? ErrorTextField)?.isErrorRevealed = false
//    }
//    
//    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        (textField as? ErrorTextField)?.isErrorRevealed = false
//        return true
//    }
//    
//    
//    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        (textField as? ErrorTextField)?.isErrorRevealed = false
//    }
    
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        emailField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first else { return }

        textFieldsInAllCellResignFirstResponder()

    }
}
