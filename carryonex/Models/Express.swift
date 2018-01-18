//
//  Express.swift
//  carryonex
//
//  Created by Chen, Zian on 1/18/18.
//  Copyright © 2018 CarryonEx. All rights reserved.
//

import Foundation
import Unbox

enum ExpressKey: String {
    case id = "id"
    case requestId = "request_id"
    case expressNumber = "express_number"
    case companyCode = "company_code"
    case company = "company"
    case timestamp = "timestamp"
}

struct Express {
    let id: Int
    let expressNumber: String
    let companyCode: String
    let company: String
    let timestamp: Int
//    let statusId: Int
//    let status: ExpressStatus
}

extension Express: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: ExpressKey.id.rawValue)
        self.expressNumber = try unboxer.unbox(key: ExpressKey.expressNumber.rawValue)
        self.company = try unboxer.unbox(key: ExpressKey.company.rawValue)
        self.companyCode = try unboxer.unbox(key: ExpressKey.companyCode.rawValue)
        self.timestamp = try unboxer.unbox(key: ExpressKey.timestamp.rawValue)
    }
}


struct ExpressStatus {
    let id: Int
    let description: String
}

extension ExpressStatus: Unboxable {
    init(unboxer: Unboxer) throws {
        self.id = try unboxer.unbox(key: "id")
        self.description = try unboxer.unbox(key: "description")
    }
}

