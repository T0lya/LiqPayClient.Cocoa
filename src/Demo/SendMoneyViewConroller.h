//
//  SendMoneyViewConroller.h
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SendMoneyViewConroller : NSObject {
    IBOutlet NSWindow *window;
    IBOutlet NSForm *merchantForm;
    IBOutlet NSFormCell *merchantIdFormCell;
    IBOutlet NSFormCell *passwordFormCell;
    IBOutlet NSForm *infoForm;
    IBOutlet NSFormCell *toFormCell;
    IBOutlet NSFormCell *amountFormCell;
    IBOutlet NSComboBox *currencyComboBox;
    NSString *merchantId;
    NSString *password;
    NSString *kind;
    NSString *to;
    double amount;
    NSString *currency;
    NSString *orderId;
    NSString *description;
    NSString *transactionId;
    NSArray *knownCurrencies;
}

@property (copy) NSString *merchantId;
@property (copy) NSString *password;
@property (copy) NSString *kind;
@property (copy) NSString *to;
@property (assign) double amount;
@property (copy) NSString *currency;
@property (copy) NSString *orderId;
@property (copy) NSString *description;
@property (copy) NSString *transactionId;
@property (retain) NSArray *knownCurrencies;

- (IBAction)sendMoney:(id)sender;

@end
