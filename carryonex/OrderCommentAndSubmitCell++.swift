//
//  OrderCommentAndSubmitCell++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/1.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

extension CommentTextViewAndSubmitCell{
    func textViewDidBeginEditing(_ textView: UITextView) {
        orderCommentPage?.transparentView.isHidden = false
        commentTextView.becomeFirstResponder()
    }
}
