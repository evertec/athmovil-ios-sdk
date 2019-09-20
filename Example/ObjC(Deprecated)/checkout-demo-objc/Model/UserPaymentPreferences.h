//
//  UserPaymentPreferences.h
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPaymentPreferences : NSObject

@property (nonatomic, assign) BOOL taxIsOn;
@property (nonatomic, assign) BOOL subTotalIsOn;
@property (nonatomic, assign) BOOL itemsIsOn;

@end
