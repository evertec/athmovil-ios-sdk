//
//  TransactionItem.h
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TransactionItem : NSObject

@property(nonatomic, retain)UIImage *image;
@property(nonatomic, retain)NSString *desc;
@property(nonatomic, retain)NSString *name;
@property(nonatomic, retain)NSString *price;
@property(nonatomic, retain)NSString *quantity;

@end
