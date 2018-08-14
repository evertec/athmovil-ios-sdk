# ATH Móvil iOS SDK


## Introduction
The ATH Móvil SDK provides a simple, secure and fast checkout experience to customers using your iOS application. After integrating our checkout process on your app you will be able to receive instant payments from more than a million ATH Móvil users.


## Prerequisites
Before you begin, please review the following prerequisites:

* An active ATH Móvil Business account is required to continue. *To sign up, download the ATH Móvil Business application on your iOS or Android on your mobile device.*

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
AMCheckout.shared.configure(
for: .production, with: apiToken, and: callbackURL)
```

| Field  | Values |
| ------------- |-------------|
| `for` |  `.production` or  `.development` |
| `with` | Provide your ATH Móvil Business API Key. Required for security purposes. |
| `callbackURL` | Set to the URL scheme of your application. |

### Handle the callback of the URL scheme.
```swift
func application(_ app: UIApplication, open url: URL, options:
[UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

do {
try AMCheckout.shared.handleIncomingURL(url: url)
} catch let error {
print(error)
}

return true
}
```

### Get the "Pay with ATH Móvil" button.
```swift
let checkoutButton = AMCheckout.shared.getCheckoutButton(
withTarget: self, action: #selector(payWithATHMButtonPressed))
```
#### Customize the button theme.
By default, the "Pay with ATH Móvil" button is displayed in orange. The style can be modified to an optional light or dark theme.

```swift
let checkoutButton = AMCheckout.shared.getCheckoutButton(
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
By default, the "Pay with ATH Móvil" button is displayed in the device's current language. You can force the button to be displayed in a single language if necessary.

```swift
AMCheckout.shared.lang = .es
```

| Languages  | Example |
| ------------- |-------------|
| `.en` | ![alt text](https://image.ibb.co/e7883o/Default.png) |
| `.es` | ![alt text](https://image.ibb.co/mLyVG8/Default.png) |

### Create a payment object with the details of the payment.
```swift
var items: [AMPaymentItem] = []

let newItem = AMPaymentItem(
desc: “Item Description”,
name:”Item Name”,
price: 4.99,
quantity: 1)

items.append(newItem)

let payment = AMPayment(
referenceId: 12345,
subTotal: 3.45,
tax: 0.45,
total: 5.99,
items: items)

```
| Variable  | Data Type | Required | Description |
| ------------- |:-------------:|:-----:| ------------- |
| `referenceId` | String | Yes | Provide an ID to identify the transaction on your end. This reference ID is sent back in the transaction completion response and its never presented to the end user. |
| `subTotal` | String | Yes | Use this variable to display the payment subtotal. *Can be set as null.* |
| `tax` | String | Yes | Use this variable to display the payment tax. *Can be set as null.* |
| `total` | String | Yes | The amount provided on this method is the final amount to be paid by the end user. |
| `items` | Array | Yes | Use this variable to display the items that the user is purchasing on ATH Móvil. Items on the array are expected in the following order: ("desc", “name”, “price”, “quantity”). *Can be set as null.* |

#### Set an optional payment timeout.
Use this optional method to limit the amount of time (in seconds) that the user has to complete the payment. Timer starts the moment ATH Móvil's instance is displayed. The default value of this method is set to 600 (10 mins).

```swift
AMCheckout.shared.timeout = 60
```

### Handle the checkout button action.
```swift
do {
try AMCheckout.shared.checkout(with: payment)
} catch let error {
print(error)
}
```

### Implement the response delegate on your controller.
```swift
extension CheckoutViewController: AMCheckoutDelegate {
func paymentCanceled(with referenceId: String) {
//Handle Canceled response
}

func paymentFailed(with referenceId: String, errorCode:
//Handle Failed response
}

func paymentSuccess(with referenceId: String,
transactionReference: String,
dailyTransactionId: String) {
//Handle Completed response
}
}
```

| Function  | Response Parameter | Possible Values |
| ------------- | ------------- | ------------- |
| `paymentCanceled` | `referenceId` | `referenceId`: Reference ID that was provided when the payment object was created.|
| `paymentFailed` | `referenceId` & `errorCode` | `referenceId`: Reference ID that was provided when the payment object was created. `errorCode`: `UserHaveNoActiveCards`, `BusinessUnavailable`, `TimeOut`. |
| `paymentSuccess` | `referenceId`, `transactionReference` & `dailyTransactionId` | `referenceId`: Reference ID that was provided when the payment object was created. `transactionReference`: ATH Móvil’s reference number. Required to verify or refund a payment. `dailyTransactionId`: ATH Móvil Business daily transaction ID. |

## Testing
Set the configuration of the SDK to `.development`. A simulator that responds transaction requests is included in the SDK.

## User experience
![alt text](https://preview.ibb.co/cU7xiz/API_Flow.png)

## Legal
### API Terms of Service
You have the option of using the API code described herein, free of charge, which will allow you to integrate the ATH Móvil Business service (the “Service”) as a method of payment in your webpages or applications. In order to use the API, you must (1) be registered in the Service and (2) comply with the Service’s terms and conditions of use and with the API documentation (as made available to you herein). You hereby acknowledge that any use, reproduction or distribution of the API or API documentation, or any derivatives or portions thereof, constitutes your acceptance of these terms and conditions, including all other sections within the API documentation. The API documentation may not be modified. No title to the intellectual property in the API or API documentation is transferred to you under these terms and conditions. Your use of the API or the API documentation, whether through a developer or otherwise, is made with the understanding that neither your financial institution nor Evertec will provide you with any technical support, customer support or maintenance in relation to the use of the API. You may discontinue the use of the API at any time. In the event that you are assisted by a developer, you understand and acknowledge that you will be solely responsible for your developer’s compliance with the terms and conditions of the Service, these terms and conditions, and the rest of the API documentation.

### Disclaimer of Warranty
You hereby understand and acknowledge that the API is provided “AS IS” and that your use of the API is completely voluntary and at your own risk. Both Evertec and your financial institution disclaim all warranties and make no representations of any kind, whether express or implied, as to (1) the merchantability or fitness of the API for any particular purpose; (2) the APIs performance or availability; (3) the APIs condition of titled; or (4) that the APIs use or process derived or produced therefrom will not infringe any patent, copyright or other third parties. You agree that in no event shall Evertec or your financial institution be liable for any direct, indirect, special, consequential or accidental damages or loss (including, but not limited to, loss of anticipated profits or data, or other commercial damage), however arising, or any kind with relation to the API and its use or inability to use with the Service.
