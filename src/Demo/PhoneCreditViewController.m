//
//  PhoneCreditViewController.m
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "PhoneCreditViewController.h"
#import <LiqpayClient/LiqPayClient.h>
#import <LiqPayClient/Classes.h>
#import "UserSettings.h"

@interface PhoneCreditViewController ()

- (void)loadSettings;
- (void)saveSettings;

@end

@implementation PhoneCreditViewController

@synthesize merchantId;
@synthesize password;
@synthesize phone;
@synthesize amount;
@synthesize currency;
@synthesize orderId;
@synthesize knownCurrencies;

- (id)init {
    self = [super init];
    if (self != nil) {
        knownCurrencies = [NSArray arrayWithArray:[MGLiqPayExchange knownCurrencyNames]];
        [self loadSettings];
    }
    return self;
}

- (void)dealloc {
    [self setMerchantId:nil];
    [self setPassword:nil];
    [self setPhone:nil];
    [self setCurrency:nil];
    [self setOrderId:nil];
    [self setKnownCurrencies:nil];
    
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

- (IBAction)credit:(id)sender {
    MGLiqPayClient *liqpayClient = [[MGLiqPayClient alloc] initWithMerchantId:self.merchantId 
                                                           sendMoneySignature:self.password
                                                     otherOperationsSignature:nil];
    @try {
        [liqpayClient creditPhone:self.phone
                           amount:self.amount 
                         currency:self.currency 
                          orderId:self.orderId];
        [self saveSettings];
    }
    @catch (NSException * e) {
        NSRunAlertPanel(@"LiqPay", @"Credit phone failed with error: %@", @"OK", nil, nil, [e description]);
    }
    @finally {
        [liqpayClient release];
    }
}

@end
