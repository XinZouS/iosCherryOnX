//
//  CustomerServersController++.swift
//  carryonex
//
//  Created by Xin Zou on 10/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import UdeskSDK

extension CustomerServersController {
    
    func onlineCustomerServersButtonTapped(){
        let dict : NSDictionary = [
            "productImageUrl":"http://img.club.pchome.net/kdsarticle/2013/11small/21/,fd548da909d64a988da20fa0ec124ef3_1000x750.jpg",
            "productTitle":"测试测试测试测你测试测试测你测试测试测你测试测试测你测试测",
            "productDetail":"¥88888.088888.088888.0",
            "productURL":"http://www.baidu.com"
        ]
        let chatViewManager = UdeskSDKManager()
        chatViewManager.setProductMessage(dict as! [AnyHashable : Any])
        chatViewManager.pushUdesk(in: self, completion: nil)
    }
    
    func backButtonTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == titles.count - 1, indexPath.row == titles[titles.count - 1].count - 1 {
//            return // the last cell is for "footer" info, so do nothing
//        }else{
//            let webCtl = WebController()
//            webCtl.url = URL(string: urls[indexPath.section][indexPath.item]) ?? URL(string: "https://www.carryonex.com/")
//            webCtl.title = titles[indexPath.section][indexPath.row]
//            navigationController?.pushViewController(webCtl, animated: true)
//        }
//    }
    
//    internal func getContentTitleAndUrlFromDB(){
//        ApiServers.shared.getConfigDocTitleAndUrls(typeKey: .customerService) { (dictionary) in
//            guard dictionary.count > 0 else { return }
//
//            var getHeaders  : [String] = []
//            var getTitles   : [[String]] = []
//            var getUrls     : [[String]] = []
//
//            for pair in dictionary {
//                if let p = pair.value as? [String:Any] {
//                    getHeaders.append(p["title"] as! String)
//                    if let urlDic = p["urls"] as? [[String:String]] {
//                        var titArr: [String] = []
//                        var urlArr: [String] = []
//                        for item in urlDic {
//                            titArr.append(item["title"] as! String)
//                            urlArr.append(item["url"] as! String)
//                        }
//                        getTitles.append(titArr)
//                        getUrls.append(urlArr)
//                    }
//                }
//            }
//            if var last = getTitles.last as? [String] {
//                last.append(" ")
//                getTitles.removeLast()
//                getTitles.append(last)
//            }
//            self.headers = getHeaders
//            self.titles = getTitles
//            self.urls = getUrls
//        }
//    }
    
}
