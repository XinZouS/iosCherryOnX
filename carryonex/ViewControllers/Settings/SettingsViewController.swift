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
    
    //let titles = ["消息设置","定位权限","账号信息","服务条款","Version 1.0","退出"]
    let titles = [L("settings.ui.title.message"),
                  L("settings.ui.title.gps"),
                  L("settings.ui.title.account"),
                  L("settings.ui.title.policy"),
                  "Version",
                  L("settings.ui.title.logout")
                  ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = .default
        title = L("settings.ui.title.settings") // "设置"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    private func setupNavigationBar(){
        UIApplication.shared.statusBarStyle = .default
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0) // t,l,b,r
        tableView.separatorColor = colorTableCellSeparatorLightGray
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
            let title: String = titles[indexPath.row]
            cell.titleLabel.text = title
            if indexPath.row == 4 { // version cell
                setupVersionCell(cell)
            }
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }
    
    private func setupVersionCell(_ cell: SettingsCell) {
        cell.detailLabel.isHidden = true
        let label = UILabel()
        label.text = "1.0"
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 18)
        cell.addSubview(label)
        label.addConstraints(left: nil, top: cell.topAnchor, right: cell.rightAnchor, bottom: cell.bottomAnchor, leftConstent: 0, topConstent: 0, rightConstent: 30, bottomConstent: 0, width: 0, height: 0)
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
            let url = "\(ApiServers.shared.host)/doc_license"
            let webCtl = WebController()
            webCtl.url = URL(string: url) ?? URL(string: "https://www.carryonex.com/")
            navigationController?.pushViewController(webCtl, animated: true)
            webCtl.title = titles[indexPath.row]
            
        case 4:
            print("版本 info, do nothing;")
            
        case 5:
            ProfileManager.shared.logoutUser()
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
