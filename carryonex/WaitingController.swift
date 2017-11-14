//
//  RequestArrangingController.swift
//  carryonex
//
//  Created by Xin Zou on 8/27/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FacebookShare

class WaitingController: UIViewController {
    
    var isForShipper : Bool = false
    
    let titleLabel: UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 18)
        b.textAlignment = .center
        b.text = "安排接单"
        return b
    }()
    
    lazy var closeButton: UIButton = {
        let b = UIButton()
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Close"), for: .normal)
        b.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return b
    }()
    
    let imageView: UIImageView = {
        let v = UIImageView()
        v.backgroundColor = .white
        v.contentMode = .scaleAspectFit
        v.image = #imageLiteral(resourceName: "CarryonEx_Waiting_B")
        return v
    }()
    
    let hintTextView : UITextView = {
        let b = UITextView()
        b.text = "游箱正在为您安排揽件人，当揽件人接到此单，游箱会第一时间通知您！"
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .center
        return b
    }()
    
    let underlineView : UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    let sharingTitle : UILabel = {
        let b = UILabel()
        b.font = UIFont.boldSystemFont(ofSize: 12)
        b.textAlignment = .center
        b.text = "分享给好友"
        return b
    }()
    
    var shareStackView : UIStackView!
    
    lazy var wechatButton : UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Wechat_Icon"), for: .normal)
        b.addTarget(self, action: #selector(shareToWechat), for: .touchUpInside)
        return b
    }()
    
    lazy var momentButton : UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Moment_Icon"), for: .normal)
        b.addTarget(self, action: #selector(shareToMonent), for: .touchUpInside)
        return b
    }()

    lazy var weiboButton : UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Weibo_Icon"), for: .normal)
        b.addTarget(self, action: #selector(shareToWeibo), for: .touchUpInside)
        return b
    }()
    
    lazy var facebookButton : UIButton = {
        let b = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        b.setImage(#imageLiteral(resourceName: "CarryonEx_Facebook_Icon"), for: .normal)
        b.addTarget(self, action: #selector(shareToFacebook), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        UIApplication.shared.statusBarStyle = .default
        title = "安排接单"
        
        setupTitleAndButton()
        setupImageView()
        setupHintTextView()
        setupUnderlineAndSharingLabel()
        setupShareStackView()
    }
    
    private func setupTitleAndButton(){
        view.addSubview(titleLabel)
        titleLabel.addConstraints(left: nil, top: view.topAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 30, rightConstent: 0, bottomConstent: 0, width: 150, height: 30)
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(closeButton)
        closeButton.addConstraints(left: nil, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 40, rightConstent: 20, bottomConstent: 0, width: 20, height: 20)
    }
    
    func setupImageView(){
        let imgWidth: CGFloat = view.bounds.width - 60
        let imgHeigh: CGFloat = imgWidth * (3.0 / 4.0) // image is 3:4
        view.addSubview(imageView)
        imageView.addConstraints(left: nil, top: titleLabel.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 30, rightConstent: 0, bottomConstent: 0, width: imgWidth, height: imgHeigh)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        imageView.image = isForShipper ? #imageLiteral(resourceName: "CarryonEx_waiting_A") : #imageLiteral(resourceName: "CarryonEx_Waiting_B")
    }
    
    func setupHintTextView(){
        let sideMargin: CGFloat = 40
        view.addSubview(hintTextView)
        hintTextView.addConstraints(left: view.leftAnchor, top: imageView.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 20, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 80)
        
        let a = "游箱正在为您匹配发件人，当匹配到发件人，游箱会第一时间通知您！"
        let b = "游箱正在为您安排揽件人，当揽件人接到此单，游箱会第一时间通知您！"
        hintTextView.text = isForShipper ? a : b
    }
    
    private func setupUnderlineAndSharingLabel(){
        view.addSubview(underlineView)
        underlineView.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 120, width: 0, height: 1)
        
        view.addSubview(sharingTitle)
        sharingTitle.addConstraints(left: nil, top: underlineView.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 90, height: 20)
        sharingTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setupShareStackView(){
        
        let w : CGFloat = 40, h : CGFloat = 40, l : CGFloat = 0
        let v1 = UIView(), v2 = UIView(), v3 = UIView(), v4 = UIView()
        
        v1.addSubview(wechatButton)
        v2.addSubview(momentButton)
        v3.addSubview(weiboButton)
        v4.addSubview(facebookButton)
        wechatButton.addConstraints(left: nil, top: v1.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        momentButton.addConstraints(left: nil, top: v2.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        weiboButton.addConstraints(left: nil, top: v3.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        facebookButton.addConstraints(left: nil, top: v4.topAnchor, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: h)
        wechatButton.centerXAnchor.constraint(equalTo: v1.centerXAnchor).isActive = true
        momentButton.centerXAnchor.constraint(equalTo: v2.centerXAnchor).isActive = true
        weiboButton.centerXAnchor.constraint(equalTo: v3.centerXAnchor).isActive = true
        facebookButton.centerXAnchor.constraint(equalTo: v4.centerXAnchor).isActive = true
        
        shareStackView = UIStackView(arrangedSubviews: [v1, v2, v3, v4])
        shareStackView.axis = .horizontal
        shareStackView.distribution = .fillEqually
        
        view.addSubview(shareStackView)
        shareStackView.addConstraints(left: view.leftAnchor, top: nil, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 40, topConstent: 0, rightConstent: 40, bottomConstent: 30, width: 0, height: h)
    }
}


extension WaitingController: FBSDKSharingDelegate {
    
    internal func dismissView() {
        self.navigationController?.popToRootViewController(animated: false)
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
            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error?.localizedDescription ?? "get err in ")")
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
