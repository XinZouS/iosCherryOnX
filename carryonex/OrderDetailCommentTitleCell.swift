//
//  OrderDetailCommentTitleCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class OrderDetailCommentTitleCell : OrderDetailCommentBaseCell {
    
    var CommentNumLabel : UILabel = {
        let l = UILabel()
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    
    var commentLevel: Int = 1 {
        didSet {
            for i in 0..<5 {
                let button = starCommentBtns[i]
                let starImage = (i < commentLevel) ?#imageLiteral(resourceName: "carryonex_star") : #imageLiteral(resourceName: "carryonex_unselectstar")
                button.setImage(starImage, for: .normal)
            }
        }
    }
    
    var starCommentView: UIStackView?
    
    lazy var starCommentBtns: [UIButton] = {
        var buttons = [UIButton]()
        for i in 0..<5 {
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "carryonex_unselectstar"), for: .normal)
            button.tag = i
            button.addTarget(self, action: #selector(handleStarButton(sender:)), for: .touchUpInside)
            buttons.append(button)
        }
        return buttons
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupNameLabel()
        setupStarCommentView()
        setupUnderlineView()
    }
    
    private func setupStarCommentView(){
//        let w : CGFloat = 46, h : CGFloat = 46, l : CGFloat = 0
//        let v1 = UIView(), v2 = UIView(), v3 = UIView(), v4 = UIView(),v5 = UIView()
//        v1.addSubview(StarCommentBtn1)
//        v2.addSubview(StarCommentBtn2)
//        v3.addSubview(StarCommentBtn3)
//        v4.addSubview(StarCommentBtn4)
//        v5.addSubview(StarCommentBtn5)
//        StarCommentBtn1.addConstraints(left: nil, top: v1.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
//        StarCommentBtn2.addConstraints(left: nil, top: v2.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
//        StarCommentBtn3.addConstraints(left: nil, top: v3.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
//        StarCommentBtn4.addConstraints(left: nil, top: v4.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
//        StarCommentBtn5.addConstraints(left: nil, top: v5.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: w, height: h)
//
//        StarCommentBtn1.centerXAnchor.constraint(equalTo: v1.centerXAnchor).isActive = true
//        StarCommentBtn2.centerXAnchor.constraint(equalTo: v2.centerXAnchor).isActive = true
//        StarCommentBtn3.centerXAnchor.constraint(equalTo: v3.centerXAnchor).isActive = true
//        StarCommentBtn4.centerXAnchor.constraint(equalTo: v4.centerXAnchor).isActive = true
//        StarCommentBtn5.centerXAnchor.constraint(equalTo: v5.centerXAnchor).isActive = true
        
        starCommentView = UIStackView(arrangedSubviews: starCommentBtns)
        starCommentView?.axis = .horizontal
        starCommentView?.distribution = .fillEqually
        
        addSubview(starCommentView!)
        starCommentView?.addConstraints(left: leftAnchor, top: CommentNumLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 20, topConstent: 20, rightConstent: 20, bottomConstent: 0, width: 0, height: 46)
    }
    
    private func setupNameLabel(){
        addSubview(CommentNumLabel)
        CommentNumLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 30, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = CommentNumLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    
    private func setupUnderlineView(){
        underlineView.backgroundColor = .lightGray
        addSubview(underlineView)
        underlineView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
        underlineViewBottomConstraint = underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3)
        underlineViewBottomConstraint?.isActive = true
    }
    
    @objc private func handleStarButton(sender: UIButton) {
        print("Star tapped: \(sender.tag)")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

