using System;
using CoreGraphics;
using Foundation;
using ObjCRuntime;
using UIKit;
using athmovil_checkout;

namespace ATHMovilPaymentButton
{
	// @interface ATHMBusinessAccount : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMBusinessAccount
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
		[Export ("description")]
		string Description { get; }

		// -(instancetype _Nonnull)initWithToken:(NSString * _Nonnull)token __attribute__((objc_designated_initializer));
		[Export ("initWithToken:")]
		[DesignatedInitializer]
		IntPtr Constructor (string token);

		// -(instancetype _Nonnull)initWithDictionary:(NSDictionary * _Nonnull)dictionary __attribute__((objc_designated_initializer));
		[Export ("initWithDictionary:")]
		[DesignatedInitializer]
		IntPtr Constructor (NSDictionary dictionary);
	}

	// @interface ATHMButton : UIButton
	[BaseType (typeof(UIButton))]
	[DisableDefaultCtor]
	interface ATHMButton
	{
		// -(instancetype _Nullable)initWithCoder:(NSCoder * _Nonnull)coder __attribute__((objc_designated_initializer));
		[Export ("initWithCoder:")]
		[DesignatedInitializer]
		IntPtr Constructor (NSCoder coder);

		// -(void)awakeFromNib __attribute__((objc_requires_super));
		[Export ("awakeFromNib")]
		[RequiresSuper]
		void AwakeFromNib ();

		// -(instancetype _Nonnull)initWithFrame:(CGRect)frame __attribute__((objc_designated_initializer));
		[Export ("initWithFrame:")]
		[DesignatedInitializer]
		IntPtr Constructor (CGRect frame);
	}

	// @interface ATHMCustomer : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMCustomer
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull name;
		[Export ("name")]
		string Name { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull phoneNumber;
		[Export ("phoneNumber")]
		string PhoneNumber { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull email;
		[Export ("email")]
		string Email { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
		[Export ("description")]
		string Description { get; }
	}

	// @interface ATHMPayment : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMPayment
	{
		// @property (readonly, nonatomic, strong) NSNumber * _Nonnull total;
		[Export ("total", ArgumentSemantic.Strong)]
		NSNumber Total { get; }

		// @property (nonatomic, strong) NSNumber * _Nonnull subtotal;
		[Export ("subtotal", ArgumentSemantic.Strong)]
		NSNumber Subtotal { get; set; }

		// @property (nonatomic, strong) NSNumber * _Nonnull tax;
		[Export ("tax", ArgumentSemantic.Strong)]
		NSNumber Tax { get; set; }

		// @property (nonatomic, strong) NSNumber * _Nonnull fee;
		[Export ("fee", ArgumentSemantic.Strong)]
		NSNumber Fee { get; set; }

		// @property (nonatomic, strong) NSNumber * _Nonnull netAmount;
		[Export ("netAmount", ArgumentSemantic.Strong)]
		NSNumber NetAmount { get; set; }

		// @property (copy, nonatomic) NSArray<ATHMPaymentItem *> * _Nonnull items;
		[Export ("items", ArgumentSemantic.Copy)]
		ATHMPaymentItem[] Items { get; set; }

		// @property (copy, nonatomic) NSString * _Nonnull metadata1;
		[Export ("metadata1")]
		string Metadata1 { get; set; }

		// @property (copy, nonatomic) NSString * _Nonnull metadata2;
		[Export ("metadata2")]
		string Metadata2 { get; set; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
		[Export ("description")]
		string Description { get; }

		// -(instancetype _Nonnull)initWithTotal:(NSNumber * _Nonnull)total __attribute__((objc_designated_initializer));
		[Export ("initWithTotal:")]
		[DesignatedInitializer]
		IntPtr Constructor (NSNumber total);

		// -(instancetype _Nonnull)initWithDictionary:(NSDictionary * _Nonnull)dictionary __attribute__((objc_designated_initializer));
		[Export ("initWithDictionary:")]
		[DesignatedInitializer]
		IntPtr Constructor (NSDictionary dictionary);
	}

	// @interface ATHMPaymentError : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMPaymentError
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull failureReason;
		[Export ("failureReason")]
		string FailureReason { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull errorDescription;
		[Export ("errorDescription")]
		string ErrorDescription { get; }

		// @property (readonly, nonatomic) BOOL isRequestError;
		[Export ("isRequestError")]
		bool IsRequestError { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
		[Export ("description")]
		string Description { get; }
	}

	// @interface ATHMPaymentHandler : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMPaymentHandler
	{
		// -(instancetype _Nonnull)initOnCompleted:(void (^ _Nonnull)(ATHMPaymentResponse * _Nonnull))onCompleted onExpired:(void (^ _Nonnull)(ATHMPaymentResponse * _Nonnull))onExpired onCancelled:(void (^ _Nonnull)(ATHMPaymentResponse * _Nonnull))onCancelled onException:(void (^ _Nonnull)(ATHMPaymentError * _Nonnull))onException __attribute__((objc_designated_initializer));
		[Export ("initOnCompleted:onExpired:onCancelled:onException:")]
		[DesignatedInitializer]
		IntPtr Constructor (Action<ATHMPaymentResponse> onCompleted, Action<ATHMPaymentResponse> onExpired, Action<ATHMPaymentResponse> onCancelled, Action<ATHMPaymentError> onException);
	}

	// @interface ATHMPaymentHandlerDictionary : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMPaymentHandlerDictionary
	{
		// -(instancetype _Nonnull)initOnCompleted:(void (^ _Nonnull)(NSDictionary * _Nonnull))onCompleted onExpired:(void (^ _Nonnull)(NSDictionary * _Nonnull))onExpired onCancelled:(void (^ _Nonnull)(NSDictionary * _Nonnull))onCancelled onException:(void (^ _Nonnull)(ATHMPaymentError * _Nonnull))onException __attribute__((objc_designated_initializer));
		[Export ("initOnCompleted:onExpired:onCancelled:onException:")]
		[DesignatedInitializer]
		IntPtr Constructor (Action<NSDictionary> onCompleted, Action<NSDictionary> onExpired, Action<NSDictionary> onCancelled, Action<ATHMPaymentError> onException);
	}

	// @interface ATHMPaymentItem : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMPaymentItem
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull name;
		[Export ("name")]
		string Name { get; }

		// @property (readonly, nonatomic) NSInteger quantity;
		[Export ("quantity")]
		nint Quantity { get; }

		// @property (readonly, nonatomic, strong) NSNumber * _Nonnull price;
		[Export ("price", ArgumentSemantic.Strong)]
		NSNumber Price { get; }

		// @property (copy, nonatomic) NSString * _Nonnull desc;
		[Export ("desc")]
		string Desc { get; set; }

		// @property (copy, nonatomic) NSString * _Nonnull metadata;
		[Export ("metadata")]
		string Metadata { get; set; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
		[Export ("description")]
		string Description { get; }

		// -(instancetype _Nonnull)initWithName:(NSString * _Nonnull)name price:(NSNumber * _Nonnull)price quantity:(NSInteger)quantity __attribute__((objc_designated_initializer));
		[Export ("initWithName:price:quantity:")]
		[DesignatedInitializer]
		IntPtr Constructor (string name, NSNumber price, nint quantity);

		// -(instancetype _Nonnull)initWithDictionary:(NSDictionary * _Nonnull)dictionary __attribute__((objc_designated_initializer));
		[Export ("initWithDictionary:")]
		[DesignatedInitializer]
		IntPtr Constructor (NSDictionary dictionary);
	}

	// @interface ATHMPaymentRequest : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMPaymentRequest
	{
		// @property (nonatomic) NSTimeInterval timeout;
		[Export ("timeout")]
		double Timeout { get; set; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
		[Export ("description")]
		string Description { get; }

		// -(instancetype _Nonnull)initWithAccount:(ATHMBusinessAccount * _Nonnull)account scheme:(ATHMURLScheme * _Nonnull)scheme payment:(ATHMPayment * _Nonnull)payment __attribute__((objc_designated_initializer));
		[Export ("initWithAccount:scheme:payment:")]
		[DesignatedInitializer]
		IntPtr Constructor (ATHMBusinessAccount account, ATHMURLScheme scheme, ATHMPayment payment);

		// -(void)payWithHandler:(ATHMPaymentHandler * _Nonnull)handler;
		[Export ("payWithHandler:")]
		void PayWithHandler (ATHMPaymentHandler handler);

		// -(void)payWithDictionaryHandler:(ATHMPaymentHandlerDictionary * _Nonnull)handler;
		[Export ("payWithDictionaryHandler:")]
		void PayWithDictionaryHandler (ATHMPaymentHandlerDictionary handler);
	}

	// @interface ATHMPaymentResponse : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMPaymentResponse
	{
		// @property (readonly, nonatomic, strong) ATHMPayment * _Nonnull payment;
		[Export ("payment", ArgumentSemantic.Strong)]
		ATHMPayment Payment { get; }

		// @property (readonly, nonatomic, strong) ATHMPaymentStatus * _Nonnull status;
		[Export ("status", ArgumentSemantic.Strong)]
		ATHMPaymentStatus Status { get; }

		// @property (readonly, nonatomic, strong) ATHMCustomer * _Nonnull customer;
		[Export ("customer", ArgumentSemantic.Strong)]
		ATHMCustomer Customer { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
		[Export ("description")]
		string Description { get; }
	}

	// @interface ATHMPaymentSession : NSObject
	[BaseType (typeof(NSObject))]
	interface ATHMPaymentSession
	{
		// @property (readonly, nonatomic, strong, class) ATHMPaymentSession * _Nonnull shared;
		[Static]
		[Export ("shared", ArgumentSemantic.Strong)]
		ATHMPaymentSession Shared { get; }

		// @property (copy, nonatomic) NSURL * _Nullable url;
		[NullAllowed, Export ("url", ArgumentSemantic.Copy)]
		NSUrl Url { get; set; }
	}

	// @interface ATHMPaymentStatus : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMPaymentStatus
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull statusPayment;
		[Export ("statusPayment")]
		string StatusPayment { get; }

		// @property (readonly, copy, nonatomic) NSDate * _Nonnull date;
		[Export ("date", ArgumentSemantic.Copy)]
		NSDate Date { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull referenceNumber;
		[Export ("referenceNumber")]
		string ReferenceNumber { get; }

		// @property (readonly, nonatomic) NSInteger dailyTransactionID;
		[Export ("dailyTransactionID")]
		nint DailyTransactionID { get; }

		// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
		[Export ("description")]
		string Description { get; }
	}

	// @protocol ATHMPaymentTheme
	/*
  Check whether adding [Model] to this declaration is appropriate.
  [Model] is used to generate a C# class that implements this protocol,
  and might be useful for protocols that consumers are supposed to implement,
  since consumers can subclass the generated class instead of implementing
  the generated interface. If consumers are not supposed to implement this
  protocol, then [Model] is redundant and will generate code that will never
  be used.
*/[Protocol]
	interface ATHMPaymentTheme
	{
		// @required @property (readonly, nonatomic, strong) UIColor * _Nonnull background;
		[Abstract]
		[Export ("background", ArgumentSemantic.Strong)]
		UIColor Background { get; }

		// @required @property (readonly, nonatomic, strong) UIColor * _Nonnull tintColor;
		[Abstract]
		[Export ("tintColor", ArgumentSemantic.Strong)]
		UIColor TintColor { get; }

		// @required @property (readonly, nonatomic, strong) UIImage * _Nullable image;
		[Abstract]
		[NullAllowed, Export ("image", ArgumentSemantic.Strong)]
		UIImage Image { get; }
	}

	// @interface ATHThemeClassic : NSObject <ATHMPaymentTheme>
	[BaseType (typeof(NSObject))]
	interface ATHThemeClassic : IATHMPaymentTheme
	{
		// @property (readonly, nonatomic, strong) UIColor * _Nonnull background;
		[Export ("background", ArgumentSemantic.Strong)]
		UIColor Background { get; }

		// @property (readonly, nonatomic, strong) UIColor * _Nonnull tintColor;
		[Export ("tintColor", ArgumentSemantic.Strong)]
		UIColor TintColor { get; }

		// @property (readonly, nonatomic, strong) UIImage * _Nullable image;
		[NullAllowed, Export ("image", ArgumentSemantic.Strong)]
		UIImage Image { get; }
	}

	// @interface ATHThemeLight : NSObject <ATHMPaymentTheme>
	[BaseType (typeof(NSObject))]
	interface ATHThemeLight : IATHMPaymentTheme
	{
		// @property (readonly, nonatomic, strong) UIColor * _Nonnull background;
		[Export ("background", ArgumentSemantic.Strong)]
		UIColor Background { get; }

		// @property (readonly, nonatomic, strong) UIColor * _Nonnull tintColor;
		[Export ("tintColor", ArgumentSemantic.Strong)]
		UIColor TintColor { get; }

		// @property (readonly, nonatomic, strong) UIImage * _Nullable image;
		[NullAllowed, Export ("image", ArgumentSemantic.Strong)]
		UIImage Image { get; }
	}

	// @interface ATHThemeNight : NSObject <ATHMPaymentTheme>
	[BaseType (typeof(NSObject))]
	interface ATHThemeNight : IATHMPaymentTheme
	{
		// @property (readonly, nonatomic, strong) UIColor * _Nonnull background;
		[Export ("background", ArgumentSemantic.Strong)]
		UIColor Background { get; }

		// @property (readonly, nonatomic, strong) UIColor * _Nonnull tintColor;
		[Export ("tintColor", ArgumentSemantic.Strong)]
		UIColor TintColor { get; }

		// @property (readonly, nonatomic, strong) UIImage * _Nullable image;
		[NullAllowed, Export ("image", ArgumentSemantic.Strong)]
		UIImage Image { get; }
	}

	// @interface ATHMURLScheme : NSObject
	[BaseType (typeof(NSObject))]
	[DisableDefaultCtor]
	interface ATHMURLScheme
	{
		// @property (readonly, copy, nonatomic) NSString * _Nonnull description;
		[Export ("description")]
		string Description { get; }

		// -(instancetype _Nonnull)initWithUrlScheme:(NSString * _Nonnull)urlScheme __attribute__((objc_designated_initializer));
		[Export ("initWithUrlScheme:")]
		[DesignatedInitializer]
		IntPtr Constructor (string urlScheme);

		// -(instancetype _Nonnull)initWithDictionary:(NSDictionary * _Nonnull)dictionary __attribute__((objc_designated_initializer));
		[Export ("initWithDictionary:")]
		[DesignatedInitializer]
		IntPtr Constructor (NSDictionary dictionary);
	}

	// @interface athmovil_checkout_Swift_550 (UIButton)
	[Category]
	[BaseType (typeof(UIButton))]
	interface UIButton_athmovil_checkout_Swift_550
	{
		// -(void)toggleATHMNight;
		[Export ("toggleATHMNight")]
		void ToggleATHMNight ();

		// -(void)toggleATHMLight;
		[Export ("toggleATHMLight")]
		void ToggleATHMLight ();

		// -(void)toggleATHMClassic;
		[Export ("toggleATHMClassic")]
		void ToggleATHMClassic ();
	}
}
