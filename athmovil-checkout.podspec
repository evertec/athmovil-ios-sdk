#
# Be sure to run `pod lib lint athmovil-checkout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'athmovil-checkout'
  s.version          = '2.0.0'
  s.summary          = 'Provides a simple, secure and fast checkout experience to customers using your iOS application.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.homepage         = 'https://github.com/evertec/athmovil-ios-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evertec' => 'christopher.bautista@evertecinc.com' }
  s.source           = { :git => 'https://github.com/evertec/athmovil-ios-sdk.git', :tag => s.version }

  s.ios.deployment_target = '10.0'
  s.swift_version = '4.2'
  s.source_files = 'athmovil-checkout/Source/**/*'
  
  s.resource_bundles = {'athmovil-checkout' => 'athmovil-checkout/ATHMAssets.xcassets'}
  s.resource = 'athmovil-checkout/ATHMAssets.xcassets'

end
