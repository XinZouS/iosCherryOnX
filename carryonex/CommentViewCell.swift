//
//  CommentViewCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/30.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class CommentViewCell : CommentBaseCell {
    
    let commentStateLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "非常好"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    
    var starCommentView: UIStackView?
    var tagCommentView: UIStackView?
    
    let StarCommentBtn1 :UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Logo"), for: .normal)
        return b
    }()
    let StarCommentBtn2 :UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Logo"), for: .normal)
        return b
    }()
    let StarCommentBtn3 :UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Logo"), for: .normal)
        return b
    }()
    let StarCommentBtn4 :UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Logo"), for: .normal)
        return b
    }()
    let StarCommentBtn5 :UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Logo"), for: .normal)
        return b
    }()
    
    let TagCommentBtn1 :UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 10
        b.setTitle("神速", for: .normal)
        b.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        b.layer.masksToBounds = true
        return b
    }()
    let TagCommentBtn2 :UIButton = {
        let b = UIButton()
        b.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        b.layer.cornerRadius = 10
        b.setTitle("超级细心", for: .normal)
        b.layer.masksToBounds = true
        return b
    }()
    let TagCommentBtn3 :UIButton = {
        let b = UIButton()
        b.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        b.layer.cornerRadius = 10
        b.setTitle("骗子", for: .normal)
        b.layer.masksToBounds = true
        return b
    }()
    let TagCommentBtn4 :UIButton = {
        let b = UIButton()
        b.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        b.layer.cornerRadius = 10
        b.setTitle("善于沟通", for: .normal)
        b.layer.masksToBounds = true
        return b
    }()
    let TagCommentBtn5 :UIButton = {
        let b = UIButton()
        b.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        b.layer.cornerRadius = 10
        b.setTitle("很有责任心", for: .normal)
        b.layer.masksToBounds = true
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupCommentStateLabel()
        setupStarCommentView()
    }
    private func setupCommentStateLabel(){
        addSubview(commentStateLabel)
        commentStateLabel.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: 150, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = commentStateLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupStarCommentView(){
        let w : CGFloat = 46, h : CGFloat = 46, l : CGFloat = 0
        let v1 = UIView(), v2 = UIView(), v3 = UIView(), v4 = UIView(),v5 = UIView()
        v1.addSubview(StarCommentBtn1)
        v2.addSubview(StarCommentBtn2)
        v3.addSubview(StarCommentBtn3)
        v4.addSubview(StarCommentBtn4)
        v5.addSubview(StarCommentBtn5)
        StarCommentBtn1.addConstraints(left: nil, top: v1.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        StarCommentBtn2.addConstraints(left: nil, top: v2.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        StarCommentBtn3.addConstraints(left: nil, top: v3.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        StarCommentBtn4.addConstraints(left: nil, top: v4.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        StarCommentBtn5.addConstraints(left: nil, top: v5.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        StarCommentBtn1.centerXAnchor.constraint(equalTo: v1.centerXAnchor).isActive = true
        StarCommentBtn2.centerXAnchor.constraint(equalTo: v2.centerXAnchor).isActive = true
        StarCommentBtn3.centerXAnchor.constraint(equalTo: v3.centerXAnchor).isActive = true
        StarCommentBtn4.centerXAnchor.constraint(equalTo: v4.centerXAnchor).isActive = true
        StarCommentBtn5.centerXAnchor.constraint(equalTo: v5.centerXAnchor).isActive = true
        
        
        starCommentView = UIStackView(arrangedSubviews: [v1, v2, v3, v4,v5])
        starCommentView?.axis = .horizontal
        starCommentView?.distribution = .fillEqually
        
        addSubview(starCommentView!)
        starCommentView?.addConstraints(left: leftAnchor, top: commentStateLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 20, topConstent: 20, rightConstent: 20, bottomConstent: 0, width: 0, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

