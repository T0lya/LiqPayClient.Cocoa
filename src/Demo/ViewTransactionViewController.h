//
//  ViewTransactionViewController.h
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MGLiqPayTransaction;

@interface ViewTransactionViewController : NSObject {
    IBOutlet NSForm *merchantForm;
    IBOutlet NSFormCell *merchantIdFormCell;
    IBOutlet NSFormCell *passwordFormCell;
    IBOutlet NSFormCell *orderIdFormCell;
    NSString *merchantId;
    NSString *password;
    NSString *viewTransactionId;
    NSString *viewOrderId;
    MGLiqPayTransaction *transaction;
}

@property (copy) NSString *merchantId;
@property (copy) NSString *password;
@property (copy) NSString *viewTransactionId;
@property (copy) NSString *viewOrderId;
@property (retain) MGLiqPayTransaction *transaction;

- (IBAction)viewTransaction:(id)sender;

@end
