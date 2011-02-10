//
//  UserSettings.h
//  Demo
//
//  Created by Tolya on 10.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UserSettings : NSObject {
    NSMutableDictionary *settings;
    NSString *domainName;
}

+ (id)sharedSettings;

- (NSString *)merchantId;
- (void)setMerchantId:(NSString *)aMerchantId;

- (NSString *)sendMoneySignature;
- (void)setSendMoneySignature:(NSString *)aSignature;

- (NSString *)otherOperationsSignature;
- (void)setOtherOperationsSignature:(NSString *)aSignature;

- (void)save;

@end
