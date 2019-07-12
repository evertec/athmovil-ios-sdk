# ATH Móvil iOS SDK


## Introduction
The ATH Móvil SDK provides a simple, secure and fast checkout experience to customers paying on your iOS application. After integrating our Payment Button on your app you will be able to receive instant payments from more than a million ATH Móvil users.


## Prerequisites
Before you begin, please review the following prerequisites:

* An active ATH Móvil Business account is required to continue. *To sign up, download "ATH Móvil Business" on the App Store if you have an iOS device or on the Play Store if you have an Android device.*

* Your ATH Móvil Business account needs to have a registered, verified and active ATH® card.

* Have the API key of your Business account at hand. You can view your API key on the settings section of the ATH Móvil Business application for iOS or Android.

If you need help signing up, adding a card or have any other question please refer to https://athmovilbusiness.com/preguntas or contact our support team at (787) 773-5466.


## Installation
Before we get started, let’s configure your project:

* Add the `athmovil-checkout` pod requirement to your Podfile.
```swift
target 'MyProject' do
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

For instructions on how to define a custom URL scheme for your application
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
![alt text](https://preview.ibb.co/cU7xiz/API_Flow.png)

## Legal
### API Terms of Service
You have the option of using the API code described herein, free of charge, which will allow you to integrate the ATH Móvil Business service (the “Service”) as a method of payment in your webpages or applications. In order to use the API, you must (1) be registered in the Service and (2) comply with the Service’s terms and conditions of use and with the API documentation (as made available to you herein). You hereby acknowledge that any use, reproduction or distribution of the API or API documentation, or any derivatives or portions thereof, constitutes your acceptance of these terms and conditions, including all other sections within the API documentation. The API documentation may not be modified. No title to the intellectual property in the API or API documentation is transferred to you under these terms and conditions. Your use of the API or the API documentation, whether through a developer or otherwise, is made with the understanding that neither your financial institution nor Evertec will provide you with any technical support, customer support or maintenance in relation to the use of the API. You may discontinue the use of the API at any time. In the event that you are assisted by a developer, you understand and acknowledge that you will be solely responsible for your developer’s compliance with the terms and conditions of the Service, these terms and conditions, and the rest of the API documentation.

### Disclaimer of Warranty
You hereby understand and acknowledge that the API is provided “AS IS” and that your use of the API is completely voluntary and at your own risk. Both Evertec and your financial institution disclaim all warranties and make no representations of any kind, whether express or implied, as to (1) the merchantability or fitness of the API for any particular purpose; (2) the APIs performance or availability; (3) the APIs condition of titled; or (4) that the APIs use or process derived or produced therefrom will not infringe any patent, copyright or other third parties. You agree that in no event shall Evertec or your financial institution be liable for any direct, indirect, special, consequential or accidental damages or loss (including, but not limited to, loss of anticipated profits or data, or other commercial damage), however arising, or any kind with relation to the API and its use or inability to use with the Service.
