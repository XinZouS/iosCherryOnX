//
//  STCustomers.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/11/30.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct STCustomers: Unboxable {
    let id: String?
    var object: String? = "customer"
    let accountBalance: Int?
    let businessVatId: String?
    let created: TimeInterval?
    let currency: String?
    let defaultSource: String?
    let delinquent: Bool?
    let description: String?
    let discount:[STDiscount]?
    let email: String?
    let livemode: Bool?
    // let metadata
    let shipping:STShipping?
    let sources:[STSources]?
    let subscriptions:[STSubscriptions]?
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.accountBalance = try? unboxer.unbox(key: STKeys.accountBalance.rawValue)
        self.businessVatId = try? unboxer.unbox(key: STKeys.businessVatId.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.defaultSource = try? unboxer.unbox(key: STKeys.defaultSource.rawValue)
        self.delinquent = try? unboxer.unbox(key: STKeys.delinquent.rawValue)
        self.description = try? unboxer.unbox(key: STKeys.description.rawValue)
        self.discount = try? unboxer.unbox(key: STKeys.discount.rawValue)
        self.email = try? unboxer.unbox(key: STKeys.email.rawValue)
        self.livemode = try? unboxer.unbox(key: STKeys.livemode.rawValue)
        self.shipping = try? unboxer.unbox(key: STKeys.shipping.rawValue)
        self.sources = try? unboxer.unbox(key: STKeys.sources.rawValue)
        self.subscriptions = try? unboxer.unbox(key: STKeys.subscriptions.rawValue)
    }
}
struct STShipping: Unboxable{
    let address: STSourceOwnerAddress?
    let name: String?
    let phone: String?
    init(unboxer: Unboxer) throws {
        self.address = try? unboxer.unbox(key: STKeys.address.rawValue)
        self.name = try? unboxer.unbox(key: STKeys.name.rawValue)
        self.phone = try? unboxer.unbox(key: STKeys.phone.rawValue)
    }
}
struct STSources: Unboxable {
    var object: String? = "list"
    let data: [STData]?
    let hasMore: Bool?
    let url: String?
    init(unboxer: Unboxer) throws {
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.data = try? unboxer.unbox(key: STKeys.data.rawValue)
        self.hasMore = try? unboxer.unbox(key: STKeys.hasMore.rawValue)
        self.url =  try? unboxer.unbox(key: STKeys.url.rawValue)
    }
}
struct STSubscriptions:Unboxable {
    var object: String? = "list"
    let data: [STSubscription]?
    let hasMore: Bool?
    let url: String?
    init(unboxer: Unboxer) throws {
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.data = try? unboxer.unbox(key: STKeys.data.rawValue)
        self.hasMore = try? unboxer.unbox(key: STKeys.hasMore.rawValue)
        self.url = try? unboxer.unbox(key: STKeys.url.rawValue)
    }
}

struct STSubscription:Unboxable {
    let id: String?
    var object: String? = "subscription"
    let applicationFeePercent: Decimal?
    let cancelAtPeriodEnd: Bool?
    let canceledAt: TimeInterval?
    let created: TimeInterval?
    let currentPeriodEnd: TimeInterval?
    let currentPeriodStart: TimeInterval?
    let customer: String?
    let discount: STDiscount?
    let endedAt: TimeInterval?
    let items: [STItem]?
    let livemode: Bool?
    //let metadata
    let plan: STPlan?
    let quantity: Int?
    let start: TimeInterval?
    let status: String?
    let taxPercent: Decimal?
    let trialEnd: TimeInterval?
    let trialStart: TimeInterval?
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.applicationFeePercent = try? unboxer.unbox(key: STKeys.applicationFee.rawValue)
        self.cancelAtPeriodEnd = try? unboxer.unbox(key: STKeys.cancelAtPeriodEnd.rawValue)
        self.canceledAt = try? unboxer.unbox(key: STKeys.canceledAt.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currentPeriodEnd = try? unboxer.unbox(key: STKeys.currentPeriodEnd.rawValue)
        self.currentPeriodStart = try? unboxer.unbox(key: STKeys.currentPeriodEnd.rawValue)
        self.customer = try? unboxer.unbox(key: STKeys.customer.rawValue)
        self.discount = try? unboxer.unbox(key: STKeys.discount.rawValue)
        self.endedAt = try? unboxer.unbox(key: STKeys.endedAt.rawValue)
        self.items = try? unboxer.unbox(key: STKeys.items.rawValue)
        self.livemode = try? unboxer.unbox(key: STKeys.livemode.rawValue)
        self.plan = try? unboxer.unbox(key: STKeys.plan.rawValue)
        self.quantity = try? unboxer.unbox(key: STKeys.quantity.rawValue)
        self.start = try? unboxer.unbox(key: STKeys.start.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)
        self.taxPercent = try? unboxer.unbox(key: STKeys.taxPercent.rawValue)
        self.trialEnd = try? unboxer.unbox(key: STKeys.trialEnd.rawValue)
        self.trialStart = try? unboxer.unbox(key: STKeys.trialStart.rawValue)
    }
}

struct STItem:Unboxable {
    var object: String? = "list"
    let data: [STListData]?
    let hasMore: Bool?
    let url: String?
    init(unboxer: Unboxer) throws {
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.data = try? unboxer.unbox(key: STKeys.data.rawValue)
        self.hasMore = try? unboxer.unbox(key: STKeys.hasMore.rawValue)
        self.url = try? unboxer.unbox(key: STKeys.url.rawValue)
    }
}
struct STListData:Unboxable{
    let id: String?
    var object: String? = "list"
    let created: Int?
    //let metadata
    let plan: STPlan?
    let quantity: Int?
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.plan = try? unboxer.unbox(key: STKeys.plan.rawValue)
        self.quantity = try? unboxer.unbox(key: STKeys.quantity.rawValue)
    }
}
