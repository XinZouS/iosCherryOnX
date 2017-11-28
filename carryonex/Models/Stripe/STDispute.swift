//
//  STDispute.swift
//  carryonex
//
//  Created by Chen, Zian on 11/27/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct STDispute: Unboxable {
    //evidence see STEvidence
    //evidence_details see STEvidenceDetail
    //skip metadata
    //balance_transaction is an array of STBalanceTransaction
    let id: String?
    let object: String?
    let amount: Int?
    let balanceTransactions: [STBalanceTransaction]?
    let charge: String?
    let created: TimeInterval?
    let currency: String?
    let evidence: STEvidence?
    let evidenceDetails: STEvidenceDetail?
    let isChargeRefundable: Bool?
    let livemode: Bool?
    //let metadata: Hashable? // skipped
    let reason: String?
    let status: String?
    
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.balanceTransactions = try? unboxer.unbox(key: STKeys.balanceTransaction.rawValue)
        self.charge = try? unboxer.unbox(key: STKeys.charge.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.evidence = try? unboxer.unbox(key: STKeys.evidence.rawValue)
        self.evidenceDetails = try? unboxer.unbox(key: STKeys.evidenceDetails.rawValue)
        self.isChargeRefundable = try? unboxer.unbox(key: STKeys.isChargeRefundable.rawValue)
        self.livemode = try? unboxer.unbox(key: STKeys.livemode.rawValue)
        //self.metadata: Hashable? // skipped
        self.reason = try? unboxer.unbox(key: STKeys.reason.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)
    }
    
    
}

struct STEvidence: Unboxable {
    let accessActivityLog: String?
    let billingAddress: String?
    let cancellationPolicy: String?
    let cancellationPolicyDisclosure: String?
    let cancellationRebuttal: String?
    let customerCommunication: String?
    let customerEmailAddress: String?
    let customerName: String?
    let customerPurchaseIp: String?
    let customerSignature: String?
    let duplicateChargeDocumentation: String?
    let duplicateChargeExplanation: String?
    let duplicateChargeId: String?
    let productDescription: String?
    let receipt: String?
    let refundPolicy: String?
    let refundPolicyDisclosure: String?
    let refundRefusalExplanation: String?
    let serviceDate: String?
    let serviceDocumentation: String?
    let shippingAddress: String?
    let shippingCarrier: String?
    let shippingDate: String?
    let shippingDocumentation: String?
    let shippingTrackingNumber: String?
    let uncategorizedFile: String?
    let uncategorizedText: String?
    
    init(unboxer: Unboxer) throws {
        self.accessActivityLog = try? unboxer.unbox(key: STKeys.accessActivityLog.rawValue)
        self.billingAddress = try? unboxer.unbox(key: STKeys.billingAddress.rawValue)
        self.cancellationPolicy = try? unboxer.unbox(key: STKeys.cancellationPolicy.rawValue)
        self.cancellationPolicyDisclosure = try? unboxer.unbox(key: STKeys.cancellationPolicyDisclosure.rawValue)
        self.cancellationRebuttal = try? unboxer.unbox(key: STKeys.cancellationRebuttal.rawValue)
        self.customerCommunication = try? unboxer.unbox(key: STKeys.customerCommunication.rawValue)
        self.customerEmailAddress = try? unboxer.unbox(key: STKeys.customerEmailAddress.rawValue)
        self.customerName = try? unboxer.unbox(key: STKeys.customerName.rawValue)
        self.customerPurchaseIp = try? unboxer.unbox(key: STKeys.customerPurchaseIp.rawValue)
        self.customerSignature = try? unboxer.unbox(key: STKeys.customerSignature.rawValue)
        self.duplicateChargeDocumentation = try? unboxer.unbox(key: STKeys.duplicateChargeDocumentation.rawValue)
        self.duplicateChargeExplanation = try? unboxer.unbox(key: STKeys.duplicateChargeExplanation.rawValue)
        self.duplicateChargeId = try? unboxer.unbox(key: STKeys.duplicateChargeId.rawValue)
        self.productDescription = try? unboxer.unbox(key: STKeys.productDescription.rawValue)
        self.receipt = try? unboxer.unbox(key: STKeys.receipt.rawValue)
        self.refundPolicy = try? unboxer.unbox(key: STKeys.refundPolicy.rawValue)
        self.refundPolicyDisclosure = try? unboxer.unbox(key: STKeys.refundPolicyDisclosure.rawValue)
        self.refundRefusalExplanation = try? unboxer.unbox(key: STKeys.refundRefusalExplanation.rawValue)
        self.serviceDate = try? unboxer.unbox(key: STKeys.serviceDate.rawValue)
        self.serviceDocumentation = try? unboxer.unbox(key: STKeys.serviceDocumentation.rawValue)
        self.shippingAddress = try? unboxer.unbox(key: STKeys.shippingAddress.rawValue)
        self.shippingCarrier = try? unboxer.unbox(key: STKeys.shippingCarrier.rawValue)
        self.shippingDate = try? unboxer.unbox(key: STKeys.shippingDate.rawValue)
        self.shippingDocumentation = try? unboxer.unbox(key: STKeys.shippingDocumentation.rawValue)
        self.shippingTrackingNumber = try? unboxer.unbox(key: STKeys.shippingTrackingNumber.rawValue)
        self.uncategorizedFile = try? unboxer.unbox(key: STKeys.uncategorizedFile.rawValue)
        self.uncategorizedText = try? unboxer.unbox(key: STKeys.uncategorizedText.rawValue)
    }
    
}



struct STEvidenceDetail: Unboxable {
    let dueBy: TimeInterval?
    let hasEvidence: Bool?
    let pastDue: Bool?
    let submissionCount: Int?
    
    init(unboxer: Unboxer) throws {
        self.dueBy = try? unboxer.unbox(key: STKeys.dueBy.rawValue)
        self.hasEvidence = try? unboxer.unbox(key: STKeys.hasEvidence.rawValue)
        self.pastDue = try? unboxer.unbox(key: STKeys.pastDue.rawValue)
        self.submissionCount = try? unboxer.unbox(key: STKeys.submissionCount.rawValue)
    }
    
    
}
