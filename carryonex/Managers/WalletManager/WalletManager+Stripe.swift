//
//  WalletManager+Stripe.swift
//  carryonex
//
//  Created by Zian Chen on 12/5/17.
//  Copyright © 2017 CarryonEx. All rights reserved.
//

import Foundation
import Stripe

private let stripeTestPublishableKey = "pk_test_CYQgDCI6ZzIg6aDOwp6noMhW"
private let stripePublishableKey = "pk_live_MRIB2doVh5Npf12pPgQHUMb7"

enum WalletCurrency: String {
    case usd = "usd"
    case cny = "cny"
}

enum WalletStripePaymentStatus: Int {
    case success
    case error
    case userCancelled
}

protocol WalletStripeDelegate: class {
    func walletStripePaymentDidFinish(status: WalletStripePaymentStatus?, error: Error?)
    func walletStripePaymentDidUpdate(method: String?, amount: Int)
    func walletStripePaymentDidFailToLoad(error: Error?)
}

extension WalletManager {
    func initializeStripe() {
        STPPaymentConfiguration.shared().publishableKey = stripeTestPublishableKey
        //        STPPaymentConfiguration.shared().publishableKey = stripePublishableKey    //Production
        STPPaymentConfiguration.shared().companyName = "Carryon Technologies Inc"
        //STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.carryontech"
    }
    
    func pay(price: Int, currency: WalletCurrency = .usd, hostViewController: UIViewController) {
        let customerContext = STPCustomerContext(keyProvider: self)
        let paymentContext = STPPaymentContext(customerContext: customerContext)
        let userInformation = STPUserInformation()
        paymentContext.prefilledInformation = userInformation
        paymentContext.paymentAmount = price
        paymentContext.paymentCurrency = currency.rawValue  //Allow user to choose currency
        paymentContext.delegate = self
        paymentContext.hostViewController = hostViewController
        paymentContext.requestPayment()
        
        stripePaymentContext = paymentContext
    }
    
    func retryLoading() {
        stripePaymentContext?.retryLoading()
    }
}

extension WalletManager: STPPaymentContextDelegate {
    
    func paymentContext(_ paymentContext: STPPaymentContext,
                        didCreatePaymentResult paymentResult: STPPaymentResult,
                        completion: @escaping STPErrorBlock) {
        
        if let stripePaymentContext = self.stripePaymentContext {
            ApiServers.shared.postWalletStripeCompleteCharge(paymentResult,
                                                             amount: stripePaymentContext.paymentAmount,
                                                             currency: stripePaymentContext.paymentCurrency,
                                                             completion: completion)
        }
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext,
                        didFinishWith status: STPPaymentStatus,
                        error: Error?) {
        
        var walletPmtStatus: WalletStripePaymentStatus?
        if let paymentStatus = WalletStripePaymentStatus(rawValue: Int(status.rawValue)) {
            walletPmtStatus = paymentStatus
        }
        delegate?.walletStripePaymentDidFinish(status: walletPmtStatus, error: error)
    }
    
    func paymentContextDidChange(_ paymentContext: STPPaymentContext) {
        delegate?.walletStripePaymentDidUpdate(method: paymentContext.selectedPaymentMethod?.label,
                                               amount: paymentContext.paymentAmount)
    }
    
    func paymentContext(_ paymentContext: STPPaymentContext, didFailToLoadWithError error: Error) {
        delegate?.walletStripePaymentDidFailToLoad(error: error)
    }
}

extension WalletManager: STPEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        ApiServers.shared.getWalletStripeEphemeralKey(apiVersion: apiVersion) { (response, error) in
            completion(response, error)
        }
    }
}
