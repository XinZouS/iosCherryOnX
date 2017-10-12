//
//  WalletController.swift
//  carryonex
//
//  Created by Xin Zou on 9/6/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit


class WalletController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let sectionTitles = ["账户余额", "银行账号", "信用卡"]
    
    let walletBaseCellId = "walletBaseCellId"
    let walletCheckingCellId = "walletCheckingCellId"
    let walletCheckingAddId = "walletCheckingAddId"
    let walletCreditCellId = "walletCreditCellId"
    let walletCreditAddId = "walletCreditAddId"
    
    
    lazy var tableView : UITableView = {
        let t = UITableView()
        t.backgroundColor = .white
        t.separatorStyle = .none // remove the underline in cell
        t.dataSource = self
        t.delegate = self
        return t
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupNavitagionBar()
        setupTableView()
    }
    
    private func setupNavitagionBar(){
        navigationItem.title = "我的钱包"
    }
    
    private func setupTableView(){
        let sideMargin: CGFloat = 20
        view.addSubview(tableView)
        tableView.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: sideMargin, topConstent: sideMargin, rightConstent: sideMargin, bottomConstent: 0, width: 0, height: 0)
        // 账户余额
        tableView.register(WalletBaseCell.self, forCellReuseIdentifier: walletBaseCellId)
        // 银行账号
        tableView.register(WalletCheckingCell.self, forCellReuseIdentifier: walletCheckingCellId)
        tableView.register(WalletAddingCell.self, forCellReuseIdentifier: walletCheckingAddId)
        // 信用卡
        tableView.register(WalletCreditCell.self, forCellReuseIdentifier: walletCreditCellId)
        tableView.register(WalletAddingCell.self, forCellReuseIdentifier: walletCreditAddId)
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: // 账户余额
            return 1

        case 1: // 银行账号
            return Wallet.sharedInstance.checkingAccounts.count + 1 // the last adding cell
            
        case 2: // 信用卡
            return Wallet.sharedInstance.creditAccounts.count + 1 // the last adding cell
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = WalletBaseCell()
        
        switch indexPath.section {
        case 0: // 账户余额
            cell = tableView.dequeueReusableCell(withIdentifier: walletBaseCellId, for: indexPath) as! WalletBaseCell
            cell.titleLabel.text = "我的余额"
            let credit = Wallet.sharedInstance.creditAvailable + Wallet.sharedInstance.creditPending
            cell.infoLabel.text = String(format: "$%.02f", locale: .current, arguments: [credit])  //"\(formatter.string(from: nsCredit)!)"
            
        case 1: // 银行账号
            if indexPath.item < Wallet.sharedInstance.checkingAccounts.count {
                cell = tableView.dequeueReusableCell(withIdentifier: walletCheckingCellId, for: indexPath) as! WalletCheckingCell
                cell.checkingAccount = Wallet.sharedInstance.checkingAccounts[indexPath.row]
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: walletCheckingAddId, for: indexPath) as! WalletAddingCell
                cell.titleLabel.text = "添加新的银行账号"
            }
        case 2: // 信用卡
            if indexPath.item < Wallet.sharedInstance.creditAccounts.count {
                cell = tableView.dequeueReusableCell(withIdentifier: walletCreditCellId, for: indexPath) as! WalletCreditCell
                cell.creditAccount = Wallet.sharedInstance.creditAccounts[indexPath.row]
            }else{
                cell = tableView.dequeueReusableCell(withIdentifier: walletCreditAddId, for: indexPath) as! WalletAddingCell
                cell.titleLabel.text = "添加新的信用卡"
            }
            
        default:
            cell = WalletBaseCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    
    // for header view in each section
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return HeaderView(titleText: sectionTitles[section])
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(40)
    }
    
    
    
}
