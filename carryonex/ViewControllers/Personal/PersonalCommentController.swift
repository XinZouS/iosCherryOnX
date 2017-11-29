//
//  PersonalCommentController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/29.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class PersonalCommentController: UIViewController{
    @IBOutlet weak var commentTableView: UITableView!
    let cellId = "UserCommentCellId"
    var commentDict: [String: Any]!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchComment()
        setupTableView()
    }
    private func setupTableView(){
        commentTableView.allowsSelection = false
        title = "我的评价"
    }
    
    private func fetchComment(){
    if let userInfo = ProfileManager.shared.getCurrentUser(){
        if let userId = userInfo.id{
            ApiServers.shared.getUserComments(commenteeId: userId, offset: 5) { (userCommnt, error) in
                    guard error != nil else {return}
//                    self.commentDict.append(contentsOf: userCommnt)
                    self.commentTableView.reloadData()
                }
            }
        }
    }
}

extension PersonalCommentController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PersonalCommentCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
