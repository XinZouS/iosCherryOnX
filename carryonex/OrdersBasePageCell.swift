//
//  OrdersBasePageCell.swift
//  carryonex
//
//  Created by Xin Zou on 11/2/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class OrdersBasePageCell : UICollectionViewCell, UICollectionViewDelegate {
    
    var ordersLogCtl : OrdersLogController! {
        didSet{
            setupBackgroundButton()
        }
    }
    
    var isFetching = false {
        didSet{
            isFetching ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        }
    }

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let v = UICollectionView(frame: .zero, collectionViewLayout: layout)
        v.backgroundColor = .white
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
    
    var activityIndicator: UIActivityIndicatorCustomizeView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        setupBackgroundHintView()
        setupCollectionViewPage()
        setupActivityIndicator()
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
    
    
    func setupCollectionViewPage(){
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 5
        }
        collectionView.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0) // top, left, bottom, right
        collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0)

        addSubview(collectionView)
        collectionView.addConstraints(left: leftAnchor, top: topAnchor, right: rightAnchor, bottom: bottomAnchor, leftConstent: 0, topConstent: 60, rightConstent: 0, bottomConstent: 60, width: 0, height: 0)
    }
    
    private func setupActivityIndicator(){
        activityIndicator = UIActivityIndicatorCustomizeView()
        activityIndicator.frame = CGRect(x:self.center.x-15,y:self.center.y-15,width:0,height:0)
        activityIndicator.bounds = CGRect(x: 0, y: 0, width: 60, height: 60)
        self.addSubview(activityIndicator)
    }
    

    
    public func setupBackgroundButton(){}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}





extension OrdersBasePageCell {
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let ordersDetailPage = OrderDetailPage(collectionViewLayout: layout)
        ordersLogCtl.navigationController?.pushViewController(ordersDetailPage, animated: true)
    }
    
    func fetchOrdersLogList(){
        print("TODO: fetchOrdersLogList from server, OrdersLogPageCell.fetchOrdersLogList() !!!!!")
    }
    
    func updateUIContentsForRequestsList(){
        print("TODO: updateUIContentsForRequestsList [..] ...")
    }
    
    func backgroundButtonTapped(){
    }
    
}


