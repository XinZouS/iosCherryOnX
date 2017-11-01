//
//  OrderCommentPage++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/30.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

extension OrderCommentPage {
    
    func textFieldDidBeginEditing(_ textView: UITextView) {
        transparentView.isHidden = false
        textView.becomeFirstResponder()
    }
    
    func textFieldsInAllCellResignFirstResponder(){
        transparentView.isHidden = true
        commentTextViewAndSubmmitCell?.commentTextView.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if touches.count > 0 {
            textFieldsInAllCellResignFirstResponder()
        }
    }
}
