//
//  UserSettings.m
//  Demo
//
//  Created by Tolya on 10.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "UserSettings.h"

#define MERCHANT_ID_KEY                    @"merchantId"
#define SEND_MONEY_SIGNATURE_KEY        @"sendMoneySignature"
#define OTHER_OPERATIONS_SIGNATURE_KEY    @"otherOperationsSignature"

@implementation UserSettings

static UserSettings *sharedSettings = nil;

- (id)init {
    if (sharedSettings) {
        [self release];
        self = nil;
    } else {
        self = [super init];
        if (self) {
            NSBundle * bundle = [NSBundle bundleForClass:[self class]];
            domainName = [bundle bundleIdentifier];
            NSDictionary *persistentDomain = [[NSUserDefaults standardUserDefaults] persistentDomainForName:domainName];
            if (persistentDomain)
                settings = [[NSMutableDictionary alloc] initWithDictionary:persistentDomain];
            else
                settings = [NSMutableDictionary new];
        }
    }
    
    return self;
}

- (void)dealloc {
    if (self != sharedSettings)
        [super dealloc];
}

+ (id)sharedSettings {
    if (!sharedSettings)
        sharedSettings = [[[self class] alloc] init];
    
    return sharedSettings;
}

- (NSString *)merchantId {
    return [settings valueForKey:MERCHANT_ID_KEY];
}

- (void)setMerchantId:(NSString *)aMerchantId {
    [settings setValue:aMerchantId forKey:MERCHANT_ID_KEY];
}

- (NSString *)sendMoneySignature {
    return [settings valueForKey:SEND_MONEY_SIGNATURE_KEY];
}

- (void)setSendMoneySignature:(NSString *)aSignature {
    [settings setValue:aSignature forKey:SEND_MONEY_SIGNATURE_KEY];
}

- (NSString *)otherOperationsSignature {
    return [settings valueForKey:OTHER_OPERATIONS_SIGNATURE_KEY];
}

- (void)setOtherOperationsSignature:(NSString *)aSignature {
    [settings setValue:aSignature forKey:OTHER_OPERATIONS_SIGNATURE_KEY];
}

- (void)save {
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:settings forName:domainName];
}

@end
