# ATH Móvil iOS SDK


## Introduction
The ATH Móvil SDK provides a simple, secure and fast checkout experience to customers paying on your iOS application. After integrating our Payment Button on your app you will be able to receive instant payments from more than a million ATH Móvil users.


## Prerequisites
Before you begin, please review the following prerequisites:

1. An active ATH Móvil Business account is required to continue.
 * Note: *To sign up, download "ATH Móvil Business" on the App Store if you have an iOS device or on the Play Store if you have an Android device.*


2. Your ATH Móvil Business account needs to have a registered, verified and active ATH® card.

3. Have the public and private API keys of your Business account at hand.
 * Note: ***You can view your API keys on the settings section of the ATH Móvil Business application for iOS or Android.***

## Support
If you need help signing up, adding a card or have any other question please refer to https://athmovilbusiness.com/preguntas or contact our support team at (787) 773-5466. For technical support please complete the following form:  https://forms.gle/ZSeL8DtxVNP2K2iDA.


## Installation
Before we get started, let’s configure your project:

* Add the `athmovil-checkout` pod requirement to your Podfile.
```swift
target 'MyProject' do
use_frameworks!
pod 'athmovil-checkout', :git => 'https://github.com/evertec/athmovil-ios-sdk.git'
end
```

* Execute `pod install` to complete the installation of the SDK pod.

## Usage
To implement ATH Móvil’s checkout process on your iOS application you will need to open the CocoaPods workspace and complete the step by step guide below.

### Configure the SDK.
```swift
do {
            try ATHMCheckout.shared.configure(for: .production, with: publicToken, and: callbackURL)
        } catch {
            print(error.localizedDescription)
        }
```

| Property  | Values |
| ------------- |-------------|
| `for` |  `.production` or  `.development` |
| `with` | Provide your ATH Móvil Business Public API Key. This determines the Business account where the payment will be sent to. |
| `and` | Set to the URL scheme of your application. |

Notes:
* You need to define and configure your own callbackURL variable in your project's URL Types. **Do not** copy the callbackURL provided on this demo.
* For instructions on how to define a custom URL scheme for your application
<a href="https://developer.apple.com/documentation/uikit/core_app/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app">click here</a>.

### Handle the callback of the URL scheme.
```swift
func application(_ app: UIApplication, open url: URL, options:
[UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

do {
    try ATHMCheckout.shared.handleIncomingURL(url: url)
} catch let error {
    print(error)
}

return true
}
```
### Get the "Pay with ATH Móvil" button.
```swift
let checkoutButton = ATHMCheckout.shared.getCheckoutButton(
withTarget: self, action: #selector(payWithATHMButtonPressed))
```
#### Customize the button theme.
By default, the Payment Button is displayed in orange. The style can be modified to an optional light or dark theme.

```swift
let checkoutButton = ATHMCheckout.shared.getCheckoutButton(
withTarget: self,
action: #selector(payWithATHMButtonPressed),
and style: .dark)
```

| Styles  | Example |
| ------------- |-------------|
| default | ![alt text](https://image.ibb.co/e7883o/Default.png) |
| `.light` | ![alt text](https://image.ibb.co/jAOaio/Light.png) |
| `.dark` | ![alt text](https://image.ibb.co/kSmvio/Dark.png) |

#### Customize the button language.
By default, the Payment Button is displayed in the configured primary language of the device. You can force the button to the language of your choice if necessary.

```swift
ATHMCheckout.shared.lang = .es
```

| Languages  | Example |
| ------------- |-------------|
| `.en` | ![alt text](https://image.ibb.co/e7883o/Default.png) |
| `.es` | ![alt text](https://image.ibb.co/mLyVG8/Default.png) |

### Create a payment object with the details of the payment.
```swift
var items: [ATHMPaymentItem] = []

let newItem = try? ATHMPaymentItem(
name: “Item”,
description: ”This is a description”,
quantity: 1,
price: 1.00,
metadata: "metadata test")

items.append(newItem)

let payment = try? ATHMPayment(
total: 1.00,
subtotal: 1.00,
tax: 1.00,
metadata1: ”metadata1 test”,
metadata2: "metadata2 test",
items: items)

```
| Variable  | Data Type | Required | Description |
| ------------- |:-------------:|:-----:| ------------- |
| `total` | NSNumber | Yes | Total amount to be paid by the end user. |
| `subtotal` | NSNumber | No | Optional  variable to display the payment subtotal (if applicable) |
| `tax` | NSNumber | No | Optional variable to display the payment tax (if applicable). |
| `metadata1` | String | No | Optional variable to attach key-value data to the payment object. |
| `metadata2` | String | No | Optional variable to attach key-value data to the payment object. |
| `items` | Array | No | Optional variable to display the items that the user is purchasing on ATH Móvil's payment screen. ||

#### Set an optional payment timeout.
This optional payment timeout expires the payment process if the payment hasn't been completed by the user after the provided amount of time (in seconds). Countdown starts immediately after the user presses the Payment Button. Default value is set to 600 seconds (10 mins).

```swift
AMCheckout.shared.timeout = 60
```

### Handle the Payment Button action.
```swift
do {
try ATHMCheckout.shared.checkout(with: payment)
} catch let error {
print(error)
}
```

### Implement the response delegate on your controller.
```swift
extension CheckoutViewController: ATHMCheckoutDelegate {
    func onCompletedPayment(referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {
        //Handle response
    }

    func onCancelledPayment(referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {
        //Handle response
    }

    func onExpiredPayment(referenceNumber: String?, total: NSNumber, tax: NSNumber?, subtotal: NSNumber?, metadata1: String?, metadata2: String?, items: [ATHMPaymentItem]?) {
        //Handle response
      }
}
```

## Testing
Install athm-simulator and set the configuration of the SDK to `.development`. A simulator that responds transaction requests is included in the SDK.

## User experience
![paymentux](paymentux.png)

## Legal
The use of this API and any related documentation is governed by and must be used in accordance with the Terms and Conditions of Use of ATH Móvi Business ®, which may be found at: https://athmovilbusiness.com/terminos.
