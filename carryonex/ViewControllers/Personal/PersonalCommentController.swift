//
//  PersonalCommentController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/29.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit
import AlamofireImage

class PersonalCommentController: UIViewController{
    @IBOutlet weak var commentTableView: UITableView!
    let cellId = "UserCommentCellId"
    var commentDict: UserComments?
    var hasLoadData: Bool! = false
    var loadMoreView:UIView?
    var loadMoreEnable = true
    var offset: Int = 0
    let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComment()
        setupTableView()
        setupLoadMoreView()
        self.commentTableView.tableFooterView = self.loadMoreView
    }
    private func setupTableView(){
        commentTableView.allowsSelection = false
        title = "我的评价"
    }
    
    private func setupLoadMoreView() {
        self.loadMoreView = UIView(frame: CGRect(x: 0, y:self.commentTableView.contentSize.height,
                                                 width:self.commentTableView.bounds.size.width, height: 60))
        self.loadMoreView!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.loadMoreView!.backgroundColor = UIColor.clear
        
        //添加中间的环形进度条
        activityViewIndicator.color = UIColor.darkGray
        let indicatorX = self.loadMoreView!.frame.size.width/2-activityViewIndicator.frame.width/2
        let indicatorY = self.loadMoreView!.frame.size.height/2-activityViewIndicator.frame.height/2
        activityViewIndicator.frame = CGRect(x: indicatorX,y: indicatorY,
                                             width: activityViewIndicator.frame.width,
                                             height: activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        self.loadMoreView!.addSubview(activityViewIndicator)
    }
    
    func fetchComment(){
        if let userInfo = ProfileManager.shared.getCurrentUser(){
            if let userId = userInfo.id{
                ApiServers.shared.getUserComments(commenteeId: userId, offset: offset) { (userCommnt, error) in
                        guard error == nil else {return}
                        if let userCommnt = userCommnt{
                            self.commentDict = userCommnt
                            self.hasLoadData = true
                            self.commentTableView.reloadData()
                        }
                    }
                }
            }
    }
    func UpdateHistoryComment(){
        loadMoreEnable = false
        if let userInfo = ProfileManager.shared.getCurrentUser(){
            if let userId = userInfo.id{
                ApiServers.shared.getUserComments(commenteeId: userId, offset: offset) { (userCommnt, error) in
                    guard error == nil else {return}
                    if let userCommnt = userCommnt{
                        for comments in userCommnt.comments{
                            self.commentDict?.comments.append(comments)
                        }
                        self.commentTableView.reloadData()
                    }
                }
            }
        }
    }
}

    

extension PersonalCommentController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasLoadData{
            if let rowNum = commentDict?.comments.count{
                return rowNum
            }else{
              return 0
            }
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PersonalCommentCell
        if hasLoadData{
            cell.commentTextView.text = commentDict?.comments[indexPath.row].comment
            if let rank = commentDict?.comments[indexPath.row].rank{
                cell.rateViewConstraint.constant = CGFloat(rank*10)
            }
            cell.userNameLabel.text = commentDict?.comments[indexPath.row].realName
            
            if let imageUrl = commentDict?.comments[indexPath.row].imageUrl,let url = URL(string:imageUrl){
                cell.userButton.af_setImage(for: .normal, url: url, placeholderImage: #imageLiteral(resourceName: "CarryonEx_User"), filter: nil, progress: nil, completion: nil)
            } else {
                cell.userButton.setImage(#imageLiteral(resourceName: "CarryonEx_User"), for: .normal)
            }
            
            if let timeStamp = commentDict?.comments[indexPath.row].timestamp{
                let dateFormat = DateFormatter()
                dateFormat.dateFormat = "yyyy年MM日dd日"
                let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
                cell.timeLabel.text = dateFormat.string(from: date)
            }
            if let count = commentDict?.comments.count{
                if (indexPath.row == count-1) {
                    loadMoreEnable = true
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
extension PersonalCommentController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Float(scrollView.contentOffset.y) > Float(scrollView.contentSize.height - scrollView.frame.size.height) {
            if (loadMoreEnable){
                if let commentsLength = commentDict?.commentsLength{
                    if offset < commentsLength-1{
                        offset += 1
                        UpdateHistoryComment()
                    }else{
                        print("load All data")
                        activityViewIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
