//
//  Transaction.m
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import "Transaction.h"
#import "TransactionItem.h"

@implementation Transaction
+ (NSArray*) dummyTransactionItemList {
    
    TransactionItem *item1 = [[TransactionItem alloc] init];
    item1.image= [UIImage imageNamed:@"dummy-image-0"];
    item1.desc= @"6oz";
    item1.name= @"Blueberries";
    item1.price= @"3.99";
    item1.quantity= @"1";
    
    TransactionItem *item2 = [[TransactionItem alloc] init];
    item2.image= [UIImage imageNamed:@"dummy-image-1"];
    item2.desc= @"6oz";
    item2.name= @"Raspberries";
    item2.price= @"2.75";
    item2.quantity= @"1";
    
    return @[item1, item2];
}

+ (Transaction*) dummyTransaction {
    Transaction *dummy = [[Transaction alloc] init];
    dummy.businessToken= @"fb1f7ae2849a07da1545a89d997d8a435a5f21ac";
    dummy.scheme= @"athm-checkout";
    dummy.cartReferenceId= @"0987654321";
    dummy.subTotal= @"1.50";
    dummy.tax= @"3.42";
    dummy.total= @"3.92";
    dummy.itemList= [NSMutableArray arrayWithArray:Transaction.dummyTransactionItemList];
    return dummy;
}

@end
