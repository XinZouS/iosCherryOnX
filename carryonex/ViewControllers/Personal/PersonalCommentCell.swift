//
//  PersonalCommentCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/29.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit

class PersonalCommentCell: UITableViewCell {
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var rateViewConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userButton.setImage(nil, for: .normal)
    }
}
