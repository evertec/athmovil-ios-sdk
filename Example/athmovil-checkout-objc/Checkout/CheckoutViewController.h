//
//  CheckoutViewController.h
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckoutViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIStackView *buttonStack;
@property(weak, nonatomic) IBOutlet UIButton *checkoutButton;

@end
