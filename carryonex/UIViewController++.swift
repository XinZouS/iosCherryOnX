//
//  UIViewController++.swift
//  carryonex
//
//  Created by Chen, Zian on 11/1/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func displayAlert(title: String, message: String, action: String) {
        displayAlert(title: title, message: message, action: action, completion: nil)
    }
        
    func displayAlert(title: String, message: String, action: String, completion:(() -> Void)?) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            completion?()
        }
        v.addAction(action)
        present(v, animated: true, completion: nil)
    }
    
}
