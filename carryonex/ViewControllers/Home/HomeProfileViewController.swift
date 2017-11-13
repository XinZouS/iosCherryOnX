//
//  HomeProfileViewController.swift
//  carryonex
//
//  Created by Chen, Zian on 11/10/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class HomeProfileViewController: UIViewController {
    
    @IBOutlet weak var userProfileImageBtn: UIButton!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var shiperButton: UIButton!
    @IBOutlet weak var senderButton: UIButton!
    
    override func viewDidLoad() {
        loadingUserProfile()
    }
    private func loadingUserProfile(){
//        guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
//        // 加载用户头像
//        let imgUrl = URL(string: currUser.imageUrl ?? "")
//        URLCache.shared.removeAllCachedResponses()
//        userProfileImageBtn.af_setImage(for: .normal, url: imgUrl!, placeholderImage: #imageLiteral(resourceName: "CarryonEx_UploadProfile"), filter: nil, progress: nil, completion: nil)
//        //加载用户名称
//        if let currName = currUser.realName, currName != "" {
//            let date = Date()
//            let timeFormatter = DateFormatter()
//            timeFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm:ss.SSS"
//            var strNowTime = timeFormatter.string(from: date) as String
//            helloLabel.text = currName
//        }else{
//            helloLabel.text = "亲，您还没设置名称哦！"
//        }
    }
    
    @IBAction func userProfileImageBtnTapped(_ sender: Any) {
    }
    @IBAction func shiperButtonTapped(_ sender: Any) {
    }
    @IBAction func senderButtonTapped(_ sender: Any) {
    }
}
