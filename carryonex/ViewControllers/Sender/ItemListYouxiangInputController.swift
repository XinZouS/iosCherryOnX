//
//  ItemListYouxiangInputController.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/27.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import UIKit
import Material

class ItemListYouxiangInputController: UIViewController{
    
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        setupNavigationBar()
        setupBackGroundColor()
    }
    
    private func setupBackGroundColor(){
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        let beginColor :UIColor = UIColor.MyTheme.darkBlue
        let endColor :UIColor = UIColor.MyTheme.cyan
        gradientLayer.colors = [beginColor.cgColor,endColor.cgColor]
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupNavigationBar(){
        title = "寄件"
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
}
