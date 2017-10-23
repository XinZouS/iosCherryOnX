//
//  DetailCreditLevelCell++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/20.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import MessageUI

extension DetailCreditLevelCell{
    func wechatButtonTap(){
        
    }
    
    func phoneButtonTap(){
        let PhoneNumberUrl = "tel://8613043579747"
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
    func MessageButtonTap(){
        //设置联系人
        let str = "18056088090"
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
                self.orderDetailPage?.present(controller, animated: true,completion: nil)
            } else {
                print("本设备不能发短信")
            }
        }
        alertController.addAction(cancleAction)
        alertController.addAction(sendAction)
        
        self.orderDetailPage?.present(alertController, animated: true, completion: nil)
    }
    func LinkinButtonTap(){
        
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
        default:
            print("短信已发送")
            break
        }
    }
}
