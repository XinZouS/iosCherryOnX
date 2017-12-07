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
    var loadMoreEnable = true
    var offset: Int = 0
    let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    var doneLabel: UILabel = {
        let l = UILabel()
        l.text = "亲，没有您有关的评论了哦~"
        l.isHidden = true
        l.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return l
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComment()
        setupTableView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gotoOtherPeopleIntro",let viewController = segue.destination as? ShipperInfoViewController,let dictionary = commentDict{
            let index = sender as! Int
            viewController.commenteeId = dictionary.comments[index].id
            viewController.commenteeImage = dictionary.comments[index].imageUrl
            viewController.commenteeRealName = dictionary.comments[index].realName
        }
    }
    
    private func setupTableView(){
        commentTableView.tableFooterView = setupLoadMoreView()
        commentTableView.allowsSelection = true
        title = "我的评价"
    }
    
    private func setupLoadMoreView() ->UIView{
        let view = UIView(frame: CGRect(x: 0, y:self.commentTableView.contentSize.height,
                                           width:self.commentTableView.bounds.size.width, height: 60))
            view.autoresizingMask = UIViewAutoresizing.flexibleWidth
            view.backgroundColor = UIColor.clear
            
            //添加中间的环形进度条
            activityViewIndicator.color = UIColor.darkGray
            let indicatorX = view.frame.size.width/2-activityViewIndicator.frame.width/2
            let indicatorY = view.frame.size.height/2-activityViewIndicator.frame.height/2
            activityViewIndicator.frame = CGRect(x: indicatorX,y: indicatorY,
                                                 width: activityViewIndicator.frame.width,
                                                 height: activityViewIndicator.frame.height)
            doneLabel.frame = CGRect(x: self.view.frame.size.width/2-125,
                                     y: indicatorY,
                                     width: 250,
                                     height: activityViewIndicator.frame.height)
            view.addSubview(activityViewIndicator)
            view.addSubview(doneLabel)
            return view
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
                            if self.commentDict?.comments.count == 0 {
                                self.activityViewIndicator.stopAnimating()
                                self.doneLabel.isHidden = false
                            }
                        }
                    }
                }
            }
    }
    func UpdateHistoryComment(){
        activityViewIndicator.startAnimating()
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
    func isLoadAllData(){
        if let dictionary = commentDict{
            if (dictionary.comments.count == dictionary.commentsLength){
                doneLabel.isHidden = false
                activityViewIndicator.stopAnimating()
                loadMoreEnable = false
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
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if hasLoadData{
            cell.commentTextView.text = commentDict?.comments[indexPath.row].comment
            if let rank = commentDict?.comments[indexPath.row].rank{
                cell.rateViewConstraint.constant = CGFloat(rank*10)
            }
            cell.userNameLabel.text = commentDict?.comments[indexPath.row].realName
            
            if let imageUrl = commentDict?.comments[indexPath.row].imageUrl,let url = URL(string:imageUrl){
                cell.userButton.af_setImage(for: .normal, url: url, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, completion: nil)
            } else {
                cell.userButton.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
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
                    isLoadAllData()
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        performSegue(withIdentifier: "gotoOtherPeopleIntro", sender: index)
    }
}
extension PersonalCommentController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Float(scrollView.contentOffset.y) > Float(scrollView.contentSize.height - scrollView.frame.size.height) {
            if (loadMoreEnable){
                if let commentsLength = commentDict?.commentsLength{
                    if offset < commentsLength-1{
                        offset += 4
                        UpdateHistoryComment()
                    }else{
                        print("load All data")
                        doneLabel.isHidden = false
                        activityViewIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
