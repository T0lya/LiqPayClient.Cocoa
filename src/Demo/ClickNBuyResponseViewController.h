//
//  ClickNBuyResponseViewController.h
//  Demo
//
//  Created by Tolya on 16.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MGLiqPayClickNBuyResponse;

@interface ClickNBuyResponseViewController : NSObject {
    IBOutlet NSWindow *window;
    IBOutlet NSForm *merchantForm;
    IBOutlet NSFormCell *merchantIdFormCell;
    IBOutlet NSFormCell *passwordFormCell;
    IBOutlet NSTextView *responseTextView;
    IBOutlet NSTextField *responseSignatureTextField;
    NSString *merchantId;
    NSString *password;
    NSString *responseSignature;
    NSAttributedString *responseString;
    MGLiqPayClickNBuyResponse *clicknbuyResponse;
}

@property (copy) NSString *merchantId;
@property (copy) NSString *password;
@property (copy) NSString *responseSignature;
@property (copy) NSAttributedString *responseString;
@property (retain) MGLiqPayClickNBuyResponse *clicknbuyResponse;

- (IBAction)parse:(id)sender;

@end
