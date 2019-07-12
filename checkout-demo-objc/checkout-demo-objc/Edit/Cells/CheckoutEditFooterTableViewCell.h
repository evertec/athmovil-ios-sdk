//
//  CheckoutEditFooterTableViewCell.h
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutEditFooterTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *descLabel;
+(NSString*)reuseIdentifier;
@end
