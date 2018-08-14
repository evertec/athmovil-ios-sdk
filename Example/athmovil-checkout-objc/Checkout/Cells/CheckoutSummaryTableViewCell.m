//
//  CheckoutSummaryTableViewCell.m
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import "CheckoutSummaryTableViewCell.h"
#import "Transaction.h"

@interface CheckoutSummaryTableViewCell()
//@property(nonatomic,retain)Transaction * transaction;
@end
@implementation CheckoutSummaryTableViewCell
@synthesize contentView, totalLabel, totalValueLabel, subTotalValueLabel;
@synthesize subTotalLabel, taxLabel, taxValueLabel ;//, transaction;
+(NSString *)reuseIdentifier {
    return @"CheckoutSummaryTableViewCell";
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    contentView.backgroundColor = [UIColor whiteColor];
    totalLabel.textColor = [UIColor blueColor];
    totalValueLabel.textColor = [UIColor blueColor];
    totalLabel.font = [UIFont boldSystemFontOfSize:18];
    totalValueLabel.font = [UIFont boldSystemFontOfSize:18];
}

-(void)configWith:(Transaction *)transaction {
    subTotalValueLabel.text = transaction.subTotal;
    taxValueLabel.text = transaction.tax;
    totalValueLabel.text = transaction.total;
    subTotalLabel.text = @"Subtotal";
    taxLabel.text = @"Tax(12%)";
    totalLabel.text = @"TOTAL";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
