//
//  STCharge.swift
//  carryonex
//
//  Created by Chen, Zian on 11/27/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct STCharge: Unboxable {
    //Skip "refunds for now"
    //Skip "meta data
    //Skip fraud_details
    let id: String?
    let object: String?
    let amount: Int?
    let amountRefunded: Int?
    let application: String?
    let applicationFee: String?
    let balanceTransation: String?
    let captured: Bool?
    let created: TimeInterval?
    let currency: String?
    let customer: String?
    let description: String?
    let destination: String?
    let dispute: String?
    let failureCode: String?
    let failureMessage: String?
    //let fraudDetails: Hashable? // skipped
    let invoice: String?
    let livemode: Bool?
    //let metadata: Hashable? // skipped
    let onBehalfOf: String?
    let order: String?
    let outcome: STChargeOutcome?
    let paid: Bool?
    let receiptEmail: String?
    let receiptNumber: String?
    let refunded: String?
    let refunds: STChargeRefunds?
    let review: String?
    let shipping: STChargeShipping?
    let source: STCardObject?
    let sourceTransfer: String?
    let statementDescriptor: String?
    let status: String?
    let transfer: String?
    let transferGroup: String?
    
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.amountRefunded = try? unboxer.unbox(key: STKeys.amountRefunded.rawValue)
        self.application = try? unboxer.unbox(key: STKeys.application.rawValue)
        self.applicationFee = try? unboxer.unbox(key: STKeys.applicationFee.rawValue)
        self.balanceTransation = try? unboxer.unbox(key: STKeys.balanceTransaction.rawValue)
        self.captured = try? unboxer.unbox(key: STKeys.captured.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.customer = try? unboxer.unbox(key: STKeys.customer.rawValue)
        self.description = try? unboxer.unbox(key: STKeys.description.rawValue)
        self.destination = try? unboxer.unbox(key: STKeys.destination.rawValue)
        self.dispute = try? unboxer.unbox(key: STKeys.dispute.rawValue)
        self.failureCode = try? unboxer.unbox(key: STKeys.failureCode.rawValue)
        self.failureMessage = try? unboxer.unbox(key: STKeys.failureMessage.rawValue)
        self.invoice = try? unboxer.unbox(key: STKeys.invoice.rawValue)
        self.livemode = try? unboxer.unbox(key: STKeys.livemode.rawValue)
        self.onBehalfOf = try? unboxer.unbox(key: STKeys.onBehalfOf.rawValue)
        self.order = try? unboxer.unbox(key: STKeys.order.rawValue)
        self.outcome = try? unboxer.unbox(key: STKeys.outcome.rawValue)
        self.paid = try? unboxer.unbox(key: STKeys.paid.rawValue)
        self.receiptEmail = try? unboxer.unbox(key: STKeys.receiptEmail.rawValue)
        self.receiptNumber = try? unboxer.unbox(key: STKeys.receiptNumber.rawValue)
        self.refunded = try? unboxer.unbox(key: STKeys.refunded.rawValue)
        self.refunds = try? unboxer.unbox(key: STKeys.refunds.rawValue)
        self.review = try? unboxer.unbox(key: STKeys.review.rawValue)
        self.shipping = try? unboxer.unbox(key: STKeys.shipping.rawValue)
        self.source = try? unboxer.unbox(key: STKeys.source.rawValue)
        self.sourceTransfer = try? unboxer.unbox(key: STKeys.sourceTransfer.rawValue)
        self.statementDescriptor = try? unboxer.unbox(key: STKeys.statementDescriptor.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)
        self.transfer = try? unboxer.unbox(key: STKeys.transfer.rawValue)
        self.transferGroup = try? unboxer.unbox(key: STKeys.transferGroup.rawValue)
    }
    
}



struct STChargeOutcome: Unboxable {
    let networkStatus: String?
    let reason: String?
    let riskLevel: String?
    let rule: String?
    let sellerMessage: String?
    let type: String?
    
    init(unboxer: Unboxer) throws {
        self.networkStatus = unboxer.unbox(key: STKeys.networkStatus.rawValue)
        self.reason = unboxer.unbox(key: STKeys.reason.rawValue)
        self.riskLevel = unboxer.unbox(key: STKeys.riskLevel.rawValue)
        self.rule = unboxer.unbox(key: STKeys.rule.rawValue)
        self.sellerMessage = unboxer.unbox(key: STKeys.sellerMessage.rawValue)
        self.type = unboxer.unbox(key: STKeys.type.rawValue)
    }
    
}



struct STChargeRefunds: Unboxable {
    let object: String?
    let data: STChargeRefundsData?
    let hasMore: Bool?
    let url: String?
    
    init(unboxer: Unboxer) throws {
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.data = try? unboxer.unbox(key: STKeys.data.rawValue)
        self.hasMore = try? unboxer.unbox(key: STKeys.hasMore.rawValue)
        self.url = try? unboxer.unbox(key: STKeys.url.rawValue)
    }
    
}



struct STChargeRefundsData: Unboxable {
    let id: String?
    let object: String?
    let amount: Int?
    let balanceTransaction: String?
    let charge: String?
    let created: TimeInterval?
    let currency: String?
    let failureBalanceTran: String?
    let failureReason: String?
    //let metadata: Hashable? // Skipped
    let reason: String?
    let receiptNumber: String?
    let status: String?
    
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.balanceTransaction = try? unboxer.unbox(key: STKeys.balanceTransaction.rawValue)
        self.charge = try? unboxer.unbox(key: STKeys.charge.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.failureBalanceTran = try? unboxer.unbox(key: STKeys.failureBalanceTran.rawValue)
        self.failureReason = try? unboxer.unbox(key: STKeys.failureReason.rawValue)
        self.reason = try? unboxer.unbox(key: STKeys.reason.rawValue)
        self.receiptNumber = try? unboxer.unbox(key: STKeys.receiptNumber.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)
    }
    
}


struct STChargeShipping: Unboxable {
    let address: STChargeShippingAddress?
    let carrier: String?
    let name: String?
    let phone: String?
    let trackingNumber: String?
    
    init(unboxer: Unboxer) throws {
        self.address = try? unboxer.unbox(key: STKeys.address.rawValue)
        self.carrier = try? unboxer.unbox(key: STKeys.carrier.rawValue)
        self.name = try? unboxer.unbox(key: STKeys.name.rawValue)
        self.phone = try? unboxer.unbox(key: STKeys.phone.rawValue)
        self.trackingNumber = try? unboxer.unbox(key: STKeys.trackingNumber.rawValue)
    }
    
}


struct STChargeShippingAddress: Unboxable {
    let city: String?
    let country: String?
    let line1: String?
    let line2: String?
    let postalCode: String?
    let state: String?
    
    init(unboxer: Unboxer) {
        self.city = try? unboxer.unbox(key: STKeys.addressCity.rawValue)
        self.country = try? unboxer.unbox(key: STKeys.addressCountry.rawValue)
        self.line1 = try? unboxer.unbox(key: STKeys.addressLine1.rawValue)
        self.line2 = try? unboxer.unbox(key: STKeys.addressLine2.rawValue)
        self.postalCode = try? unboxer.unbox(key: STKeys.addressZip.rawValue)
        self.state = try? unboxer.unbox(key: STKeys.addressState.rawValue)
    }
    
}


struct STCardObject: Unboxable {
    let id: String?
    let object: String?
    let account: String?
    let addressCity: String?
    let addressCountry: String?
    let addressLine1: String?
    let addressLine1Check: String?
    let addressLine2: String?
    let addressState: String?
    let addressZip: String?
    let addressZipCheck: String?
    let availablePayoutMethods: [String]?
    let brand: String?
    let country: String?
    let currency: String?
    let customer: String?
    let cvcCheck: String?
    let defaultForCurrency: Bool?
    let dynamicLast4: String?
    let expMonth: Int?
    let expYear: Int?
    let fingerprint: String?
    let funding: String?
    let last4: String?
    //let metadata: Hashable? // skipped
    let name: String?
    let recipient: String?
    let tokenizationMethod: String?
    
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.account = try? unboxer.unbox(key: STKeys.account.rawValue)
        self.addressCity = try? unboxer.unbox(key: STKeys.addressCity.rawValue)
        self.addressCountry = try? unboxer.unbox(key: STKeys.addressCountry.rawValue)
        self.addressLine1 = try? unboxer.unbox(key: STKeys.addressLine1.rawValue)
        self.addressLine1Check = try? unboxer.unbox(key: STKeys.addressLine1Check.rawValue)
        self.addressLine2 = try? unboxer.unbox(key: STKeys.addressLine2.rawValue)
        self.addressState = try? unboxer.unbox(key: STKeys.addressState.rawValue)
        self.addressZip = try? unboxer.unbox(key: STKeys.addressZip.rawValue)
        self.addressZipCheck = try? unboxer.unbox(key: STKeys.addressZipCheck.rawValue)
        self.availablePayoutMethods = try? unboxer.unbox(key: STKeys.availablePayoutMethods.rawValue)
        self.brand = try? unboxer.unbox(key: STKeys.brand.rawValue)
        self.country = try? unboxer.unbox(key: STKeys.country.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.customer = try? unboxer.unbox(key: STKeys.customer.rawValue)
        self.cvcCheck = try? unboxer.unbox(key: STKeys.cvcCheck.rawValue)
        self.defaultForCurrency = try? unboxer.unbox(key: STKeys.defaultForCurrency.rawValue)
        self.dynamicLast4 = try? unboxer.unbox(key: STKeys.dynamicLast4.rawValue)
        self.expMonth = try? unboxer.unbox(key: STKeys.expMonth.rawValue)
        self.expYear = try? unboxer.unbox(key: STKeys.expYear.rawValue)
        self.fingerprint = try? unboxer.unbox(key: STKeys.fingerprint.rawValue)
        self.funding = try? unboxer.unbox(key: STKeys.funding.rawValue)
        self.last4 = try? unboxer.unbox(key: STKeys.last4.rawValue)
        self.name = try? unboxer.unbox(key: STKeys.name.rawValue)
        self.recipient = try? unboxer.unbox(key: STKeys.recipient.rawValue)
        self.tokenizationMethod = try? unboxer.unbox(key: STKeys.tokenizationMethod.rawValue)
    }
    
    
}
