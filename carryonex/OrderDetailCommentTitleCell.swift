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

