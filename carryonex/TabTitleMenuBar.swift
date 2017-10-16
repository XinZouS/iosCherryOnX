//
//  TabTitleMenuBarView.swift
//  carryonex
//
//  Created by Xin Zou on 9/5/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class TabTitleMenuBar : UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    /// Parent controllers:
    weak var ordersLogController: OrdersLogController?
    weak var userGuideController: UserGuideController?
    
    let titleList = ["我是发件人", "我是揽件人"]
    
    var senderCell: TabTitleMenuCell!
    var shipperCell:TabTitleMenuCell!

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = pickerColorLightGray
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    let cellId  = "TabTitleMenuBarCellId"
    
    var barViewCenterXConstraint : NSLayoutConstraint!
    
    let barView : UIView = {
        let v = UIView()
        v.backgroundColor = buttonThemeColor
        return v
    }()
    
    let underLine: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCollectionView()
        setupBarView()
        setupUnderline()
    }
    
    private func setupCollectionView(){
        addSubview(collectionView)
        collectionView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        collectionView.register(TabTitleMenuCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    private func setupBarView(){
        addSubview(barView)
        let ratio: CGFloat = UIScreen.main.bounds.width < 330 ? 3.0 : 4.0
        let w = CGFloat(UIScreen.main.bounds.width / ratio)
        barView.addConstraints(left: nil, top: nil, right: nil, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: 4)
        
        let deltaX = UIScreen.main.bounds.width / CGFloat(titleList.count) * 0.5
        barViewCenterXConstraint = barView.centerXAnchor.constraint(equalTo: leftAnchor, constant: deltaX)
        barViewCenterXConstraint.isActive = true
    }
    
    private func setupUnderline(){
        addSubview(underLine)
        underLine.addConstraints(left: leftAnchor, top: nil, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 1)
    }

    
    
    /// - MARK: collectionView delegates
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! TabTitleMenuCell
        cell.titleLabel.text = titleList[indexPath.item]
        if indexPath.item == 0 {
            senderCell = cell
        }else if indexPath.item == 1 {
            shipperCell = cell
        }
        return cell
    }
    /// UICollectionViewDelegateFlowLayout delegate:
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = UIScreen.main.bounds.width / CGFloat(titleList.count)
        return CGSize(width: w, height: 40)
    }
    
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
