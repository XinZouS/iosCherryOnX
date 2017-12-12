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
    let version: Int
    let iosVersion: String?
    let faq: ConfigSection
    let order: ConfigSection
    let payment: ConfigSection
    let softwareIssue: ConfigSection
    let report: ConfigSection
    let problems: [ConfigURLItem]
    let sender: [ConfigURLItem]
    let carrier: [ConfigURLItem]
}

//MARK: - Adjust based on config feed return.

extension Config: Unboxable {
    init(unboxer: Unboxer) throws {
        self.version = try unboxer.unbox(key: "version")
        self.iosVersion = try? unboxer.unbox(key: "ios_version")
        self.faq = try unboxer.unbox(keyPath: "customer_service.faq")
        self.order = try unboxer.unbox(keyPath: "customer_service.order")
        self.payment = try unboxer.unbox(keyPath: "customer_service.payment")
        self.softwareIssue = try unboxer.unbox(keyPath: "customer_service.software_issue")
        self.report = try unboxer.unbox(keyPath: "customer_service.report")
        self.problems = try unboxer.unbox(keyPath: "tutorials.problems")
        self.sender = try unboxer.unbox(keyPath: "tutorials.sender")
        self.carrier = try unboxer.unbox(keyPath: "tutorials.carrier")
    }
}

struct ConfigSection {
    let title: String
    let order: Int
    let urlItems: [ConfigURLItem]
}

extension ConfigSection: Unboxable {
    init(unboxer: Unboxer) throws {
        self.title = try unboxer.unbox(key: "title")
        self.order = try unboxer.unbox(key: "order")
        self.urlItems = try unboxer.unbox(key: "urls")
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
        self.titleAlias = try unboxer.unbox(key: "title-alias")
        self.url = try unboxer.unbox(key: "url")
    }
}
