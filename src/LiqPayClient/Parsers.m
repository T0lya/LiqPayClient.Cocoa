//
//  LiqPayExchangeParser.m
//  LiqPayClient
//
//  Created by Tolya on 04.12.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import "Parsers.h"
#import "Constants.h"
#import "LiqPayConstants.h"


@interface MGLiqPayExchangeParser ()

@property (nonatomic, retain) NSString *rootCurrency;
@property (nonatomic, retain) NSString *rateCurrency;

@end

@implementation MGLiqPayExchangeParser

@synthesize rootCurrency;
@synthesize rateCurrency;

- (void)dealloc {
    [self setRootCurrency:nil];
    [self setRateCurrency:nil];
    
    [super dealloc];
}

- (NSDictionary *)ratesDictionary {
    return ratesDictionary;
}

- (NSError *)parserError {
    return parserError;
}

- (BOOL)parseContentOfUrl:(NSURL *)anUrl {
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithContentsOfURL:anUrl] autorelease];
    [parser setDelegate:self];
    BOOL isParsed = [parser parse];
    if (!isParsed)
        parserError = [parser parserError];

    return isParsed;
}

#pragma mark - NSXMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    ratesDictionary = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
    if (![elementName isEqualToString: RATES_NODE_NAME]) {
        if (self.rootCurrency) {
            self.rateCurrency = elementName;
        } else {
            self.rootCurrency = elementName;
            currencyDictionary = [NSMutableDictionary dictionary];
        }
    }
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:self.rootCurrency]) {
        [ratesDictionary setObject:currencyDictionary forKey:self.rootCurrency];
        self.rootCurrency = nil;
        currencyDictionary = nil;
    } else if ([elementName isEqualToString:self.rateCurrency])
        self.rateCurrency = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.rootCurrency && self.rateCurrency) {
        [currencyDictionary setValue:string forKey:self.rateCurrency];
    }
}

@end


@interface XmlParser ()

@property (nonatomic, copy) NSString *path;

@end

@implementation XmlParser

@synthesize path;

- (void) dealloc
{
    [self setPath:nil];
    
    [super dealloc];
}

- (NSDictionary *)dictionaryFromContentsOfUrl:(NSURL *)url error:(NSError **)anError {
    nodeValues = [NSMutableDictionary dictionary];
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithContentsOfURL:url] autorelease];
    [parser setDelegate:self];
    if (![parser parse]) {
        nodeValues = nil;
        if (anError)
            *anError = [parser parserError];
    }
    
    return nodeValues;
}

- (NSDictionary *)dictionaryFromXmlString:(NSString *)string
                                    error:(NSError **)anError {
    nodeValues = [NSMutableDictionary dictionary];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
    [parser setDelegate:self];
    if (![parser parse]) {
        nodeValues = nil;
        if (anError)
            *anError = [parser parserError];
    }
    
    return nodeValues;
}

#pragma marke - NSXMLParser delegate

- (void)parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
    attributes:(NSDictionary *)attributeDict {
    if (self.path)
        self.path = [self.path stringByAppendingPathComponent:elementName];
    else
        self.path = elementName;
}

- (void)parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    self.path = [self.path stringByDeletingLastPathComponent];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (self.path) {
        NSString *value = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([value length] > 0) {
            id obj = [nodeValues objectForKey:self.path];
            if (obj) {
                Class objClass = [obj class];
                if ([objClass isSubclassOfClass:[NSString class]]) {
                    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:
                                             obj, string, nil];
                    [nodeValues setValue:array forKey:self.path];
                    [array release];
                } else if ([objClass isSubclassOfClass:[NSMutableArray class]]) {
                    [obj addObject:string];
                } else {
                    NSAssert(NO, @"Dictionary contains object of unsupported type.");
                }
            } else {
                [nodeValues setValue:value forKey:self.path];
            }
        }
    }
}

@end