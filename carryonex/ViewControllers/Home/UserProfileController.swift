//
//  UserProfileController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/13.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit
import AlamofireImage

class UserProfileController: UIViewController {
    
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userProfileImageBtn: UIButton!
    @IBOutlet weak var senderButton: UIButton!
    @IBOutlet weak var shiperButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        loadUserProfile()
    }
    
    private func loadUserProfile(){
        guard let currUser = ProfileManager.shared.getCurrentUser() else { return }
        let imgUrl = URL(string: currUser.imageUrl ?? "")
        URLCache.shared.removeAllCachedResponses()
        //userProfileImageBtn.af_setImage(for: .normal, url: imgUrl!, placeholderImage: #imageLiteral(resourceName: "carryonex_UserInfo"), filter: nil, progress: nil, completion: nil)
    }
    
    @IBAction func userProfileImageBtnTapped(_ sender: Any) {
    }
    @IBAction func shiperButtonTapped(_ sender: Any) {
    }
    @IBAction func senderButtonTapped(_ sender: Any) {
    }
}
