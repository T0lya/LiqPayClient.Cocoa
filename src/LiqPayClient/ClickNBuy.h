//
//  ClickNBuy.h
//  LiqPayClient
//
//  Created by Tolya on 14.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MGLiqPaySignatureProvider;

/**
 * Provides common methods to generate code ready to insert into html page
 * to add click & buy functionality.
 */
@interface MGLiqPayClickNBuy : NSObject {
    NSString *merchantId;
    NSURL *resultUrl;
    NSURL *serverUrl;
    NSString *orderId;
    double amount;
    NSString *currency;
    NSString *description;
    NSString *defaultPhone;
    NSString *payWay;
}

//! Get/Set merchant identifier.
@property (copy) NSString *merchantId;

//! Gets/Sets URL to redirect client to after payment completion.
@property (retain) NSURL *resultUrl;

//! Gets/Sets URL to send server response to.
@property (retain) NSURL *serverUrl;

//! Get/Set order identifier.
@property (copy) NSString *orderId;

//! Get/Set amount value.
@property (assign) double amount;

//! Get/Set currency name.
@property (copy) NSString *currency;

//! Get/Set operation description.
@property (copy) NSString *description;

//! Get/Set default phone number.
@property (copy) NSString *defaultPhone;

//! Get/Set payment method (liqpay, card, etc).
@property (copy) NSString *payWay;

/**
 * Get default html form name.
 * @return String containing default html form name.
 */
- (NSString *)DefaultFormName;

/**
 * Generates XML representation of click & buy api request.
 * @return String value containing click & buy request in XML format.
 */
- (NSString *)xmlString;

/**
 * Generates html code for click & buy operation.
 * @param aFormName Html form tag name.
 * @param aSubmitValue Submit button value.
 * @param aSignatureProvider Signature provider which will be used to generate signature.
 */
- (NSString *)htmlStringWithFormName:(NSString *)aFormName 
                    submitButtonValue:(NSString *)aSubmitValue 
                    signatureProvider:(MGLiqPaySignatureProvider *)aSignatureProvider;

/**
 * Generates html code for click & buy operation.
 * @param aSubmitValue Submit button value.
 * @param aSignatureProvider Signature provider which will be used to generate signature.
 */
- (NSString *)htmlStringWithSubmitButtonValue:(NSString *)aSubmitValue
                             signatureProvider:(MGLiqPaySignatureProvider *)aSignatureProvider;
@end


/**
 * Represents click & buy response.
 */
@interface MGLiqPayClickNBuyResponse : NSObject {
    NSString *apiVersion;
    NSString *action;
    NSString *merchantId;
    double amount;
    NSString *currency;
    NSString *description;
    NSString *orderId;
    NSString *payWay;
    NSString *senderPhone;
    NSString *status;
    NSString *transactionId;
}

//! LiqPay API version.
@property (copy) NSString *apiVersion;

//! LiqPay action name.
@property (copy) NSString *action;

//! Merchant identifier who sent the money.
@property (copy) NSString *merchantId;

//! Sent amount value.
@property (assign) double amount;

//! Sent currency name.
@property (copy) NSString *currency;

//! Operation description.
@property (copy) NSString *description;

//! Order identifier.
@property (copy) NSString *orderId;

//! Used pay way.
@property (copy) NSString *payWay;

//! Sender phone number.
@property (copy) NSString *senderPhone;

//! Operation status.
@property (copy) NSString *status;

//! Transaction identifier.
@property (copy) NSString *transactionId;

/**
 * Parses response XML and initializes new instance of MGLiqPayClickNBuyResponse.
 */
+ (id)responseFromXmlString:(NSString *)anXml;

/**
 * Parses response XML and initializes new instance of MGLiqPayClickNBuyResponse.
 */
- (id)initWithXmlString:(NSString *)anXml;

@end