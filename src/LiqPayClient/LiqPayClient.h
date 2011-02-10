//
//  LiqPayClient.h
//  LiqPayClient
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MGLiqPayTransaction;

/**
 * Provides common methods to work with LiqPay service.
 */
@interface MGLiqPayClient : NSObject {
    NSString *merchantId;
    NSString *sendMoneySign;
    NSString *otherOperationsSign;
}

//! Get/Set merchant identifier.
@property (copy) NSString *merchantId;

//! Get/Set merchant password for send money operation.
@property (copy) NSString *sendMoneySign;

//! Get/Set merchant password for operations other than send money.
@property (copy) NSString *otherOperationsSign;

/**
 * Initializes new instance of MGLiqPayClient.
 * @param aMerchantId Merchant identifier.
 * @param aSendMoneySign Merchant password for send money operation.
 * @param anOtherOperationsSign Merchant password for other operations.
 */
- (id)initWithMerchantId:(NSString *)aMerchantId 
      sendMoneySignature:(NSString *)aSendMoneySign 
otherOperationsSignature:(NSString *)anOtherOperationsSign;

/**
 * Gets merchant's balance information.
 * @return NSDictionary containing balance information.
 */
- (NSDictionary *)viewBalance;

/**
 * Transfers money.
 * @param aTo Payee information (card/phone number).
 * @param aCurrency Currency name.
 * @param aKind Transfer kind.
 * @param aDescription Operation description.
 * @param anOrderId Order identifier.
 * @return Transaction identifier.
 */
- (NSString *)sendMoneyTo:(NSString *)aTo 
                   amount:(double)anAmount 
                 currency:(NSString *)aCurrency 
        usingTransferKind:(NSString *)aKind 
          withDescription:(NSString *)aDescription 
                  orderId:(NSString *)anOrderId;

/**
 * Get transaction information by transaction identifier.
 * @param aTransactionId Transaction identifier.
 * @return MGLiqPayTransaction object containing transaction information.
 */
- (MGLiqPayTransaction *)viewTransactionByTransactionId:(NSString *)aTransactionId;

/**
 * Get transaction information by order identifier.
 * @param anOrderId Order identifier.
 * @return MGLiqPayTransaction object containing transaction information.
 */
- (MGLiqPayTransaction *)viewTransactionByOrderId:(NSString *)anOrderId;

/**
 * Credit phone.
 * @param aPhone Phone number to credit.
 * @param anAmount Amount value to credit.
 * @param aCurrency Currency name.
 * @param anOrderId Order identifier.
 */
- (void)creditPhone:(NSString *)aPhone 
             amount:(double)anAmount 
           currency:(NSString *)aCurrency 
            orderId:(NSString *)anOrderId;

@end
