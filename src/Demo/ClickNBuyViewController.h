//
//  ClickNBuyViewController.h
//  Demo
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class MGLiqPayClickNBuy;

@interface ClickNBuyViewController : NSObject {
    IBOutlet NSWindow *window;
    IBOutlet NSForm *mainParamsForm;
    IBOutlet NSFormCell *merchantIdFormCell;
    IBOutlet NSFormCell *passwordFormCell;
    IBOutlet NSFormCell *resultUrlFormCell;
    IBOutlet NSFormCell *serverUrlFormCell;
    IBOutlet NSFormCell *amountFormCell;
    IBOutlet NSComboBox *currencyComboBox;
    MGLiqPayClickNBuy *clicknbuy;
    NSString *password;
    NSString *resultUrl;
    NSString *serverUrl;
    NSString *generatedHtml;
    NSArray *knownCurrencies;
}

@property (retain) MGLiqPayClickNBuy *clicknbuy;
@property (copy) NSString *password;
@property (copy) NSString *resultUrl;
@property (copy) NSString *serverUrl;
@property (copy) NSString *generatedHtml;
@property (copy) NSArray *knownCurrencies;

- (IBAction)generateHtml:(id)sender;

@end
