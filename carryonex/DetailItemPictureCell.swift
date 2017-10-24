//
//  DetailItemPictureCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailItemPictureCell : DetailBaseCell{
    
    var dic:Dictionary<String,String>=["0":"sample1","1":"sample2","2":"sample3","3":"sample4","4":"sample5","5":"sample6"]
    let nameLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "物品图片:"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    lazy var photoBrowserViewCtl : PhotoBrowserViewController = {
         let p = PhotoBrowserViewController()
         return p
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNameLabel()
        setUpPictureView()
        backgroundColor = .white
        
    }
    private func setUpPictureView(){
        addSubview(photoBrowserViewCtl.view)
    }
    private func setupNameLabel(){
        addSubview(nameLabel)
        nameLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
