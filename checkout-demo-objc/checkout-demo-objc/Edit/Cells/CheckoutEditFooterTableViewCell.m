//
//  CheckoutEditFooterTableViewCell.m
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import "CheckoutEditFooterTableViewCell.h"

@implementation CheckoutEditFooterTableViewCell
@synthesize descLabel;

+(NSString*)reuseIdentifier {
    return @"CheckoutEditFooterTableViewCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setDescLabelStyle];
}

-(void) setDescLabelStyle {
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.numberOfLines = 0;
    descLabel.textColor = [UIColor grayColor];
    descLabel.font = [UIFont systemFontOfSize:12];
    descLabel.text = NSLocalizedString(@"checkout_edit_footer_description", comment: "");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
