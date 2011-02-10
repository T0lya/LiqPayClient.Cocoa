//
//  ClickNBuyResponseViewController.m
//  Demo
//
//  Created by Tolya on 16.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "ClickNBuyResponseViewController.h"
#import "UserSettings.h"
#import <LiqPayClient/Classes.h>
#import <LiqPayClient/ClickNBuy.h>

@interface ClickNBuyResponseViewController ()

- (BOOL)checkInputData;
- (void)loadSettings;
- (void)saveSettings;

@end

@implementation ClickNBuyResponseViewController

@synthesize merchantId;
@synthesize password;
@synthesize responseSignature;
@synthesize responseString;
@synthesize clicknbuyResponse;

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
    [self setResponseSignature:nil];
    [self setResponseString:nil];
    [self setClicknbuyResponse:nil];
    
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
    if ([self.responseString length] == 0) {
        [window makeFirstResponder:responseTextView];
        NSRunAlertPanel(@"Incorrect input data", @"Response string is missing.", @"OK", nil, nil);
        
        return NO;
    }
    if ([self.responseSignature length] == 0) {
        [window makeFirstResponder:responseSignatureTextField];
        NSRunAlertPanel(@"Incorrect input data", @"Response signature is missing.", @"OK", nil, nil);
        
        return NO;
    }
    
    return YES;
}

- (IBAction)parse:(id)sender {
    self.clicknbuyResponse = nil;
    if ([self checkInputData]) {
        MGLiqPaySignatureProvider *signatureProvider = [MGLiqPaySignatureProvider signatureProviderWithPassword:self.password];
        NSString *generatedSignature = [signatureProvider generateSignatureForString:[self.responseString string]];
        if ([generatedSignature isEqualToString:self.responseSignature]) {
            @try {
                self.clicknbuyResponse = [MGLiqPayClickNBuyResponse responseFromXmlString:[self.responseString string]];
                [self saveSettings];
            }
            @catch (NSException *exception) {
                NSRunAlertPanel(@"Invalid click & buy response", [exception reason], @"OK", nil, nil);
            }
        } else {
            NSRunAlertPanel(@"Invalid click & buy response", @"Signatures do not match.", @"OK", nil, nil);
        }
    }
}

@end
