//
//  DetailItemPictureCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/19.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class DetailItemPictureCell : DetailBaseCell{
    
    var dic:Dictionary<String,String>=["0":"CarryonEx_Wechat_Icon","1":"CarryonEx_Logo","2":"carryonex_sheet","3":"CarryonEx_Logo","4":"CarryonEx_CreditCard"]
    var pictureStackView : UIStackView?
    let nameLabel : UILabel = {
        let l = UILabel()
        //        l.backgroundColor = .cyan
        l.text = "物品图片:"
        l.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 14 : 16) // i5 < 400 < i6,7
        return l
    }()
    let picture1Btn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 30
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    let picture2Btn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 30
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    let picture3Btn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 30
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    let picture4Btn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 30
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    let picture5Btn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 30
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    let picture6Btn : UIButton = {
        let b = UIButton()
        b.layer.cornerRadius = 30
        b.backgroundColor = .white
        //        b.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        return b
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNameLabel()
        setUpPictureView()
        backgroundColor = .white
        
    }
    private func setUpPictureView(){
        let v1 = UIView(), v2 = UIView(), v3 = UIView(),v4 = UIView(),v5 = UIView(),v6 = UIView()
        setupPictureBtn()
        for (key,value) in dic {
            switch key{
            case "0":
                v1.addSubview(picture1Btn)
                picture1Btn.addConstraints(left: v1.leftAnchor, top: v1.topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 60, height: 60)
            case "1":
                v2.addSubview(picture2Btn)
                picture2Btn.addConstraints(left: v2.leftAnchor, top: v2.topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 60, height: 60)
            case "2":
                v3.addSubview(picture3Btn)
                picture3Btn.addConstraints(left: v3.leftAnchor, top: v3.topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 60, height: 60)
            case "3":
                v4.addSubview(picture4Btn)
                picture4Btn.addConstraints(left: v4.leftAnchor, top: v4.topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 60, height: 60)
            case "4":
                v5.addSubview(picture5Btn)
                picture5Btn.addConstraints(left: v5.leftAnchor, top: v5.topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 60, height: 60)
            default:
                v6.addSubview(picture6Btn)
                picture6Btn.addConstraints(left: v6.leftAnchor, top: v6.topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 60, height: 60)
            }
        }
        pictureStackView = UIStackView(arrangedSubviews: [v1, v2, v3, v4, v5, v6])
        switch dic.count {
        case 1:
            pictureStackView = UIStackView(arrangedSubviews: [v1])
        case 2:
            pictureStackView = UIStackView(arrangedSubviews: [v1, v2])
        case 3:
            pictureStackView = UIStackView(arrangedSubviews: [v1, v2, v3])
        case 4:
            pictureStackView = UIStackView(arrangedSubviews: [v1, v2, v3, v4])
        case 5:
            pictureStackView = UIStackView(arrangedSubviews: [v1, v2, v3, v4, v5])
        default:
            pictureStackView = UIStackView(arrangedSubviews: [v1, v2, v3, v4, v5, v6])
        }
        pictureStackView?.axis = .horizontal
        pictureStackView?.distribution = .fillEqually
        
        addSubview(pictureStackView!)
        pictureStackView?.addConstraints(left: leftAnchor, top: nameLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 320, height: 100)
    }
    private func setupNameLabel(){
        addSubview(nameLabel)
        nameLabel.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: nil, leftConstent: 10, topConstent: 10, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
        titleLabelWidthConstraint = nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width < 325 ? 95 : 130)
        titleLabelWidthConstraint?.isActive = true
    }
    private func setupPictureBtn(){
        for (key,value) in dic {
            switch key{
            case "0":
                picture1Btn.setImage(UIImage(named: value), for: .normal)
            case "1":
                picture2Btn.setImage(UIImage(named: value), for: .normal)
            case "2":
                picture3Btn.setImage(UIImage(named: value), for: .normal)
            case "3":
                picture4Btn.setImage(UIImage(named: value), for: .normal)
            case "4":
                picture5Btn.setImage(UIImage(named: value), for: .normal)
            default:
                picture6Btn.setImage(UIImage(named: value), for: .normal)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
