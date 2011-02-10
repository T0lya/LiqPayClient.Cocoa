//
//  Response.h
//  LiqPayClient
//
//  Created by Tolya on 08.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGLiqPayTransaction;

/**
 * Represents LiqPay server response.
 */
@interface MGLiqPayResponse : NSObject {
    NSString *apiVersion;
    NSString *responseText;
    NSString *status;
    NSString *code;
    NSString *responseDescription;
    NSString *action;
}

//! API version used.
@property (copy) NSString *apiVersion;

//! Response text.
@property (copy) NSString *responseText;

//! Response status.
@property (copy) NSString *status;

//! Response code.
@property (copy) NSString *code;

//! Response description.
@property (copy) NSString *responseDescription;

//! Action name.
@property (copy) NSString *action;

/**
 * Initializes new instance of MGLiqPayResponse subclass with properties from operation XML
 * @param anOperationXml Operation XML string.
 * @return Instance of class derived from MGLiqPayResponse.
 */
+ (id)responseFromXml:(NSString *)anOperationXml;

/**
 * Must be overridden in derived claasses to return new instance of MGLiqPayResponse subclass
 * initialized with properties in node values dictionary.
 */
+ (id)responseFromNodeValues:(NSDictionary *)aNodeValues;

/**
 * Determines if operation processed successfully.
 * @return YES if operation processed successfully otherwise NO.
 */
- (BOOL)isSuccess;

@end


/**
 * Represents invalid response.
 */
@interface MGLiqPayInvalidResponse : MGLiqPayResponse {
    
}

/**
 * Initializes new instance of MGLiqPayInvalidResponse.
 * @param anErrorCode Error code of operation.
 * @param aDescription Detailed error description.
 * @param aResponseText Clear response text returned by server.
 */
+ (id)responseWithErrorCode:(NSString *)anErrorCode 
                description:(NSString *)aDescription 
               responseText:(NSString *)aResponseText;

/**
 * Initializes new instance of MGLiqPayInvalidResponse.
 * @param anErrorCode Error code of operation.
 * @param aDescription Detailed error description.
 * @param aResponseText Clear response text returned by server.
 */
- (id)initWithErrorCode:(NSString *)anErrorCode 
            description:(NSString *)aDescription 
           responseText:(NSString *)aResponseText;

@end


/**
 * Represents send money response.
 */
@interface MGLiqPaySendMoneyResponse : MGLiqPayResponse {
    NSString *merchantId;
    NSString *kind;
    NSString *orderId;
    NSString *to;
    double amount;
    NSString *currency;
    NSString *description;
    NSString *transactionId;
}

//! Get/Set merchant identifier.
@property (copy) NSString *merchantId;

//! Get/Set transfer kind.
@property (copy) NSString *kind;

//! Get/Set order identifier.
@property (copy) NSString *orderId;

//! Get/Set payee phone/card number.
@property (copy) NSString *to;

//! Get/Set transfered amount.
@property (assign) double amount;

//! Get/Set currency name.
@property (copy) NSString *currency;

//! Get/Set operation description.
@property (copy) NSString *description;

//! Get/Set transaction identifier.
@property (copy) NSString *transactionId;

@end


/**
 * Represents view balance response.
 */
@interface MGLiqPayViewBalanceResponse : MGLiqPayResponse {
    NSString *merchantId;
    NSDictionary *balance;
}

//! Get/Set merchant identifier.
@property (copy) NSString *merchantId;

//! Get/Set balance information.
@property (copy) NSDictionary *balance;

@end


/**
 * Represents view transaction response.
 */
@interface MGLiqPayViewTransactionResponse : MGLiqPayResponse {
    NSString *merchantId;
    MGLiqPayTransaction *transaction;
}

//! Get/Set merchant identifier.
@property (copy) NSString *merchantId;

//! Get/Set transaction information.
@property (retain) MGLiqPayTransaction *transaction;

@end


/**
 * Represents phone credit response.
 */
@interface MGLiqPayPhoneCreditResponse : MGLiqPayResponse {
    NSString *merchantId;
    double amount;
    NSString *currency;
    NSString *phone;
    NSString *orderId;
}

//! Get/Set merchant identifier.
@property (copy) NSString *merchantId;

//! Get/Set amount to credit.
@property (assign) double amount;

//! Get/Set currency name.
@property (copy) NSString *currency;

//! Get/Set phone number to credit.
@property (copy) NSString *phone;

//! Get/Set order identifier.
@property (copy) NSString *orderId;

@end