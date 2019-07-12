//
//  AMCheckout.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

@objc public enum AMCheckoutButtonStyle: NSInteger, RawRepresentable {
    case original
    case light
    case dark
}

extension AMCheckoutButtonStyle {
    public var bgColor: UIColor {
        switch self {
        case .original:
            return .orange
        case .light:
            return .white
        case .dark:
            return .darkGray
        }
    }
    
    public var textColor: UIColor {
        switch self {
        case .original, .dark:
            return .white
        case .light:
            return .black
        }
    }
    
    public func image(bundle: Bundle, _ lang : AMLanguage) -> UIImage? {
        var name: String
        switch self {
        case .original, .dark:
            name = "white_checkout_button_\(lang.subFix)"
        case .light:
            name = "black_checkout_button_\(lang.subFix)"
        }
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    
    public var name: String {
        switch self {
        case .original:
            return "Original"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }
}

@objc public enum AMLanguage: NSInteger, RawRepresentable {
    case en
    case es
}

extension AMLanguage {
    static var deviceLanguage: AMLanguage {
        let prefferedLanguage = Locale.preferredLanguages[0]
        let arr = prefferedLanguage.components(separatedBy: "-")
        let deviceLanguage = arr.first
        switch deviceLanguage {
        case "es":
            return .es
        default:
            return .en
        }
    }
    
    public var subFix: String {
        switch self {
        case .es:
            return "es"
        default:
            return "en"
        }
    }
}

@objc public enum AMEnvironment: NSInteger, RawRepresentable {
    case development
    case production
}

extension AMEnvironment {
    var scheme: String {
        switch self {
        case .development:
            return "athm-simulator://"
        case .production:
            return "athm://"
        }
    }
}

@objc public protocol AMCheckoutDelegate: NSObjectProtocol {
    
    @objc func onCompletedPayment(
        referenceNumber: String?, total: NSNumber, tax: NSNumber?,
        subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?)
    
    @objc func onCancelledPayment(
        referenceNumber: String?, total: NSNumber, tax: NSNumber?,
        subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?)
    
    @objc func onExpiredPayment(
        referenceNumber: String?, total: NSNumber, tax: NSNumber?,
        subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?)
}

public enum AMErrorType: String, Error {
    case requiredURLQueryNotFound
    case malformedURLException
    case decodingJSONException
    case requiredJSONPropertiesNotFound
    case decodingDataException
    case encodingJSONException
    case apiTokenOrCallbackURLNotProvided
    case paymentCanceled
    case paymentFailed
    case transactionExpired
    case timeoutOutOfRange
    case businessNotAvailable
    case specialCharactersNotAllowed
}

@objc public class ATHMCheckout: NSObject {
    
    @objc public static let shared = ATHMCheckout()
    
    public var env: AMEnvironment = .development
    
    public var publicToken: String?
    
    public var callbackURL: String?
    
    public var lang: AMLanguage = .deviceLanguage
    
    public var theme: AMCheckoutButtonStyle = .original
    
    public typealias Seconds = Double
    
    /// The timeout must respect a minimum and maximum limit
    /// of 1 and 10 minutes, respectively.
    @objc public var timeout: Seconds = 600 {
        didSet {
            validateTimeoutRange()
        }
    }
    
    @objc public var delegate: AMCheckoutDelegate?
    
    private var payment: ATHMPayment?
    
    private override init() { /** Not allowed */ }
    
    fileprivate func validateTimeoutRange() {
        
        let validRange = 60...600 ~= timeout
        
        if !validRange {
            fatalError(AMErrorType.timeoutOutOfRange.rawValue)
        }
    }
    
    @objc public func configure(for env: AMEnvironment, with publicToken: String, and callbackURL: String) throws {
        
        if publicToken.isEmpty, callbackURL.isEmpty {
            throw AMErrorType.apiTokenOrCallbackURLNotProvided
        }
        
        self.publicToken = publicToken
        self.env = env
        self.callbackURL = callbackURL
    }
    
    @objc public func getCheckoutButton(withTarget target: Any, action: Selector) -> ATHMCheckoutButton {
        
        let checkoutButton = ATHMCheckoutButton(type: .system)
        checkoutButton.style = self.theme
        checkoutButton.lang = lang
        checkoutButton.addTarget(target, action: action, for: .touchUpInside)
        
        return checkoutButton
    }
    
    @objc public func handleIncomingURL(url: URL) throws {
        
        let decoder = JSONDecoder()
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        guard let query = components?.getQueryItem(named: "athm_payment_data")
            else { throw AMErrorType.requiredURLQueryNotFound }
        
        guard let data = query.value?.toData
            else { throw AMErrorType.decodingDataException }
        
        guard let response = try? decoder.decode(ATHMResponse.self, from: data)
            else { throw AMErrorType.decodingJSONException }
        
        switch response.status {
        case .success:
             handleOnCompletedPayment(with: response)
        case .timeout:
            handleOnExpiredPayment(with: response)
        default:
            handleOnCancelledPayment(with: response)
        }
    }
    
    func handleOnCompletedPayment(with response: ATHMResponse) {
        delegate?.onCompletedPayment(
            referenceNumber: response.transactionReference, total: response.total.toNSNumber,
            tax: response.tax?.toNSNumber, subtotal: response.subtotal?.toNSNumber,
            metadata1: response.metadata1, metadata2: response.metadata2, items: response.items)
    }
    
    func handleOnExpiredPayment(with response: ATHMResponse) {
        delegate?.onExpiredPayment(
            referenceNumber: response.referenceNumber, total: response.total.toNSNumber,
            tax: response.tax?.toNSNumber, subtotal: response.subtotal?.toNSNumber,
            metadata1: response.metadata1, metadata2: response.metadata2, items: response.items)
    }
    
    func handleOnCancelledPayment(with response: ATHMResponse) {
        delegate?.onCancelledPayment(
            referenceNumber: response.referenceNumber, total: response.total.toNSNumber,
            tax: response.tax?.toNSNumber, subtotal: response.subtotal?.toNSNumber,
            metadata1: response.metadata1, metadata2: response.metadata2, items: response.items)
    }
    
    @objc public func checkout(with payment: ATHMPayment) throws {
        self.payment = payment
        
        guard let dictionary = payment.toDictionary
            else { throw AMErrorType.apiTokenOrCallbackURLNotProvided }
        
        guard let jsonString = dictionary.toJSONString?.addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) else { throw AMErrorType.encodingJSONException }
        
        guard let appStoreURL = URL(string: "itms://itunes.apple.com/"
            + "sg/app/ath-movil/id658539297?l=zh&mt=8") else { return }

        guard let backURL = URL(string: "\(env.scheme)payment/" +
            "?transaction_data=\(jsonString)") else { throw AMErrorType.malformedURLException }

        let urlOpener = URLOpener(application: UIApplication.shared)
        urlOpener.openWebsite(url: backURL, alternateURL: appStoreURL, completion: nil)
    }
}
