//
//  UIViewController++.swift
//  carryonex
//
//  Created by Chen, Zian on 11/1/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func displayAlertOkCancel(title: String, message: String, completion:((UIAlertActionStyle) -> Void)?) {
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: L("action.ok"), style: .default) { (action) in
            completion?(action.style)
        }
        let cancelAction = UIAlertAction(title: L("action.cancel"), style: .cancel) { (action) in
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
        AppDelegate.shared().stopLoading()
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            completion?()
        }
        v.addAction(action)
        
        present(v, animated: true, completion: nil)
    }
    
    /// Alert with single actions, completion:(tag) -> Void
    func displayGlobalAlert(title: String, message: String, action: String, completion:(() -> Void)?) {
        AppDelegate.shared().stopLoading()
        let v = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: action, style: .default) { (action) in
            completion?()
        }
        
        v.addAction(action)
        
        if let topVC = UIViewController.topViewController(base: self) {
            topVC.present(v, animated: true, completion: nil)
        }
    }

    /// Alert with multiple actions, completion:(tag) -> Void
    func displayGlobalAlertActions(style: UIAlertControllerStyle = .alert,title: String, message: String, actions: [String], referenceView refView: UIView? = nil, completion:((Int) -> Void)?) {
        let v = UIAlertController(title: title, message: message, preferredStyle: style)
        for i in 0..<actions.count {
            let action = UIAlertAction(title: actions[i], style: .default) { (action) in
                completion?(i)
            }
            v.addAction(action)
        }
        if style == .actionSheet {
            let cancelBtn = UIAlertAction(title: L("action.cancel"), style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            v.addAction(cancelBtn)
        }
        
        if let topVC = UIViewController.topViewController(base: self) {
            if UIDevice.current.userInterfaceIdiom == .pad, let refV = refView {
                v.popoverPresentationController?.sourceView = refV
            }            
            topVC.present(v, animated: true, completion: nil)
        }
    }

    static func topViewController(base: UIViewController? = ((UIApplication.shared).delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
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
