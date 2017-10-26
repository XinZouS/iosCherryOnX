//
//  RequestSendController++.swift
//  carryonex
//
//  Created by Xin Zou on 8/27/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Social
import FBSDKCoreKit
import FBSDKShareKit
import FacebookShare

extension WaitingController: FBSDKSharingDelegate {
    
    
    internal func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    
    
    func shareToWechat(){
        let title: String = "CarryonEx 帮你把思念带回家"
        let msg: String = "关注[游箱]网站获取更多活动信息： https://www.carryonex.com/"
        // mob.com sdk:
        //prepareSharing(title: title, msg: msg, img: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"), type: SSDKPlatformType.typeWechat)
        
        // wechat offical sdk:
        shareToWeChat(scene: WXSceneSession, textMsg: "\(title)🚚😊 \(msg)", image: nil, imageFileName: nil, webUrl: nil)
    }
    
    func shareToMonent(){
        let title: String = "CarryonEx 帮你把思念带回家"
        let msg: String = "关注我们的网站获取更多活动信息：https://www.carryonex.com/"
        //prepareSharing(title: title, msg: msg, img: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"), type: SSDKPlatformType.typeWechat)
        
        // wechat offical sdk:
        shareToWeChat(scene: WXSceneTimeline, textMsg: "\(title)🚚😊 \(msg)", image: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"), imageFileName: "CarryonEx_OnBoarding-02-1.png", webUrl: nil)
    }
    
    func shareToWeibo(){
        let title: String = "CarryonEx 帮你把思念带回家"
        let msg: String = "关注我们的网站获取更多活动信息：https://www.carryonex.com/"
        prepareSharing(title: title, msg: msg, img: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"), type: SSDKPlatformType.typeSinaWeibo)
    }
    
    func shareToFacebook(){
        if let token = FBSDKAccessToken.current() {
            print("\n\rget FBSDKAccessToken: \(token)")
        }
        let title: String = "CarryonEx 帮你把思念带回家"
        let msg: String = "关注我们的网站获取更多活动信息：https://www.carryonex.com/"
        let url = URL(string: "https://www.carryonex.com/download/")
        //let url = URL(string: "http://www.xingyu-gu.com")
        let imgUrl = URL(string: "https://static.wixstatic.com/media/6e8d8c_24b10870843c4f74ae760e7fd4317b69~mv2.png/v1/fill/w_161,h_66,al_c,usm_0.66_1.00_0.01/6e8d8c_24b10870843c4f74ae760e7fd4317b69~mv2.png")
        
        let content = LinkShareContent(url: url!, title: title, description: "description!!!", quote: msg, imageURL: imgUrl) //FBSDKShareLinkContent()
        do {
            try ShareDialog.show(from: self, content: content)
        }catch let err {
            print(err)
            let msg = "分享好像没发出去，错误信息：\(err)"
            self.displayAlert(title: "哎呀分享失败啦", message: msg, action: "换个姿势再来一次")
        }
        
        // plan B: the same as above
//        let myContent:FBSDKShareLinkContent = FBSDKShareLinkContent()
//        myContent.contentTitle = title
//        myContent.contentDescription = msg
//        myContent.contentURL = url
//        myContent.quote = msg
//        
//        let shareDialog = FBSDKShareDialog()
//        shareDialog.mode = .shareSheet
//        FBSDKShareDialog.show(from: self, with: myContent, delegate: nil)
//        
//        let vc = SLComposeViewController(forServiceType:SLServiceTypeFacebook)
//        vc?.add(#imageLiteral(resourceName: "CarryonEx_OnBoarding-02-1"))
//        vc?.add(url) //Your custom URL
//        vc?.setInitialText("setInitialText: Your sample share message...")
//        self.present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    private func shareToWeChat(scene: WXScene, textMsg: String, image: UIImage?, imageFileName: String?, webUrl: String?){
        let req = SendMessageToWXReq()
        let message = WXMediaMessage()
        // 1. share Image:
        if let img = image {
            //message.setThumbImage(img)  //生成缩略图
            UIGraphicsBeginImageContext(CGSize(width: 200, height: 200))
            img.draw(in: CGRect(x: 0, y: 0, width: 100, height: 100))
            if let thumbImage = UIGraphicsGetImageFromCurrentImageContext() {
                UIGraphicsEndImageContext()
                message.thumbData = UIImagePNGRepresentation(thumbImage)
            }
            let imgObj = WXImageObject()
            if let d = UIImagePNGRepresentation(img) {
                imgObj.imageData = d
                message.mediaObject = imgObj
                message.title=nil
                message.description=nil
                message.mediaTagName = "CarryonEx[游箱]"
            }
            req.bText = false
            req.message = message
        
        } else if webUrl != nil { // 2. share offical Website:
            let web =  WXWebpageObject()
            web.webpageUrl = "https://www.carryonex.com/"
            message.mediaObject = web
            message.title = "CarryonEx [游箱]帮你把思念带回家"
            message.description = "关注[游箱]网站获取更多活动信息：https://www.carryonex.com/"
            message.setThumbImage(#imageLiteral(resourceName: "CarryonExIcon-29"))
            
            req.bText = false
            req.message = message

        } else { // 3. share text message:
            req.bText = true
            req.text = textMsg
        }
        req.scene = Int32(scene.rawValue) //Int32(WXSceneSession.rawValue) // 
        WXApi.send(req)
    }
    
    // MARK: -
    
    private func prepareSharing(title: String, msg: String, img: UIImage, type: SSDKPlatformType) {
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(
            byText: msg,
            images : img, //UIImage(named: "shareImg.png"),
            url : NSURL(string:"http://mob.com") as URL!,
            title : title,
            type : SSDKContentType.image)
        
        //2.进行分享
        ShareSDK.share(type, parameters: shareParames) {
            (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            
            switch state{
            case SSDKResponseState.success: print("分享成功")
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error?.localizedDescription)")
            case SSDKResponseState.cancel:  print("操作取消")
            default:
                break
            }
            
        }

    }
    
    
    // MARK: - FBSDKSharingDelegate
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        print("share err: \(error)")
    }
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print("did complete with result = \(results)")
    }
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        print("sharerDidCancel....")
    }
    
    
    
    
}

// MARK: - Pop alert view
extension WaitingController {
    
    func displayAlert(title: String, message: String, action: String) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        v.addAction(action)
        present(v, animated: true, completion: nil)
    }
    
}

