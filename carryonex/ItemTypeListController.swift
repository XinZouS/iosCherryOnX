//
//  ItemTypeListController.swift
//  carryonex
//
//  Created by Xin Zou on 8/19/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class ItemTypeListController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    /// class ItemCategory(), for UI display use ONLY!
    var itemCategoryList : [ItemCategory]! = []
    
    var request = Request()
    
     
    let cellId = "ItemTypeListCellId"
    
    lazy var submitButton : UIButton = {
        let b = UIButton()
        b.backgroundColor = .lightGray //buttonThemeColor
        b.isEnabled = false
        b.addTarget(self, action: #selector(submitButtonTapped), for: .touchUpInside)
        b.setTitle("确认清单", for: .normal)
        return b
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addItemTypesToList()
        
        setupNavigationBar()
        setupCollectionView()        
        setupSubmitButton() 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request.numberOfItem.removeAll() // reset NumOfItems in the current Request
    }
    
    
    private func setupNavigationBar(){
        navigationItem.title = "货物清单"
        UINavigationBar.appearance().tintColor = buttonColorWhite
        navigationController?.navigationBar.tintColor = buttonColorWhite
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: buttonColorWhite]
        
        let barBtn = UIBarButtonItem(title: "确认清单", style: .plain, target: self, action: #selector(submitButtonTapped))
        navigationItem.rightBarButtonItem = barBtn
        let cancel = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancel
    }
    
    private func setupCollectionView(){
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 1
        }
        collectionView?.backgroundColor = .white
        
        // reset content area: UIEdgeInsetsMake(top, left, bottom, right)
        //collectionView?.contentInset = UIEdgeInsetsMake(0, 20, 50, 20) // replaced by constraints:
        let w : CGFloat = UIScreen.main.bounds.width < 325 ? 20 : 30
        collectionView?.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: w, topConstent: 10, rightConstent: w, bottomConstent: 40, width: 0, height: 0)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(ItemTypeListCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.isScrollEnabled = true
    }
    
    private func setupSubmitButton(){
        view.addSubview(submitButton)
        submitButton.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 40)
    }

    
    
    /// collectionView delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCategoryList.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ItemTypeListCell
        cell.itemCategory = itemCategoryList[indexPath.item]
        cell.itemTypeListController = self // for item add and sub action
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 56)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    
    
    
}

