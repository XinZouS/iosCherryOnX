//
//  UserSettingCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/15/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class UserSettingCell : UITableViewCell {
    
    let titleLabel : UILabel = {
        let b = UILabel()
        b.textColor = .black
        b.textAlignment = .left
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    
    let arrowImageView: UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "CarryonEx_Plus")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        setupTitleLabel()
        setupArrowImage()
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 20, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 26)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupArrowImage(){
        addSubview(arrowImageView)
        arrowImageView.addConstraints(left: nil, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 20, height: 0)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

