//
//  PostBaseCell.swift
//  carryonex
//
//  Created by Xin Zou on 8/29/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class PostBaseCell : UICollectionViewCell {
    
    var postTripController : PostTripController!
    
    var idString: String = ""
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        b.text = "title"
        return b
    }()
    
    let infoLabel: UILabel = {
        let b = UILabel()
        b.backgroundColor = .white
        b.textAlignment = .right
        b.textColor = .lightGray
        return b
    }()
    
    lazy var infoButton: UIButton = {
        let b  = UIButton()
        //b.setTitle("button不要title", for: .normal)
        b.addTarget(self, action: #selector(infoButtonTapped), for: .touchUpInside)
        return b
    }()

    private let underlineView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    let hintLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 12)
        b.textColor = textThemeColor
        b.textAlignment = .left
        b.numberOfLines = 2
        return b
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupTitleLabel()
        setupInfoLabelAndButton()
        setupUnderlineView()
        setupHintLabel()
        setupInfoButton()
    }
    
    private func setupTitleLabel(){
        addSubview(titleLabel)
        titleLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 20, rightConstent: 0, bottomConstent: 0, width: 100, height: 20)
    }
    
    private func setupInfoLabelAndButton(){
        addSubview(infoLabel)
        infoLabel.addConstraints(left: titleLabel.rightAnchor, top: titleLabel.topAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 20)
    }
    
    private func setupUnderlineView(){
        addSubview(underlineView)
        underlineView.addConstraints(left: leftAnchor, top: titleLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
    }
    private func setupHintLabel(){
        addSubview(hintLabel)
        hintLabel.addConstraints(left: leftAnchor, top: underlineView.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 30) // 2 lines, 15 px for each line
    }
    
    private func setupInfoButton(){
        addSubview(infoButton)
        infoButton.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
