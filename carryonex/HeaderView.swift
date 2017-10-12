//
//  HeaderView.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class HeaderView : UIView {
    
    let titleLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 16)
        b.backgroundColor = .white
        b.textAlignment = .left
        return b
    }()
    
    private let underline : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitleLabel()
        setupUnderline()
    }
    
    init(titleText: String){
        super.init(frame: .zero)
        
        setupTitleLabel()
        setupUnderline()
        titleLabel.text = titleText
    }
    
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 1, width: 0, height: 0)
    }
    
    private func setupUnderline(){
        addSubview(underline)
        underline.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
