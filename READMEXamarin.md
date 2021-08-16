# ATH Móvil iOS SDK for Xamarin.IOS

This guide will help you to create a ATHM Móvil interface for Xamarin.IOS. You can use the ATH Móvil Button the same way as says the Readme.md

## Introduction
The ATH Móvil SDK provides a simple, secure and fast checkout experience to customers paying on your iOS application. After integrating our Payment Button on your app you will be able to receive instant payments from more than a million ATH Móvil users.


## Prerequisites
Before you begin, please review the following prerequisites:

* An active ATH Móvil Business account is required to continue. *To sign up, download "ATH Móvil Business" on the App Store if you have an iOS device or on the Play Store if you have an Android device.*

* Your ATH Móvil Business account needs to have a registered, verified and active ATH® card.

* Have the API key of your Business account at hand. You can view your API key on the settings section of the ATH Móvil Business application for iOS or Android.

* Xcode 12.4 

* Sharpie Tool de <a href="https://docs.microsoft.com/en-us/xamarin/cross-platform/macios/binding/objective-sharpie/get-started">Microsoft Version 3.5</a>.

* Microsoft Visual Studio Version 8.9.2

* Xcode Tools  xcode-select –install (XCodeBuild 12.4)
 
If you need help signing up, adding a card or have any other question please refer to https://athmovilbusiness.com/preguntas or contact our support team at (787) 773-5466. For technical support please complete the following form: https://forms.gle/ZSeL8DtxVNP2K2iDA.

## Basic Walkthrough
You can use the ATH Móvil Button in your proyect Xamarin.IOS but before you import the button you must follow the next sptes:
* Create an interface from Swift to C#
* Integrate with Visual Studio

## Creating Interface from Swift

To integrate the IOS Payment Button into a Xamarin.IOS project you will need to generate a interface called APIDefinition.cs that maps all the necessary classes from Swift to C#, after that you can use the logic in Xamarin.

To generate the APIDefinition.cs interface, we have included a script to generate that interface, so the first thing to do will be as follows:

* Download or clone the proyect
* Find the file athmovil-checkout-ios/Xamarin.sh
* Open a terminal an execute the following command 

```bash
sh Xamarin.sh
```

* The following should be seen in the console when running the script. This indicates that the APIDefinition.cs file was generated correctly. You should see the architectures x86_64 and arm64 

```bash

Architectures in the fat file: Release/athmovil_checkout.framework/athmovil_checkout are: x86_64 arm64 
...

🏆 Creating XamarinApiDef
3.4.0-c0f0e73
Parsing 1 header files...

Binding...
  [write] ApiDefinitions.cs

Done.
🏁 Xamarin.sh XamarinApiDef is ready 
```

Once the file is generated ApiDefinition.cs can be found within the same folder as the athmovil-checkout-ios/build/XamarinApiDef

ApiDefinition.cs is generated with the Sharpie tool, therefore it is a version that you have to remove some lines because Sharpie does not interpret correctly, therefore open ApiDefinition.cs file with any text editor and perform the following actions.

* Remove the line 
```csharp
using athmovil_checkout;
```

* Find and remove the occurrences of the following lines 
```csharp
// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
[Export ("description")
string Description { get; }
```

* Find the definition of interface ATHMButton and delete the following lines

```csharp
// -(instancetype _Nullable)initWithCoder:(NSCoder * _Nonnull)coder __attribute__((objc_designated_initializer));
[Export ("initWithCoder:")]
[DesignatedInitializer]
IntPtr Constructor (NSCoder coder);

// -(void)awakeFromNib __attribute__((objc_requires_super));
[Export ("awakeFromNib")]
[RequiresSuper]
void AwakeFromNib ();

```

* Find the definition of interface ATHThemeClassic, ATHThemeLight y ATHThemeNight change the definition as follows:

```csharp
[BaseType(typeof(NSObject))]
interface ATHThemeClassic : ATHMPaymentTheme
{...

// @interface ATHThemeLight : NSObject <ATHMPaymentTheme>
[BaseType(typeof(NSObject))]
interface ATHThemeLight : ATHMPaymentTheme
{...

// @interface ATHThemeNight : NSObject <ATHMPaymentTheme>
[BaseType(typeof(NSObject))]
interface ATHThemeNight : ATHMPaymentTheme
{...
```

Finally save the ApiDefinitions.cs file and close. In the next step you will need the following files:

* ApiDefinitions.cs
* athmovil_checkout.framework this is in the path build/Release/

## Integrate with Visual Studio

The next step is intergate the APIDefinition.cs with Visual Studio.
For instructions on how to create a binding proyect and how consume the binding project <a href="https://docs.microsoft.com/en-us/xamarin/ios/platform/binding-swift/walkthrough#build-a-binding-library">click here</a>.

## Usage

In your Xamarin.IOS proyect you can use the ATH Movil Payment Buttons the same way as Swift, there are some differences regarding sintaxis but the logic and objects are the same. Here you can find some examples for more information refere to README.md

* Import the namespce

```csharp
using ATHMovilPaymentButton;
```

* Using Storyboard or Xib

![xamarinios](ReadmeImages/XamarinXib.png)

* Setting ATH Movil Payment Button to a UIKit UIButton

```csharp
yourUIButton.ToggleATHMLight();
```

* Adding a ATH Móvil Button by code

```csharp
ATHMButton buttonByCode = new ATHMButton(new CoreGraphics.CGRect(0, 0, 320, 50));
buttonByCode.TouchUpInside += (sender, e) => {
    this.sendPayment();
};

stackButtons.InsertArrangedSubview(buttonByCode, 5);
buttonByCode.ToggleATHMNight();
```

* Make a request to ATH Movil Personal

```csharp
void sendPayment()
{
    /// Set your url scheme, this is the url name that ATH Movil is going to send the response after the payment
    /// Avoid to use this xamarinSDK, the app cliente should define custom name in the info.plist
    ATHMURLScheme scheme = new ATHMURLScheme("xamarinSDK");

    /// Business token, it means the business account that will receive the payment
    /// You can use the public token as dummy for testing. For more information read the Readme.md 
    ATHMBusinessAccount business = new ATHMBusinessAccount("e7d8056974085111e695b5f7a99d27c206a73089");

    /// Payment to send to ATH Movil, tax, subtotal and items are optional so the client can avoid them
    ATHMPayment payment = new ATHMPayment(2.0);
    payment.Tax = 1.0;
    payment.Subtotal = 1.0;
    payment.Items = new ATHMPaymentItem[] { new ATHMPaymentItem("Item Test", 1.0, 1) };

    /// Lambda Expression to call after ATH Movil respond, it depends on the status of the transaction.
    /// Error would call if there is an error in the request or in response
    ATHMPaymentHandler handler = new ATHMPaymentHandler(
        onCompleted => paymentResponse(onCompleted),
        onExpired => paymentResponse(onExpired),
        onCancelled => paymentResponse(onCancelled),
        onExceptionrror => errorFromATHMovil(onExceptionrror));


    /// Object that send the payment to ATH Móvil Personal
    ATHMPaymentRequest request = new ATHMPaymentRequest(business, scheme, payment);
    request.Timeout = 140;
    request.PayWithHandler(handler);

}
```

* Wait for the response

```csharp
[Export("scene:openURLContexts:")]
public void OpenUrlContexts(UIScene scene, NSSet<UIOpenUrlContext> urlContexts)
{
    ATHMovilPaymentButton.ATHMPaymentSession.Shared.Url = urlContexts.AnyObject.Url;
}
```

Any question please refer to README.md, also in Xamarin you can use the ATH Payment Simulator.

## Legal
The use of this API and any related documentation is governed by and must be used in accordance with the Terms and Conditions of Use of ATH Móvi Business ®, which may be found at: https://athmovilbusiness.com/terminos.
