#
# Be sure to run `pod lib lint athmovil-checkout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'athmovil-checkout'
  s.version          = '1.1.0'
  s.summary          = 'Provides a simple, secure and fast checkout experience to customers using your iOS application.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/evertec/athmovil-ios-sdk'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Evertec' => 'christopher.bautista@evertecinc.com' }
  s.source           = { :git => 'https://github.com/evertec/athmovil-ios-sdk.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '3.0'
  s.source_files = 'athmovil-checkout/athmovil-checkout/Source/**/*'
  
  s.resource_bundles = {'athmovil-checkout' => 'athmovil-checkout/athmovil-checkout/Source/ATHMAssets.xcassets'}
  s.resource = 'athmovil-checkout/athmovil-checkout/Source/ATHMAssets.xcassets'

end