//
//  OrdersShipperHeaderCell.swift
//  carryonex
//
//  Created by Xin Zou on 10/26/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class OrdersShipperHeaderCell : UICollectionViewCell {
    
    var trip : Trip? {
        didSet{
            setupLabelsByTrip()
        }
    }
    
    let iconImageView : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFit
        v.image = #imageLiteral(resourceName: "CarryonEx_Logo")
        return v
    }()
    
    let colorBar : UIView = {
        let v = UIView()
        v.backgroundColor = buttonThemeColor
        return v
    }()
    
    let youxiangCodeLabel : UILabel = {
        let b = UILabel()
        b.text = "yooxiang"
        b.font = UIFont.systemFont(ofSize: 14)
        b.textAlignment = .center
        return b
    }()
    let cityLabel : UILabel = {
        let b = UILabel()
        b.text = "city--city"
        b.font = UIFont.systemFont(ofSize: 14)
        b.textAlignment = .center
        return b
    }()
    let dateLabel : UILabel = {
        let b = UILabel()
        b.text = "2000/01/01"
        b.font = UIFont.systemFont(ofSize: 14)
        b.textAlignment = .center
        return b
    }()
    
    let whiteBar1 : UIView = {
        let b = UIView()
        b.backgroundColor = .white
        return b
    }()
    let whiteBar2 : UIView = {
        let b = UIView()
        b.backgroundColor = .white
        return b
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupIconImage() // the order of setups should NOT change!!!
        setupColorBar()  // they depend on eachother.
        setupLabels()
        setupWhiteBars()
    }
    
    private func setupIconImage(){
        addSubview(iconImageView)
        iconImageView.addConstraints(left: leftAnchor, top: topAnchor, right: nil, bottom: bottomAnchor, leftConstent: 5, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 30, height: 0)
    }
    
    private func setupColorBar(){
        let h : CGFloat = 24
        colorBar.layer.masksToBounds = true
        colorBar.layer.cornerRadius = h / 2
        addSubview(colorBar)
        colorBar.addConstraints(left: iconImageView.rightAnchor, top: nil, right: rightAnchor, bottom: nil, leftConstent: 10, topConstent: 0, rightConstent: 10, bottomConstent: 0, width: 0, height: h)
        colorBar.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupLabels(){
        let w : CGFloat = (self.bounds.width - 60) / 4
        addSubview(youxiangCodeLabel) // left
        youxiangCodeLabel.addConstraints(left: colorBar.leftAnchor, top: colorBar.topAnchor, right: nil, bottom: colorBar.bottomAnchor, leftConstent: 5, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: 0)
        
        addSubview(dateLabel) // right
        dateLabel.addConstraints(left: nil, top: colorBar.topAnchor, right: colorBar.rightAnchor, bottom: colorBar.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 5, bottomConstent: 0, width: w, height: 0)
        
        addSubview(cityLabel) // center
        cityLabel.addConstraints(left: youxiangCodeLabel.rightAnchor, top: colorBar.topAnchor, right: dateLabel.leftAnchor, bottom: colorBar.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    }
    
    private func setupWhiteBars(){
        let w : CGFloat = 2
        addSubview(whiteBar1)
        whiteBar1.addConstraints(left: youxiangCodeLabel.rightAnchor, top: colorBar.topAnchor, right: nil, bottom: colorBar.bottomAnchor, leftConstent: -1, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: 0)
        
        addSubview(whiteBar2)
        whiteBar2.addConstraints(left: nil, top: colorBar.topAnchor, right: dateLabel.leftAnchor, bottom: colorBar.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: 0)
    }
    
    
    private func setupLabelsByTrip(){
        youxiangCodeLabel.text = trip?.tripCode ?? "tripCode"
        
        let startCity = trip?.getStartAddress().city ?? "start"
        let endCity   = trip?.getEndAddress().city ?? "end"
        cityLabel.text = "\(startCity)--\(endCity)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let d = Date(timeIntervalSince1970: trip?.pickupDate ?? 0)
        dateLabel.text = formatter.string(from: d)
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
