import Foundation

final class ATHMBundleToken {}

extension Bundle {
    static var athm: Bundle {
        #if SWIFT_PACKAGE
        return .module
        #else
        let candidates = [
            Bundle(for: ATHMBundleToken.self),
            Bundle.main
        ]

        for bundle in candidates {
            if let resourceBundleURL = bundle.url(forResource: "athmovil-checkout-assets", withExtension: "bundle"),
               let resourceBundle = Bundle(url: resourceBundleURL) {
                return resourceBundle
            }
        }

        return Bundle(for: ATHMBundleToken.self)
        #endif
    }
}