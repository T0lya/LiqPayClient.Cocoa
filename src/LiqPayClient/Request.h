//
//  Request.h
//  LiqPayClient
//
//  Created by Tolya on 09.11.10.
//  Copyright 2010 Magnis. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MGLiqPaySignatureProvider;

/**
 * Represents LiqPay operation request.
 */
@interface MGLiqPayRequest : NSObject {
    NSMutableArray *operations;
    MGLiqPaySignatureProvider *signatureProvider;
}

//! Get/Set LiqPay operations.
@property (retain) NSMutableArray *operations;

//! Get/Set signature provider used to generate signatures.
@property (retain) MGLiqPaySignatureProvider *signatureProvider;

/**
 * Generates XML representation of request.
 * @return String containing request in XML form.
 */
- (NSString *)xmlString;

/**
 * Sends request to the server and processes response.
 * @return Array of MGLiqPayResponse objectsr representing each operation request.
 */
- (NSArray *)processRequestAndReturnResponses;

@end
