//
//  ReachabilityManager.swift
//  carryonex
//
//  Created by Xin Zou on 11/3/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
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
            DLog("error in ReachabilityManager::startObserving, could not start reachability notifier")
        }
    }
    
    func stopObserving(){
        //Stop
    }
    
}
