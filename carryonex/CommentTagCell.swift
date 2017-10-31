//
//  CommentTagCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/31.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

class CommentTagCell : CommentBaseCell {
    
    let commentStateLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "非常好"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupCommentStateLabel()
    }
    private func setupCommentStateLabel(){
        addSubview(commentStateLabel)
        commentStateLabel.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: 150, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = commentStateLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


