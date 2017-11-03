//
//  ReachabilityManager.swift
//  carryonex
//
//  Created by Xin Zou on 11/3/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit
import Reachability

class ReachabilityManager {
    
    static let shared = ReachabilityManager()
    
    let reachability = Reachability()!
    
    fileprivate var targetViewController: UIViewController? // for presenting alert
    
    private init(){
    }
    
    
}


extension ReachabilityManager {
    
    func startObserving(inViewController vc: UIViewController){
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("error in ReachabilityManager::startObserving, could not start reachability notifier")
        }
        targetViewController = vc
    }
    
    @objc public func reachabilityChanged(note: Notification) {
        guard let reachability = note.object as? Reachability, let vc = self.targetViewController else { return }
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            
        case .cellular:
            print("Reachable via Cellular")

        case .none:
            let msg = "⚠️您的网络不可用，为了更准确即时地更新您的数据信息，请确保手机能使用WiFi或流量数据。对此给您带来的不便只好忍忍了，反正您也不能来打我。"
            vc.displayAlert(title: "无法链接到服务器", message: msg, action: "来人！给我拿下！")
            print("Network not reachable")
        }
    }
    
    func stopObserving(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}
