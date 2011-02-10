//
//  ViewTransactionViewController.m
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "ViewTransactionViewController.h"
#import "UserSettings.h"
#import <LiqPayClient/LiqPayClient.h>
#import <LiqPayClient/Classes.h>


@interface ViewTransactionViewController ()

- (void)loadSettings;
- (void)saveSettings;
- (BOOL)checkInputData;

@end

@implementation ViewTransactionViewController

@synthesize merchantId;
@synthesize password;
@synthesize viewTransactionId;
@synthesize viewOrderId;
@synthesize transaction;

- (id)init {
    self = [super init];
    if (self != nil) {
        [self loadSettings];
    }
    
    return self;
}

- (void)dealloc {
    [self setMerchantId:nil];
    [self setPassword:nil];
    [self setViewTransactionId:nil];
    [self setViewOrderId:nil];
    [self setTransaction:nil];
    
    [super dealloc];
}

- (void)loadSettings {
    UserSettings *settings = [UserSettings sharedSettings];
    self.merchantId = [settings merchantId];
    self.password = [settings otherOperationsSignature];        
}

- (void)saveSettings {
    UserSettings *settings = [UserSettings sharedSettings];
    [settings setMerchantId:self.merchantId];
    [settings setOtherOperationsSignature:self.password];
    [settings save];
}

- (BOOL)checkInputData {
    if ([self.merchantId length] == 0) {
        [merchantForm selectTextAtIndex:[merchantIdFormCell tag]];
        NSRunAlertPanel(@"Incorrect input data", @"Merchant identifier is missing.", @"OK", nil, nil);
        
        return NO;
    }
    if ([self.password length] == 0) {
        [merchantForm selectTextAtIndex:[passwordFormCell tag]];
        NSRunAlertPanel(@"Incorrect input data", @"Merchant password is missing.", @"OK", nil, nil);
        
        return NO;
    }
    if ([self.viewOrderId length] == 0 && [self.viewTransactionId length] == 0) {
        [merchantForm selectTextAtIndex:[orderIdFormCell tag]];
        NSRunAlertPanel(@"Incorrect input data", @"Enter transaction or order identifier.", @"OK", nil, nil);
        
        return NO;
    }
    
    return YES;
}

- (IBAction)viewTransaction:(id)sender {
    if ([self checkInputData]) {
        MGLiqPayClient *liqpayClient = [[MGLiqPayClient alloc] initWithMerchantId:self.merchantId 
                                                               sendMoneySignature:nil
                                                         otherOperationsSignature:self.password];
        @try {
            if ([self.viewTransactionId length] == 0)
                self.transaction = [liqpayClient viewTransactionByOrderId:self.viewOrderId];
            else
                self.transaction = [liqpayClient viewTransactionByTransactionId:self.viewTransactionId];
            [self saveSettings];
            
        }
        @catch (NSException * e) {
            NSRunAlertPanel(@"LiqPay", @"View transaction failed with error: %@", @"OK", nil, nil, [e description]);
        }
        @finally {
            [liqpayClient release];
        }
    }
}

@end
