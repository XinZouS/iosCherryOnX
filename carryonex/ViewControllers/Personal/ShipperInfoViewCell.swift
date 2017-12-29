//
//  ShipperInfoViewCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/12/7.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

class ShipperInfoViewCell: UITableViewCell {
    
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var rateStar5MaskWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var rateViewWidthConstraint: NSLayoutConstraint!
    
    public var comment: Comment? {
        didSet {
            updateUIInfoforComment()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userButton.setImage(nil, for: .normal)
    }
    
    private func updateUIInfoforComment(){
        guard let cmt = self.comment else { return }
        commentTextView.text = cmt.comment
        
        if let rank = cmt.rank {
            let fullLength = rateStar5MaskWidthConstraint.constant
            rateViewWidthConstraint.constant = fullLength * CGFloat(rank / 5.0)
        }
        userNameLabel.text = cmt.realName
        
        if let imageUrl = cmt.imageUrl,let url = URL(string:imageUrl){
            userButton.af_setImage(for: .normal, url: url, placeholderImage: #imageLiteral(resourceName: "blankUserHeadImage"), filter: nil, progress: nil, completion: nil)
        } else {
            userButton.setImage(#imageLiteral(resourceName: "blankUserHeadImage"), for: .normal)
        }
        
        let timeStamp = cmt.timestamp
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = L("personal.ui.dateformat.cn")
        let date = Date(timeIntervalSince1970: TimeInterval(timeStamp))
        timeLabel.text = dateFormat.string(from: date)
        
    }

}
