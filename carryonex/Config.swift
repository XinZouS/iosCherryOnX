//
//  Config.swift
//  carryonex
//
//  Created by Chen, Zian on 10/24/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import Foundation
import Unbox

struct Config {
    let version: String
    let ask: [ConfigURLItem]
    let order: [ConfigURLItem]
    let payment: [ConfigURLItem]
    let software: [ConfigURLItem]
    let complain: [ConfigURLItem]
    let problems: [ConfigURLItem]
    let sender: [ConfigURLItem]
    let carrier: [ConfigURLItem]
}

//MARK: - Adjust based on config feed return.

extension Config: Unboxable {
    init(unboxer: Unboxer) throws {
        self.version = try unboxer.unbox(key: "version")
        self.ask = try unboxer.unbox(key: "customer_service.ask")
        self.order = try unboxer.unbox(key: "customer_service.order")
        self.payment = try unboxer.unbox(key: "customer_service.payment")
        self.software = try unboxer.unbox(key: "customer_service.software")
        self.complain = try unboxer.unbox(key: "customer_service.complain")
        self.problems = try unboxer.unbox(key: "tutorials.problems")
        self.sender = try unboxer.unbox(key: "tutorials.sender")
        self.carrier = try unboxer.unbox(key: "tutorials.carrier")
    }
}

//MARK: - ConfigURLItem
struct ConfigURLItem {
    let title: String
    let titleAlias: String
    let url: String
}

extension ConfigURLItem: Unboxable {
    init(unboxer: Unboxer) throws {
        self.title = try unboxer.unbox(key: "title")
        self.titleAlias = try unboxer.unbox(key: "title_alias")
        self.url = try unboxer.unbox(key: "url")
    }
}
