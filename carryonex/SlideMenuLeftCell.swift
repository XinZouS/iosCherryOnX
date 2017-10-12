//
//  SlideMenuLeftCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/10/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class SlideMenuLeftCell: UITableViewCell {
    
    let iconImageView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .yellow
        return v
    }()
    
    let titleLabel : UILabel = {
        let t = UILabel()
        t.text = "title label"
        t.backgroundColor = .green
        return t
    }()
    
    let underLineView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super .init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(iconImageView)
        iconImageView.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: bottomAnchor, leftConstent: 10, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 40, height: 0)

        addSubview(underLineView)
        underLineView.addConstraints(left: iconImageView.rightAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 5, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 2)
        
        addSubview(titleLabel)
        titleLabel.addConstraints(left: iconImageView.rightAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 5, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        
    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


