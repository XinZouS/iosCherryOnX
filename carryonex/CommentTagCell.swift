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
        l.layer.borderWidth = 2
        l.layer.cornerRadius = 20
        l.layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        l.textAlignment = .center
        l.textColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    var array : [String]?
    var forNameIndex : Int?
    var index = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupCommentStateLabel()
    }
    private func setupCommentStateLabel(){
        addSubview(commentStateLabel)
        commentStateLabel.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


