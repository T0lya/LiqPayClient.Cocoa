//
//  SendMoneyViewConroller.m
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "SendMoneyViewConroller.h"
#import <LiqPayClient/Classes.h>
#import <LiqPayClient/LiqPayClient.h>
#import "UserSettings.h"

@interface SendMoneyViewConroller ()

- (void)loadSettings;
- (void)saveSettings;
- (BOOL)checkInputData;

@end

@implementation SendMoneyViewConroller

@synthesize merchantId;
@synthesize password;
@synthesize kind;
@synthesize to;
@synthesize amount;
@synthesize currency;
@synthesize orderId;
@synthesize description;
@synthesize transactionId;
@synthesize knownCurrencies;

- (id)init {
    self = [super init];
    if (self != nil) {
        [self loadSettings];
        knownCurrencies = [[NSArray alloc] initWithArray:[MGLiqPayExchange knownCurrencyNames]];
        self.kind = @"phone";
    }
    
    return self;
}

- (void)dealloc {
    [self setMerchantId:nil];
    [self setPassword:nil];
    [self setKind:nil];
    [self setTo:nil];
    [self setCurrency:nil];
    [self setOrderId:nil];
    [self setDescription:nil];
    [self setTransactionId:nil];
    
    [super dealloc];
}

- (void)loadSettings {
    UserSettings *settings = [UserSettings sharedSettings];
    self.merchantId = [settings merchantId];
    self.password = [settings sendMoneySignature];        
}

- (void)saveSettings {
    UserSettings *settings = [UserSettings sharedSettings];
    [settings setMerchantId:self.merchantId];
    [settings setSendMoneySignature:self.password];
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
    if ([self.to length] == 0) {
        [infoForm selectTextAtIndex:[toFormCell tag]];
        NSRunAlertPanel(@"Incorrect input data", @"To field is missing.", @"OK", nil, nil);
        
        return NO;
    }
    if (self.amount == 0.0) {
        [infoForm selectTextAtIndex:[amountFormCell tag]];
        NSRunAlertPanel(@"Incorrect input data", @"Incorrect amount value. Amount must be greater than zero.", @"OK", nil, nil);
        
        return NO;
    }
    if ([self.currency length] == 0) {
        [window makeFirstResponder:currencyComboBox];
        NSRunAlertPanel(@"Incorrect input data", @"Currency is missing.", @"OK", nil, nil);
        
        return NO;
    }
    
    return YES;
}

- (IBAction)sendMoney:(id)sender {
    if ([self checkInputData]) {
        MGLiqPayClient *liqpayClient = [[MGLiqPayClient alloc] initWithMerchantId:self.merchantId 
                                                               sendMoneySignature:self.password 
                                                         otherOperationsSignature:nil];
        @try {
            self.transactionId = [liqpayClient sendMoneyTo:self.to 
                                                    amount:self.amount 
                                                  currency:self.currency 
                                         usingTransferKind:self.kind 
                                           withDescription:self.description 
                                                   orderId:self.orderId];
            [self saveSettings];
        }
        @catch (NSException * e) {
            NSRunAlertPanel(@"LiqPay", @"Send money failed with error: %@", @"OK", nil, nil, [e description]);
        }
        @finally {
            [liqpayClient release];
        }
    }
}


@end
