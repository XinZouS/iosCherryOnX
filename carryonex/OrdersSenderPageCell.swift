//
//  OrdersLogBaseCell.swift
//  carryonex
//
//  Created by Xin Zou on 9/4/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class OrdersSenderPageCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var ordersLogCtl : OrdersLogController! {
        didSet{
            setupBackgroundButton()
        }
    }
    let cellIdOrderLogSenderCell = "cellIdOrderLogSenderCell"
    
    var dataList: [Request]? {
        didSet{
            dataListDidSet()
        }
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .white
        v.dataSource = self
        v.delegate = self
        return v
    }()
    
    let backgroundHintView: UIView = {
        let v = UIView()
        v.backgroundColor = pickerColorLightGray
        return v
    }()

    let backgroundLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 18)
        b.textAlignment = .center
        b.textColor = .lightGray
        b.numberOfLines = 2
        return b
    }()

    lazy var backgroundButton: UIButton = {
        let b = UIButton()
        b.addTarget(self, action: #selector(backgroundButtonTapped), for: .touchUpInside)
        b.backgroundColor = buttonThemeColor
        return b
    }()

    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupBackgroundHintView()
        setupCollectionViewPage()
        registerCollectionView()
        
        fetchRequests() // do it separatly in OrderSenderPageCell++ and OrderShipperPageCell++
    }
    
    private func setupBackgroundHintView(){
        addSubview(backgroundHintView)
        backgroundHintView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        let mg: CGFloat = 50
        let bkImgView = UIImageView(image: #imageLiteral(resourceName: "CarryonEx_Waiting_B"))
        bkImgView.contentMode = .scaleAspectFit
        addSubview(bkImgView)
        bkImgView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: nil, leftConstent: mg, topConstent: mg * 2, rightConstent: mg, bottomConstent: 0, width: 0, height: 160)
        
        addSubview(backgroundLabel)
        backgroundLabel.addConstraints(left: leftAnchor, top: bkImgView.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: 0, topConstent: 20, rightConstent: 0, bottomConstent: 0, width: 0, height: 60)
        
        addSubview(backgroundButton)
        backgroundButton.addConstraints(left: leftAnchor, top: backgroundLabel.bottomAnchor, right: rightAnchor, bottom: nil, leftConstent: mg * 2, topConstent: 20, rightConstent: mg * 2, bottomConstent: 0, width: 0, height: 40)
    }
    
    private func setupBackgroundButton(){
        let id = self.reuseIdentifier ?? ordersLogCtl.cellIdSenderPage
        let att = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        var str = NSAttributedString()
        if id == ordersLogCtl.cellIdSenderPage {
            str = NSAttributedString(string: "立刻去发货", attributes: att)
            backgroundLabel.text = "订单空空的，快去给亲友\n送点礼物表达思念吧！"
        }else{
            str = NSAttributedString(string: "出发看世界", attributes: att)
            backgroundLabel.text = "行程空空的哪都没去呢，\n世界这么大，难道不想去看看吗？"
        }
        backgroundButton.setAttributedTitle(str, for: .normal)
    }
    
    func setupCollectionViewPage(){
        addSubview(collectionView)
        collectionView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 60, rightConstent: 0, bottomConstent: 60, width: 0, height: 0)
    }
    
    
    /// - MARK: collectionView delegate, for page container
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdOrderLogSenderCell, for: indexPath) as! OrderLogSenderCell
        
        cell.ordersLogCtl = self.ordersLogCtl
        if indexPath.item < (dataList?.count)! {
            cell.request = dataList?[indexPath.item]
        }

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 100) // for each log item in one page
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    
    
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

