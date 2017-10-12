//
//  ItemTypeListCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/19/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class ItemTypeListCell : UICollectionViewCell {
    
    var itemTypeListController : ItemTypeListController!
    
    var itemCategory : ItemCategory! {
        didSet {
            iconImgView.image = itemCategory.icon
            titleLabel.text = itemCategory.nameCN
            countLabel.text = "\(itemCategory.count)"
        }
    }
    
    let iconImgView : UIImageView = {
        let v = UIImageView()
        //v.backgroundColor = .cyan
        v.contentMode = .scaleAspectFit
        return v
    }()
    
    let titleLabel : UILabel = {
        let b = UILabel()
        //b.backgroundColor = .green
        b.textAlignment = .left
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    
    lazy var buttonMinus : UIButton = {
        let b = UIButton()
        //b.backgroundColor = .orange
        b.addTarget(self, action: #selector(buttonMinusTapped), for: .touchUpInside)
        b.setBackgroundImage(#imageLiteral(resourceName: "CarryonEx_Minus"), for: .normal)
        return b
    }()
    
    lazy var buttonAdd : UIButton = {
        let b = UIButton()
        //b.backgroundColor = .orange
        b.addTarget(self, action: #selector(buttonAddTapped), for: .touchUpInside)
        b.setBackgroundImage(#imageLiteral(resourceName: "CarryonEx_Plus"), for: .normal)
        return b
    }()
    
    let countLabel : UILabel = {
        let b = UILabel()
        //b.backgroundColor = .yellow
        b.text = "0"
        b.textAlignment = .center
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()

    let underlineView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
     
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCellView()
        
    }
    
    private func setupCellView(){
        
        let h : CGFloat = 25
        let pageMargin: CGFloat = UIScreen.main.bounds.width < 325 ? 5 : 20
        self.backgroundColor = .white
        
        addSubview(iconImgView)
        iconImgView.addConstraints(left: leftAnchor, top: nil, right: nil, bottom: nil, leftConstent: pageMargin, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: h, height: h)
        iconImgView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        /// adding order: right to left, bcz titleLabel.width is depends on cell.view.width
        
        addSubview(buttonAdd) // most right
        buttonAdd.addConstraints(left: nil, top: nil, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: pageMargin, bottomConstent: 0, width: h, height: h)
        buttonAdd.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
         
        addSubview(countLabel)
        countLabel.addConstraints(left: nil, top: nil, right: buttonAdd.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 5, bottomConstent: 0, width: h, height: h)
        countLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(buttonMinus)
        buttonMinus.addConstraints(left: nil, top: nil, right: countLabel.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 5, bottomConstent: 0, width: h, height: h)
        buttonMinus.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        addSubview(titleLabel) // in middle
        titleLabel.addConstraints(left: iconImgView.rightAnchor, top: nil, right: buttonMinus.leftAnchor, bottom: nil, leftConstent: 5, topConstent: 0, rightConstent: 5, bottomConstent: 0, width: 0, height: h)
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(underlineView)
        underlineView.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



