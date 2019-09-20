//
//  CheckoutDefaultTableViewCell.h
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckoutDefaultCellDelegate;
@class TransactionItem;

@interface CheckoutDefaultTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *productImageView;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet UILabel *descLabel;
@property(weak, nonatomic) IBOutlet UILabel *priceLabel ;
@property(weak, nonatomic) IBOutlet UILabel *stepperValueLabel;
@property(weak, nonatomic) IBOutlet UIStepper *stepperView;
@property(weak, nonatomic) id<CheckoutDefaultCellDelegate> delegate;
+(NSString *)reuseIdentifier;
-(void)setTransactionItem:(TransactionItem*)value;
@end

@protocol CheckoutDefaultCellDelegate <NSObject>
-(void) didUpdateQuantityatIndex:(UITableViewCell*)cell with:(NSString*)value;
@end

