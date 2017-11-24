//
//  OrderCommentRateController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/24.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class OrderCommentRateController: UIViewController{
    @IBOutlet weak var commentRate: UIImage!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var commentWidth: NSLayoutConstraint!
    var rateLevel:Float = 0
    var commentContain:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: coverView)
            if position.y > CGFloat(-20) && position.y < CGFloat(50) && position.x > CGFloat(0){
                if position.x > CGFloat(150) {
                    commentWidth.constant = CGFloat(150)
                    rateLevel = Float(150)/30
                }else{
                   commentWidth.constant = position.x
                    rateLevel = Float(position.x)/30
                }
            }
        }
    }
    @IBAction func commentButtonTapped(sender: UIButton) {
        commentContain = commentTextField.text!
        ApiServers.shared.postComment(comment: commentContain, commenteeId: 99, commenterId: 89, rank: rateLevel) { (success, err) in
            if success {
                print("commited success!")
            }else{
                print(err ?? "")
            }
        }
    }
    
}
