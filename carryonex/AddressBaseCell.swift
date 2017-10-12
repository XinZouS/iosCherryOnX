//
//  AddressBaseCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/30/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class AddressBaseCell : UITableViewCell {
    
    let labelHeigh: CGFloat = 20
    let sideMargin: CGFloat = 30
    
    var addressCtl : AddressController!
    
    var idString: String!
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.backgroundColor = pickerColorLightGray
        b.textAlignment = .left
        b.textColor = .black
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    let selectedLabel: UILabel = {
        let b = UILabel()
        b.backgroundColor = pickerColorLightGray
        b.textAlignment = .right
        b.textColor = .black
        b.font = UIFont.systemFont(ofSize: 16)
        return b
    }()
    lazy var button: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return b
    }()
    let arrowImageView: UIImageView = { // the small down-arrow on the right side
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = #imageLiteral(resourceName: "CarryonEx_Plus")
        return v
    }()
    let underline: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupTitleLabel()
        setupselectedLabelAndArrow()
        setupButton()
        setupUnderline()
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: sideMargin, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 140, height: labelHeigh)
    }
    
    private func setupselectedLabelAndArrow(){
        addSubview(arrowImageView)
        arrowImageView.addConstraints(left: nil, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: sideMargin, bottomConstent: 0, width: 10, height: labelHeigh)
        
        addSubview(selectedLabel)
        selectedLabel.addConstraints(left: titleLabel.rightAnchor, top: topAnchor, right: arrowImageView.leftAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: labelHeigh)
    }
    
    private func setupButton(){
        addSubview(button)
        button.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 0, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 30)
    }
    
    private func setupUnderline(){
        addSubview(underline)
        underline.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 10, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 1)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

