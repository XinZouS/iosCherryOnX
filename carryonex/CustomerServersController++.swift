//
//  CustomerServersController++.swift
//  carryonex
//
//  Created by Xin Zou on 10/22/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit

extension CustomerServersController {
    
    func onlineCustomerServersButtonTapped(){
        //displayAlert(title: "Online Customer Servers", message: "Got questions? Please call our online assistan: 201-666-2333", action: "OK")
        guard let callUrl = URL(string: "tel://\(19292150588)") else { return }
        UIApplication.shared.open(callUrl, options: [:], completionHandler: nil)
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

// MARK: - Pop alert view
extension CustomerServersController {
    
    func displayAlert(title: String, message: String, action: String) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            //self.dismiss(animated: true, completion: nil) // this will back to HomePage
        }
        v.addAction(action)
        present(v, animated: true, completion: nil)
    }
}