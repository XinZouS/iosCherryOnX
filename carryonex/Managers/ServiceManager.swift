//
//  ServiceManager.swift
//  carryonex
//
//  Created by Chen, Zian on 10/29/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import UdeskSDK

final class ServiceManager {
    
    static let shared = ServiceManager()
    
    fileprivate let uDeskOrganization: UdeskOrganization = {
        let kUdeskDomain = "carryonex.udesk.cn"
        let kUdeskAppKey = "1d3ffd926dd53b91b8e13c5bc6080405"
        let kUdeskAppId = "89139ec04e28961d"
        return UdeskOrganization.init(domain: kUdeskDomain, appKey: kUdeskAppKey, appId: kUdeskAppId)
    }()
}


//UDesk Extension
extension ServiceManager {
    
    func logoutUdesk() {
        UdeskManager.logoutUdesk()
    }
    
    //To initialize UdeskManager
    func setupUDeskWithUser(user: ProfileUser) {
        let customer = customerFromProfileUser(user: user)
        UdeskManager.initWith(self.uDeskOrganization, customer: customer)
    }
    
    //To update UDeskCustomer
    func updateUDeskCustomer(user: ProfileUser) {
        let customer = customerFromProfileUser(user: user)
        UdeskManager.update(customer)
    }
    
    private func customerFromProfileUser(user: ProfileUser) -> UdeskCustomer {
        let customer = UdeskCustomer()
        customer.sdkToken = user.id
        customer.nickName = user.realName
        return customer
    }
}
