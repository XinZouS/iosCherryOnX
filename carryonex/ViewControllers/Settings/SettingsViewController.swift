//
//  SettingsViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/21/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit


class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let titles = ["消息设置","定位权限","账号信息","服务条款","版本","退出"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "设置"
        setupTableView()
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0) // t,l,b,r
    }
    
}

extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsCell {
            cell.titleLabel.text = titles[indexPath.row]
            if indexPath.row == 4 {
                cell.detailLabel.text = "TODO: API for version"
            } else {
                cell.detailLabel.isHidden = true
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            print("selection...")
            
        case 0:
            print("selection...")
            
        case 0:
            print("selection...")
            
        case 0:
            print("selection...")
            
        case 0:
            print("selection...")
            
        case 0:
            print("selection...")
            
        default:
            print("Error: invalidate selection in SettingsViewController tableView;")
        }
    }

    
    
}


class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    
    
}
