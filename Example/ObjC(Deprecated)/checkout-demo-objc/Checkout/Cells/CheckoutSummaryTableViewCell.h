//
//  CheckoutSummaryTableViewCell.h
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Transaction;
@interface CheckoutSummaryTableViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *subTotalLabel;
@property(weak, nonatomic) IBOutlet UILabel *taxLabel;
@property(weak, nonatomic) IBOutlet UILabel *totalLabel;
@property(weak, nonatomic) IBOutlet UILabel *subTotalValueLabel;
@property(weak, nonatomic) IBOutlet UILabel *taxValueLabel;
@property(weak, nonatomic) IBOutlet UILabel *totalValueLabel;
-(void)configWith:(Transaction *)transaction;
+(NSString *)reuseIdentifier;
@end
