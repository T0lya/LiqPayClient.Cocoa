//
//  Response.m
//  LiqPayClient
//
//  Created by Tolya on 08.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "Response.h"
#import "Constants.h"
#import "LiqPayConstants.h"
#import "Classes.h"
#import "Categories.h"
#import "Parsers.h"

@implementation MGLiqPayResponse

@synthesize apiVersion;
@synthesize responseText;
@synthesize status;
@synthesize code;
@synthesize responseDescription;
@synthesize action;

- (void)dealloc {
    [self setApiVersion:nil];
    [self setResponseText:nil];
    [self setStatus:nil];
    [self setCode:nil];
    [self setResponseDescription:nil];
    [self setAction:nil];
    
    [super dealloc];
}

+ (id)responseFromXml:(NSString *)anOperationXml {
    MGLiqPayResponse *response = nil;
    NSError *error = nil;
    XmlParser *responseParser = [[[XmlParser alloc] init] autorelease];
    @try {
        NSDictionary *nodeValues = [responseParser dictionaryFromXmlString:anOperationXml
                                                                     error:&error];
        if (nodeValues) {
            NSString *action = [nodeValues valueForKey:RESPONSE_ACTION_KEY];
            if ([action isEqualToString:MGSendMoneyLiqPayAction]) {
                response = [MGLiqPaySendMoneyResponse responseFromNodeValues:nodeValues];
            } else if ([action isEqualToString:MGViewBalanceLiqPayAction]) {
                response = [MGLiqPayViewBalanceResponse responseFromNodeValues:nodeValues];
            } else if ([action isEqualToString:MGViewTransactionLiqPayAction]) {
                response = [MGLiqPayViewTransactionResponse responseFromNodeValues:nodeValues];
            } else if ([action isEqualToString:MGPhoneCreditLiqPayAction]) {
                response = [MGLiqPayPhoneCreditResponse responseFromNodeValues:nodeValues];
            } else {
                NSString *reason = [NSString stringWithFormat:@"Unknown LiqPay action: '%@'", action];
                @throw [NSException exceptionWithName:MGLiqPayExceptionName 
                                               reason:reason
                                             userInfo:nil];
            }
            response.action = action;
            response.apiVersion = [nodeValues valueForKey:RESPONSE_VERSION_KEY];
            response.status = [nodeValues valueForKey:RESPONSE_STATUS_KEY];
            if (![response isSuccess]) {
                response.code = [nodeValues valueForKey:RESPONSE_CODE_KEY];
                response.responseDescription = [nodeValues valueForKey:RESPONSE_RESP_DESCRIPTION_KEY];
            }
        } else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException 
                                           reason:@"XML is not well formed." 
                                         userInfo:nil];
        }
    }
    @catch (NSException * e) {
        response = [[[MGLiqPayInvalidResponse alloc] init] autorelease];
        response.responseDescription = [e reason];
    }
    response.responseText = anOperationXml;
    
    return response;
}

+ (id)responseFromNodeValues:(NSDictionary *)aNodeValues {
    return nil;
}

- (BOOL)isSuccess {
    NSComparisonResult compareResult = [self.status caseInsensitiveCompare:MGSuccessLiqPayStatus];
    
    return compareResult == NSOrderedSame;
}

@end


@implementation MGLiqPayInvalidResponse

+ (id)responseWithErrorCode:(NSString *)anErrorCode 
                description:(NSString *)aDescription 
               responseText:(NSString *)aResponseText {
    id newResponse = [[self alloc] initWithErrorCode:anErrorCode 
                                         description:aDescription 
                                        responseText:aResponseText];
    
    return [newResponse autorelease];
}

- (id)initWithErrorCode:(NSString *)anErrorCode 
            description:(NSString *)aDescription 
           responseText:(NSString *)aResponseText {
    self = [super init];
    if (self) {
        self.code = anErrorCode;
        self.responseDescription = aDescription;
        self.responseText = aResponseText;
    }
    
    return self;
}

- (BOOL)isSuccess {
    return NO;
}

@end


@implementation MGLiqPaySendMoneyResponse

@synthesize merchantId;
@synthesize kind;
@synthesize orderId;
@synthesize to;
@synthesize amount;
@synthesize currency;
@synthesize description;
@synthesize transactionId;

- (void)dealloc {
    [self setMerchantId:nil];
    [self setKind:nil];
    [self setOrderId:nil];
    [self setTo:nil];
    [self setCurrency:nil];
    [self setDescription:nil];
    [self setTransactionId:nil];
    
    [super dealloc];
}

+ (id)responseFromNodeValues:(NSDictionary *)aNodeValues {
    MGLiqPaySendMoneyResponse *response = [[[self alloc] init] autorelease];
    response.kind = [aNodeValues valueForKey:RESPONSE_KIND_KEY];
    response.merchantId = [aNodeValues valueForKey:RESPONSE_MERCHANT_ID_KEY];
    response.orderId = [aNodeValues valueForKey:RESPONSE_ORDER_ID_KEY];
    response.to = [aNodeValues valueForKey:RESPONSE_TO_KEY];
    response.amount = [[aNodeValues valueForKey:RESPONSE_AMOUNT_KEY] doubleValue];
    response.currency = [aNodeValues valueForKey:RESPONSE_CURRENCY_KEY];
    response.description = [aNodeValues valueForKey:RESPONSE_DESCRIPTION_KEY];
    response.transactionId = [aNodeValues valueForKey:RESPONSE_TRANSACTION_ID_KEY];
    
    return response;
}

@end


@implementation MGLiqPayViewBalanceResponse

@synthesize merchantId;
@synthesize balance;


- (void)dealloc {
    [self setMerchantId:nil];
    [self setBalance:nil];
    
    [super dealloc];
}

+ (id)responseFromNodeValues:(NSDictionary *)aNodeValues {
    MGLiqPayViewBalanceResponse *viewBalanceResponse = [[[self alloc] init] autorelease];
    NSMutableDictionary *balance = [NSMutableDictionary dictionary];
    for (NSString *key in [aNodeValues allKeys]) {
        if ([key isEqualToString:RESPONSE_MERCHANT_ID_KEY])
            viewBalanceResponse.merchantId = [aNodeValues valueForKey:key];
        else if ([key hasPrefix:RESPONSE_BALANCES_KEY]) {
            [balance setValue:[aNodeValues valueForKey:key] 
                       forKey:[key lastPathComponent]];
        }
    }
    viewBalanceResponse.balance = balance;
    
    return viewBalanceResponse;
}

@end


@implementation MGLiqPayViewTransactionResponse

@synthesize merchantId;
@synthesize transaction;

- (void)dealloc {
    [self setMerchantId:nil];
    [self setTransaction:nil];
    
    [super dealloc];
}

+ (id)responseFromNodeValues:(NSDictionary *)aNodeValues {
    MGLiqPayViewTransactionResponse *response = [[[self alloc] init] autorelease];
    response.merchantId = [aNodeValues valueForKey:RESPONSE_MERCHANT_ID_KEY];
    MGLiqPayTransaction *transaction = [MGLiqPayTransaction new];
    transaction.transactionId = [aNodeValues valueForKey:TRANSACTION_TRANS_ID_KEY];
    transaction.orderId = [aNodeValues valueForKey:TRANSACTION_ORDER_ID_KEY];
    transaction.amount = [[aNodeValues valueForKey:TRANSACTION_AMOUNT_KEY] doubleValue];
    transaction.currency = [aNodeValues valueForKey:TRANSACTION_CURRENCY_KEY];
    transaction.description = [aNodeValues valueForKey:TRANSACTION_DESCRIPTION_KEY];
    transaction.from = [aNodeValues valueForKey:TRANSACTION_DESCRIPTION_KEY];
    transaction.to = [aNodeValues valueForKey:TRANSACTION_TO_KEY];
    transaction.refererAddress = [aNodeValues valueForKey:TRANSACTION_REFERER_URL_KEY];
    response.transaction = transaction;
    
    return response;
}

@end


@implementation MGLiqPayPhoneCreditResponse

@synthesize merchantId;
@synthesize amount;
@synthesize currency;
@synthesize phone;
@synthesize orderId;

- (void)dealloc {
    [self setMerchantId:nil];
    [self setCurrency:nil];
    [self setPhone:nil];
    [self setOrderId:nil];
    
    [super dealloc];
}

+ (id)responseFromNodeValues:(NSDictionary *)aNodeValues {
    MGLiqPayPhoneCreditResponse *response = [[[self alloc] init] autorelease];
    response.merchantId = [aNodeValues valueForKey:RESPONSE_MERCHANT_ID_KEY];
    response.amount = [[aNodeValues valueForKey:RESPONSE_AMOUNT_KEY] doubleValue];
    response.currency = [aNodeValues valueForKey:RESPONSE_CURRENCY_KEY];
    response.phone = [aNodeValues valueForKey:RESPONSE_PHONE_KEY];
    response.orderId = [aNodeValues valueForKey:RESPONSE_ORDER_ID_KEY];
    
    return response;
}

@end