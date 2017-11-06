//
//  OrderDetailCommentPageController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/6.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

class OrderDetailCommentPageController: UICollectionViewController, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate{
    
    var transparentView : UIView = {
        let v = UIView()
        v.isHidden = true
        v.backgroundColor = .black
//        v.addGestureRecognizer(UITapGestureRecognizer(target: self,action:#selector(textFieldsInAllCellResignFirstResponder)))
        return v
    }()
    var index = 0
    var forLongIndex = 0
    var forNameIndex = 0
    
    var request = Request()
    let orderDetailCommentTitleCellId = "commentDetailCommentTitleCellId"
    let orderDetailCommentInfoCellId = "commentDetailCommentInfoCellId"
    
    var orderDetailCommentTitleCell : OrderDetailCommentTitleCell?
    var orderDetailCommentInfoCell : OrderDetailCommentInfoCell?
    var orderDetailCommentBaseCell : OrderDetailCommentBaseCell?
    
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
        collectionView?.register(OrderDetailCommentTitleCell.self, forCellWithReuseIdentifier: orderDetailCommentTitleCellId)
        collectionView?.register(OrderDetailCommentInfoCell.self, forCellWithReuseIdentifier:orderDetailCommentInfoCellId)
    }
    
    /// collectionView delegate
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let date1 = "20171031191234"
        let date2 = "20171017191234"
        let date3 = "20171030191234"
        let date4 = "20171019191234"
        let date5 = "20171015191234"
        let date6 = "20171024191234"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let infoDict : Dictionary<String,[String:Any]> = [
            "小红" : [
                "date" : formatter.date(from: date1) ?? "" ,
                "comment" : "从纽约到旧金山，一天就到了，很快"
            ],
            "小萌" : [
                "date" : formatter.date(from: date2) ?? "",
                "comment" : "帮父母带的保健品，三天就到家了，而且很便宜，赞！"
            ],
            "小傻" : [
                "date" : formatter.date(from: date3) ?? "",
                "comment" : "取件送件很及时！物品保护的也很好。。。期待再次合作。"
            ],
            "小牛" : [
                "date" : formatter.date(from: date4) ?? "",
                "comment" : "好快好快比我还快"
            ],
            "小鸡" : [
                "date" : formatter.date(from: date5) ?? "",
                "comment" : "快如老狗"
            ],
            "小辣椒" : [
                "date" : formatter.date(from: date6) ?? "",
                "comment" : "我觉得比小牛还要快"
            ]
        ]
        print(infoDict.count)
        return 1+infoDict.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cellId : String = orderDetailCommentTitleCellId
        let date1 = "20171031191234"
        let date2 = "20171017191234"
        let date3 = "20171030191234"
        let date4 = "20171019191234"
        let date5 = "20171015191234"
        let date6 = "20171024191234"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        let infoDict : Dictionary<String,[String:Any]> = [
            "小红" : [
                "date" : formatter.date(from: date1) ?? "" ,
                "comment" : "从纽约到旧金山，一天就到了，很快",
                "imageUrl" : "http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eod5pEU7wbhnrMH6UxubiacVwsI8IEB3h2d9g3eGnOWy5dIKlKiaK2Ta57bpT2s6VM0uwibJiaYWtqVdw/0"
            ],
            "小萌" : [
                "date" : formatter.date(from: date2) ?? "",
                "comment" : "帮父母带的保健品，三天就到家了，而且很便宜，赞！",
                "imageUrl" : "http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eod5pEU7wbhnrMH6UxubiacVwsI8IEB3h2d9g3eGnOWy5dIKlKiaK2Ta57bpT2s6VM0uwibJiaYWtqVdw/0"
            ],
            "小傻" : [
                "date" : formatter.date(from: date3) ?? "",
                "comment" : "取件送件很及时！物品保护的也很好。。。期待再次合作。",
                "imageUrl" : "http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eod5pEU7wbhnrMH6UxubiacVwsI8IEB3h2d9g3eGnOWy5dIKlKiaK2Ta57bpT2s6VM0uwibJiaYWtqVdw/0"
            ],
            "小牛" : [
                "date" : formatter.date(from: date4) ?? "",
                "comment" : "好快好快比我还快",
                "imageUrl" : "http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eod5pEU7wbhnrMH6UxubiacVwsI8IEB3h2d9g3eGnOWy5dIKlKiaK2Ta57bpT2s6VM0uwibJiaYWtqVdw/0"
            ],
            "小鸡" : [
                "date" : formatter.date(from: date5) ?? "",
                "comment" : "快如老狗",
                "imageUrl" : "http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eod5pEU7wbhnrMH6UxubiacVwsI8IEB3h2d9g3eGnOWy5dIKlKiaK2Ta57bpT2s6VM0uwibJiaYWtqVdw/0"
            ],
            "小辣椒" : [
                "date" : formatter.date(from: date6) ?? "",
                "comment" : "我觉得比小牛还要快",
                "imageUrl" : "http://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eod5pEU7wbhnrMH6UxubiacVwsI8IEB3h2d9g3eGnOWy5dIKlKiaK2Ta57bpT2s6VM0uwibJiaYWtqVdw/0"
            ]
        ]
        let keys = Array(infoDict.keys)
        switch indexPath.item{
        case 0:
            cellId = orderDetailCommentTitleCellId
        default:
            cellId = orderDetailCommentInfoCellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OrderDetailCommentBaseCell
        switch indexPath.item{
        case 0:
            orderDetailCommentTitleCell = cell as? OrderDetailCommentTitleCell
            orderDetailCommentTitleCell?.CommentNumLabel.text = "\(infoDict.count)个评价"
            orderDetailCommentTitleCell?.CommentNumLabel.textAlignment = .left
            orderDetailCommentTitleCell?.CommentNumLabel.font = UIFont.systemFont(ofSize: UIScreen.main.bounds.width < 325 ? 20 : 24) // i5 < 400 < i6,7
            let commentLevel = 4
            switch commentLevel {
            case 1:
                orderDetailCommentTitleCell?.StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
            case 2:
                orderDetailCommentTitleCell?.StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn2.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
            case 3:
                orderDetailCommentTitleCell?.StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn2.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn3.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
            case 4:
                orderDetailCommentTitleCell?.StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn2.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn3.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn4.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
            case 5:
                orderDetailCommentTitleCell?.StarCommentBtn1.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn2.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn3.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn4.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
                orderDetailCommentTitleCell?.StarCommentBtn5.setImage(#imageLiteral(resourceName: "carryonex_star"), for: .normal)
            default:
                break
            }
        default:
            orderDetailCommentInfoCell = cell as? OrderDetailCommentInfoCell
            orderDetailCommentInfoCell?.nameLabel.text = keys[indexPath.item-1]
        }
        cell.orderDetailCommentPageCtl = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w: CGFloat = collectionView.bounds.width
        switch indexPath.item {
        case 0:
            return CGSize(width: w, height: 150)
        default:
            return CGSize(width:w, height: 150)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
}

