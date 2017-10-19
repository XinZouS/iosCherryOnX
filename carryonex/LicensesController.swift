//
//  LicensesController.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

class LicensesController: UITableViewController {
    
    let licenseTableCellId = "licenseTableCellId"
    
    let titles = ["软件使用协议", "个人信息保护及隐私政策", "软件授权", "平台用户规则"]
    let urls = ["\(userGuideWebHoster)/doc_license",
                "\(userGuideWebHoster)/doc_privacy",
                "\(userGuideWebHoster)/doc_acknowledgements",
                "\(userGuideWebHoster)/doc_agreement"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UserSettingCell.self, forCellReuseIdentifier: licenseTableCellId)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: licenseTableCellId, for: indexPath) as! UserSettingCell
        cell.titleLabel.text = titles[indexPath.item]
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
