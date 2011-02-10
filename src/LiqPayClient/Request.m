//
//  Request.m
//  LiqPayClient
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "Request.h"
#import "Categories.h"
#import "Classes.h"
#import "Constants.h"
#import "LiqPayConstants.h"
#import "Operation.h"
#import "Response.h"
#import "Parsers.h"


@interface MGLiqPayRequest ()

- (NSURLRequest *)createURLRequest;
- (NSString *)sendRequest:(NSURLRequest *)aRequest;
- (MGLiqPayResponse *)processResponse:(NSString *)aResponseText
                     withOperationXml:(NSString *)anEncodedOperationXml 
                            signature:(NSString *)aSignature;

@end

@implementation MGLiqPayRequest

@synthesize operations;
@synthesize signatureProvider;

- (id)init {
    self = [super init];
    if (self != nil) {
        operations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self setOperations:nil];
    [self setSignatureProvider:nil];
    
    [super dealloc];
}

- (NSString *)xmlString {
    NSMutableString *xml = [NSMutableString stringWithString:@"<?xml version=\"1.0\" encoding=\"UTF-8\" ?><request><liqpay>"];
    for (MGLiqPayOperation *operation in self.operations) {
        NSString *operationEnvelope = [operation operationEnvelopeXmlStringUsingSignatureProvider:self.signatureProvider];
        [xml appendString:operationEnvelope];
    }
    [xml appendString:@"</liqpay></request>"];

    return xml;
}

- (MGLiqPayResponse *)processResponse:(NSString *)aResponseText
                     withOperationXml:(NSString *)anEncodedOperationXml 
                            signature:(NSString *)aSignature{
    if (!(anEncodedOperationXml && aSignature)) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  aResponseText, MGLiqPayResponseTextKey,
                                  nil];
        @throw [NSException exceptionWithName:MGLiqPayExceptionName 
                                       reason:@"Invalid response." 
                                     userInfo:userInfo];
    }
    NSString *operationXml = [anEncodedOperationXml stringFromBase64EncodedStringUsingEncoding:NSUTF8StringEncoding];
    MGLiqPayResponse *liqpayResponse;
    if ([[self.signatureProvider generateSignatureForString:operationXml] isEqualToString:aSignature]) {
        liqpayResponse = [MGLiqPayResponse responseFromXml:operationXml];
    } else {
        liqpayResponse = [MGLiqPayInvalidResponse responseWithErrorCode:MGLiqPaySignatureError 
                                                            description:@"Signatures do not match." 
                                                           responseText:aResponseText];
    }
    
    return liqpayResponse;
}

- (NSArray *)processRequestAndReturnResponses {
    NSMutableArray *responses = [NSMutableArray array];
    NSURLRequest *urlRequest = [self createURLRequest];
    NSString *responseText = [self sendRequest:urlRequest];
    NSError *error = nil;
    XmlParser *parser = [[[XmlParser alloc] init] autorelease];
    NSDictionary *nodeValues = [parser dictionaryFromXmlString:responseText
                                                         error:&error];
    if (nodeValues) {
        id operationXmls = [nodeValues valueForKey:RESPONSE_OPERATION_XML_KEY];
        id signatureXmls = [nodeValues valueForKey:RESPONSE_SIGNATURE_KEY];
        if ([[operationXmls class] isSubclassOfClass:[NSArray class]]) {
            for (NSUInteger i = 0; i < [operationXmls count]; i++) {
                NSString *operationXml = [operationXmls objectAtIndex:i];
                NSString *signature = [signatureXmls objectAtIndex:i];
                MGLiqPayResponse *response = [self processResponse:responseText
                                                  withOperationXml:operationXml
                                                         signature:signature];
                [responses addObject:response];
            }
        } else {
            MGLiqPayResponse *response = [self processResponse:responseText
                                              withOperationXml:operationXmls
                                                     signature:signatureXmls];
            [responses addObject:response];
        }
    }
    else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  responseText, MGLiqPayResponseTextKey,
                                  error, MGLiqPayExceptionName,
                                  nil];
        @throw [NSException exceptionWithName:MGLiqPayExceptionName 
                                       reason:@"Response text is not a well formed xml." 
                                     userInfo:userInfo];
    }
    
    return responses;
}

- (NSURLRequest *)createURLRequest {
    NSString *post = [self xmlString];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding];
    NSString *postDataLength = [NSString stringWithFormat:@"%d", [postData length]];
    NSURL *url = [NSURL URLWithString:OPERATION_URL];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"text/xml;charset=\"utf-8\"" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    return request;
}

- (NSString *)sendRequest:(NSURLRequest *)aRequest {
    NSURLResponse *response;
    NSError *error;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:aRequest 
                                                 returningResponse:&response 
                                                             error:&error];
    if (responseData) {
        NSString *responseString = [[NSString alloc] initWithData:responseData
                                                         encoding:NSASCIIStringEncoding];
        
        return [responseString autorelease];
    } else {
        @throw [NSException exceptionWithName:MGLiqPayExceptionName 
                                       reason:[error localizedDescription] 
                                     userInfo:[error userInfo]];
    }
}

@end
