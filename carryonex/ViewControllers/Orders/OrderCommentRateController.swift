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
        addDoneButtonOnKeyboard()
    }
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        self.commentTextField.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.commentTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: coverView)
            if position.y > CGFloat(-20) && position.y < CGFloat(50) && position.x > CGFloat(0){
                if position.x > CGFloat(150) {
                    commentWidth.constant = CGFloat(150)
                    rateLevel = Float(150)/30
                }else{
                    let actualLevel = (Int(Float(position.x)/30)+1)*30
                    commentWidth.constant = CGFloat(actualLevel)
                    rateLevel = Float(actualLevel)/30
                }
            }
        }
    }
    @IBAction func commentButtonTapped(sender: UIButton) {
        commentContain = commentTextField.text!
        ApiServers.shared.postComment(comment: commentContain, commenteeId: 7, commenterId: 10, rank: rateLevel) { (success, err) in
            if success {
                print("commited success!")
            }else{
                print(err ?? "")
            }
        }
    }
    
}
