//
//  CommentTextviewAndSubmitCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/31.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//
import UIKit
import Material

class CommentTextViewAndSubmitCell : CommentBaseCell {
    
    let commentTextView : TextView = {
        let t = TextView()
        t.borderWidth = 2
        t.borderColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        t.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        t.layer.cornerRadius = 10
        t.placeholder = "写入您对本次带货的评价吧~"
        return t
    }()
    let submitButton : UIButton = {
        let b = UIButton()
        b.setTitle("提交", for: .normal)
        b.layer.cornerRadius = 10
        b.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCommentView()
        setupSubmitBtn()
        backgroundColor = .white
        
    }
    private func setupCommentView(){
        addSubview(commentTextView)
        commentTextView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 50, width: 0, height: 0)
    }
    private func setupSubmitBtn(){
        addSubview(submitButton)
        submitButton.addConstraints(left: nil, top: commentTextView.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 10, bottomConstent: 0, width: 60, height: 40)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



