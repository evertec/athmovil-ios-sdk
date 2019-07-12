//
//  CheckoutViewController.m
//  athm-checkout-demo-objc
//
//  Created by Cristopher Bautista on 7/10/18.
//  Copyright © 2018 EVERTEC. All rights reserved.
//

#import "CheckoutViewController.h"
#import "Transaction.h"
#import "TransactionItem.h"
#import "CheckoutDefaultTableViewCell.h"
#import "CheckoutSummaryTableViewCell.h"
#import "TransactionConfirmationViewController.h"
#import "CheckoutEditViewController.h"
#import "UserPaymentPreferences.h"

@import athm_checkout;
@interface CheckoutViewController ()<CheckoutEditDelegate, CheckoutDefaultCellDelegate, AMCheckoutDelegate>
@property (nonatomic, retain) Transaction *transaction;
@property (nonatomic, retain) UserPaymentPreferences *userPref;
@property (nonatomic, assign) int interpolationIndex;
@end

@implementation CheckoutViewController
@synthesize tableView, buttonStack, checkoutButton;
@synthesize userPref;
@synthesize transaction, interpolationIndex;

+ (CheckoutViewController*)initFromStoryboard {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Checkout" bundle:nil];
    CheckoutViewController *myViewController = [storyboard instantiateViewControllerWithIdentifier:@"CheckoutViewController"];
    return myViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cart";
    interpolationIndex = 0;
    transaction = Transaction.dummyTransaction;
    userPref = [[UserPaymentPreferences alloc] init];
    userPref.taxIsOn = true;
    userPref.subTotalIsOn = true;
    userPref.itemsIsOn = true;
    ATHMCheckout.shared.delegate = self;
    ATHMCheckout.shared.timeout = 60;
    [self setupTableView];
    [self setupCheckoutButton];
}

// MARK: Helper Methods

- (void)payWithATHMButtonPressed:(UIButton*)sender {
    
    ATHMPayment *payment = [self getPaymentWith:transaction];
    if (!payment) {
        return;
    }
    
    payment = [self validateUserPrefWith:payment];

    NSError *error;
    [ATHMCheckout.shared checkoutWith:payment error:&error];
}

- (void)setupCheckoutButton {
    [self setCheckoutButtonStyle];
    
    ATHMCheckoutButton *checkoutATH = [[ATHMCheckout shared] getCheckoutButtonWithTarget:self action:@selector(payWithATHMButtonPressed:)];

    [buttonStack insertArrangedSubview:checkoutATH atIndex:0];
    

    NSLayoutConstraint *height = [NSLayoutConstraint
                                  constraintWithItem:checkoutATH
                                  attribute:NSLayoutAttributeHeight
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:nil
                                  attribute:NSLayoutAttributeNotAnAttribute
                                  multiplier:0
                                  constant:48];
    
    [checkoutATH addConstraint:height];
}

-(ATHMPayment*)validateUserPrefWith:(ATHMPayment*) payment {

    if (!(userPref.taxIsOn && userPref.subTotalIsOn && userPref.itemsIsOn)) {
        return payment;
    }

    if (!userPref.taxIsOn) {
        return [[ATHMPayment alloc] initWithTotal:payment.total
                                         subtotal:payment.subtotal
                                              tax:nil
                                        metadata1:payment.metadata1
                                        metadata2:payment.metadata2
                                            items:payment.items
                                            error: nil];
    }

    if (!userPref.subTotalIsOn) {
    
        return [[ATHMPayment alloc] initWithTotal:payment.total
                                         subtotal:nil
                                              tax:payment.tax
                                        metadata1:payment.metadata1
                                        metadata2:payment.metadata2
                                            items:payment.items
                                            error: nil];
    }

    if (!userPref.itemsIsOn) {
        return [[ATHMPayment alloc] initWithTotal:payment.total
                                         subtotal:payment.subtotal
                                              tax:payment.tax
                                        metadata1:payment.metadata1
                                        metadata2:payment.metadata2
                                            items:payment.items
                                            error: nil];
    }

    return payment;
}

-(ATHMPayment*)getPaymentWith:(Transaction*) transaction {
    
    NSMutableArray *items = [[NSMutableArray alloc] init];

    for (TransactionItem *item in transaction.itemList) {
        ATHMPaymentItem *newElement = [[ATHMPaymentItem alloc] initWithDesc:item.desc
                                                                   name:item.name
                                                            priceNumber:((NSNumber *)item.price)
                                                               quantity:[item.quantity doubleValue]
                                                               metadata:nil
                                                                  error:nil];
        [items addObject:newElement];
    }
    
    ATHMPayment *payment = [[ATHMPayment alloc] initWithTotal:[NSNumber numberWithDouble:[transaction.total floatValue]]
                                                     subtotal:[NSNumber numberWithDouble:[transaction.subTotal floatValue]]
                                                          tax:[NSNumber numberWithDouble:[transaction.tax floatValue]]
                                                    metadata1:@"metadata1"
                                                    metadata2:@"metadata2"
                                                        items:items
                                                        error:nil];
    return payment;
}

-(void)setupTableView {
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 120;
    tableView.sectionFooterHeight = UITableViewAutomaticDimension;
    tableView.estimatedSectionFooterHeight = 120;
    
    NSString *checkoutDefaultNibName = @"CheckoutDefaultTableViewCell";
    NSString *checkoutSummaryNibName = @"CheckoutSummaryTableViewCell";
    UINib *checkoutDefaultNib = [UINib nibWithNibName:checkoutDefaultNibName bundle:nil];
    UINib *checkoutSummaryNib = [UINib nibWithNibName: checkoutSummaryNibName bundle: nil];

    [tableView registerNib:checkoutDefaultNib forCellReuseIdentifier:CheckoutDefaultTableViewCell.reuseIdentifier];
    [tableView registerNib:checkoutSummaryNib forCellReuseIdentifier:CheckoutSummaryTableViewCell.reuseIdentifier];
}

-(void) setCheckoutButtonStyle {
    [checkoutButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [checkoutButton setTitle:@"Checkout" forState:UIControlStateNormal];
    checkoutButton.tintColor = [UIColor whiteColor];
    checkoutButton.backgroundColor = [UIColor blueColor];
    checkoutButton.layer.shadowColor = [UIColor colorWithRed:0 green: 0 blue: 0 alpha: 0.25].CGColor;
    checkoutButton.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    checkoutButton.layer.shadowOpacity = 1.0;
    checkoutButton.layer.shadowRadius = 2.0;
    checkoutButton.layer.masksToBounds = NO;
    checkoutButton.layer.cornerRadius = 4.0;
}

-(void)setupNavigationBar {
    UIImage *chevronIcon = [UIImage imageNamed: @"ic_chevron"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:chevronIcon style:UIBarButtonItemStylePlain target:self action:@selector(chevronIconPressed)];
    
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target: self action: @selector(editIconPressed)];

    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action: @selector(addIconPressed)];

    [self.navigationItem setRightBarButtonItems: @[addButtonItem, editButtonItem] animated: true];
}

-(void)chevronIconPressed { /* Not applies **/ }

-(void) addIconPressed {
    
    Transaction *newTransactionItem = [Transaction.dummyTransactionItemList objectAtIndex:interpolationIndex];
    interpolationIndex = interpolationIndex == 0 ? 1 : 0;
    [transaction.itemList addObject:newTransactionItem];

    unsigned long newRowIndex = transaction.itemList.count - 1;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    [self scrollToBottom];
    [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

-(void)scrollToBottom {
    dispatch_async(dispatch_get_main_queue(), ^(void){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.transaction.itemList.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

-(void)editIconPressed {
    CheckoutEditViewController *editViewController = CheckoutEditViewController.initFromStoryboard;

    editViewController.delegate = self;

    if (userPref) {
        editViewController.userPref = userPref;
    }

    [self.navigationController pushViewController:editViewController animated:YES];
}

-(void)presentTransactionConfirmationWith:(NSString*)title and:(NSString*)description {
    
    TransactionConfirmationViewController *confirmationViewController = TransactionConfirmationViewController.initFromStoryboard;

    confirmationViewController.iconImage = [UIImage
                                            imageNamed: @"ic_confirmed_blue"];
    confirmationViewController.primaryTitle = title;
    confirmationViewController.secondaryTitle = description;

    [self.navigationController presentViewController:confirmationViewController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return transaction.itemList.count;
}

- (UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = CheckoutDefaultTableViewCell.reuseIdentifier;
    CheckoutDefaultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    [cell setTransactionItem:[transaction.itemList objectAtIndex:indexPath.row]];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    NSString *reuseIdentifier = CheckoutSummaryTableViewCell.reuseIdentifier;
    CheckoutSummaryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    [cell configWith:transaction];
    return cell;
}

- (void)didUpdatePreferences:(UserPaymentPreferences *)pref {
    self.userPref = pref;
}

-(void) didUpdateQuantityatIndex:(UITableViewCell*)cell with:(NSString*)value {
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    TransactionItem *transItem = transaction.itemList[indexPath.row];
    transItem.quantity = value;
    [tableView reloadData];
}

- (void)onCancelledPaymentWithReferenceNumber:(NSString * _Nullable)referenceNumber
                                        total:(NSNumber * _Nonnull)total
                                          tax:(NSNumber * _Nullable)tax
                                     subtotal:(NSNumber * _Nullable)subtotal
                                    metadata1:(NSString * _Nullable)metadata1
                                    metadata2:(NSString * _Nullable)metadata2
                                        items:(NSArray<ATHMPaymentItem *> * _Nullable)items {
    
    NSString *title = @"Payment Canceled";
    NSString *message = @"Your payment has been canceled.";
    [self presentTransactionConfirmationWith:title and:message];
}

- (void)onCompletedPaymentWithReferenceNumber:(NSString * _Nullable)referenceNumber
                                        total:(NSNumber * _Nonnull)total
                                          tax:(NSNumber * _Nullable)tax
                                     subtotal:(NSNumber * _Nullable)subtotal
                                    metadata1:(NSString * _Nullable)metadata1
                                    metadata2:(NSString * _Nullable)metadata2
                                        items:(NSArray<ATHMPaymentItem *> * _Nullable)items {
    
    NSString *title = @"We've send you a confirmation email.";
    NSString *message = [NSString stringWithFormat:@"Your order has been processed transaction reference: %@", referenceNumber];
    [self presentTransactionConfirmationWith:title and:message];
}

- (void)onExpiredPaymentWithReferenceNumber:(NSString * _Nullable)referenceNumber
                                      total:(NSNumber * _Nonnull)total
                                        tax:(NSNumber * _Nullable)tax
                                   subtotal:(NSNumber * _Nullable)subtotal
                                  metadata1:(NSString * _Nullable)metadata1
                                  metadata2:(NSString * _Nullable)metadata2
                                      items:(NSArray<ATHMPaymentItem *> * _Nullable)items {
    
    NSString *errorCode = @"TimeOut";
    NSString *errorDescription = @"The transaction 'expireIn' time has been reached.";
    [self presentTransactionConfirmationWith:errorCode and:errorDescription];
}

@end


