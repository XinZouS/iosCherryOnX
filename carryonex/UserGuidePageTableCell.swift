//
//  UserGuidePageTableCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class UserGuidePageTableCell : UITableViewCell {
    
    weak var userGuideCtl : UserGuideController!
    
    let titleLabel : UILabel = {
        let b = UILabel()
        b.textColor = .black
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        setupTitleLabel()
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 36, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 26)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
