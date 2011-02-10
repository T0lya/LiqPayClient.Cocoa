//
//  Categories.h
//  LiqPayClient
//
//  Created by Tolya on 20.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (LiqPayClient)

+ (id)dataWithBase64EncodedString:(NSString *)string 
                    usingEncoding:(NSStringEncoding)encoding;
- (id)initWithBase64EncodedString:(NSString *)string 
                    usingEncoding:(NSStringEncoding)encoding;
- (NSString *)stringFromBase64EncodedData;

+ (id)dataWithSHA1HashedString:(NSString *)string 
                 usingEncoding:(NSStringEncoding)encoding;
- (id)initWithSHA1HashedString:(NSString *)string 
                 usingEncoding:(NSStringEncoding)encoding;

@end


@interface NSString (LiqPayClient)

- (NSString *)base64EncodedStringUsingEncoding:(NSStringEncoding)encoding;
- (NSString *)stringFromBase64EncodedStringUsingEncoding:(NSStringEncoding)encoding;

@end
