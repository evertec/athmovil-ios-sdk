//
//  CheckoutDefaultTableViewCell.m
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import "CheckoutDefaultTableViewCell.h"
#import "TransactionItem.h"

@interface CheckoutDefaultTableViewCell()
@property(nonatomic, retain)TransactionItem *transactionItem;
@end
@implementation CheckoutDefaultTableViewCell

@synthesize productImageView;
@synthesize stepperView;
@synthesize stepperValueLabel;
@synthesize nameLabel, priceLabel, descLabel;
@synthesize delegate;

+(NSString *)reuseIdentifier {
    return @"CheckoutDefaultTableViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    productImageView.layer.cornerRadius = 4;
    productImageView.layer.masksToBounds = YES;
    stepperView.tintColor =  [UIColor blueColor];
    [stepperView setHidden:YES];
}

- (void)setTransactionItem:(TransactionItem *)value {
    _transactionItem = value;
    productImageView.image = value.image;
    nameLabel.text = value.name;
    priceLabel.text = value.price;
    stepperValueLabel.text = value.quantity;
    descLabel.text = value.desc;
    
    /// set stepper value equals to quantity
//    guard let value = Double(transactionItem.quantity) else { return }
//    stepperView.value = value
}

-(IBAction) stepperViewValueChanged:(UIStepper*)sender {
    int value = (int)sender.value;
    NSString *stringValue = [NSString stringWithFormat:@"%d",value];
    _transactionItem.quantity = stringValue;
    stepperValueLabel.text = stringValue;
    [delegate didUpdateQuantityatIndex:self with:stringValue];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
