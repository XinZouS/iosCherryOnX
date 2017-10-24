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
    //let tutorial: ConfigSection
    let customerService: ConfigSection
}

//MARK: - Adjust based on config feed return.

extension Config: Unboxable {
    init(unboxer: Unboxer) throws {
        self.version = try unboxer.unbox(key: "version")
        //self.tutorial = try unboxer.unbox(key: "tutorials")
        self.customerService = try unboxer.unbox(key: "customer_service")
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
        self.titleAlias = try unboxer.unbox(key: "title_alias")
        self.url = try unboxer.unbox(key: "url")
    }
}
