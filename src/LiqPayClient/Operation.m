//
//  Operation.m
//  LiqPayClient
//
//  Created by Tolya on 08.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "Operation.h"
#import "Classes.h"
#import "Constants.h"
#import "LiqPayConstants.h"
#import "Categories.h"

@implementation MGLiqPayOperation

@synthesize action;

- (id)initWithAction:(NSString *)anAction {
    self = [super init];
    if (self) {
        self.action = anAction;
    }
    
    return self;
}

- (void)dealloc {
    [self setAction:nil];
    
    [super dealloc];
}

- (NSString *)apiVersion {
    return API_VERSION;
}
- (NSString *)xmlString {
    return nil;
}

- (NSString *)operationEnvelopeXmlStringUsingSignatureProvider:(MGLiqPaySignatureProvider *)aSignatureProvider {
    NSString *operationXml = [self xmlString];
    NSString *operationEnvelope = [operationXml base64EncodedStringUsingEncoding:NSASCIIStringEncoding];
    NSString *signature = [aSignatureProvider generateSignatureForString:operationXml];
    NSString *xml = [NSString stringWithFormat:OPERATION_ENVELOPE_XML_TEMPLATE, 
                     operationEnvelope, 
                     signature];
    
    return xml;
}

@end


@implementation MGLiqPaySendMoneyOperation

@synthesize merchantId;
@synthesize kind;
@synthesize to;
@synthesize amount;
@synthesize currency;
@synthesize description;
@synthesize orderId;

- (id)init {
    self = [super initWithAction:MGSendMoneyLiqPayAction];

    return self;
}


- (void)dealloc {
    [self setMerchantId:nil];
    [self setKind:nil];
    [self setCurrency:nil];
    [self setDescription:nil];
    [self setOrderId:nil];
    
    [super dealloc];
}

- (NSString *)xmlString {
    NSString *xml = [NSString stringWithFormat:SEND_MONEY_XML_TEMPLATE, 
                     self.kind, self.merchantId, self.orderId, self.to, self.amount, 
                     self.currency, self.description];
    
    return xml;
}

@end


@implementation MGLiqPayViewBalanceOperation

@synthesize merchantId;

- (id)init {
    self = [super initWithAction:MGViewBalanceLiqPayAction];
    if (self != nil) {
        
    }
    return self;
}

- (id)initWithMerchantId:(NSString *)aMerchantId {
    self = [self init];
    if (self) {
        self.merchantId = aMerchantId;
    }
    
    return self;
}

- (void)dealloc {
    [self setMerchantId:nil];
    
    [super dealloc];
}

- (NSString *)xmlString {
    NSString *xml = [NSString stringWithFormat:VIEW_BALANCE_XML_TEMPLATE, self.merchantId];
    
    return xml;
}

@end


@implementation MGLiqPayViewTransactionOperation

@synthesize merchantId;
@synthesize transactionId;
@synthesize transactionOrderId;

- (id)init {
    self = [super initWithAction:MGViewTransactionLiqPayAction];
    if (self != nil) {
        
    }
    
    return self;
}

- (void)dealloc {
    [self setMerchantId:nil];
    [self setTransactionId:nil];
    [self setTransactionOrderId:nil];
    
    [super dealloc];
}

- (NSString *)xmlString {
    NSString *xml = [NSString stringWithFormat:VIEW_TRANSACTION_XML_TEMPLATE,
                     self.merchantId,
                     self.transactionId ? self.transactionId : @"",
                     self.transactionOrderId ? self.transactionOrderId : @""];
    
    return xml;
}

@end


@implementation MGLiqPayPhoneCreditOperation

@synthesize merchantId;
@synthesize amount;
@synthesize currency;
@synthesize phone;
@synthesize orderId;

- (id)init {
    self = [super initWithAction:MGPhoneCreditLiqPayAction];
    
    return self;
}

- (void)dealloc {
    [self setMerchantId:nil];
    [self setCurrency:nil];
    [self setPhone:nil];
    [self setOrderId:nil];
    
    [super dealloc];
}

- (NSString *)xmlString {
    NSString *xml = [NSString stringWithFormat:PHONE_CREDIT_XML_TEMPLATE,
                     self.merchantId, self.amount, self.currency, self.phone, self.orderId];
    
    return xml;
}

@end