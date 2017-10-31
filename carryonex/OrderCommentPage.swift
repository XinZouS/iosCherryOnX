//
//  OrderCommentPage.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/30.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class OrderCommentPage: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var array = ["神速","超级细心","骗子","善于沟通","很有责任心"]
    var request = Request()
    
    let commentUserNameCellId = "commentUserNameCellId"
    let commentViewCellId = "commentViewCellId"
    let commentTextviewAndSubmitCellId = "commentTextviewAndSubmitCellId"
    let commentTagCellId = "commentTagCell"
    
    var commentBaseCell : CommentBaseCell?
    var commentUserNameCell : CommentUserNameCell?
    var commentViewCell : CommentViewCell?
    var commentTagCell : CommentTagCell?
    var commentTextViewAndSubmmitCell : CommentTextViewAndSubmitCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupCollectionView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request.numberOfItem.removeAll() // reset NumOfItems in the current Request
    }
    
    
    private func setupNavigationBar(){
        title = "评价"
        UINavigationBar.appearance().tintColor = buttonColorWhite
        navigationController?.navigationBar.tintColor = buttonColorWhite
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: buttonColorWhite]
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
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(CommentUserNameCell.self, forCellWithReuseIdentifier: commentUserNameCellId)
        collectionView?.register(CommentViewCell.self, forCellWithReuseIdentifier: commentViewCellId)
        collectionView?.register(CommentTextViewAndSubmitCell.self, forCellWithReuseIdentifier:commentTextviewAndSubmitCellId)
        collectionView?.register(CommentTagCell.self, forCellWithReuseIdentifier:commentTagCellId)
    }
    
    /// collectionView delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tagNum = array.count
        return 3+tagNum
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellId : String = commentUserNameCellId
        let tagNum = array.count
        switch indexPath.item{
        case 0:
            cellId = commentUserNameCellId
        case 1:
            cellId = commentViewCellId
        case 2+tagNum:
            cellId = commentTextviewAndSubmitCellId
        default:
            cellId = commentTagCellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentBaseCell
        switch indexPath.item {
        case 0 :
            commentUserNameCell = cell as? CommentUserNameCell
        case 1:
            commentViewCell = cell as? CommentViewCell
        case 2+tagNum:
            commentTextViewAndSubmmitCell = cell as? CommentTextViewAndSubmitCell
        default:
            commentTagCell = cell as? CommentTagCell
        }
        cell.orderCommentPage = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.width
        let tagStringLong = 2
        let tagNum = array.count
        switch UIScreen.main.bounds.width {
        case 320:
            switch indexPath.item {
            case 0:
                return CGSize(width: w, height: 80)
            case 1:
                return CGSize(width: w, height: 50)
            case 2+tagNum:
                return CGSize(width: w, height: 350)
            default:
                return CGSize(width: 20*tagStringLong, height: 400)
            }
        case 375:
            switch indexPath.item {
            case 0:
                return CGSize(width: w, height: 128)
            case 1:
                return CGSize(width: w, height: 50)
            case 2+tagNum:
                return CGSize(width: w, height: 440)
            default:
                return CGSize(width: 20*tagStringLong, height: 400)
            }
        case 414:
            switch indexPath.item {
            case 0:
                return CGSize(width: w, height: 167)
            case 1:
                return CGSize(width: w, height: 50)
            case 2+tagNum:
                return CGSize(width: w, height: 500)
            default:
                return CGSize(width: 20*tagStringLong, height: 400)
            }
        default:
            switch indexPath.item {
            case 0:
                return CGSize(width: w, height: 196)
            case 1:
                return CGSize(width: w, height: 50)
            case 2+tagNum:
                return CGSize(width: w, height: 540)
            default:
                return CGSize(width: 20*tagStringLong, height: 400)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

