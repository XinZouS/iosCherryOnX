//
//  WaitingListController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/23.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

class WaitingListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    let cellIdSenderPage = "cellIdSenderPage"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        
        setupCollectonView()
    }
    
    private func setupNavigationBar(){
        title = "等待订单"
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
//        let cancelBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "CarryonEx_Back"), style: .plain, target: self, action: #selector(cancelButtonTapped))
//        navigationItem.setLeftBarButton(cancelBtn, animated: true)
    }
    
    private func setupCollectonView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 5
        }
        collectionView?.backgroundColor = .white
        //constraints will NOT working for this collectionView...why??? setup in childViews.
        //collectionView?.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        collectionView?.register(OrdersSenderPageCell.self, forCellWithReuseIdentifier: cellIdSenderPage)
        
        collectionView?.isPagingEnabled = true
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = WaitingListCell()
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdSenderPage, for: indexPath) as! WaitingListCell
            cell.waitingListCtl = self
        cell.backgroundColor = .white
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height)
    }
    
}
