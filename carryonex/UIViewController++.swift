//
//  UIViewController++.swift
//  carryonex
//
//  Created by Chen, Zian on 11/1/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func displayAlertOkCancel(title: String, message: String, completion:((UIAlertActionStyle) -> Void)?) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "好", style: .default) { (action) in
            completion?(action.style)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            completion?(action.style)
        }
        v.addAction(okAction)
        v.addAction(cancelAction)
        
        present(v, animated: true, completion: nil)
    }
    
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
    
    func displayGlobalAlert(title: String, message: String, action: String, completion:(() -> Void)?) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            completion?()
        }
        
        v.addAction(action)
        
        if let topVC = topViewController(base: self) {
            topVC.present(v, animated: true, completion: nil)
        }
    }

    func topViewController(base: UIViewController? = ((UIApplication.shared).delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    
}
