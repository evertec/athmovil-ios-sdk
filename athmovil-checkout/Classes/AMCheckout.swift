//
//  AMCheckout.swift
//  athm-checkout
//
//  Created by Leonardo Maldonado on 5/17/18.
//  Copyright © 2018 Evertec, Inc. All rights reserved.
//

import Foundation

@objc public enum AMCheckoutButtonStyle : NSInteger, RawRepresentable {
    case original
    case light
    case dark
}

extension AMCheckoutButtonStyle {
    public var bgColor : UIColor {
        switch self {
        case .original:
            return .orange
        case .light:
            return .white
        case .dark:
            return .darkGray
        }
    }
    
    public var textColor : UIColor {
        switch self {
        case .original, .dark:
            return .white
        case .light:
            return .black
        }
    }
    
    public func image(bundle: Bundle, _ lang : AMLanguage) -> UIImage? {
        var name : String
        switch self {
        case .original, .dark:
            name = "white_checkout_button_\(lang.subFix)"
        case .light:
            name = "black_checkout_button_\(lang.subFix)"
        }
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
}

@objc public enum AMLanguage : NSInteger, RawRepresentable {
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
    
    public var subFix : String {
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

@objc public protocol AMCheckoutDelegate : NSObjectProtocol {
    
    @objc func paymentSuccess(with referenceId: String,
                              transactionReference: String,
                              dailyTransactionId: String)
    
    @objc func paymentCanceled(with referenceId: String)
    
    @objc func paymentFailed(with referenceId: String,
                             errorCode: String)
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
}

@objc public class AMCheckout : NSObject {
    
    @objc public static let shared = AMCheckout()
    
    public var env: AMEnvironment = .development
    
    public var apiToken: String?
    
    public var callbackURL: String?
    
    public var lang: AMLanguage = .deviceLanguage
    
    /// The checkout process timeout expressed in seconds.
    /// The timeout must respect a minimum and maximum limit
    /// of 1 and 10 minutes, respectively.
    @objc public var timeout: Double = 600 {
        didSet {
            validateTimeoutRange()
        }
    }
    
    @objc class func AMCheckoutButtonBgColor(style : AMCheckoutButtonStyle)-> UIColor {
        switch style {
        case .original:
            return .orange
        case .light:
            return .white
        case .dark:
            return .darkGray
        }
    }
    @objc class func AMCheckoutButtonTextColor(style : AMCheckoutButtonStyle)-> UIColor {
        switch style {
            case .original, .dark:
                return .white
            case .light:
            return .black
        }
    }
    
    @objc public var delegate: AMCheckoutDelegate?
    
    private var payment: AMPayment?
    
    private override init() { /** Not allowed */ }
    
    fileprivate func validateTimeoutRange() {
        
        let validRange = 60...600 ~= timeout
        
        if !validRange {
            let error = AMErrorType
                .timeoutOutOfRange.rawValue
            fatalError(error)
        }
    }
    
    @objc public func configure(
        for env: AMEnvironment,
        with apiToken: String,
        and callbackURL: String) {
        
        self.apiToken = apiToken
        self.env = env
        self.callbackURL = callbackURL
    }
    
    @objc public func getCheckoutButton(
        withTarget target: Any,
        action: Selector,
        and style: AMCheckoutButtonStyle
        = .original) -> AMCheckoutButton {
        
        let checkoutButton = AMCheckoutButton(type: .system)
        checkoutButton.style = style
        checkoutButton.lang = lang
        checkoutButton.addTarget(target, action: action, for: .touchUpInside)
        
        return checkoutButton
    }
    
    @objc public func handleIncomingURL(url: URL) throws {
        
        let decoder = JSONDecoder()
        let components = URLComponents(
            url: url, resolvingAgainstBaseURL: false)
        
        guard let query = components?.getQueryItem(named: "athm_payment_data")
            else { throw AMErrorType.requiredURLQueryNotFound }
        
        guard let data = query.value?.toData
            else { throw AMErrorType.decodingDataException }
        
        guard let response = try? decoder.decode(AMResponse.self, from: data)
            else { throw AMErrorType.decodingJSONException }
        
        if response.status == .success {
            delegate?.paymentSuccess(with: response.cartReferenceId,
                                     transactionReference: response.transactionReference!,
                                     dailyTransactionId: response.dailyTransactionId!)
        }else {
            if response.status == .canceled {
                delegate?.paymentCanceled(with: response.cartReferenceId)
            }else {
                delegate?.paymentFailed(
                    with: response.cartReferenceId,
                    errorCode: response.status.rawValue)
            }
        }
    }
    
    @objc public func checkout(with payment: AMPayment) throws {
        self.payment = payment
        
        guard let dictionary = payment.toDictionary
            else { throw AMErrorType.apiTokenOrCallbackURLNotProvided }
        
        guard let jsonString = dictionary.toJSONString?
            .addingPercentEncoding(withAllowedCharacters:
            .urlQueryAllowed) else { throw AMErrorType.encodingJSONException }
        
        guard let appStoreURL = URL(string: "itms://itunes.apple.com/"
            + "sg/app/ath-movil/id658539297?l=zh&mt=8")
            else { return }

        guard let backURL = URL(string: "\(env.scheme)payment/" +
            "?transaction_data=\(jsonString)") else { throw AMErrorType
            .malformedURLException }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(backURL, options: [:]) { (success) in
                if !success {
                    UIApplication.shared.open(appStoreURL, options:
                        [:], completionHandler: nil)
                }
            }
        }
    }
}
