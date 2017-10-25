//
//  TransportationCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/25/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class TransportationCell : PostBaseCell {
    
    lazy var youxiangCategorySegment: UISegmentedControl = {
        let s = UISegmentedControl(items: ["后备箱", "行李箱"])
        //s.tintColor = .white
        s.tintColor = buttonThemeColor
        s.selectedSegmentIndex = 0
        s.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 16)], for: .normal)
        s.addTarget(self, action: #selector(changeYouxiangCategory), for: .valueChanged)
        return s
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.infoButton.isEnabled = false
        self.infoButton.isHidden = true
        self.infoLabel.isHidden = true
        
        setupSegmentedControl()
    }
    
    
    private func setupSegmentedControl(){
        addSubview(youxiangCategorySegment)
        youxiangCategorySegment.addConstraints(left: titleLabel.rightAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 20, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
    }
    
    func changeYouxiangCategory(){
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
