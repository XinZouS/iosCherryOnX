//
//  ShipperInfoViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/21/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import MessageUI

class ShipperInfoViewController: UIViewController,MFMessageComposeViewControllerDelegate{
    var phoneNumber:String?
    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateViewWidth: NSLayoutConstraint!
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var commentLabel: UILabel!
    let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
    let cellId = "ShipperRatingCellId"
    var commenteeId: Int?
    var commenteeRealName: String?
    var commenteeImage: String?
    var hasLoadData: Bool! = false
    var loadMoreEnable = true
    var offset: Int = 0
    var doneLabel: UILabel = {
        let l = UILabel()
        l.text = "亲，没有您有关的评论了哦~"
        l.isHidden = true
        l.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return l
    }()
    var commentDict: UserComments?
    override func viewDidLoad() {
        super.viewDidLoad()
        getShipperCommentInformation()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    private func getShipperCommentInformation(){
        if let userId = commenteeId{
            ApiServers.shared.getUserComments(commenteeId: userId, offset: 0, completion: { (userComent, error) in
                guard error == nil else {return}
                if let userCommnt = userComent{
                    self.commentDict = userCommnt
                    self.setupUserRate()
                    self.hasLoadData = true
                    self.commentTable.reloadData()
                }
            })
        }
    }
    private func setupTableView(){
        commentTable.tableFooterView = setupLoadMoreView()
        commentTable.allowsSelection = false
        title = "我的评价"
    }
    
    private func setupLoadMoreView() ->UIView{
        let view = UIView(frame: CGRect(x: 0, y:self.commentTable.contentSize.height,
                                        width:self.commentTable.bounds.size.width, height: 60))
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
    
    private func setupView(){
        if let ownerRealName = commenteeRealName,let ownerImageUrl = commenteeImage{
            userNameLabel.text = ownerRealName    //update to real name
            if let url = URL(string:ownerImageUrl){
                userImageBtn.af_setImage(for: .normal, url: url)
                //senderImageButton //TODO: add user image
            }else{
                userImageBtn.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
            }
        }
    }
    
    private func setupUserRate(){
        if let commentDictionary = commentDict{
            rateLabel.text = String(format: "%.1f",commentDictionary.rank)
            rateViewWidth.constant = CGFloat(commentDictionary.rank*16)
            commentLabel.text = "总共\(commentDictionary.commentsLength)条评价"
        }
    }
    
    @IBAction func PhoneButtonTapped(_ sender: Any) {
        if let phoneNum = phoneNumber{
            let PhoneNumberUrl = "tel://\(phoneNum)"
            if let url = URL(string: PhoneNumberUrl) {
                //根据iOS系统版本，分别处理
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:],
                                              completionHandler: {
                                                (success) in
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    

    @IBAction func messageButtonTapped(_ sender: Any) {
         if let phoneNum = phoneNumber{
            //设置联系人
            let str = phoneNum
            //创建一个弹出框提示用户
            let alertController = UIAlertController(title: "发短信", message: "是否给\(str)发送短信?", preferredStyle: .alert)
            let cancleAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let sendAction = UIAlertAction(title: "确定", style: .default) { (alertController) in
                //判断设备是否能发短信(真机还是模拟器)
                if MFMessageComposeViewController.canSendText() {
                    let controller = MFMessageComposeViewController()
                    //短信的内容,可以不设置
                    controller.body = "你好"
                    //联系人列表
                    controller.recipients = [str]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true,completion: nil)
                } else {
                    print("本设备不能发短信")
                }
            }
            alertController.addAction(cancleAction)
            alertController.addAction(sendAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
        //判断短信的状态
        switch result{
        case .sent:
            print("短信已发送")
        case .cancelled:
            print("短信取消发送")
        case .failed:
            print("短信发送失败")
        }
    }
    
    func UpdateHistoryComment(){
        activityViewIndicator.startAnimating()
        loadMoreEnable = false
        if let userId = commenteeId{
            ApiServers.shared.getUserComments(commenteeId: userId, offset: offset) { (userCommnt, error) in
                guard error == nil else {return}
                if let userCommnt = userCommnt{
                    for comments in userCommnt.comments{
                        self.commentDict?.comments.append(comments)
                    }
                    self.commentTable.reloadData()
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
extension ShipperInfoViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        let cell = commentTable.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ShipperInfoViewCell
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
}
extension ShipperInfoViewController: UIScrollViewDelegate {
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
