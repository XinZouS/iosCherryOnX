//
//  DetailCreditLevelCell++.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/20.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit

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
//    func MessageButtonTap(){
//        //首先要判断设备具不具备发送短信功能
//        if MFMessageComposeViewController.canSendText(){
//            let controller = MFMessageComposeViewController()
//            //设置短信内容
//            controller.body = "短信内容：欢迎来到hangge.com"
//            //设置收件人列表
//            controller.recipients = ["123456","120000"]
//            //设置代理
//            controller.messageComposeDelegate = self
//            //打开界面
//            self.presentViewController(controller, animated: true, completion: { () -> Void in
//                
//            })
//        }else{
//            print("本设备不能发送短信")
//        }
//    }
    func LinkinButtonTap(){
        
    }
}
