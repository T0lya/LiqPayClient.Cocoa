//
//  Categories.m
//  LiqPayClient
//
//  Created by Tolya on 20.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "Categories.h"


@implementation NSData (LiqPayClient)

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

+ (id)dataWithBase64EncodedString:(NSString *)string usingEncoding:(NSStringEncoding)encoding {
    return [[[NSData alloc] initWithBase64EncodedString:string 
                                          usingEncoding:encoding] autorelease];
}

- (id)initWithBase64EncodedString:(NSString *)string usingEncoding:(NSStringEncoding)encoding {
    if (string == nil)
        [NSException raise:NSInvalidArgumentException format:@""];
    if ([string length] == 0)
        return [[NSData alloc] init];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:encoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    realloc(bytes, length);
    
    return [[NSData alloc] initWithBytesNoCopy:bytes length:length];    
}

- (NSString *)stringFromBase64EncodedData {
    if ([self length] == 0)
        return @"";
    
    char *characters = malloc((([self length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [self length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [self length])
            buffer[bufferLength++] = ((char *)[self bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';    
    }
    
    return [[[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES] autorelease];
}

+ (id)dataWithSHA1HashedString:(NSString *)string usingEncoding:(NSStringEncoding)encoding {
    return [[[NSData alloc] initWithSHA1HashedString:string usingEncoding:encoding] autorelease];
}

- (id)initWithSHA1HashedString:(NSString *)string usingEncoding:(NSStringEncoding)encoding {
    NSData *textData = [string dataUsingEncoding:encoding];
    unsigned char hashBytes[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([textData bytes], [textData length], hashBytes);
    NSData *hash = [NSData dataWithBytes:hashBytes length:CC_SHA1_DIGEST_LENGTH];
    
    return [hash retain];
}

@end


@implementation NSString (LiqPayClient)

- (id)base64EncodedStringUsingEncoding:(NSStringEncoding)encoding {
    NSData *data = [self dataUsingEncoding:encoding];
    
    return [data stringFromBase64EncodedData];
}

- (NSString *)stringFromBase64EncodedStringUsingEncoding:(NSStringEncoding)encoding {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self usingEncoding:encoding];
    NSString *decodedString = [[NSString alloc] initWithData:data encoding:encoding];
    [data release];
    
    return [decodedString autorelease];
}

@end
