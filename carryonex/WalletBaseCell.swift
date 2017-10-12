//
//  WalletBaseCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class WalletBaseCell : UITableViewCell {
    
    var checkingAccount : CheckingAccount!
    var creditAccount: CreditAccount!
    
    
    let titleLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 16)
        b.backgroundColor = .white
        b.textAlignment = .left
        b.textColor = .black
        return b
    }()
    
    let infoLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 16)
        b.backgroundColor = .clear
        b.textColor = textThemeColor
        b.textAlignment = .right
        return b
    }()
    
    let arrowImageView : UIImageView = {
        let v = UIImageView()
        v.image = #imageLiteral(resourceName: "CarryonEx_Plus")
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTitleLabel()
        setupArrowImageView()
        setupInfoLabel()
    }
    
    private func setupTitleLabel(){
        let w = self.bounds.width / 2.0 - 20
        let l = CGFloat(UIScreen.main.bounds.width < 333 ? 10 : 26)
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: 26)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupArrowImageView(){
        addSubview(arrowImageView)
        arrowImageView.addConstraints(left: nil, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 20, height: 0)
    }
    
    private func setupInfoLabel(){
        addSubview(infoLabel)
        infoLabel.addConstraints(left: titleLabel.rightAnchor, top: nil, right: arrowImageView.leftAnchor, bottom: nil, leftConstent: -30, topConstent: 0, rightConstent: 3, bottomConstent: 0, width: 0, height: 26)
        infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    
    

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}
