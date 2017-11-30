//
//  STInvoice.swift
//  
//
//  Created by zxbMacPro on 2017/11/30.
//

import UIKit
import Unbox

struct STInvoice: Unboxable {
    //availabe and pending see STBalanceAccount
    let id:String?
    let object: String?
    let amountDue: Int?
    let applicationFee: Int?
    let attemptCount: Int?
    let attempted: Bool?
    let charge: String?
    let closed: Bool?
    let currency: String?
    let customer: String?
    let date: TimeInterval?
    let description: String?
    let discount: STDiscount?
    let endingBalance: Int?
    let forgiven: Bool?
    let lines: [STLines]?
    let livemode: Bool?
//  let metadata
    let nextPaymentAttempt: TimeInterval?
    let paid: Bool?
    let periodEnd: TimeInterval?
    let periodStart: TimeInterval?
    let receiptNumber: String?
    let startingBalance: Int?
    let statementDescriptor: String?
    let subscription: String?
    let subscriptionProationDate: Int?
    let subtotal: Int?
    let tax: Int?
    let taxPercent: Decimal?
    let total: Int?
    let webhooksDeliveredAt: TimeInterval?
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amountDue = try? unboxer.unbox(key: STKeys.amountDue.rawValue)
        self.applicationFee = try? unboxer.unbox(key: STKeys.applicationFee.rawValue)
        self.attemptCount = try? unboxer.unbox(key: STKeys.attemptCount.rawValue)
        self.attempted = try? unboxer.unbox(key: STKeys.attempted.rawValue)
        self.charge = try? unboxer.unbox(key: STKeys.charge.rawValue)
        self.closed = try? unboxer.unbox(key: STKeys.closed.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.customer = try? unboxer.unbox(key: STKeys.customer.rawValue)
        self.date =  try? unboxer.unbox(key: STKeys.data.rawValue)
        self.description =  try? unboxer.unbox(key: STKeys.description.rawValue)
        self.discount =  try? unboxer.unbox(key: STKeys.discount.rawValue)
        self.endingBalance =  try? unboxer.unbox(key: STKeys.endingBalance.rawValue)
        self.forgiven =  try? unboxer.unbox(key: STKeys.forgiven.rawValue)
        self.lines =  try? unboxer.unbox(key: STKeys.lines.rawValue)
        self.livemode = try? unboxer.unbox(key: STKeys.livemode.rawValue)
        self.nextPaymentAttempt = try? unboxer.unbox(key: STKeys.nextPaymentAttempt.rawValue)
        self.paid = try? unboxer.unbox(key: STKeys.paid.rawValue)
        self.periodEnd = try? unboxer.unbox(key: STKeys.periodEnd.rawValue)
        self.periodStart = try? unboxer.unbox(key: STKeys.periodStart.rawValue)
        self.receiptNumber = try? unboxer.unbox(key: STKeys.receiptNumber.rawValue)
        self.startingBalance = try? unboxer.unbox(key: STKeys.startingBalance.rawValue)
        self.statementDescriptor = try? unboxer.unbox(key: STKeys.startingBalance.rawValue)
        self.subscription = try? unboxer.unbox(key: STKeys.subscription.rawValue)
        self.subscriptionProationDate = try? unboxer.unbox(key: STKeys.subscriptionProationDate.rawValue)
        self.subtotal = try? unboxer.unbox(key: STKeys.subtotal.rawValue)
        self.tax = try? unboxer.unbox(key: STKeys.tax.rawValue)
        self.taxPercent = try? unboxer.unbox(key: STKeys.taxPercent.rawValue)
        self.total = try? unboxer.unbox(key: STKeys.total.rawValue)
        self.webhooksDeliveredAt = try? unboxer.unbox(key: STKeys.webhooksDeliveredAt.rawValue)
    }

}
struct  STDiscount:Unboxable{
    var object: String? = "discount"
    let coupon: STCoupon?
    let customer: String?
    let end: TimeInterval?
    let start: TimeInterval?
    let subscription: String?
    init(unboxer: Unboxer) throws {
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.coupon = try? unboxer.unbox(key: STKeys.coupon.rawValue)
        self.customer = try? unboxer.unbox(key: STKeys.customer.rawValue)
        self.end = try? unboxer.unbox(key: STKeys.end.rawValue)
        self.start = try? unboxer.unbox(key: STKeys.start.rawValue)
        self.subscription =  try? unboxer.unbox(key: STKeys.subscription.rawValue)
    }
}

struct STLines:Unboxable {
    var object: String? = "list"
    let data:[STData]?
    let hasMore: Bool?
    let url: String?
    init(unboxer: Unboxer) throws {
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.data = try? unboxer.unbox(key: STKeys.data.rawValue)
        self.hasMore = try? unboxer.unbox(key: STKeys.hasMore.rawValue)
        self.url =  try? unboxer.unbox(key: STKeys.url.rawValue)
    }
}

struct STData:Unboxable {
    let id: String?
    let object: String?
    let amount: Int?
    let currency: String?
    let description: String?
    let discountable: Bool?
//  let metadata
    let period:STPeriod?
    let plan:STPlan?
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.description = try? unboxer.unbox(key: STKeys.description.rawValue)
        self.discountable = try? unboxer.unbox(key: STKeys.discountable.rawValue)
        self.period = try? unboxer.unbox(key: STKeys.period.rawValue)
        self.plan = try? unboxer.unbox(key: STKeys.plan.rawValue)
    }
}

struct STPeriod:Unboxable {
    let start: TimeInterval?
    let end: TimeInterval?
    init(unboxer: Unboxer) throws {
        self.start = try? unboxer.unbox(key: STKeys.start.rawValue)
        self.end = try? unboxer.unbox(key: STKeys.end.rawValue)
    }
}

struct STPlan:Unboxable {
    let id: String?
    var object: String? = "plan"
    let amount: Int?
    let created: TimeInterval?
    let currency: String?
    let interval: String?
    let intervalCount: Int?
    let livemode: Bool?
    let name: String?
    let statementDescriptor: String?
    let trialPeriodDays: TimeInterval?
    //let metadata
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.interval = try? unboxer.unbox(key: STKeys.interval.rawValue)
        self.intervalCount = try? unboxer.unbox(key: STKeys.intervalCount.rawValue)
        self.livemode = try? unboxer.unbox(key: STKeys.livemode.rawValue)
        self.name = try? unboxer.unbox(key: STKeys.name.rawValue)
        self.statementDescriptor = try? unboxer.unbox(key: STKeys.statementDescriptor.rawValue)
        self.trialPeriodDays = try? unboxer.unbox(key: STKeys.trialPeriodDays.rawValue)
    }
}

struct STCoupon:Unboxable{
    let id: String?
    var object: String? = "coupon"
    let amountOff: Int?
    let created: TimeInterval?
    let currency: String?
    let duration: String?
    let durationInMonths: Int?
    let maxRedemptions: Int?
//    let metadata
    let percentOff: Int?
    let redeemBy: TimeInterval?
    let timesRedeemed: Int?
    let valid: Bool?
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object =  try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amountOff =  try? unboxer.unbox(key: STKeys.amountOff.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.duration = try? unboxer.unbox(key: STKeys.duration.rawValue)
        self.durationInMonths = try? unboxer.unbox(key: STKeys.durationInMonths.rawValue)
        self.maxRedemptions = try? unboxer.unbox(key: STKeys.maxRedemptions.rawValue)
        self.percentOff = try? unboxer.unbox(key: STKeys.percentOff.rawValue)
        self.redeemBy = try? unboxer.unbox(key: STKeys.redeemBy.rawValue)
        self.timesRedeemed = try? unboxer.unbox(key: STKeys.redeemBy.rawValue)
        self.valid = try? unboxer.unbox(key: STKeys.vaild.rawValue)
    }
}

struct STInvoiceLineItem: Unboxable{
    let id: String?
    var object: String? = "line_item"
    let amount: Int?
    let currency: String?
    let description: String?
    let discountable: Bool?
//    let metadata
    let period: [STPeriod]?
    let plan: [STPlan]?
    let proration: Bool?
    let subscription: String?
    let subscriptionItem: String?
    let type: String?
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.description = try? unboxer.unbox(key: STKeys.description.rawValue)
        self.discountable = try? unboxer.unbox(key: STKeys.discountable.rawValue)
        self.period = try? unboxer.unbox(key: STKeys.period.rawValue)
        self.plan = try? unboxer.unbox(key: STKeys.plan.rawValue)
        self.proration = try? unboxer.unbox(key: STKeys.proration.rawValue)
        self.subscription = try? unboxer.unbox(key: STKeys.subscription.rawValue)
        self.subscriptionItem = try? unboxer.unbox(key: STKeys.subscriptionItem.rawValue)
        self.type = try? unboxer.unbox(key: STKeys.type.rawValue)
    }
}


