//
//  UserStarController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/13.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class UserStarController: UIViewController{
    let userRecentInfoCtl = UserRecentInfoController()
    var starCommentView: UIStackView?
    lazy var starCommentBtns: [UIButton] = {
        var buttons = [UIButton]()
        var creditLevel = 4.5
        let creditIntLevel = Int(creditLevel)
        for i in 0..<creditIntLevel {
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "homePageStar"), for: .normal)
            button.tag = i
            button.isEnabled = false
            buttons.append(button)
        }
        if (creditLevel-Double(creditIntLevel) != 0 ){
            let button = UIButton(type: .custom)
            button.setImage(#imageLiteral(resourceName: "starHalf"), for: .normal)
            button.tag = creditIntLevel+1
            button.isEnabled = false
            buttons.append(button)
        }
        return buttons
    }()
    
    override func viewDidLoad() {
        setupStarCommentView()
    }
    
    private func setupStarCommentView(){
        starCommentView = UIStackView(arrangedSubviews: starCommentBtns)
        starCommentView?.axis = .horizontal
        starCommentView?.distribution = .fillEqually
        
        view.addSubview(starCommentView!)
        starCommentView?.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 0, height: 10)
    }
}
