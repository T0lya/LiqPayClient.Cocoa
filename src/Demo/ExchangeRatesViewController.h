//
//  ExchangeRatesViewController.h
//  Demo
//
//  Created by Tolya on 03.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ExchangeRatesViewController : NSObject {
    NSString *ratesInfo;
}

@property (copy) NSString *ratesInfo;

- (IBAction)refreshRates:(id)sender;

@end
