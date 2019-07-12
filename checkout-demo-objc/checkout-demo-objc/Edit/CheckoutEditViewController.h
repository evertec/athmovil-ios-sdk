//
//  CheckoutEditViewController.h
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckoutEditDelegate;
@class UserPaymentPreferences;
@interface CheckoutEditViewController : UITableViewController
@property(nonatomic,retain)UserPaymentPreferences *userPref;
@property(nonatomic,weak)id<CheckoutEditDelegate> delegate;
+(CheckoutEditViewController*)initFromStoryboard;
@end

@protocol CheckoutEditDelegate <NSObject>
-(void) didUpdatePreferences:(UserPaymentPreferences*) pref;
@end
