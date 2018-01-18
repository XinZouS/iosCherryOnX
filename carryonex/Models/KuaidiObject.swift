//
//  KuaidiObject.swift
//  carryonex
//
//  Created by Zian Chen on 1/16/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import Foundation
import Unbox

struct KuaidiObject {
    let message: String
    let state: String
    let status: String
    let condition: String
    let ischeck: String
    let nu: String
    let data: [KuaidiProcessItem]
}

extension KuaidiObject: Unboxable {
    init(unboxer: Unboxer) throws {
        self.message = try unboxer.unbox(key: "message")
        self.state = try unboxer.unbox(key: "state")
        self.status = try unboxer.unbox(key: "status")
        self.condition = try unboxer.unbox(key: "condition")
        self.ischeck = try unboxer.unbox(key: "ischeck")
        self.nu = try unboxer.unbox(key: "nu")
        self.data = try unboxer.unbox(key: "data")
    }
}

struct KuaidiProcessItem {
    let context: String
    let time: String
    let ftime: String
}

extension KuaidiProcessItem: Unboxable {
    init(unboxer: Unboxer) throws {
        self.context = try unboxer.unbox(key: "context")
        self.time = try unboxer.unbox(key: "time")
        self.ftime = try unboxer.unbox(key: "ftime")
    }
}
