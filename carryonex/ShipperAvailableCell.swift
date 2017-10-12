//
//  ShipperAvailableCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/26/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class ShipperAvailableCell : UICollectionViewCell {
    
    var isSelectionEnable = false {
        didSet{
            print("isSelectionEnable = \(isSelectionEnable)")
            setupCellAppearance(isSelecting: false)
        }
    }
    
    var timeOffset: Int!
    
    
    
    let titleLabel : UILabel = {
        let b = UILabel()
        //b.textColor = .cyan
        b.font = UIFont.systemFont(ofSize: 14)
        b.textAlignment = .center
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    private func setupCell(){
        backgroundColor = .orange
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    func setupCellAppearance(isSelecting: Bool){
        if isSelectionEnable {
            if isSelecting {
                setupCellAppearanceWith(backgroundColor: buttonThemeColor, borderColor: buttonThemeColor, textColor: .white)
            }else{
                setupCellAppearanceWith(backgroundColor: .white, borderColor: .black, textColor: .black)
            }
        }else{ // gray cell disabled
            setupCellAppearanceWith(backgroundColor: .lightGray, borderColor: .lightGray, textColor: .white)
        }
    }
    
    private func setupCellAppearanceWith(backgroundColor bgClr: UIColor, borderColor bdClr: UIColor, textColor txClr: UIColor){
        self.backgroundColor = bgClr
        
        layer.borderColor = bdClr.cgColor
        layer.borderWidth = 1
        
        titleLabel.textColor = txClr
    }

    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


