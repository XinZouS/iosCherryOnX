//
//  CommentView++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/1.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

extension CommentViewCell{
    
    func starButton1Tapped(){
        StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn2.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        StarCommentBtn3.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        StarCommentBtn4.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        StarCommentBtn5.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        commentStateLabel.text = "很不满意"
    }
    func starButton2Tapped(){
        StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn2.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn3.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        StarCommentBtn4.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        StarCommentBtn5.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        commentStateLabel.text = "不太满意"
    }
    func starButton3Tapped(){
        StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn2.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn3.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn4.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        StarCommentBtn5.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        commentStateLabel.text = "一般"
    }
    func starButton4Tapped(){
        StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn2.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn3.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn4.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn5.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
        commentStateLabel.text = "好"
    }
    func starButton5Tapped(){
        StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn2.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn3.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn4.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        StarCommentBtn5.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
        commentStateLabel.text = "非常好"
    }
}
