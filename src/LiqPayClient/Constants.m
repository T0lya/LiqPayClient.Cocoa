//
//  Constants.m
//  LiqPayClient
//
//  Created by Tolya on 02.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "Constants.h"


// LiqPay actions
NSString * const MGSendMoneyLiqPayAction        = @"send_money";
NSString * const MGViewBalanceLiqPayAction        = @"view_balance";
NSString * const MGPhoneCreditLiqPayAction        = @"phone_credit";
NSString * const MGViewTransactionLiqPayAction    = @"view_transaction";

// Action statuses
NSString * const MGSuccessLiqPayStatus            = @"success";
NSString * const MGFailureLiqPayStatus            = @"failure";

// Transfer kinds
NSString * const MGPhoneLiqPayTransferType        = @"phone";
NSString * const MGCardLiqPayTransferType        = @"card";

// Currencies
NSString * const MGUAHLiqPayCurrency            = @"UAH";
NSString * const MGEURLiqPayCurrency            = @"EUR";
NSString * const MGUSDLiqPayCurrency            = @"USD";
NSString * const MGRURLiqPayCurrency            = @"RUR";

// Error codes
NSString * const MGLiqPayResponseNotFound       = @"response_not_found";
NSString * const MGLiqPaySignatureError         = @"signature_error";
NSString * const MGLiqPayTooManyResponses       = @"too_many_responses";
NSString * const MGLiqPayUnknownAction          = @"unknown_action";
NSString * const MGLiqPayResponseIsNotWellFormed= @"response_is_not_well_formed";

// Exceptions
NSString * const MGLiqPayExceptionName            = @"liqpay exception";
NSString * const MGLiqPayExceptionErrorKey        = @"error";
NSString * const MGLiqPayResponseDescriptionKey    = @"response_description";
NSString * const MGLiqPayResponseTextKey        = @"response_text";