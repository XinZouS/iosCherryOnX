//
//  CreditDetailView.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class CreditDetailView: UIView {
    
    
    let titleLabel : UILabel = {
        let b = UILabel()
        b.textAlignment = .center
        b.textColor = .lightGray
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    
    let creditLabel : UILabel = {
        let b = UILabel()
        b.textColor = .black
        b.textAlignment = .center
        b.font = UIFont.systemFont(ofSize: 18)
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        
        
        setupContents()
    }
    
    private func setupContents(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 20)
        
        addSubview(creditLabel)
        creditLabel.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 26)
    }
    
    func setupInfo(title:String, credit:Float){
        titleLabel.text = title
        
        creditLabel.text = String(format: "$%.02f", locale: .current, arguments: [credit])
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

