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
    var request: Request?
    var commentDict: UserComments?
    override func viewDidLoad() {
        super.viewDidLoad()
        getShipperCommentInformation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    private func getShipperCommentInformation(){
        if let userId = request?.ownerId{
            ApiServers.shared.getUserComments(commenteeId: userId, offset: 0, completion: { (userComent, error) in
                guard error == nil else {return}
                if let userCommnt = userComent{
                    self.commentDict = userCommnt
                    self.setupUserRate()
                }
            })
        }
    }
    
    private func setupView(){
        if let request = request {
            userNameLabel.text = request.ownerRealName    //update to real name
            if let urlString = request.ownerImageUrl,let url = URL(string:urlString){
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
}
