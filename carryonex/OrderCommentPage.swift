//
//  OrderCommentPage.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/30.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class OrderCommentPage: UICollectionViewController, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate{
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .black
        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    var array = ["神速","超级细心","骗子","善于沟通","很有责任心"]
    var forLongIndex = 0
    var forNameIndex = 0
    
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
        collectionView?.register(CommentTagCell.self, forCellWithReuseIdentifier:commentTagCellId)
        collectionView?.register(CommentTextViewAndSubmitCell.self, forCellWithReuseIdentifier:commentTextviewAndSubmitCellId)
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
        switch indexPath.item {
        case 0 :
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentUserNameCell
            commentUserNameCell = cell
            cell.orderCommentPage = self
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentViewCell
            commentViewCell = cell
            cell.orderCommentPage = self
            return cell
        case 2+tagNum:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as!CommentTextViewAndSubmitCell
            commentTextViewAndSubmmitCell = cell
            cell.orderCommentPage = self
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CommentTagCell
            commentTagCell = cell
            cell.commentStateLabel.text  = array[indexPath.item-2]
            cell.orderCommentPage = self
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.width
        let tagNum = array.count
        var tagStringLong = 0
        switch indexPath.item {
        case 0:
            return CGSize(width: w, height: 128)
        case 1:
            return CGSize(width: w, height: 150)
        case 2+tagNum:
            return CGSize(width: w, height: 240)
        default:
            tagStringLong = array[forLongIndex].count
            forLongIndex += 1
            return CGSize(width: 30*tagStringLong, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

