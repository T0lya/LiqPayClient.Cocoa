//
//  Constants.h
//  LiqPayClient
//
//  Created by Tolya on 02.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Foundation/Foundation.h>


// LiqPay action names
// Represents send money operation name.
extern NSString * const MGSendMoneyLiqPayAction;

// Represents view merchant balance operation name.
extern NSString * const MGViewBalanceLiqPayAction;

// Represents credit phone operation name.
extern NSString * const MGPhoneCreditLiqPayAction;

// Represents view transaction operation name
extern NSString * const MGViewTransactionLiqPayAction;

// Action statuses
// Represents success status name.
extern NSString * const MGSuccessLiqPayStatus;

// Represents failure status name.
extern NSString * const MGFailureLiqPayStatus;

// Transfer type names
// Represents send money to merchant account transfer kind.
extern NSString * const MGPhoneLiqPayTransferType;

// Represents send money to VISA card transfer kind.
extern NSString * const MGCardLiqPayTransferType;


// Currency names
extern NSString * const MGUAHLiqPayCurrency;
extern NSString * const MGEURLiqPayCurrency;
extern NSString * const MGUSDLiqPayCurrency;
extern NSString * const MGRURLiqPayCurrency;

// LiqPay error codes
extern NSString * const MGLiqPayResponseNotFound;
extern NSString * const MGLiqPaySignatureError;
extern NSString * const MGLiqPayTooManyResponses;
extern NSString * const MGLiqPayUnknownAction;
extern NSString * const MGLiqPayResponseIsNotWellFormed;

// Exception 
extern NSString * const MGLiqPayExceptionName;
extern NSString * const MGLiqPayExceptionErrorKey;
extern NSString * const MGLiqPayResponseDescriptionKey;
extern NSString * const MGLiqPayResponseTextKey;