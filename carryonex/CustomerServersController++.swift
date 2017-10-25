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
    
    func displayAlert(title: String, message: String, action: String) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            //self.dismiss(animated: true, completion: nil) // this will back to HomePage
        }
        v.addAction(action)
        present(v, animated: true, completion: nil)
    }
}
