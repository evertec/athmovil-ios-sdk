Pod::Spec.new do |spec|

  spec.name         = "athmovil-checkout"
  spec.version      = "6.1.0"
  spec.summary      = "Provides a simple, secure and fast checkout experience to customers using your iOS application."

  spec.description  = <<-DESC
Provides a simple, secure and fast checkout experience to customers paying on your iOS application. After integrating our Payment Button on your app you will be able to receive instant payments from more than a million ATH Movil users.
  DESC

  spec.homepage     = "https://github.com/evertec/athmovil-ios-sdk"
  spec.author       = { "Evertec" => "joel.martinez@evertecinc.com" }
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.platform     = :ios
  spec.ios.deployment_target = "13.0"
  spec.source       = { :git => "https://github.com/evertec/athmovil-ios-sdk.git", :tag => "#{spec.version}" }

  spec.swift_versions = ['5.9']

  spec.source_files = [
    "Sources/AthmovilCheckout/**/*.swift",
    "Sources/AthmovilCheckout/include/**/*.h"
  ]

  spec.public_header_files = "Sources/AthmovilCheckout/include/**/*.h"

  spec.resources = [
    "Sources/AthmovilCheckout/Resources/**/*.xib",
    "Sources/AthmovilCheckout/Resources/**/*.storyboard",
    "Sources/AthmovilCheckout/Resources/**/*.lproj",
    "Sources/AthmovilCheckout/Resources/**/*.strings"
  ]

  spec.resource_bundles = {
    'athmovil-checkout-assets' => [
      "Sources/AthmovilCheckout/Resources/**/*.xcassets",
      "Sources/AthmovilCheckout/Resources/**/*.{pdf,png,jpeg,jpg}"
    ]
  }

end