//
//  Transaction.h
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Transaction : NSObject

@property(nonatomic, retain)NSString *businessToken;
@property(nonatomic, retain)NSString *scheme;
@property(nonatomic, retain)NSString *cartReferenceId;
@property(nonatomic, retain)NSString *subTotal;
@property(nonatomic, retain)NSString *tax;
@property(nonatomic, retain)NSString *total;
@property(nonatomic, retain)NSMutableArray *itemList;// [TransactionItem]
+(NSArray*) dummyTransactionItemList;
+(Transaction*) dummyTransaction;
@end
