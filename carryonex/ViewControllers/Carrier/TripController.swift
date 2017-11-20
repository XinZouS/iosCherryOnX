//
//  TripController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/19.
//  Copyright © 2017年 CarryonEx. All rights reserved.
//

import UIKit

class TripController: UIViewController{
    

    @IBOutlet weak var confirmTripButton: UIButton!
    @IBOutlet weak var tripScroller: UIScrollView!
    
    var gradientLayer: CAGradientLayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupcomfirmTripButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupBackgroundColor()
    }
    
    
    private func setupcomfirmTripButton(){
        confirmTripButton.isEnabled = false
        confirmTripButton.backgroundColor = #colorLiteral(red: 0.8972528577, green: 0.9214243889, blue: 0.9380477071, alpha: 1)
        confirmTripButton.titleLabel?.textColor = .gray
    }
    
    private func setupBackgroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        let beginColor :UIColor = UIColor.MyTheme.darkBlue
        let endColor :UIColor = UIColor.MyTheme.cyan
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
