//
//  LicensesController++.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

extension LicensesController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // FYI, titles = ["软件使用协议", "个人信息保护及隐私政策", "软件授权", "平台用户规则"]
        let webCtl = WebController()
        webCtl.url = URL(string: urls[indexPath.item]) ?? URL(string: "https://www.carryonex.com/")
        navigationController?.pushViewController(webCtl, animated: true)
        webCtl.title = titles[indexPath.item]
    }
    
    
    
}
