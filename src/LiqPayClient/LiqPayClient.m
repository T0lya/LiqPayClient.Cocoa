//
//  LiqPayClient.m
//  LiqPayClient
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "LiqPayClient.h"
#import "Constants.h"
#import "Classes.h"
#import "Operation.h"
#import "Request.h"
#import "Response.h"

@interface MGLiqPayClient ()

- (MGLiqPayResponse *)processOperationAndReturnResponse:(MGLiqPayOperation *)anOperation;

@end

@implementation MGLiqPayClient

@synthesize merchantId;
@synthesize sendMoneySign;
@synthesize otherOperationsSign;

- (id)initWithMerchantId:(NSString *)aMerchantId 
      sendMoneySignature:(NSString *)aSendMoneySign 
otherOperationsSignature:(NSString *)anOtherOperationsSign {
    self = [super init];
    if (self) {
        self.merchantId = aMerchantId;
        self.sendMoneySign = aSendMoneySign;
        self.otherOperationsSign = anOtherOperationsSign;
    }
    
    return self;
}

- (void)dealloc {
    [self setMerchantId:nil];
    [self setSendMoneySign:nil];
    [self setOtherOperationsSign:nil];
    
    [super dealloc];
}

- (NSDictionary *)viewBalance {
    NSDictionary *balance;
    MGLiqPayViewBalanceOperation *operation = [[MGLiqPayViewBalanceOperation alloc] initWithMerchantId:self.merchantId];
    @try {
        MGLiqPayViewBalanceResponse *response = (MGLiqPayViewBalanceResponse *)[self processOperationAndReturnResponse:operation];
        balance = [[response.balance retain] autorelease];
    }
    @finally {
        [operation release];
    }
    
    return balance;
}

- (NSString *)sendMoneyTo:(NSString *)aTo 
                   amount:(double)anAmount 
                 currency:(NSString *)aCurrency 
        usingTransferKind:(NSString *)aKind 
          withDescription:(NSString *)aDescription 
                  orderId:(NSString *)anOrderId {
    NSString *transactionId = nil;
    MGLiqPaySendMoneyOperation *operation = [[MGLiqPaySendMoneyOperation alloc] init];
    operation.merchantId = self.merchantId;
    operation.amount = anAmount;
    operation.currency = aCurrency;
    operation.description = aDescription;
    operation.kind = aKind;
    operation.orderId = anOrderId;
    operation.to = aTo;
    @try {
        MGLiqPaySendMoneyResponse *response = (MGLiqPaySendMoneyResponse *)[self processOperationAndReturnResponse:operation];
        
        transactionId = response.transactionId;
    }
    @finally {
        [operation release];
    }
    
    return transactionId;
}

- (MGLiqPayTransaction *)viewTransactionByTransactionId:(NSString *)aTransactionId {
    MGLiqPayTransaction *transaction = nil;
    MGLiqPayViewTransactionOperation *operation = [[MGLiqPayViewTransactionOperation alloc] init];
    operation.merchantId = self.merchantId;
    operation.transactionId = aTransactionId;
    @try {
        MGLiqPayViewTransactionResponse *response = (MGLiqPayViewTransactionResponse *)[self processOperationAndReturnResponse:operation];
        
        transaction = response.transaction;
    }
    @finally {
        [operation release];
    }
    
    return transaction;
}

- (MGLiqPayTransaction *)viewTransactionByOrderId:(NSString *)anOrderId {
    MGLiqPayTransaction *transaction = nil;
    MGLiqPayViewTransactionOperation *operation = [[MGLiqPayViewTransactionOperation alloc] init];
    operation.merchantId = self.merchantId;
    operation.transactionOrderId = anOrderId;
    @try {
        MGLiqPayViewTransactionResponse *response = (MGLiqPayViewTransactionResponse *)[self processOperationAndReturnResponse:operation];
        
        transaction = response.transaction;
    }
    @finally {
        [operation release];
    }
    
    return transaction;
}

- (void)creditPhone:(NSString *)aPhone 
             amount:(double)anAmount 
           currency:(NSString *)aCurrency 
            orderId:(NSString *)anOrderId {
    MGLiqPayPhoneCreditOperation *operation = [[MGLiqPayPhoneCreditOperation alloc] init];
    operation.merchantId = self.merchantId;
    operation.phone = aPhone;
    operation.amount = anAmount;
    operation.currency = aCurrency;
    operation.orderId = anOrderId;
    @try {
        [self processOperationAndReturnResponse:operation];
    }
    @finally {
        [operation release];
    }
}

- (MGLiqPayResponse *)processOperationAndReturnResponse:(MGLiqPayOperation *)anOperation {
    MGLiqPayResponse *response = nil;
    NSString *password;
    if ([anOperation isMemberOfClass:[MGLiqPaySendMoneyOperation class]] ||
        [anOperation isMemberOfClass:[MGLiqPayPhoneCreditOperation class]]) {
        password = self.sendMoneySign;
    } else {
        password = self.otherOperationsSign;
    }
    MGLiqPaySignatureProvider *signatureProvider = [[MGLiqPaySignatureProvider alloc] initWithPassword:password];
    MGLiqPayRequest *request = [[MGLiqPayRequest alloc] init];
    request.signatureProvider = signatureProvider;
    [request.operations addObject:anOperation];
    [signatureProvider release];
    NSArray *responses = [request processRequestAndReturnResponses];
    [request release];
    NSUInteger responsesCount = [responses count];
    if (responsesCount == 0) {
        @throw [NSException exceptionWithName:MGLiqPayExceptionName 
                                       reason:@"Response is not found in the result" 
                                     userInfo:nil];
    } else if (responsesCount == 1) {
        response = [responses objectAtIndex:0];
        if (![response isSuccess]) {
            NSDictionary *userData = [NSDictionary dictionaryWithObjectsAndKeys:
                                      response.code, MGLiqPayExceptionErrorKey,
                                      response.responseDescription, MGLiqPayResponseDescriptionKey,
                                      response.responseText, MGLiqPayResponseTextKey,
                                      nil];
            @throw [NSException exceptionWithName:MGLiqPayExceptionName 
                                           reason:response.responseDescription 
                                         userInfo:userData];
        }
    } else {
        NSString *reason = [NSString stringWithFormat:@"Too many responses found. Expected 1 response but found %u", responsesCount];
        
        @throw [NSException exceptionWithName:MGLiqPayExceptionName 
                                       reason:reason 
                                     userInfo:nil];
    }
    
    return response;
}

@end
