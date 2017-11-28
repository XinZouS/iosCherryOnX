//
//  STSource.swift
//  carryonex
//
//  Created by Chen, Zian on 11/27/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import UIKit
import Unbox

struct STSource: Unboxable {
    //skip metadata
    //owner and receiver see STSourceUser
    //bitcoin see STSourceBitcoin
    let id: String?
    let object: String?
    let amount: Int?
    let clientSecret: String?
    let codeVerification: STCodeVerification?
    let created: TimeInterval?
    let currency: String?
    let flow: String?
    let livemode: Bool?
    //let metadata: Hashable? // skipped
    let owner: STSourceOwner?
    let receiver: STSourceReceiver?
    let redirect: STSourceRedirect?
    let statementDescriptor: String?
    let status: String?
    let type: String?
    let usage: String?
    
    init(unboxer: Unboxer) throws {
        self.id = try? unboxer.unbox(key: STKeys.id.rawValue)
        self.object = try? unboxer.unbox(key: STKeys.object.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.clientSecret = try? unboxer.unbox(key: STKeys.clientSecret.rawValue)
        self.codeVerification = try? unboxer.unbox(key: STKeys.codeVerification.rawValue)
        self.created = try? unboxer.unbox(key: STKeys.created.rawValue)
        self.currency = try? unboxer.unbox(key: STKeys.currency.rawValue)
        self.flow = try? unboxer.unbox(key: STKeys.flow.rawValue)
        self.livemode = try? unboxer.unbox(key: STKeys.livemode.rawValue)
        //self.metadata: Hashable? // skipped
        self.owner = try? unboxer.unbox(key: STKeys.owner.rawValue)
        self.receiver = try? unboxer.unbox(key: STKeys.receiver.rawValue)
        self.redirect = try? unboxer.unbox(key: STKeys.redirect.rawValue)
        self.statementDescriptor = try? unboxer.unbox(key: STKeys.statementDescriptor.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)
        self.type = try? unboxer.unbox(key: STKeys.type.rawValue)
        self.usage = try? unboxer.unbox(key: STKeys.usage.rawValue)
    }
    
}



struct STCodeVerification: Unboxable {
    let attemptsRemaining: Int?
    let status: String?
    
    init(unboxer: Unboxer) throws {
        self.attemptsRemaining = try? unboxer.unbox(key: STKeys.attemptsRemaining.rawValue)
        self.status = try? unboxer.unbox(key: STKeys.status.rawValue)
    }
    
}



struct STSourceOwner: Unboxable {
    //for "owner" and "receiver"
    let address: STSourceOwnerAddress?
    let email: String?
    let name: String?
    let phone: String?
    let verifiedAddress: STSourceOwnerAddress?
    let verifiedEmail: String?
    let verifiedName: String?
    let verifiedPhone: String?
    
    init(unboxer: Unboxer) throws {
        self.address = try? unboxer.unbox(key: STKeys.address.rawValue)
        self.email = try? unboxer.unbox(key: STKeys.email.rawValue)
        self.name = try? unboxer.unbox(key: STKeys.name.rawValue)
        self.phone = try? unboxer.unbox(key: STKeys.phone.rawValue)
        self.verifiedAddress = try? unboxer.unbox(key: STKeys.verifiedAddress.rawValue)
        self.verifiedEmail = try? unboxer.unbox(key: STKeys.verifiedEmail.rawValue)
        self.verifiedName = try? unboxer.unbox(key: STKeys.verifiedName.rawValue)
        self.verifiedPhone = try? unboxer.unbox(key: STKeys.verifiedPhone.rawValue)
    }
    
    
}

struct STSourceReceiver: Unboxable {
    let address: String?
    let amountCharged: Int?
    let amountReceived: Int?
    let amountReturned: Int?
    
    init(unboxer: Unboxer) throws {
        self.address = try? unboxer.unbox(key: STKeys.address.rawValue)
        self.amountCharged = try? unboxer.unbox(key: STKeys.amountCharged.rawValue)
        self.amountReceived = try? unboxer.unbox(key: STKeys.amountReceived.rawValue)
        self.amountReturned = try? unboxer.unbox(key: STKeys.amountReturned.rawValue)
    }
    
    
}

struct STSourceRedirect: Unboxable {
    let failureReason: String?
    let returnUrl: String?
    let tatus: String?
    let url: String?
    
    init(unboxer: Unboxer) throws {
        self.failureReason = try? unboxer.unbox(key: STKeys.failureReason.rawValue)
        self.returnUrl = try? unboxer.unbox(key: STKeys.returnUrl.rawValue)
        self.tatus = try? unboxer.unbox(key: STKeys.tatus.rawValue)
        self.url = try? unboxer.unbox(key: STKeys.url.rawValue)
    }
    
    
}


struct STSourceOwnerAddress: Unboxable {
    let city: String?
    let country: String?
    let line1: String?
    let line2: String?
    let postalCode: String?
    let state: String?
    
    init(unboxer: Unboxer) throws {
        self.city = try? unboxer.unbox(key: STKeys.city.rawValue)
        self.country = try? unboxer.unbox(key: STKeys.country.rawValue)
        self.line1 = try? unboxer.unbox(key: STKeys.line1.rawValue)
        self.line2 = try? unboxer.unbox(key: STKeys.line2.rawValue)
        self.postalCode = try? unboxer.unbox(key: STKeys.postalCode.rawValue)
        self.state = try? unboxer.unbox(key: STKeys.state.rawValue)
    }
    
    
}


struct STSourceBitcoin: Unboxable {
    //for "bitcoin"
    let address: String?
    let amount: Int?
    let amountCharged: Int?
    let amountReceived: Int?
    let amountReturned: Int?
    let url: String?
    
    init(unboxer: Unboxer) throws {
        self.address = try? unboxer.unbox(key: STKeys.address.rawValue)
        self.amount = try? unboxer.unbox(key: STKeys.amount.rawValue)
        self.amountCharged = try? unboxer.unbox(key: STKeys.amountCharged.rawValue)
        self.amountReceived = try? unboxer.unbox(key: STKeys.amountReceived.rawValue)
        self.amountReturned = try? unboxer.unbox(key: STKeys.amountReceived.rawValue)
        self.url = try? unboxer.unbox(key: STKeys.url.rawValue)
    }
    
}
