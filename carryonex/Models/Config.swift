//
//  Config.swift
//  carryonex
//
//  Created by Chen, Zian on 10/24/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation
import Unbox

struct ConfigData {
    let config: Config
    let intlPrice: ConfigPrice
    let domesticPrice: ConfigPrice
}

extension ConfigData: Unboxable {
    init(unboxer: Unboxer) throws {
        self.config = try unboxer.unbox(key: "config")
        self.intlPrice = try unboxer.unbox(key: "intl_price")
        self.domesticPrice = try unboxer.unbox(key: "domestic_price")
    }
}

struct Config {
    let version: Int
    let iosVersion: String
}

extension Config: Unboxable {
    init(unboxer: Unboxer) throws {
        self.version = try unboxer.unbox(key: "version")
        self.iosVersion = try unboxer.unbox(key: "ios_version")
    }
}

struct ConfigPrice {
    let a: Double
    let b: Double
}

extension ConfigPrice: Unboxable {
    init(unboxer: Unboxer) throws {
        self.a = try unboxer.unbox(key: "a")
        self.b = try unboxer.unbox(key: "b")
    }
}
