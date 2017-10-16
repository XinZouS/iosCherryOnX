//
//  CreditController.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class CreditController : UIViewController {
    
    var currentCredit : Float!{
        didSet{
            creditLabel.text = String(format: "$%.02f", locale: .current, arguments: [currentCredit])
        }
    }
    
    let titleLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.systemFont(ofSize: 16)
        b.textAlignment = .left
        b.text = "可用余额"
        return b
    }()
    
    let underline: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        return v
    }()
    
    let creditLabel : UILabel = {
        let b = UILabel()
        b.font = UIFont.boldSystemFont(ofSize: 26)
        b.textAlignment = .left
        return b
    }()
    
    lazy var extractButton : UIButton = {
        let b = UIButton()
        let atts = [NSFontAttributeName: UIFont.systemFont(ofSize: 16),
                    NSForegroundColorAttributeName: UIColor.white]
        let attStr = NSAttributedString(string: "提 现", attributes: atts)
        b.setAttributedTitle(attStr, for: .normal)
        b.backgroundColor = buttonThemeColor
        b.addTarget(self, action: #selector(extractButtonTapped), for: .touchUpInside)
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavigationBar()
        setupTitleViews()
        setupDetailViews()
    }
    
    private func setupNavigationBar(){
        title = "我的余额"
        
        let rightBarItem = UIBarButtonItem(title: "提现", style: .plain, target: self, action: #selector(extractButtonTapped))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    private func setupTitleViews(){
        let sideMargin: CGFloat = UIScreen.main.bounds.width < 333 ? 30 : 40
        view.addSubview(titleLabel)
        titleLabel.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 20, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 20)
        
        view.addSubview(underline)
        underline.addConstraints(left: view.leftAnchor, top: titleLabel.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 10, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 1)
        
        view.addSubview(creditLabel)
        creditLabel.addConstraints(left: view.leftAnchor, top: underline.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 5, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 30)
        
        view.addSubview(extractButton)
        extractButton.addConstraints(left: view.leftAnchor, top: creditLabel.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: sideMargin, topConstent: 10, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 40)
    }
    
    private func setupDetailViews(){
        let cellViewWidth: CGFloat = view.bounds.width / 2.0
        let cellViewHeigh: CGFloat = 70
        let topMargin : CGFloat = 15
        let totalCredit = Wallet.sharedInstance.creditAvailable + Wallet.sharedInstance.creditPending
        
        let totalCreditView = CreditDetailView()
        view.addSubview(totalCreditView)
        totalCreditView.setupInfo(title: "总余额", credit: totalCredit)
        totalCreditView.addConstraints(left: view.leftAnchor, top: extractButton.bottomAnchor, right: nil, bottom: nil, leftConstent: 0, topConstent: topMargin, rightConstent: 0, bottomConstent: 0, width: cellViewWidth, height: cellViewHeigh)
        
        let pendingView = CreditDetailView()
        view.addSubview(pendingView)
        pendingView.setupInfo(title: "未入账余额", credit: Wallet.sharedInstance.creditPending)
        pendingView.addConstraints(left: nil, top: extractButton.bottomAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: topMargin, rightConstent: 0, bottomConstent: 0, width: cellViewWidth, height: cellViewHeigh)
    }
    
    
    
}
