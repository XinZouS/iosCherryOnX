//
//  WaitingListCell.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/9.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import FoldingCell
//
class WaitingListCellController: FoldingCell {

  @IBOutlet weak var closeNumberLabel: UILabel!
    @IBOutlet weak var openNumberLabel: UILabel!
  var number: Int = 0 {
    didSet {
      closeNumberLabel.text = String(number)
      openNumberLabel.text = String(number)
    }
  }
  
  override func awakeFromNib() {
    foregroundView.layer.cornerRadius = 10
    foregroundView.layer.masksToBounds = true
    super.awakeFromNib()
  }
  
  override func animationDuration(_ itemIndex: NSInteger, type: FoldingCell.AnimationType) -> TimeInterval {
    let durations = [0.26, 0.2, 0.2]
    return durations[itemIndex]
  }
  
}

// MARK: - Actions ⚡️
extension WaitingListCellController {
  
  @IBAction func buttonHandler(_ sender: AnyObject) {
    print("tap")
  }
  
}


