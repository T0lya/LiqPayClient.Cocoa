//
//  ClickNBuyViewController.m
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "ClickNBuyViewController.h"
#import <LiqPayClient/Classes.h>
#import <LiqPayClient/ClickNBuy.h>
#import "UserSettings.h"

@interface ClickNBuyViewController ()

- (void)loadSettings;
- (void)saveSettings;
- (BOOL)checkInputData;

@end

@implementation ClickNBuyViewController

@synthesize clicknbuy;
@synthesize password;
@synthesize resultUrl;
@synthesize serverUrl;
@synthesize generatedHtml;
@synthesize knownCurrencies;

- (id)init {
    self = [super init];
    if (self != nil) {
        clicknbuy = [[MGLiqPayClickNBuy alloc] init];
        knownCurrencies = [NSArray arrayWithArray:[MGLiqPayExchange knownCurrencyNames]];
        self.clicknbuy.payWay = @"liqpay";
        
        [self loadSettings];
    }
    return self;
}

- (void)dealloc {
    [self setClicknbuy:nil];
    [self setPassword:nil];
    [self setResultUrl:nil];
    [self setServerUrl:nil];
    [self setGeneratedHtml:nil];
    [self setKnownCurrencies:nil];
    
    [super dealloc];
}

- (void)loadSettings {
    UserSettings *settings = [UserSettings sharedSettings];
    self.clicknbuy.merchantId = [settings merchantId];
    self.password = [settings otherOperationsSignature];        
}

- (void)saveSettings {
    UserSettings *settings = [UserSettings sharedSettings];
    [settings setMerchantId:self.clicknbuy.merchantId];
    [settings setOtherOperationsSignature:self.password];
    [settings save];
}

- (BOOL)checkInputData {
    if ([self.clicknbuy.merchantId length] == 0) {
        [mainParamsForm selectTextAtIndex:[merchantIdFormCell tag]];
        NSRunAlertPanel(@"Incorrect input data", @"Merchant identifier is missing.", @"OK", nil, nil);
        
        return NO;
    }
    if ([self.password length] == 0) {
        [mainParamsForm selectTextAtIndex:[passwordFormCell tag]];
        NSRunAlertPanel(@"Incorrect input data", @"Merchant password is missing.", @"OK", nil, nil);
        
        return NO;
    }
    if ([self.resultUrl length] > 0) {
        self.clicknbuy.resultUrl = [NSURL URLWithString:self.resultUrl];
        BOOL isValidUrl = self.clicknbuy.resultUrl != nil;
        if (self.clicknbuy.resultUrl) {
            NSString *scheme = [self.clicknbuy.resultUrl scheme];
            isValidUrl = scheme &&
                         (([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame) || 
                          ([scheme caseInsensitiveCompare:@"https"] == NSOrderedSame));
        }
        if (!isValidUrl) {
            [mainParamsForm selectTextAtIndex:[resultUrlFormCell tag]];
            NSRunAlertPanel(@"Incorrect input data", @"Invalid result URL.", @"OK", nil, nil);
            
            return NO;
        }
    } else {
        self.clicknbuy.resultUrl = nil;
    }
    if ([self.serverUrl length] > 0) {
        self.clicknbuy.serverUrl = [NSURL URLWithString:self.serverUrl];
        BOOL isValidUrl = self.clicknbuy.serverUrl != nil;
        if (self.clicknbuy.serverUrl) {
            NSString *scheme = [self.clicknbuy.serverUrl scheme];
            isValidUrl = scheme &&
            (([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame) || 
             ([scheme caseInsensitiveCompare:@"https"] == NSOrderedSame));
        }
        if (!isValidUrl) {
            [mainParamsForm selectTextAtIndex:[serverUrlFormCell tag]];
            NSRunAlertPanel(@"Incorrect input data", @"Invalid server URL.", @"OK", nil, nil);
            
            return NO;
        }
    } else {
        self.clicknbuy.serverUrl = nil;
    }
    if (self.clicknbuy.amount == 0.0) {
        [mainParamsForm selectTextAtIndex:[amountFormCell tag]];
        NSRunAlertPanel(@"Incorrect input data", @"Incorrect amount value. Amount must be greater than zero.", @"OK", nil, nil);
        
        return NO;
    }
    if ([clicknbuy.currency length] == 0) {
        [window makeFirstResponder:currencyComboBox];
        NSRunAlertPanel(@"Incorrect input data", @"Currency is missing.", @"OK", nil, nil);
        
        return NO;
    }
    
    return YES;
}

- (IBAction)generateHtml:(id)sender {
    self.generatedHtml = nil;
    
    if ([self checkInputData]) {
        MGLiqPaySignatureProvider *signatureProvider = [MGLiqPaySignatureProvider signatureProviderWithPassword:self.password];
        self.generatedHtml = [self.clicknbuy htmlStringWithSubmitButtonValue:@"Pay" 
                                                      signatureProvider:signatureProvider];
        [self saveSettings];
    }
}

@end
