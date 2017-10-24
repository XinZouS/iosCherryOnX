//
//  FooterInfoCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class FooterInfoCell : UITableViewCell {
    
    let textView : UITextView = {
        let v = UITextView()
        v.isEditable = false
        v.text = "客服专线：9292150588 (24/7) \n市场合作：bd@carryonex.com \n求职招聘：jobs@carryonex.com"
        v.font = UIFont.systemFont(ofSize: 14)
        v.backgroundColor = .clear
        v.textColor = .lightGray
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        addSubview(textView)
        textView.addConstraints(left: nil, top: topAnchor, right: nil, bottom: bottomAnchor, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 5, width: 230, height: 0)
        textView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
