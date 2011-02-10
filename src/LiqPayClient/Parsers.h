//
//  LiqPayExchangeParser.h
//  LiqPayClient
//
//  Created by Tolya on 04.12.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
@interface MGLiqPayExchangeParser : NSObject<NSXMLParserDelegate> {
#else
@interface MGLiqPayExchangeParser : NSObject {    
#endif
    NSMutableDictionary *ratesDictionary;
    NSString *rootCurrency;
    NSString *rateCurrency;
    NSMutableDictionary *currencyDictionary;
    NSError *parserError;
}

- (NSDictionary *)ratesDictionary;
- (NSError *)parserError;

- (BOOL)parseContentOfUrl:(NSURL *)anUrl;

@end


#if TARGET_OS_IPHONE
@interface XmlParser : NSObject<NSXMLParserDelegate> {
#else
@interface XmlParser : NSObject {
#endif
    NSString *path;
    NSMutableDictionary *nodeValues;
}

- (NSDictionary *)dictionaryFromXmlString:(NSString *)string error:(NSError **)anError;
- (NSDictionary *)dictionaryFromContentsOfUrl:(NSURL *)url error:(NSError **)anError;

@end