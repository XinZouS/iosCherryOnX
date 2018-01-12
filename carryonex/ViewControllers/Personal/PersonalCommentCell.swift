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
    @IBOutlet weak var rateStars5MaskWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rateViewConstraint: NSLayoutConstraint!
    
    
    var comment: Comment? {
        didSet{
            setupContents(comment)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userButton.setImage(nil, for: .normal)
    }
    
    private func setupContents(_ cmt: Comment?){
        guard let c = cmt else { return }
        commentTextView.text = c.comment
        let rank = c.rank ?? 0.0
        rateViewConstraint.constant = rateStars5MaskWidthConstraint.constant * CGFloat(rank / 5.0)
        userNameLabel.text = c.realName
        
        if let imageUrl = c.imageUrl, let url = URL(string: imageUrl) {
            userButton.af_setImage(for: .normal, url: url, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, completion: nil)
        } else {
            userButton.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
        }
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = L("personal.ui.dateformat.comment")
        let date = Date(timeIntervalSince1970: TimeInterval(c.timestamp))
        timeLabel.text = dateFormat.string(from: date)
    }
    
}
