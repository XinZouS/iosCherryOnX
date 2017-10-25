//
//  OrdersLogController.swift
//  carryonex
//
//  Created by Xin Zou on 9/4/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class OrdersLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let cellIdSenderPage = "cellIdSenderPage"
    let cellIdShipperPage = "cellIdShipperPage"
    
    let tabTitleMenuBarHeight : CGFloat = 40
    let tabTitleMenuBar = TabTitleMenuBar()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        if(isOrderList == false){
            setupTabMenuBar()
        }
        
        setupCollectonView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        isOrderList = false
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]

        let cancelBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "CarryonEx_Back"), style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.setLeftBarButton(cancelBtn, animated: true)
    }
    
    private func setupTabMenuBar(){
        view.addSubview(tabTitleMenuBar)
        tabTitleMenuBar.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: tabTitleMenuBarHeight)
        
        tabTitleMenuBar.ordersLogController = self
    }

    private func setupCollectonView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 5
        }
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsetsMake(tabTitleMenuBarHeight, 0, 0, 0) // top, left, bottom, right
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(tabTitleMenuBarHeight, 0, 0, 0)
        //constraints will NOT working for this collectionView...why??? setup in childViews.
        //collectionView?.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        collectionView?.register(OrdersSenderPageCell.self, forCellWithReuseIdentifier: cellIdSenderPage)
        collectionView?.register(OrdersShipperPageCell.self, forCellWithReuseIdentifier: cellIdShipperPage)
        
        collectionView?.isPagingEnabled = true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabTitleMenuBar.titleList.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = OrdersSenderPageCell()
        if indexPath.item == 0 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdSenderPage, for: indexPath) as! OrdersSenderPageCell
            cell.ordersLogCtl = self
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdShipperPage, for: indexPath) as! OrdersShipperPageCell
            cell.ordersLogCtl = self
        }
        cell.backgroundColor = .white

        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
    
    
}

