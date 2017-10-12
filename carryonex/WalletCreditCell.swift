//
//  WalletCreditCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class WalletCreditCell: WalletBaseCell {
    
    
    override var creditAccount: CreditAccount! {
        didSet{
            updateUIContentForCredit()
        }
    }
    
    let cardTypeImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.backgroundColor = .white
        return v
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel.isHidden = true
        setupImageView()
    }
    
    private func setupImageView(){
        let upbottomMargin: CGFloat = 3
        addSubview(cardTypeImageView)
        cardTypeImageView.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: bottomAnchor, leftConstent: 10, topConstent: upbottomMargin, rightConstent: 0, bottomConstent: upbottomMargin, width: 90, height: 0)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
