//
//  Operation.h
//  LiqPayClient
//
//  Created by Tolya on 08.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MGLiqPaySignatureProvider;

/**
 * Represent general LiqPay operation.
 */
@interface MGLiqPayOperation : NSObject {
    NSString *action;
}

//! Gets/Sets action name.
@property (copy) NSString *action;

/**
 * Initializes new instance of MGLiqPayOperation with action name.
 * @param anAction Action name.
 */
- (id)initWithAction:(NSString *)anAction;

/**
 * Get API version.
 * @return String containing used LiqPay API version.
 */
- (NSString *)apiVersion;

/**
 * Get XML representation of operation.
 * @return String containing XML representation of operation.
 */
- (NSString *)xmlString;

/**
 * Get XML representation of operation envelope.
 * @param aSignatureProvider MGLiqPaySignatureProvider object used to generate signature.
 * @return String containing operation envelope in XML format.
 */
- (NSString *)operationEnvelopeXmlStringUsingSignatureProvider:(MGLiqPaySignatureProvider *)aSignatureProvider;

@end


/**
 * Represents send money operation.
 */
@interface MGLiqPaySendMoneyOperation : MGLiqPayOperation {
    NSString *merchantId;
    NSString *kind;
    NSString *to;
    double amount;
    NSString *currency;
    NSString *description;
    NSString *orderId;
}

//! Get/Set merchant identifier.
@property (copy) NSString *merchantId;

//! Get/Set transfer kind.
@property (copy) NSString *kind;

//! Get/Set payee merchant phone/card number.
@property (copy) NSString *to;

//! Get/Set amount to send.
@property (assign) double amount;

//! Get/Set currency name.
@property (copy) NSString *currency;

//! Get/Set operation description.
@property (copy) NSString *description;

//! Get/Set order identifier.
@property (copy) NSString *orderId;

@end


/**
 * Represents view balance operation.
 */
@interface MGLiqPayViewBalanceOperation : MGLiqPayOperation {
    NSString *merchantId;
}

//! Merchant identifier.
@property (copy) NSString *merchantId;

/**
 * Initializes new instance of MGLiqPayViewBalanceOperation with merchant identifier.
 * @param aMerchantId Merchant identifier.
 */
- (id)initWithMerchantId:(NSString *)aMerchantId;

@end


/**
 * Represents view transaction operation.
 */
@interface MGLiqPayViewTransactionOperation : MGLiqPayOperation {
    NSString *merchantId;
    NSString *transactionId;
    NSString *transactionOrderId;
}

//! Merchant identifier.
@property (copy) NSString *merchantId;

//! Transaction identifier.
@property (copy) NSString *transactionId;

//! Order identifier.
@property (copy) NSString *transactionOrderId;

@end


/**
 * Represents phone credit operation.
 */
@interface MGLiqPayPhoneCreditOperation : MGLiqPayOperation {
    NSString *merchantId;
    double amount;
    NSString *currency;
    NSString *phone;
    NSString *orderId;
}

//! Merchant identifier.
@property (copy) NSString *merchantId;

//! Amount to credit.
@property (assign) double amount;

//! Currency name.
@property (copy) NSString *currency;

//! Phone number.
@property (copy) NSString *phone;

//! Order identifier.
@property (copy) NSString *orderId;

@end