//
//  UserInfoViewCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/10/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class UserInfoViewCell: UICollectionViewCell {
    
    let titleLabel : UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        return l
    }()
    
    let imageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
//    let underlineView: UIView = {
//        let v = UIView()
//        v.backgroundColor = barColorLightGray
//        return v
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .clear
        
        let sz: CGFloat = 30
        addSubview(imageView)
        imageView.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: 50, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: sz, height: sz)
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(titleLabel)
        titleLabel.addConstraints(left: imageView.rightAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 20, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
//        addSubview(underlineView)
//        underlineView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 5, width: 0, height: 1)
        
    }
     
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



