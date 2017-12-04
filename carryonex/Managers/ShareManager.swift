//
//  ShareManager.swift
//  
//
//  Created by zxbMacPro on 2017/12/4.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FacebookShare

class ShareManager: UIViewController{
    
    static let shared = ShareManager()
    var ShareMessage: String!
    var ShareTitle: String!
    var alert: UIAlertController?
    
    lazy var wechatButton : UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "wechatIcon"), for: .normal)
        b.addTarget(self, action: #selector(shareToWechat), for: .touchUpInside)
        return b
    }()
    
    lazy var momentButton : UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "friendCircle"), for: .normal)
        b.addTarget(self, action: #selector(shareToMonent), for: .touchUpInside)
        return b
    }()
    
    lazy var weiboButton : UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "weiboIcon"), for: .normal)
        b.addTarget(self, action: #selector(shareToWeibo), for: .touchUpInside)
        return b
    }()
    
    lazy var facebookButton : UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "facebookIcon"), for: .normal)
        b.addTarget(self, action: #selector(shareToFacebook), for: .touchUpInside)
        return b
    }()
    
    var wechatLabel :UILabel = {
        let l = UILabel()
        l.text = "微信"
        l.font = UIFont(name: "Avenir-Light", size: 10.0)
        return l
    }()
    
    var momentLabel :UILabel = {
        let l = UILabel()
        l.text = "朋友圈"
        l.font = UIFont(name: "Avenir-Light", size: 10.0)
        return l
    }()
    
    var weiboLabel :UILabel = {
        let l = UILabel()
        l.text = "微博"
        l.font = UIFont(name: "Avenir-Light", size: 10.0)
        return l
    }()
    
    var facebookLabel :UILabel = {
        let l = UILabel()
        l.text = "facebook"
        l.font = UIFont(name: "Avenir-Light", size: 10.0)
        return l
    }()
    
    func setupShareFrame()->UIAlertController{
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        let alertController = UIAlertController.shareFrame
        let margin: CGFloat = 10.0
        let viewWidth: CGFloat = alertController.view.bounds.size.width - margin * 4.0
        let rect = CGRect(x: margin, y: margin, width: viewWidth, height: 120)
        let shareView = UIView(frame: rect)
        alertController.view.addSubview(shareView)
    
        shareView.backgroundColor = .clear
        shareView.addSubview(wechatButton)
        shareView.addSubview(momentButton)
        shareView.addSubview(weiboButton)
        shareView.addSubview(facebookButton)
    
        let w: CGFloat = isPhone ? ((viewWidth - 25) / 4) : 63
        let l: CGFloat = 5
        let y: CGFloat = -10
        let t: CGFloat = 5
        wechatButton.addConstraints(left: shareView.leftAnchor, top: nil, right: nil, bottom:nil , leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: w)
        momentButton.addConstraints(left: wechatButton.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: w)
        weiboButton.addConstraints(left: momentButton.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: w)
        facebookButton.addConstraints(left: weiboButton.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: w)
    
        wechatButton.centerYAnchor.constraint(equalTo: shareView.centerYAnchor, constant: y).isActive = true
        momentButton.centerYAnchor.constraint(equalTo: shareView.centerYAnchor, constant: y).isActive = true
        weiboButton.centerYAnchor.constraint(equalTo: shareView.centerYAnchor, constant: y).isActive = true
        facebookButton.centerYAnchor.constraint(equalTo: shareView.centerYAnchor, constant: y).isActive = true
    
        shareView.addSubview(facebookLabel)
        shareView.addSubview(wechatLabel)
        shareView.addSubview(momentLabel)
        shareView.addSubview(weiboLabel)
    
        facebookLabel.centerXAnchor.constraint(equalTo: facebookButton.centerXAnchor).isActive = true
        wechatLabel.centerXAnchor.constraint(equalTo: wechatButton.centerXAnchor).isActive = true
        momentLabel.centerXAnchor.constraint(equalTo: momentButton.centerXAnchor).isActive = true
        weiboLabel.centerXAnchor.constraint(equalTo: weiboButton.centerXAnchor).isActive = true
    
        wechatLabel.addConstraints(left: nil, top: wechatButton.bottomAnchor, right: nil, bottom:nil , leftConstent: 0, topConstent: t, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        momentLabel.addConstraints(left: nil, top: momentButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: t, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        weiboLabel.addConstraints(left: nil, top: weiboButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: t, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        facebookLabel.addConstraints(left: nil, top: facebookButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: t, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
    
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        if !isPhone { // iPad MUST setup reference for alertViewController
            shareView.frame = CGRect(x: 10, y: 24, width: 200, height: 100)
        }
        alert = alertController
        alertController.addAction(cancelAction)
        return alertController
    }
    
    func SetupShareInfomation(shareMessage:String,shareTitle:String){
        ShareMessage = shareMessage
        ShareTitle = shareTitle
    }
    
    
    func shareToWechat(){
        let title: String = "CarryonEx 帮你把思念带回家"
        let msg: String = ""
        shareToWeChat(scene: WXSceneSession, textMsg: "\(title)🚚😊 \(msg)", image: nil, imageFileName: nil, webUrl: "https://www.carryonex.com/")
        
    }
    
    func shareToMonent(){
        let title: String = "CarryonEx 帮你把思念带回家"
        let msg: String = "关注我们的网站获取更多活动信息：https://www.carryonex.com/"
        shareToWeChat(scene: WXSceneTimeline, textMsg: "\(title)🚚😊 \(msg)", image: nil, imageFileName: nil, webUrl: "https://www.carryonex.com/")
    }
    
    func shareToWeibo(){
        alert?.dismiss(animated: true, completion: { [weak self] in
            self?.prepareSharing(title: ShareManager.shared.ShareTitle, msg: ShareManager.shared.ShareMessage, img: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"),url:"https://www.carryonex.com/" , type: SSDKPlatformType.typeSinaWeibo)
        })
    }
    
    func shareToFacebook(){
        //不知道怎么关闭alertcontroller，让facebook页面出来
        self.dismiss(animated: true, completion: nil)
        if let token = FBSDKAccessToken.current() {
            print("\n\rget FBSDKAccessToken: \(token)")
        }
        let title: String = ShareManager.shared.ShareTitle
        let msg: String = ShareManager.shared.ShareMessage
        let url = URL(string: "https://www.carryonex.com")
        //let url = URL(string: "http://www.xingyu-gu.com")
        let imgUrl = URL(string: "https://static.wixstatic.com/media/6e8d8c_24b10870843c4f74ae760e7fd4317b69~mv2.png/v1/fill/w_161,h_66,al_c,usm_0.66_1.00_0.01/6e8d8c_24b10870843c4f74ae760e7fd4317b69~mv2.png")
        
        let content = LinkShareContent(url: url!, title: title, description: "description!!!", quote: msg, imageURL: imgUrl) //FBSDKShareLinkContent()
        do {
            try ShareDialog.show(from: self, content: content)
        } catch let err {
            print(err)
            let msg = "分享好像没发出去，错误信息：\(err)"
            self.displayAlert(title: "哎呀分享失败啦", message: msg, action: "换个姿势再来一次")
        }
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
            web.webpageUrl = webUrl
            message.mediaObject = web
            message.title = ShareManager.shared.ShareTitle
            message.description = ShareManager.shared.ShareMessage
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
    
    private func prepareSharing(title: String, msg: String, img: UIImage,url:String , type: SSDKPlatformType) {
        
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(
            byText: msg,
            images : img, //UIImage(named: "shareImg.png"),
            url : NSURL(string:url) as URL!,
            title : title,
            type : SSDKContentType.image)
        //2.进行分享
        ShareSDK.share(type, parameters: shareParames) {
            (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in
            switch state{
            case SSDKResponseState.success:
                print("分享成功")
            case SSDKResponseState.fail:
                print("授权失败,错误描述:\(error?.localizedDescription ?? "get err in ")")
            case SSDKResponseState.cancel:
                print("操作取消")
            default:
                break
            }
        }
    }
    
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
