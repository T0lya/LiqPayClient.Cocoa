//
//  ViewBalanceViewController.m
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "ViewBalanceViewController.h"
#import <LiqPayClient/LiqPayClient.h>
#import "UserSettings.h"

@interface ViewBalanceViewController ()

- (void)loadSettings;
- (void)saveSettings;
- (BOOL)checkInputData;

@end

@implementation ViewBalanceViewController

@synthesize merchantId;
@synthesize password;
@synthesize balances;

- (id)init {
    self = [super init];
    if (self != nil) {
        [self loadSettings];
    }
    
    return self;
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
    
    return YES;
}

- (IBAction)refreshBalance:(id)sender {
    if ([self checkInputData]) {
        MGLiqPayClient *liqpayClient = [[MGLiqPayClient alloc] initWithMerchantId:self.merchantId 
                                                               sendMoneySignature:nil 
                                                         otherOperationsSignature:self.password];
        @try {
            NSDictionary *balance = [liqpayClient viewBalance];
            NSMutableString *balanceInfo = [[NSMutableString alloc] init];
            for (NSString *key in [balance allKeys]) {
                [balanceInfo appendFormat:@"%@\t=%@\n", key, [balance valueForKey:key]];
            }
            self.balances = balanceInfo;
            [balanceInfo release];
            [self saveSettings];
        }
        @catch (NSException * e) {
            NSRunAlertPanel(@"LiqPay", @"Get balance information failed with error: %@", @"OK", nil, nil, [e description]);
        }
        @finally {
            [liqpayClient release];
        }
    }
}

@end
