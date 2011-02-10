/*
 *  LiqPayConstants.h
 *  LiqPayClient
 *
 *  Created by Tolya on 17.11.10.
 *  Copyright 2010 Magnis. All rights reserved.
 *
 */

#import <Foundation/Foundation.h>

extern NSString * const API_VERSION;
extern NSString * const CLICK_N_BUY_API_URL;
extern NSString * const LIQPAY_GET_EXCHANGES_URL;
extern NSString * const OPERATION_URL;
extern NSString * const DEFAULT_FORM_NAME;

// Node names
extern NSString * const OPERATION_XML_NODE_NAME;
extern NSString * const SIGNATURE_NODE_NAME;
extern NSString * const RATES_NODE_NAME;
extern NSString * const VERSION_NODE_NAME;
extern NSString * const ACTION_NODE_NAME;
extern NSString * const STATUS_NODE_NAME;
extern NSString * const CODE_NODE_NAME;
extern NSString * const RESPONSE_DESCRIPTION_NODE_NAME;

// XPath queries
extern NSString * const RESPONSE_OPERATION_XML_KEY;
extern NSString * const RESPONSE_SIGNATURE_KEY;
extern NSString * const OPERATION_ENVELOPES_KEY;
extern NSString * const RATES_XPATH;
extern NSString * const RESPONSE_ACTION_KEY;
extern NSString * const RESPONSE_AMOUNT_KEY;
extern NSString * const RESPONSE_VERSION_KEY;
extern NSString * const RESPONSE_BALANCES_KEY;
extern NSString * const RESPONSE_CODE_KEY;
extern NSString * const RESPONSE_CURRENCY_KEY;
extern NSString * const RESPONSE_DESCRIPTION_KEY;
extern NSString * const RESPONSE_KIND_KEY;
extern NSString * const RESPONSE_MERCHANT_ID_KEY;
extern NSString * const RESPONSE_ORDER_ID_KEY;
extern NSString * const RESPONSE_PAY_WAY_KEY;
extern NSString * const RESPONSE_PHONE_KEY;
extern NSString * const RESPONSE_RESP_DESCRIPTION_KEY;
extern NSString * const RESPONSE_SENDER_PHONE_KEY;
extern NSString * const RESPONSE_STATUS_KEY;
extern NSString * const RESPONSE_TRANSACTION_ID_KEY;
extern NSString * const RESPONSE_TO_KEY;
extern NSString * const TRANSACTION_TRANS_ID_KEY;
extern NSString * const TRANSACTION_ORDER_ID_KEY;
extern NSString * const TRANSACTION_AMOUNT_KEY;
extern NSString * const TRANSACTION_CURRENCY_KEY;
extern NSString * const TRANSACTION_DESCRIPTION_KEY;
extern NSString * const TRANSACTION_FROM_KEY;
extern NSString * const TRANSACTION_TO_KEY;
extern NSString * const TRANSACTION_REFERER_URL_KEY;

// XML templates
extern NSString * const OPERATION_ENVELOPE_XML_TEMPLATE;
extern NSString * const  SEND_MONEY_XML_TEMPLATE;
extern NSString * const  VIEW_BALANCE_XML_TEMPLATE;
extern NSString * const  VIEW_TRANSACTION_XML_TEMPLATE;
extern NSString * const  PHONE_CREDIT_XML_TEMPLATE;
extern NSString * const  CLICK_N_BUY_XML_TEMPLATE;
extern NSString * const  CLICK_N_BUY_OPERATION_HTML_TEMPLATE;
extern NSString * const  CLICK_N_BUY_SIGNATURE_HTML_TEMPLATE;
extern NSString * const  CLICK_N_BUY_HTML_TEMPLATE;
