//
//  TripCompletedController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/22.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKShareKit
import FacebookShare

class TripCompletedController:UIViewController{
    @IBOutlet weak var beginLocationLabel: UILabel!
    @IBOutlet weak var endLocationLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var youxiangLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    var dateString :String!
    var beginLocationString:String!
    var endLocationString:String!
    var descriptionString: String!
    var tripId:Int!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardInformation()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    private func setupCardInformation(){
        beginLocationLabel.text = beginLocationString
        endLocationLabel.text = endLocationString
        let MonthStartIndex = dateString.index(dateString.startIndex, offsetBy: 5)
        let MonthEndIndex = dateString.index(dateString.startIndex, offsetBy: 6)
        let DayStartIndex = dateString.index(dateString.startIndex, offsetBy: 8)
        let DayEndIndex = dateString.index(dateString.startIndex, offsetBy: 9)
        let month = dateString[MonthStartIndex...MonthEndIndex]
        let day = dateString[DayStartIndex...DayEndIndex]
        var monthString = ""
        switch month{
        case "01":
            monthString = "JAN"
        case "02":
            monthString = "FEB"
        case "03":
            monthString = "MAR"
        case "04":
            monthString = "APR"
        case "05":
            monthString = "MAY"
        case "06":
            monthString = "JUN"
        case "07":
            monthString = "JULY"
        case "08":
            monthString = "AUG"
        case "09":
            monthString = "SEP"
        case "10":
            monthString = "OCT"
        case "11":
            monthString = "NOV"
        case "12":
            monthString = "DEC"
        default:
            break
        }
        monthLabel.text = monthString
        dayLabel.text = day
        descriptionLabel.text = descriptionString
        youxiangLabel.text = String(tripId)
    }
    @IBAction func shareButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let margin:CGFloat = 10.0
        let viewWidth:CGFloat = alertController.view.bounds.size.width - margin * 4.0
        let rect = CGRect(x: margin, y: margin, width: viewWidth ,height: 120)
        let shareView = UIView(frame: rect)
        alertController.view.addSubview(shareView)
        
        shareView.backgroundColor = .clear
        shareView.addSubview(wechatButton)
        shareView.addSubview(momentButton)
        shareView.addSubview(weiboButton)
        shareView.addSubview(facebookButton)
        
        wechatButton.addConstraints(left: shareView.leftAnchor, top: nil, right: nil, bottom:nil , leftConstent: 30, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: (viewWidth-150)/4, height: (viewWidth-150)/4)
        momentButton.addConstraints(left: wechatButton.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: 30, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: (viewWidth-150)/4, height: (viewWidth-150)/4)
        weiboButton.addConstraints(left: momentButton.rightAnchor, top: nil, right: nil, bottom: nil, leftConstent: 30, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: (viewWidth-150)/4, height: (viewWidth-150)/4)
        facebookButton.addConstraints(left: weiboButton.rightAnchor, top: nil, right: shareView.rightAnchor, bottom: nil, leftConstent: 30, topConstent: 0, rightConstent: 30, bottomConstent: 0, width: (viewWidth-150)/4, height: (viewWidth-150)/4)
        
        wechatButton.centerYAnchor.constraint(equalTo: shareView.centerYAnchor, constant: -10).isActive = true
        momentButton.centerYAnchor.constraint(equalTo: shareView.centerYAnchor, constant: -10).isActive = true
        weiboButton.centerYAnchor.constraint(equalTo: shareView.centerYAnchor, constant: -10).isActive = true
        facebookButton.centerYAnchor.constraint(equalTo: shareView.centerYAnchor, constant: -10).isActive = true
        
        shareView.addSubview(facebookLabel)
        shareView.addSubview(wechatLabel)
        shareView.addSubview(momentLabel)
        shareView.addSubview(weiboLabel)
        
        facebookLabel.centerXAnchor.constraint(equalTo: facebookButton.centerXAnchor).isActive = true
        wechatLabel.centerXAnchor.constraint(equalTo: wechatButton.centerXAnchor).isActive = true
        momentLabel.centerXAnchor.constraint(equalTo: momentButton.centerXAnchor).isActive = true
        weiboLabel.centerXAnchor.constraint(equalTo: weiboButton.centerXAnchor).isActive = true
        
        wechatLabel.addConstraints(left: nil, top: wechatButton.bottomAnchor, right: nil, bottom:nil , leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        momentLabel.addConstraints(left: nil, top: momentButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        weiboLabel.addConstraints(left: nil, top: weiboButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        facebookLabel.addConstraints(left: nil, top: facebookButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: 5, rightConstent: 0, bottomConstent: 0, width: 0, height: 0)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        
        alertController.addAction(cancelAction)
        
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion:{})
        }
    }
    func shareToWechat(){
        let title: String = "CarryonEx 帮你把思念带回家"
        let msg: String = "关注[游箱]网站获取更多活动信息： https://www.carryonex.com/"
        shareToWeChat(scene: WXSceneSession, textMsg: "\(title)🚚😊 \(msg)", image: nil, imageFileName: nil, webUrl: nil)
    }
    
    func shareToMonent(){
        let title: String = "CarryonEx 帮你把思念带回家"
        let msg: String = "关注我们的网站获取更多活动信息：https://www.carryonex.com/"
        shareToWeChat(scene: WXSceneTimeline, textMsg: "\(title)🚚😊 \(msg)", image: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"), imageFileName: "CarryonEx_OnBoarding-02-1.png", webUrl: nil)
    }
    
    func shareToWeibo(){
        let title: String = "CarryonEx 帮你把思念带回家"
        let msg: String = "关注我们的网站获取更多活动信息：https://www.carryonex.com/"
        prepareSharing(title: title, msg: msg, img: #imageLiteral(resourceName: "CarryonEx_OnBoarding-03-1"), type: SSDKPlatformType.typeSinaWeibo)
    }
    
    func shareToFacebook(){
        self.dismiss(animated: true, completion: nil)
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

