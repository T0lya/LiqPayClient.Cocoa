//
//  PhoneCreditViewController.h
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PhoneCreditViewController : NSObject {
    NSString *merchantId;
    NSString *password;
    NSString *phone;
    double amount;
    NSString *currency;
    NSString *orderId;
    NSArray *knownCurrencies;
}

@property (copy) NSString *merchantId;
@property (copy) NSString *password;
@property (copy) NSString *phone;
@property (assign) double amount;
@property (copy) NSString *currency;
@property (copy) NSString *orderId;
@property (copy) NSArray *knownCurrencies;

- (IBAction)credit:(id)sender;

@end
