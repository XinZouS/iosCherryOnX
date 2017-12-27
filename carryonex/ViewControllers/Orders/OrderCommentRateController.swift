//
//  OrderCommentRateController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/24.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderCommentRateController: UIViewController {
    @IBOutlet private weak var commentRate: UIImage!
    @IBOutlet private weak var commentView: UIView!
    @IBOutlet private weak var commentButton: UIButton!
    @IBOutlet private weak var commentTextField: UITextField!
    @IBOutlet private weak var coverView: UIView!
    @IBOutlet private weak var commentWidth: NSLayoutConstraint!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var realNameLabel: UILabel!
    
    var rate: Float = 5
    var commenteeId: Int = 0
    var commenteeRealName: String?
    var commenteeImage: String?
    var category: TripCategory?
    var requestId: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()
        
        realNameLabel.text = commenteeRealName
        
        if let category = category {
            categoryLabel.text = (category == .carrier) ? L("orders.ui.action.category-sender") : L("orders.ui.action.category-carrier")
        }
        
        //Set profile image
        if let image = commenteeImage, let profileUrl = URL(string: image) {
            profileImageView.af_setImage(withURL: profileUrl)
        }
    }
    
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame:CGRect(x:0,y:0,width:320,height:50))
        doneToolbar.barStyle = UIBarStyle.blackTranslucent
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: L("action.done"), style: UIBarButtonItemStyle.done, target: self, action: #selector(doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        doneToolbar.sizeToFit()
        self.commentTextField.inputAccessoryView = doneToolbar
    }
    
    @objc private func doneButtonAction() {
        self.commentTextField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let position = touch.location(in: coverView)
            if position.y > CGFloat(-20) && position.y < CGFloat(50) && position.x > CGFloat(0){
                if position.x > CGFloat(150) {
                    commentWidth.constant = CGFloat(150)
                    rate = Float(150)/30
                } else {
                    let actualLevel = (Int(Float(position.x)/30)+1)*30
                    commentWidth.constant = CGFloat(actualLevel)
                    rate = Float(actualLevel)/30
                }
            }
        }
    }
    
    @IBAction func commentButtonTapped(sender: UIButton) {
        
        commentTextField.resignFirstResponder()
        
        guard let currentUserId = ProfileManager.shared.getCurrentUser()?.id else {
            debugPrint("User need to login, no user found.")
            return
        }
        
        if let comment = commentTextField.text, !comment.trimmingCharacters(in: .whitespaces).isEmpty {
            ApiServers.shared.postComment(comment: comment,
                                          commenteeId: commenteeId,
                                          commenterId: currentUserId,
                                          rank: rate,
                                          requestId: requestId) { (success, error) in
                if let error = error {
                    print("Comment error: \(error.localizedDescription)")
                    return
                }
                
                if let category = self.category {
                    TripOrderDataStore.shared.updateRequestToCommented(category: category, requestId: self.requestId)
                }
                                            
                self.displayAlert(title: L("orders.confirm.title.comment"),
                                  message: L("orders.confirm.message.comment"),
                                  action: L("action.ok"), completion: { [weak self] _ in
                    self?.navigationController?.popViewController(animated: true)
                })
            }
            
        } else {
            displayAlert(title: L("orders.error.title.comment"), message: L("orders.error.message.comment"), action: L("action.ok"), completion: { [weak self] _ in
                self?.commentTextField.becomeFirstResponder()
            })
        }
    }
    
    @IBAction func backToHomeTapped(sender: UIButton) {
        AppDelegate.shared().mainTabViewController?.selectTabIndex(index: .home)
        self.navigationController?.popToRootViewController(animated: false)
    }
}
