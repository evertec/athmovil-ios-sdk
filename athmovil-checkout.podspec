#
#  Be sure to run `pod spec lint athmovil-checkout.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "athmovil-checkout"
  spec.version      = "2.0.0"
  spec.summary      = "Provides a simple, secure and fast checkout experience to customers using your iOS application."

  spec.description  = <<-DESC
Provides a simple, secure and fast checkout experience to customers paying on your iOS application. After integrating our Payment Button on your app you will be able to receive instant payments from more than a million ATH Movil users.
                   DESC

  spec.homepage     = "https://github.com/evertec/athmovil-ios-sdk"


  spec.license      = { :type => "MIT", :file => "LICENSE" }


  spec.author             = { "Evertec" => "christopher.bautista@evertecinc.com" }

  spec.platform     = :ios
  spec.ios.deployment_target = "10.0"
  spec.source       = { :git => "https://github.com/evertec/athmovil-ios-sdk.git", :tag => "#{spec.version}" }


  spec.source_files  = "athmovil-checkout/Source/*.{swift}"

  spec.resources = 'athmovil-checkout/*.{pdf,png,jpeg,jpg,storyboard,xib,xcassets}'
  spec.resource_bundles = { 'athmovil-checkout' => ['athmovil-checkout/ATHMAssets.xcassets'] }
  
end
