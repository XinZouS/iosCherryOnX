//
//  SettingsViewController.swift
//  carryonex
//
//  Created by Xin Zou on 11/21/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import MapKit

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
        // title: 0,    1,        2,       3,      4,     5
        // ["消息设置","定位权限","账号信息","服务条款","版本","退出"]
        switch indexPath.row {
        case 0:
            openSystemSetting()
            
        case 1:
            openSystemGpsSetting()
            
        case 2:
            // TODO:
            print("TODO: selection 账号信息")
            
        case 3:
            // TODO:
            print("TODO: selection 服务条款")
            
        case 4:
            // TODO:
            print("TODO: selection 版本: API for version")
            
        case 5:
            ProfileManager.shared.logoutUser()
            // TODO: after homepage done, get reference and do this:
            //userProfileView?.removeProfileImageFromLocalFile()
            navigationController?.popToRootViewController(animated: false)
            
        default:
            print("Error: invalidate selection in SettingsViewController tableView;")
        }
    }

    private func openSystemSetting(){
        if let sysUrl = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(sysUrl, options: [:], completionHandler: nil)
        } else {
            print("unable to openSystemSetting")
        }
    }
    
    private func openSystemGpsSetting(){
        if !CLLocationManager.locationServicesEnabled() {
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                // If general location settings are disabled then open general location settings
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            openSystemSetting()
        }
    }

    
}


class SettingsCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    
    
}
