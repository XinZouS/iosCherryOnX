//
//  CommentViewCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/30.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class CommentViewCell : CommentBaseCell,UITextViewDelegate {

    let commentStateLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "非常好"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    
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
        
        setupCommentStateLabel()
        setupStarCommentView()
    }
    private func setupCommentStateLabel(){
        addSubview(commentStateLabel)
        commentStateLabel.addConstraints(left: nil, top: nil, right: nil, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelCenterYConstraint = commentStateLabel.centerXAnchor.constraint(equalTo: centerXAnchor,constant:35)
        titleLabelCenterYConstraint?.isActive = true
        
        titleLabelWidthConstraint = commentStateLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupStarCommentView(){
        
        starCommentView = UIStackView(arrangedSubviews: starCommentBtns)
        starCommentView?.axis = .horizontal
        starCommentView?.distribution = .fillEqually
        
        addSubview(starCommentView!)
        starCommentView?.addConstraints(left: leftAnchor, top: commentStateLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 20, topConstent: 20, rightConstent: 20, bottomConstent: 0, width: 0, height: 30)
    }
    
    @objc private func handleStarButton(sender: UIButton) {
        for i in 0..<5{
            let button = starCommentBtns[i]
            let starImage = (i<=sender.tag) ?#imageLiteral(resourceName: "carryonex_star") : #imageLiteral(resourceName: "carryonex_unselectstar")
            button.setImage(starImage, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

