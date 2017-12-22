//
//  ShipperInfoViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/21/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import MessageUI
import BPCircleActivityIndicator

class ShipperInfoViewController: UIViewController,MFMessageComposeViewControllerDelegate{
    
    var phoneNumber:String?
    
    @IBOutlet weak var userImageBtn: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var rateViewWidth: NSLayoutConstraint!
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var commentLabel: UILabel!
    
    let cellId = "ShipperRatingCellId"
    var commenteeId: Int?
    var commenteeRealName: String?
    var commenteeImage: String?
    var hasLoadData: Bool! = false
    var loadMoreEnable = true
    var offset: Int = 0
    
    var circleIndicator: BPCircleActivityIndicator!
    let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)

    var doneLabel: UILabel = {
        let l = UILabel()
        l.text = L("personal.ui.placeholder.comment")
        l.textAlignment = .center
        l.isHidden = true
        l.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return l
    }()
    
    var commentDict: UserComments?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = L("personal.ui.title.shiperinfo-comments")
        setupIndicator()
        getShipperCommentInformation()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    private func setupIndicator(){
        circleIndicator = BPCircleActivityIndicator()
        circleIndicator.frame = CGRect(x:view.center.x-15,y:view.center.y-105,width:0,height:0)
        circleIndicator.isHidden = true
        view.addSubview(circleIndicator)
    }
    
    private func getShipperCommentInformation(){
        guard let userId = commenteeId else { return }
        circleIndicator.isHidden = false
        circleIndicator.animate()
        ApiServers.shared.getUserComments(commenteeId: userId, offset: 0, completion: { (userComent, error) in
            guard error == nil else {return}
            self.circleIndicator.stop()
            self.circleIndicator.isHidden = true
            if let userCommnt = userComent{
                self.commentDict = userCommnt
                self.setupUserRate()
                self.hasLoadData = true
                self.commentTable.reloadData()
                if self.commentDict?.comments.count == 0 {
                    self.activityViewIndicator.stopAnimating()
                    self.doneLabel.isHidden = false
                }else{
                    self.doneLabel.isHidden = true
                }
            }
        })
    }
    
    private func setupTableView(){
        commentTable.tableFooterView = setupLoadMoreView()
        commentTable.allowsSelection = false
    }
    
    private func setupLoadMoreView() ->UIView{
        let view = UIView(frame: CGRect(x: 0, y:self.commentTable.contentSize.height,
                                        width:self.commentTable.bounds.size.width, height: 60))
        view.autoresizingMask = UIViewAutoresizing.flexibleWidth
        view.backgroundColor = UIColor.clear
        
        //添加中间的环形进度条
        activityViewIndicator.color = UIColor.darkGray
        let indicatorX = view.frame.midX - activityViewIndicator.frame.midX
        let indicatorY = view.frame.midY - activityViewIndicator.frame.midY
        activityViewIndicator.frame = CGRect(x: indicatorX, y: indicatorY,
                                             width: activityViewIndicator.frame.width,
                                             height: activityViewIndicator.frame.height)
        let w: CGFloat = 250
        doneLabel.frame = CGRect(x: self.view.frame.midX - (w / 2.0),
                                 y: indicatorY + 20,
                                 width: w,
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
            rateViewWidth.constant = CGFloat(commentDictionary.rank*20)
            commentLabel.text = "\(L("personal.ui.title.comments-all-p1")) \(commentDictionary.commentsLength) \(L("personal.ui.title.comments-all-p2"))"
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
            let alertController = UIAlertController(title: L("personal.confirm.title.send-message"),
                                                    message: L("personal.confirm.message.send-message-p1") + "\(str)" + L("personal.confirm.message.send-message-p2"), preferredStyle: .alert)
            let cancleAction = UIAlertAction(title: L("action.cancel"), style: .cancel, handler: nil)
            let sendAction = UIAlertAction(title: L("action.ok"), style: .default) { (alertController) in
                //判断设备是否能发短信(真机还是模拟器)
                if MFMessageComposeViewController.canSendText() {
                    let controller = MFMessageComposeViewController()
                    //短信的内容,可以不设置
                    controller.body = L("personal.confirm.message.send-body")
                    //联系人列表
                    controller.recipients = [str]
                    controller.messageComposeDelegate = self
                    self.present(controller, animated: true,completion: nil)
                } else {
                    print("本设备不能发短信")
                    self.displayGlobalAlertActions(title: L("sender.error.title.upload"),
                                                   message: L("personal.error.message.send-message"),
                                                   actions: [L("action.ok")], completion: nil)
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
                dateFormat.dateFormat = L("personal.ui.dateformat.cn")
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
                        activityViewIndicator.stopAnimating()
                    }
                }
            }
        }
    }
}
