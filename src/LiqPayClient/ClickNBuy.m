//
//  ClickNBuy.m
//  LiqPayClient
//
//  Created by Tolya on 14.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "ClickNBuy.h"
#import "Categories.h"
#import "Classes.h"
#import "LiqPayConstants.h"
#import "Parsers.h"


@interface MGLiqPayClickNBuy ()

- (NSString *)operationHtml;
- (NSString *)signatureHtml:(MGLiqPaySignatureProvider *)aSignatureProvider;

@end

@implementation MGLiqPayClickNBuy

@synthesize merchantId;
@synthesize resultUrl;
@synthesize serverUrl;
@synthesize orderId;
@synthesize amount;
@synthesize currency;
@synthesize description;
@synthesize defaultPhone;
@synthesize payWay;

- (void)dealloc {
    [self setResultUrl:nil];
    [self setServerUrl:nil];
    [self setMerchantId:nil];
    [self setOrderId:nil];
    [self setCurrency:nil];
    [self setDescription:nil];
    [self setDefaultPhone:nil];
    [self setPayWay:nil];
    
    [super dealloc];
}

- (NSString *)DefaultFormName {
    return DEFAULT_FORM_NAME;
}

- (NSString *)xmlString {
    NSString *resultUrlString = self.resultUrl ? [self.resultUrl absoluteString] : @"";
    NSString *serverUrlString = self.serverUrl ? [self.serverUrl absoluteString] : @"";
    NSString *xml = [NSString stringWithFormat:CLICK_N_BUY_XML_TEMPLATE,
                     resultUrlString,
                     serverUrlString,
                     self.merchantId ? self.merchantId : @"",
                     self.orderId ? self.orderId : @"",
                     self.amount,
                     self.currency ? self.currency : @"",
                     self.description ? self.description : @"",
                     self.defaultPhone ? self.defaultPhone : @"",
                     self.payWay ? self.payWay : @""];

    return xml;
}

- (NSString *)operationHtml {
    NSString *xml = [self xmlString];
    NSString *encodedXml = [xml base64EncodedStringUsingEncoding:NSASCIIStringEncoding];
    NSString *html = [NSString stringWithFormat:CLICK_N_BUY_OPERATION_HTML_TEMPLATE, encodedXml];
    
    return html;
}

- (NSString *)signatureHtml:(MGLiqPaySignatureProvider *)aSignatureProvider {
    NSString *xml = [self xmlString];
    NSString *signature = [aSignatureProvider generateSignatureForString:xml];
    NSString *html = [NSString stringWithFormat:CLICK_N_BUY_SIGNATURE_HTML_TEMPLATE, signature];
    
    return html;
}

- (NSString *)htmlStringWithFormName:(NSString *)aFormName 
                    submitButtonValue:(NSString *)aSubmitValue 
                    signatureProvider:(MGLiqPaySignatureProvider *)aSignatureProvider {
    NSString *formName = [aFormName length] > 0 ? aFormName : DEFAULT_FORM_NAME;
    NSString *html = [NSString stringWithFormat:CLICK_N_BUY_HTML_TEMPLATE,
                      formName,
                      CLICK_N_BUY_API_URL,
                      [self operationHtml],
                      [self signatureHtml:aSignatureProvider],
                      aSubmitValue];
    
    return html;
}

- (NSString *)htmlStringWithSubmitButtonValue:(NSString *)aSubmitValue
                             signatureProvider:(MGLiqPaySignatureProvider *)aSignatureProvider {
    return [self htmlStringWithFormName:DEFAULT_FORM_NAME
                      submitButtonValue:aSubmitValue
                      signatureProvider:aSignatureProvider];
}

@end


@implementation MGLiqPayClickNBuyResponse

@synthesize apiVersion;
@synthesize action;
@synthesize merchantId;
@synthesize amount;
@synthesize currency;
@synthesize description;
@synthesize orderId;
@synthesize payWay;
@synthesize senderPhone;
@synthesize status;
@synthesize transactionId;

+ (id)responseFromXmlString:(NSString *)anXml {
    return [[[[self class] alloc] initWithXmlString:anXml] autorelease];
}

- (id)initWithXmlString:(NSString *)anXml {
    self = [super init];
    if (self) {
        NSError *error = nil;
        XmlParser *parser = [[[XmlParser alloc] init] autorelease];
        NSDictionary *nodeValues = [parser dictionaryFromXmlString:anXml error:&error];
        if (nodeValues) {
            self.apiVersion = [nodeValues valueForKey:RESPONSE_VERSION_KEY];
            self.action = [nodeValues valueForKey:RESPONSE_ACTION_KEY];
            self.merchantId = [nodeValues valueForKey:RESPONSE_MERCHANT_ID_KEY];
            self.orderId = [nodeValues valueForKey:RESPONSE_ORDER_ID_KEY];
            self.amount = [[nodeValues valueForKey:RESPONSE_AMOUNT_KEY] doubleValue];
            self.currency = [nodeValues valueForKey:RESPONSE_CURRENCY_KEY];
            self.description = [nodeValues valueForKey:RESPONSE_DESCRIPTION_KEY];
            self.orderId = [nodeValues valueForKey:RESPONSE_ORDER_ID_KEY];
            self.payWay = [nodeValues valueForKey:RESPONSE_PAY_WAY_KEY];
            self.senderPhone = [nodeValues valueForKey:RESPONSE_SENDER_PHONE_KEY];
            self.status = [nodeValues valueForKey:RESPONSE_STATUS_KEY];
            self.transactionId = [nodeValues valueForKey:RESPONSE_TRANSACTION_ID_KEY];
        } else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:@"Response string is not a well formed XML." 
                                         userInfo:nil];
        }
    }
    
    return self;
}

- (void)dealloc {
    [self setApiVersion:nil];
    [self setAction:nil];
    [self setMerchantId:nil];
    [self setCurrency:nil];
    [self setDescription:nil];
    [self setOrderId:nil];
    [self setPayWay:nil];
    [self setSenderPhone:nil];
    [self setStatus:nil];
    [self setTransactionId:nil];
    
    [super dealloc];
}


@end