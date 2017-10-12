//
//  TabTitleMenuCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit




class TabTitleMenuCell : UICollectionViewCell {
    
    
    let titleLabel : UILabel = {
        let b = UILabel()
        b.backgroundColor = .clear
        b.text = "titleLabel"
        b.textAlignment = .center
        return b
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = pickerColorLightGray
        
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
