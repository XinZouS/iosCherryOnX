//
//  GlobalVariable.swift
//  carryonex
//
//  Created by zxbMacPro on 2017/10/18.
//  Copyright © 2017年 Xin Zou. All rights reserved.
//

import Foundation

enum LoginStatus {
    case registeration
    case modifyPhone
    case changePassword
    case unknow 
}

enum CurrencyType: String {
    case CNY = "￥"
    case USD = "$"
}

// if changes the key in this map, MUST change also in the flagsTitle array
// *** the order of flags in flagsTitle should NOT be change!!!
let codeOfFlag : [String:String] = ["🇺🇸  +1":"1", "🇨🇳 +86":"86", "🇭🇰 852":"852", "🇹🇼 886":"886", "🇦🇺 +61":"61", "🇬🇧 +44":"44", "🇩🇪 +49":"49"]
var flagsTitle : [String] = ["🇺🇸  +1", "🇨🇳 +86", "🇭🇰 852", "🇹🇼 886", "🇦🇺 +61", "🇬🇧 +44", "🇩🇪 +49"]

//正则校验
struct MyRegex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input,
                                        options: [],
                                        range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        else {
            return false
        }
    }
}
// Theam colors 
let colorOkYelow = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
let colorOkgreen = #colorLiteral(red: 0.2061403394, green: 0.6508488059, blue: 0.72418648, alpha: 1)
let colorErroRed = #colorLiteral(red: 1, green: 0.5261772685, blue: 0.5414895289, alpha: 1)
let colorErrGray = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
let colorTheamRed = #colorLiteral(red: 1, green: 0.4149920642, blue: 0.4057528675, alpha: 1)
let colorLineLightGray = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)

// wechat login judge
var wxloginStatus :String = ""
// appDidLaunch judge
var appDidLaunch = false

enum ImageTypeOfID : String {
    case passport = "passport"
    case idCardA = "idCardA"
    case idCardB = "idCardB"
    case profile = "profile"
    case requestImages = "requestImages"
}

protocol PickerMenuViewDelegate: class {
    
    func setupMenuWith(hostView: UIView, targetPickerView: UIPickerView, leftBtn: UIButton, rightBtn: UIButton)
    func setupTitle(text: String)
    func showUpAnimation(withTitle: String)
    func dismissAnimation()
}

protocol PhoneNumberDelegate: class {
    func dismissAndReturnToHomePage()
}

enum Payment {
    case applePay, paypal, creditCard, wechatPay
}

protocol ZipcodeCellDelegate: class {
    func setupTextField()
}

protocol Identifiable {
    var id: Int { get set }
}

enum TripCategory: Int {
    case carrier
    case sender
    
    var stringValue: String {
        switch self {
        case .carrier:
            return "carrier"
        case .sender:
            return "sender"
        }
    }
}

/// Save user into disk by NSUserDefault
enum UserDefaultKey : String {
    case OnboardingFinished = "OnboardingFinished"
    case profileImageLocalUrl = "profileImageLocalUrl"
}

/// weixin SDK keys
let WX_APPID = "wx9dc6e6f4fe161a4f"
let WX_APPSecret = "7cdd2641573ef06d5d7c435d119dae14"

/// QQ SDK keys
let QQ_APPID = "100371282"
let QQ_APPKEY = "aed9b0303e3ed1e27bae87c33761161d"

/// Weibo SDK keys
let WB_APPKEY = "568898243"
let WB_APPSecret = "38a4f8204cc784f81f9f0daaf31e02e3"

/// AWS server keys
let awsIdentityPoolId = "us-west-2:08a19db5-a7cc-4e82-b3e1-6d0898e6f2b7" 
let awsBucketName = "carryoneximage"
let awsPublicBucketName = "carryonexpublicimage"

let imageCompress: CGFloat = 0.1

/// for more info display in MenuController
let userGuideWebHoster = "http://54.245.216.35:5000"

//Secrets
let carryonSalt = "MkzpN2J4GnoaiQsCOE23"

//MARK: - Helper Methods

func debugLog(_ message: String,
              function: String = #function,
              file: String = #file,
              line: Int = #line) {
    print("Message \"\(message)\" (File: \(file), Function: \(function), Line: \(line))")
}

func L(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

/// Stripe payment
enum STKeys: String {
    case accessActivityLog = "access_activity_log"
    case account = "account"
    case accountBalance = "account_balance"
    case accountHolderName = "account_holder_name"
    case accountHolderType = "account_holder_type"
    case address = "address"
    case addressCity = "address_city"
    case addressCountry = "address_country"
    case addressLine1 = "address_line1"
    case addressLine1Check = "address_line1_check"
    case addressLine2 = "address_line2"
    case addressState = "address_state"
    case addressZip = "address_zip"
    case addressZipCheck = "address_zip_check"
    case amount = "amount"
    case amountCharged = "amount_charged"
    case amountDue = "amount_due"
    case amountReceived = "amount+received"
    case amountRefunded = "amount_refunded"
    case amountReturned = "amount_returned"
    case amountOff = "ampunt_off"
    case application = "application"
    case applicationFee = "application_fee"
    case applicationFeePercent = "application_fee_percent"
    case arrivalDate = "arrival_date"
    case attemptsRemaining = "attempts_remaining"
    case attemptCount = "attempt_count"
    case attempted = "attempted"
    case automatic = "automatic"
    case available = "available"
    case availableOn = "available_on"
    case availablePayoutMethods = "available_payout_methods"
    case balanceTransaction = "balance_transaction"
    case bankName = "bank_name"
    case billingAddress = "billing_address"
    case brand = "brand"
    case canceledAt = "canceled_at"
    case cancelAtPeriodEnd = "cancel_at_period_end"
    case cancellationPolicy = "cancellation_policy"
    case cancellationPolicyDisclosure = "cancellation_policy_disclosure"
    case cancellationRebuttal = "cancellation_rebuttal"
    case captured = "captured"
    case carrier = "carrier"
    case charge = "charge"
    case city = "city"
    case clientSecret = "client_secret"
    case closed = "closed"
    case codeVerification = "code_verification"
    case connectReserved = "connect_reserved"
    case country = "country"
    case coupon = "coupon"
    case created = "created"
    case currency = "currency"
    case currentPeriodEnd = "current_period_end"
    case currentPeriodStart = "current_period_start"
    case customer = "customer"
    case customerCommunication = "customer_communication"
    case customerEmailAddress = "customer_email_address"
    case customerName = "customer_name"
    case customerPurchaseIp = "customer_purchase_ip"
    case customerSignature = "customer_signature"
    case businessVatId = "business_vat_id"
    case cvcCheck = "cvc_check"
    case data = "data"
    case defaultForCurrency = "default_for_currency"
    case defaultSource = "default_source"
    case description = "description"
    case destination = "destination"
    case delinquent = "delinquent"
    case dispute = "dispute"
    case dueBy = "due_by"
    case duration = "duration"
    case durationInMonths = "duration_in_months"
    case duplicateChargeDocumentation = "duplicate_charge_documentation"
    case duplicateChargeExplanation = "duplicate_charge_explanation"
    case duplicateChargeId = "duplicate_charge_id"
    case discount = "discount"
    case discountable = "discountable"
    case dynamicLast4 = "dynamic_last4"
    case email = "email"
    case end = "end"
    case endedAt = "ended_at"
    case endingBalance = "ending_balance"
    case evidence = "evidence"
    case evidenceDetails = "evidence_details"
    case expMonth = "exp_month"
    case expYear = "exp_year"
    case failureBalanceTran = "failure_balance_tran"
    case failureBalanceTransaction = "failure_balance_transaction"
    case failureCode = "failure_code"
    case failureMessage = "failure_message"
    case failureReason = "failure_reason"
    case fee = "fee"
    case feeDetails = "fee_details"
    case fingerprint = "fingerprint"
    case forgiven = "forgiven"
    case flow = "flow"
    case fraudDetails = "fraud_details"
    case funding = "funding"
    case hasEvidence = "has_evidence"
    case hasMore = "has_more"
    case id = "id"
    case items = "items"
    case invoice = "invoice"
    case interval = "interval"
    case intervalCount = "interval_count"
    case isChargeRefundable = "is_charge_refundable"
    case last4 = "last4"
    case line1 = "line1"
    case line2 = "line2"
    case lines = "lines"
    case livemode = "lovemode"
    case maxRedemptions = "max_redemptions"
    case metadata = "metadata"
    case method = "method"
    case name = "name"
    case net = "net"
    case networkStatus = "network_status"
    case nextPaymentAttempt = "next_payment_attempt"
    case object = "object"
    case onBehalfOf = "on_behalf_of"
    case order = "order"
    case orderId = "order_id"
    case outcome = "outcome"
    case owner = "owner"
    case paid = "paid"
    case pastDue = "past_due"
    case pending = "pending"
    case percentOff = "percent_off"
    case period = "period"
    case periodEnd = "period_end"
    case periodStart = "period_start"
    case phone = "phone"
    case plan = "plan"
    case postalCode = "postal_code"
    case proration = "proration"
    case productDescription = "product_description"
    case reason = "reason"
    case redirect = "redirect"
    case receipt = "receipt"
    case receiptEmail = "receipt_email"
    case receiptNumber = "receipt_number"
    case redeemBy = "redeem_by"
    case receiver = "receiver"
    case recipient = "recipient"
    case refunded = "refunded"
    case refundPolicy = "refund_policy"
    case refundPolicyDisclosure = "refund_policy_disclosure"
    case refundRefusalExplanation = "refund_refusal_explanation"
    case refunds = "refunds"
    case returnUrl = "return_url"
    case review = "review"
    case riskLevel = "risk_level"
    case routingNumber = "routing_number"
    case rule = "rule"
    case sellerMessage = "seller_message"
    case serviceDate = "service_date"
    case serviceDocumentation = "service_documentation"
    case start = "start"
    case shipping = "shipping"
    case shippingAddress = "shipping_address"
    case shippingCarrier = "shipping_carrier"
    case shippingDate = "shipping_date"
    case shippingDocumentation = "shipping_documentation"
    case shippingTrackingNumber = "shipping_tracking_number"
    case subtotal = "subtotal"
    case subscription = "subscription"
    case subscriptions = "subscriptions"
    case subscriptionItem = "subscription_item"
    case subscriptionProationDate = "subscription_proration_date"
    case source = "source"
    case sources = "sources"
    case sourceTransfer = "source_transfer"
    case sourceType = "source_type"
    case state = "state"
    case statementDescriptor = "statement_descriptor"
    case status = "status"
    case startingBalance = "starting_balance"
    case stripeReserved = "stripe_reserved"
    case submissionCount = "submission_count"
    case timesRedeemed = "times_redeemed"
    case tatus = "tatus"
    case tax = "tax"
    case taxPercent = "tax_percnet"
    case tokenizationMethod = "tokenization_method"
    case total = "total"
    case totalCount = "total_count"
    case transfer = "transfer"
    case transferGroup = "transfer_group"
    case trackingNumber = "tracking_number"
    case trialPeriodDays = "trial_period_days"
    case trialEnd = "trial_end"
    case trialStart = "trial_start"
    case type = "type"
    case quantity = "quantity"
    case uncategorizedFile = "uncategorized_file"
    case uncategorizedText = "uncategorized_text"
    case url = "url"
    case usage = "usage"
    case vaild = "vaild"
    case verifiedAddress = "verified_address"
    case verifiedEmail = "verified_email"
    case verifiedName = "verified_name"
    case verifiedPhone = "verified_phone"
    case webhooksDeliveredAt = "webhooks_delivered_at"
}

enum STTransactionType: String { //https://stripe.com/docs/api#balance_transaction_object
    case adjustment = "adjustment"
    case applicationFee = "application_fee"
    case applicationFeeRefund = "application_fee_refund"
    case charge = "charge"
    case payment = "payment"
    case paymentFailureRefund = "payment_failure_refund"
    case paymentRefund = "payment_refund"
    case refund = "refund"
    case transfer = "transfer"
    case transferRefund = "transfer_refund"
    case payout = "payout"
    case payoutCancel = "payout_cancel"
    case payoutFailure = "payout_failure"
    case validation = "validation"
    case stripeFee = "stripe_fee"
}

enum STNetworkStatus: String {
    case approvedByNetwork = "approved_by_network"
    case declinedByNetwork = "declined_by_network"
    case notSentToNetwork = "not_sent_to_network"
    case reversedAfterApproval = "reversed_after_approval"
}

enum ErrorType: Int {
    case noError = 0
    case userRegisterErr = 1
    case userAlreadyExist = 2
    case userLoadLocalFail = 3
    case userInfoNull = 4
}


enum ServerError: Int {
    
    // Informational.
    case continueDo = 100
    case switchingProtocols = 101
    case processing = 102
    case checkpoint = 103
    case urlTooLong = 122
    case ok = 200
    case created = 201
    case accepted = 202
    case nonAuthoritativeInfo = 203
    case noContent = 204
    case resetContent = 205
    case partialContent = 206
    case multiStatus = 207
    case alreadyReported = 208
    case imUsed = 226
    
    // Redirection.
    case multipleChoices = 300
    case movedPermanently = 301
    case found = 302
    case seeOther = 303
    case notModified = 304
    case useProxy = 305
    case switchProxy = 306
    case temporaryRedirect = 307
    case permanentRedirect = 308
    
    // Client Error.
    case badRequest = 400
    case unauthorized = 401
    case invalidTrip = 402
    case forbidden = 403
    case notFound = 404
    case methodNotAllowed = 405
    case notAcceptable = 406
    case proxyAuthenticationRequired = 407
    case timeout = 408
    case conflict = 409
    case gone = 410
    case inactiveTrip = 411
    case preconditionFailed = 412
    case requestEntityTooLarge = 413
    case requestUriTooLarge = 414
    case unsupportedMediaType = 415
    case requestedRangeNotSatisfiable = 416
    case expectationFailed = 417
    case teapot = 418
    case misdirectedRequest = 421
    case unprocessableEntity = 422
    case locked = 423
    case failedDependency = 424
    case unorderedCollection = 425
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests = 429
    case headerFieldsTooLarge = 431
    case noResponse = 444
    case retry = 449
    case blockedByWindowsParentalControls = 450
    case unavailableForLegalReasons = 451
    case clientClosedRequest = 499
    
    // Server Error.
    case internalServerError = 500
    case notImplemented = 501
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case httpVersionNotSupported = 505
    case variantAlsoNegotiates = 506
    case insufficientStorage = 507
    case bandwidthLimitExceeded = 509
    case notExtended = 510
    case networkAuthenticationRequired = 511

    func desplayString() -> String {
        switch self {
        // Informational.
        case .continueDo:
            return ""
        case .switchingProtocols:
            return ""
        case .processing:
            return ""
        case .checkpoint:
            return ""
        case .urlTooLong:
            return ""
        case .ok: // 200
            return ""
        case .created:
            return ""
        case .accepted:
            return ""
        case .nonAuthoritativeInfo:
            return ""
        case .noContent:
            return ""
        case .resetContent:
            return ""
        case .partialContent:
            return ""
        case .multiStatus:
            return ""
        case .alreadyReported:
            return ""
        case .imUsed:
            return ""

        // Redirection.
        case .multipleChoices:
            return ""
        case .movedPermanently:
            return ""
        case .found:
            return ""
        case .seeOther:
            return ""
        case .notModified:
            return ""
        case .useProxy:
            return ""
        case .switchProxy:
            return ""
        case .temporaryRedirect:
            return ""
        case .permanentRedirect:
            return ""

        // Client Error.
        case .badRequest: // 400
            return ""
        case .unauthorized: // 401
            return ""
        case .invalidTrip: // 402
            return ""
        case .forbidden: // 403
            return ""
        case .notFound: // 404
            return ""
        case .methodNotAllowed: // 405
            return ""
        case .notAcceptable: // 406
            return ""
        case .proxyAuthenticationRequired: // 407
            return ""
        case .timeout: // 408
            return ""
        case .conflict: // 409
            return ""
        case .gone: // 410
            return ""
        case .inactiveTrip: // 411
            return ""
        case .preconditionFailed: // 412
            return ""
        case .requestEntityTooLarge: // 413
            return ""
        case .requestUriTooLarge: // 414
            return ""
        case .unsupportedMediaType: // 415
            return ""
        case .requestedRangeNotSatisfiable:  // 416
            return ""
        case .expectationFailed:  // 417
            return ""
        case .teapot: // 418
            return ""
        case .misdirectedRequest: // 421
            return ""
        case .unprocessableEntity: // 422
            return ""
        case .locked: // 423
            return ""
        case .failedDependency: // 424
            return ""
        case .unorderedCollection: // 425
            return ""
        case .upgradeRequired: // 426
            return ""
        case .preconditionRequired:
            return ""
        case .tooManyRequests:
            return ""
        case .headerFieldsTooLarge:
            return ""
        case .noResponse:
            return ""
        case .retry:
            return ""
        case .blockedByWindowsParentalControls:
            return ""
        case .unavailableForLegalReasons:
            return ""
        case .clientClosedRequest:
            return ""

        // Server Error.
        case .internalServerError:
            return ""
        case .notImplemented:
            return ""
        case .badGateway:
            return ""
        case .serviceUnavailable:
            return ""
        case .gatewayTimeout:
            return ""
        case .httpVersionNotSupported:
            return ""
        case .variantAlsoNegotiates:
            return ""
        case .insufficientStorage:
            return ""
        case .bandwidthLimitExceeded:
            return ""
        case .notExtended:
            return ""
        case .networkAuthenticationRequired:
            return ""

        }
    }
    
}



