//
//  Classes.m
//  LiqPayClient
//
//  Created by Tolya on 02.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "Classes.h"
#import "Constants.h"
#import "LiqPayConstants.h"
#import "Categories.h"
#import "Parsers.h"

@implementation MGLiqPayTransaction

@synthesize transactionId;
@synthesize orderId;
@synthesize amount;
@synthesize currency;
@synthesize description;
@synthesize from;
@synthesize to;
@synthesize refererAddress;

- (void)dealloc {
    [self setTransactionId:nil];
    [self setOrderId:nil];
    [self setCurrency:nil];
    [self setDescription:nil];
    [self setFrom:nil];
    [self setTo:nil];
    [self setRefererAddress:nil];
    
    [super dealloc];
}

@end


@implementation MGLiqPayExchange

+ (NSDictionary *)getExchangeRates {
    NSURL *url = [[[NSURL alloc] initWithString:LIQPAY_GET_EXCHANGES_URL] autorelease];
    NSError *error = nil;
    XmlParser *p = [[[XmlParser alloc] init] autorelease];
    NSDictionary *dict = [p dictionaryFromContentsOfUrl:url error:&error];
    if (dict)
        NSLog(@"%@", dict);
    else
        NSLog(@"%@", error);
    
    
    MGLiqPayExchangeParser *parser = [[[MGLiqPayExchangeParser alloc] init] autorelease];
    if (![parser parseContentOfUrl:url]) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [parser parserError], MGLiqPayExceptionName,
                                  nil];
        @throw [NSException exceptionWithName:MGLiqPayExceptionName 
                                       reason:@"Response text is not a well formed xml." 
                                     userInfo:userInfo];
    }
    
    return [parser ratesDictionary];
}

+ (NSArray *)knownCurrencyNames {
    static NSArray *knownLiqPayCurrencies = nil;
    if (!knownLiqPayCurrencies) {
        knownLiqPayCurrencies = [NSArray arrayWithObjects:
                                 @"UAH", 
                                 @"USD", 
                                 @"EUR", 
                                 @"RUR", 
                                 nil];
    }
    
    return knownLiqPayCurrencies;
}

@end


@interface MGLiqPaySignatureProvider ()

@property (copy) NSString *password;

@end

@implementation MGLiqPaySignatureProvider

@synthesize password;


- (id)initWithPassword:(NSString *)aPassword {
    self = [super init];
    if (self) {
        self.password = aPassword;
    }
    
    return self;
}

+ (id)signatureProviderWithPassword:(NSString *)aPassword {
    return [[[self alloc] initWithPassword:aPassword] autorelease];
}

- (NSString *)generateSignatureForString:(NSString *)aData 
{
    NSString *text = [[NSString alloc] initWithFormat:@"%@%@%@", 
                      self.password, 
                      aData, 
                      self.password];
    NSData *sha1Hash = [[NSData alloc] initWithSHA1HashedString:text 
                                                  usingEncoding:NSUTF8StringEncoding];
    NSString *signature = [sha1Hash stringFromBase64EncodedData];
    [sha1Hash release];
    [text release];
    
    return signature;
}

@end