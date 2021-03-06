//
//  PersonalCommentController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/29.
//  Copyright © 2017 CarryonEx. All rights reserved.
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
    var circleIndicator: BPCircleActivityIndicator! // one is for entire page, one is for reload, shoud give them correct names. - Xin
    let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    
    var doneLabel: UILabel = {
        let l = UILabel()
        l.text = L("personal.ui.placeholder.comment")
        l.textAlignment = .center
        l.isHidden = true
        l.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupIndicator()
        fetchComment()
        setupTableView()
        setupNavigationBar()
    }
    
    private func setupIndicator(){
        circleIndicator = BPCircleActivityIndicator()
        circleIndicator.center = CGPoint(x: view.center.x - 15, y: view.center.y - 60)
        circleIndicator.isHidden = true
        view.addSubview(circleIndicator)
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
        commentTableView.separatorColor = colorTableCellSeparatorLightGray
    }
    
    private func setupNavigationBar(){
        title = L("personal.ui.title.my-comments")
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.shadowImage = colorTableCellSeparatorLightGray.as1ptImage()
    }
    
    private func setupLoadMoreView() ->UIView{
        let view = UIView(frame: CGRect(x: 0,
                                        y: self.commentTableView.contentSize.height,
                                        width: self.commentTableView.bounds.size.width, height: 60))
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        view.backgroundColor = UIColor.clear
        
        //添加中间的环形进度条
        activityViewIndicator.color = UIColor.darkGray
        let indicatorX = view.frame.midX - activityViewIndicator.frame.midX
        let indicatorY = view.frame.midY - activityViewIndicator.frame.midY
        activityViewIndicator.frame = CGRect(x: indicatorX,y: indicatorY,
                                             width: activityViewIndicator.frame.width,
                                             height: activityViewIndicator.frame.height)
        let w: CGFloat = 250
        doneLabel.frame = CGRect(x: self.view.frame.midX - (w / 2.0),
                                 y: indicatorY,
                                 width: w,
                                 height: activityViewIndicator.frame.height)
        view.addSubview(activityViewIndicator)
        view.addSubview(doneLabel)
        return view
    }
    
    func fetchComment(){
        circleIndicator.isHidden = false
        circleIndicator.animate()
        if let userInfo = ProfileManager.shared.getCurrentUser(), let userId = userInfo.id {
            ApiServers.shared.getUserComments(commenteeId: userId, offset: offset) { (userCommnt, error) in
                guard error == nil else {return}
                self.circleIndicator.isHidden = true
                self.circleIndicator.stop()
                if let userCommnt = userCommnt {
                    self.commentDict = userCommnt
                    self.hasLoadData = true
                    self.commentTableView.reloadData()
                    if self.commentDict?.comments.count == 0 {
                        self.activityViewIndicator.stopAnimating()
                        self.doneLabel.isHidden = false
                    }else{
                        self.doneLabel.isHidden = true
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
}

    

extension PersonalCommentController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hasLoadData ? (commentDict?.comments.count ?? 0) : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PersonalCommentCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        if hasLoadData {
            cell.comment = commentDict?.comments[indexPath.row]
            
            if let count = commentDict?.comments.count, indexPath.row == count - 1 {
                loadMoreEnable = !(commentDict!.commentsLength == count)
                activityViewIndicator.stopAnimating()
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
                        DLog("load All data")
                        activityViewIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
