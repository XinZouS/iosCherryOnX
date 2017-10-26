//
//  PaymentCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/27/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import M13Checkbox


class PaymentCell : UICollectionViewCell {
    
    var paymentController: PaymentController!
    
    var payment : Payment!
    
    let iconImageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.text = "pay title label???"
        b.textAlignment = .left
        b.numberOfLines = 3
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    
    lazy var checkbox : M13Checkbox = {
        let b = M13Checkbox(frame: CGRect(x: 0.0, y: 0.0, width: 25.0, height: 25.0))
        b.addTarget(self, action: #selector(checkboxTapped), for: .valueChanged)
        b.isUserInteractionEnabled = false
        b.tintColor = textThemeColor
        b.checkmarkLineWidth = 4
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupIconImageView()
        setupCheckbox()
        setupTitleLabel()
    }
    
    private func setupIconImageView(){
        let margin : CGFloat = 10
        addSubview(iconImageView)
        iconImageView.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: bottomAnchor, leftConstent: margin, topConstent: margin, rightConstent: 0, bottomConstent: margin, width: 85, height: 0)
    }
    
    private func setupCheckbox(){
        addSubview(checkbox)
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        checkbox.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        checkbox.widthAnchor.constraint(equalToConstant: 25).isActive = true
        checkbox.heightAnchor.constraint(equalToConstant: 25).isActive = true
        checkbox.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: iconImageView.rightAnchor, top: topAnchor, right: checkbox.leftAnchor, bottom: bottomAnchor, leftConstent: 15, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

