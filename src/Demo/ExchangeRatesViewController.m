//
//  ExchangeRatesViewController.m
//  Demo
//
//  Created by Tolya on 03.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "ExchangeRatesViewController.h"
#import <LiqPayClient/Classes.h>


@implementation ExchangeRatesViewController

@synthesize ratesInfo;

- (IBAction)refreshRates:(id)sender {
    @try {
        NSDictionary *exchangeRates = [MGLiqPayExchange getExchangeRates];
        NSMutableString *ratesText = [NSMutableString new];
        for (NSString *key in [exchangeRates allKeys]) {
            NSDictionary *rates = [exchangeRates valueForKey:key];
            for (NSString *currency in [rates allKeys]) {
                [ratesText appendFormat:@"1 %@ = %@ %@\n", 
                 key, 
                 [rates valueForKey:currency], 
                 currency];
            }
            [ratesText appendString:@"\n"];
        }
        self.ratesInfo = ratesText;
    }
    @catch (NSException * e) {
        NSRunAlertPanel(@"LiqPay", @"Get exchange rates failed with error: %@", @"OK", nil, nil, [e description]);
    }
}

@end
