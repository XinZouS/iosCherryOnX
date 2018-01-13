//
//  RegistrationSuccessViewController.swift
//  carryonex
//
//  Created by Xin Zou on 12/28/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation

class RegistrationSuccessViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var checkmarkImageHeighConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = L("register.ui.title.success")
        checkmarkImageView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let imgBounds = checkmarkImageView.bounds
        let bX = imgBounds.origin.x - (imgBounds.width / 2) + 10
        let bY = imgBounds.origin.y - (imgBounds.height / 2) + 10
        checkmarkImageView.bounds = CGRect(x: bX, y: bY, width: 20, height: 20)
        
        checkmarkImageView.isHidden = false
        UIView.animate(withDuration: 0.6, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 8, options: .curveEaseInOut, animations: {
            
            self.checkmarkImageView.bounds = imgBounds
            
        }, completion: nil)
        
        _ = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { (timer) in
            self.dismiss(animated: true, completion: nil)
        })

    }
    
    
}
