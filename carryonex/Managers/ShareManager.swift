//
//  ShareManager.swift
//  
//
//  Created by zxbMacPro on 2017/12/4.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit

class ShareViewFactory: UIView {
    
    var message: String!
    var title: String!
    var url: String!

    var alert: UIAlertController?
    var sourceViewController: UIViewController?

    func setupShare(_ sourceViewController: UIViewController, trip: Trip) -> UIAlertController {
        
        self.sourceViewController = sourceViewController
        
        let isPhone = UIDevice.current.userInterfaceIdiom == .phone
        let alertController = UIAlertController.shareFrame
        let margin: CGFloat = 10.0
        let viewWidth: CGFloat = alertController.view.bounds.size.width - margin * 4.0
        if !isPhone { // iPad MUST setup reference for alertViewController
            self.frame = CGRect(x: 10, y: 24, width: 200, height: 100)
        } else {
            self.frame = CGRect(x: margin, y: margin, width: viewWidth, height: 90)
        }
        
        let (title, message, url) = trip.shareInfo()
        self.title = title
        self.message = message
        self.url = url
        self.backgroundColor = .clear
    
        //Buttons
        let wechatButton = UIButton(type: .custom)
        wechatButton.setImage(#imageLiteral(resourceName: "wechatIcon"), for: .normal)
        wechatButton.addTarget(self, action: #selector(shareToWechat), for: .touchUpInside)
        
        let momentButton = UIButton(type: .custom)
        momentButton.setImage(#imageLiteral(resourceName: "friendCircle"), for: .normal)
        momentButton.addTarget(self, action: #selector(shareToMoment), for: .touchUpInside)
        
        let weiboButton = UIButton(type: .custom)
        weiboButton.setImage(#imageLiteral(resourceName: "weiboIcon"), for: .normal)
        weiboButton.addTarget(self, action: #selector(shareToWeibo), for: .touchUpInside)
        
        let facebookButton = UIButton(type: .custom)
        facebookButton.setImage(#imageLiteral(resourceName: "facebookIcon"), for: .normal)
        facebookButton.addTarget(self, action: #selector(shareToFacebook), for: .touchUpInside)
        
        let wechatLabel = UILabel()
        wechatLabel.text = L("managers.ui.title.wechat")
        wechatLabel.font = UIFont(name: "Avenir-Light", size: 10.0)
        
        let momentLabel = UILabel()
        momentLabel.text = L("managers.ui.title.moment")
        momentLabel.font = UIFont(name: "Avenir-Light", size: 10.0)
        
        let weiboLabel = UILabel()
        weiboLabel.text = L("managers.ui.title.weibo")
        weiboLabel.font = UIFont(name: "Avenir-Light", size: 10.0)
        
        let facebookLabel = UILabel()
        facebookLabel.text = L("managers.ui.title.facebook")
        facebookLabel.font = UIFont(name: "Avenir-Light", size: 10.0)
        
        self.addSubview(wechatButton)
        self.addSubview(momentButton)
        self.addSubview(weiboButton)
        self.addSubview(facebookButton)
        self.addSubview(wechatLabel)
        self.addSubview(momentLabel)
        self.addSubview(facebookLabel)
        self.addSubview(weiboLabel)
        
        let w: CGFloat = isPhone ? ((viewWidth - 100) / 4) : 46
        let l: CGFloat = 20  // left constent for UIButton
        let y: CGFloat = isPhone ? -10 : -26 // centerYAnchor for UIButton
        let t: CGFloat = isPhone ? 10 : 5  // top constent for UILabel

        wechatButton.addConstraints(left: self.leftAnchor, top: nil, right: nil, bottom:nil , leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: w)
        momentButton.addConstraints(left: wechatButton.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: w)
        weiboButton.addConstraints(left: momentButton.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: w)
        facebookButton.addConstraints(left: weiboButton.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: l, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: w, height: w)
        
        wechatButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: y).isActive = true
        momentButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: y).isActive = true
        weiboButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: y).isActive = true
        facebookButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: y).isActive = true
        
        facebookLabel.centerXAnchor.constraint(equalTo: facebookButton.centerXAnchor).isActive = true
        wechatLabel.centerXAnchor.constraint(equalTo: wechatButton.centerXAnchor).isActive = true
        momentLabel.centerXAnchor.constraint(equalTo: momentButton.centerXAnchor).isActive = true
        weiboLabel.centerXAnchor.constraint(equalTo: weiboButton.centerXAnchor).isActive = true
        
        wechatLabel.addConstraints(left: nil, top: wechatButton.bottomAnchor, right: nil, bottom:nil , leftConstent: 0, topConstent: t, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        momentLabel.addConstraints(left: nil, top: momentButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: t, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        weiboLabel.addConstraints(left: nil, top: weiboButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: t, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        facebookLabel.addConstraints(left: nil, top: facebookButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: t, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        let cancelAction = UIAlertAction(title: L("action.cancel"), style: .cancel, handler: nil)
        alertController.view.addSubview(self)
        alertController.addAction(cancelAction)
        
        alert = alertController
        return alertController
    }
    
    @objc func shareToWechat(){
        let title: String = L("managers.confirm.title.share")
        let msg: String = ""
        shareToWeChat(scene: WXSceneSession, textMsg: "\(title)🚚😊 \(msg)", image: nil, imageFileName: nil, webUrl: self.url)
        alert?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func shareToMoment(){
        let title: String = L("managers.confirm.title.share")
        let msg: String = L("managers.confirm.message.share") + "：https://www.carryonex.com/"
        shareToWeChat(scene: WXSceneTimeline, textMsg: "\(title)🚚😊 \(msg)", image: nil, imageFileName: nil, webUrl: self.url)
        alert?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func shareToWeibo(){
        alert?.dismiss(animated: true, completion: { [weak self] in
            if let title = self?.title, let message = self?.message, let url = self?.url {
                self?.prepareSharing(title: title, msg: message, img: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"), url: url , type: SSDKPlatformType.typeSinaWeibo)
            }
        })
    }
    
    @objc private func shareToFacebook(){
        alert?.dismiss(animated: true, completion: { [weak self] in
            if let message = self?.message, let urlString = self?.url, let url = URL(string: urlString) {
                if let sourceViewController = self?.sourceViewController {
                    let fbContent = FBSDKShareLinkContent()
                    fbContent.contentURL = url
                    fbContent.quote = message
                    let shareDialog = FBSDKShareDialog()
                    shareDialog.shareContent = fbContent
                    shareDialog.delegate = self
                    shareDialog.fromViewController = sourceViewController
                    shareDialog.show()
                }
            }
        })
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
                message.mediaTagName = L("managers.confirm.message.share-media-tag")
            }
            req.bText = false
            req.message = message
            
        } else if webUrl != nil { // 2. share offical Website:
            let web =  WXWebpageObject()
            web.webpageUrl = webUrl
            message.mediaObject = web
            message.title = title
            message.description = self.message
            message.setThumbImage(#imageLiteral(resourceName: "logo_square"))
            
            req.bText = false
            req.message = message
            
        } else { // 3. share text message:
            req.bText = true
            req.text = textMsg
        }
        req.scene = Int32(scene.rawValue) //Int32(WXSceneSession.rawValue) //
        WXApi.send(req)
    }
    
    private func prepareSharing(title: String, msg: String, img: UIImage, url:String , type: SSDKPlatformType) {
        
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
                DLog("分享成功")
                AnalyticsManager.shared.finishTimeTrackingKey(.carrierShareTime)
            case SSDKResponseState.fail:
                DLog("授权失败,错误描述:\(error?.localizedDescription ?? "get err in ")")
                AnalyticsManager.shared.clearTimeTrackingKey(.carrierShareTime)
            case SSDKResponseState.cancel:
                DLog("操作取消")
                AnalyticsManager.shared.clearTimeTrackingKey(.carrierShareTime)
            default:
                break
            }
        }
    }
}

extension ShareViewFactory: FBSDKSharingDelegate {
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        DLog("share err: \(error)")
        AnalyticsManager.shared.clearTimeTrackingKey(.carrierShareTime)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        DLog("did complete with result = \(results)")
        AnalyticsManager.shared.finishTimeTrackingKey(.carrierShareTime)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        DLog("sharerDidCancel....")
        AnalyticsManager.shared.clearTimeTrackingKey(.carrierShareTime)
    }
}
