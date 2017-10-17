//
//  UserGuidePageCell++.swift
//  carryonex
//
//  Created by Xin Zou on 10/16/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

extension UserGuidePageCell {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let webCtl = WebController()
        webCtl.url = URL(string: urls[indexPath.section][indexPath.item]) ?? URL(string: "https://www.carryonex.com/")
        userGuideCtl.navigationController?.pushViewController(webCtl, animated: true)
        webCtl.title = titles[indexPath.section][indexPath.item]
    }
    
    
}
