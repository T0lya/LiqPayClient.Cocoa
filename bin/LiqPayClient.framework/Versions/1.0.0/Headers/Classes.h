//
//  Classes.h
//  LiqPayClient
//
//  Created by Tolya on 02.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 * Represents transaction information
 */
@interface MGLiqPayTransaction : NSObject {
@private
    NSString *transactionId;
    NSString *orderId;
    double    amount;
    NSString *currency;
    NSString *description;
    NSString *from;
    NSString *to;
    NSString *refererAddress;
}

//! Get/Set transaction identifier.
@property(copy) NSString * transactionId;

//! Get/Set order identifier.
@property(copy) NSString * orderId;

//! Get/Set amount value.
@property double amount;

//! Get/Set currency name.
@property(copy) NSString *currency;

//! Get/Set operation description.
@property(copy) NSString *description;

//! Get/Set sender merchant information (card or phone number).
@property(copy) NSString *from;

//! Get/Set payee merchant information.
@property(copy) NSString *to;

//! Get/Set referer url address.
@property(copy) NSString *refererAddress;

@end


/**
 * Provides common methods to work with LiqPay exchange service.
 */
@interface MGLiqPayExchange : NSObject {
    
}

/** 
 * Retrieves exchanges rates from the server.
 * @return A dictionary of exchange rates where key is currency and value is a dictionary of currency and rate.
 */
+ (NSDictionary *)getExchangeRates;

/**
 * Get list of known currency names.
 * @return Array of string values representing known currency names.
 */
+ (NSArray *)knownCurrencyNames;

@end


/**
 * Provides common methods to work with signature.
 */
@interface MGLiqPaySignatureProvider : NSObject {
    NSString *password;
}

/** 
 * Initializes a new instance of MGLiqPaySignatureProvider class with merchant password.
 * @param aPassword Merchant password.
 */
+ (id)signatureProviderWithPassword:(NSString *)aPassword;

/** 
 * Initializes a new instance of MGLiqPaySignatureProvider class with merchant password.
 * @param aPassword Merchant password.
 */
- (id)initWithPassword:(NSString *)aPassword;

/**
 * Generates signature for specified string.
 * @param aData String value to generate signature for.
 */
- (NSString *)generateSignatureForString:(NSString *)aData;

@end