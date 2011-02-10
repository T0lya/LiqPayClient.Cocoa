//
//  ViewBalanceViewController.h
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface ViewBalanceViewController : NSObject {
    IBOutlet NSForm *merchantForm;
    IBOutlet NSFormCell *merchantIdFormCell;
    IBOutlet NSFormCell *passwordFormCell;
    NSString *merchantId;
    NSString *password;
    NSString *balances;
}

@property (copy) NSString *merchantId;
@property (copy) NSString *password;
@property (copy) NSString *balances;

- (IBAction)refreshBalance:(id)sender;

@end
