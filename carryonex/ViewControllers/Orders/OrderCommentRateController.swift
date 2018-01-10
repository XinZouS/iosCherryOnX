//
//  OrderCommentRateController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/24.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class OrderCommentRateController: UIViewController {
    
    @IBOutlet weak var titleLabelScore: UILabel!
    @IBOutlet weak var titleLabelComment: UILabel!
    @IBOutlet weak var hintLabelComment: UILabel!
    @IBOutlet private weak var commentRate: UIImage!
    @IBOutlet private weak var commentView: UIView!
    @IBOutlet private weak var commentButton: UIButton!
    @IBOutlet private weak var commentTextField: ThemTextField!
    @IBOutlet private weak var stars5MaskImageView: UIImageView!
    @IBOutlet private weak var commentWidth: NSLayoutConstraint!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var realNameLabel: UILabel!
    @IBOutlet weak var backToHomeButton: UIButton!
    var toolbarTextView: UITextView?
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    lazy var inputContainerView: UIView = {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height:80)
        v.backgroundColor = .white
        
        let doneBtn = UIButton()
        doneBtn.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        doneBtn.setTitle(L("action.done"), for: .normal)
        doneBtn.setTitleColor(colorTextBlack, for: .normal)
        v.addSubview(doneBtn)
        doneBtn.addConstraints(left: nil, top: v.topAnchor, right: v.rightAnchor, bottom: v.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 0, bottomConstent: 0, width: 80, height: 0)
        
        let tx = UITextView()
        tx.layer.masksToBounds = true
        tx.layer.cornerRadius = 5
        tx.layer.borderWidth = 1
        tx.layer.borderColor = colorTableCellSeparatorLightGray.cgColor
        tx.font = UIFont.systemFont(ofSize: 16)
        v.addSubview(tx)
        tx.addConstraints(left: v.leftAnchor, top: v.topAnchor, right: doneBtn.leftAnchor, bottom: v.bottomAnchor, leftConstent: 10, topConstent: 8, rightConstent: 0, bottomConstent: 8, width: 0, height: 0)
        self.toolbarTextView = tx
        tx.becomeFirstResponder()

        return v
    }()
    
    var rate: Float = 5
    var commenteeId: Int = 0
    var commenteeRealName: String?
    var commenteeImage: String?
    var category: TripCategory?
    var requestId: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTextField.attributedPlaceholder = NSAttributedString(string: L("sender.ui.placeholder.comment"), attributes: [NSForegroundColorAttributeName: #colorLiteral(red: 0.7529411765, green: 0.8196078431, blue: 0.8666666667, alpha: 1)])
        commentTextField.delegate = self

        realNameLabel.text = commenteeRealName
        
        if let category = category {
            categoryLabel.text = (category == .carrier) ? L("orders.ui.action.category-sender") : L("orders.ui.action.category-carrier")
        }
        
        //Set profile image
        if let image = commenteeImage, let profileUrl = URL(string: image) {
            profileImageView.af_setImage(withURL: profileUrl)
        }
    }
    
    @objc private func doneButtonAction() {
        if let inputTxt = toolbarTextView?.text {
            commentTextField.text = inputTxt
        }
        commentTextField.resignFirstResponder()
        toolbarTextView?.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let loc = touch.location(in: stars5MaskImageView)
        let fullLength = stars5MaskImageView.bounds.width
        let stars = ceil((loc.x / fullLength) * 5)
        commentWidth.constant = fullLength * (stars / 5)
        rate = Float(stars)
    }
    
    @IBAction func commentButtonTapped(sender: UIButton) {
        
        commentTextField.resignFirstResponder()
        
        guard let currentUserId = ProfileManager.shared.getCurrentUser()?.id else {
            DLog("User need to login, no user found.")
            return
        }
        
        if let comment = commentTextField.text, !comment.trimmingCharacters(in: .whitespaces).isEmpty {
            ApiServers.shared.postComment(comment: comment,
                                          commenteeId: commenteeId,
                                          commenterId: currentUserId,
                                          rank: rate,
                                          requestId: requestId) { (success, error) in
                if let error = error {
                    DLog("Comment error: \(error.localizedDescription)")
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

extension OrderCommentRateController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        toolbarTextView?.becomeFirstResponder()
        if let tx = textField.text, let tbxv = toolbarTextView {
            tbxv.text = tx
            let traits = tbxv.value(forKey: "textInputTraits") as AnyObject
            traits.setValue(colorTheamRed, forKey: "insertionPointColor")
        }
        return true
    }
    
}
