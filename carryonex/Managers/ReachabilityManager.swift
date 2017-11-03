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
    let reachability = Reachability()
}

extension ReachabilityManager {
    func startObserving() {
        do {
            try self.reachability?.startNotifier()
        } catch{
            print("error in ReachabilityManager::startObserving, could not start reachability notifier")
        }
    }
    
    /*
    func startObserving(completionHandler: @escaping(Bool) -> Void){
        
        /*
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: reachability, queue: nil) { notification in
            
            guard let reachability = notification.object as? Reachability else { return }
            switch reachability.connection {
            case .wifi:
                print("ReachabilityManager: Reachable via WiFi")
                completionHandler(true)
                
            case .cellular:
                print("ReachabilityManager: Reachable via Cellular")
                completionHandler(true)

            case .none:
                print("ReachabilityManager: Network not reachable")
                completionHandler(false)
            }
         */
        }
    }
    */
    func stopObserving(){
        //reachability.stopNotifier()
        //NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}
