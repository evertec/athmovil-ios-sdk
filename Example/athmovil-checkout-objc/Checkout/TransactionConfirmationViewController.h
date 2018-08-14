//
//  TransactionConfirmationViewController.h
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransactionConfirmationViewController : UIViewController
@property(weak, nonatomic)IBOutlet UIButton *doneButton;
@property(weak, nonatomic)IBOutlet UIImageView *iconImageView;
@property(weak, nonatomic)IBOutlet UILabel *primaryLabel;
@property(weak, nonatomic)IBOutlet UILabel *secondaryLabel;
@property(strong, nonatomic)NSString *primaryTitle;
@property(strong, nonatomic)NSString *secondaryTitle;
@property(strong, nonatomic)UIImage *iconImage;
+(TransactionConfirmationViewController*)initFromStoryboard;
@end
