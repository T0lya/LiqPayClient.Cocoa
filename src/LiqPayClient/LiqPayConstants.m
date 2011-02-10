/*
 *  LiqPayConstants.m
 *  LiqPayClient
 *
 *  Created by Tolya on 18.11.10.
 *  Copyright 2010 Magnis. All rights reserved.
 *
 */


#import "LiqPayConstants.h"

NSString * const API_VERSION                        = @"1.2";
NSString * const CLICK_N_BUY_API_URL                = @"https://liqpay.com?do=clickNbuy";
NSString * const LIQPAY_GET_EXCHANGES_URL           = @"https://liqpay.com/exchanges/exchanges.cgi";
NSString * const OPERATION_URL                      = @"https://liqpay.com/?do=api_xml";

// Node names
NSString * const OPERATION_XML_NODE_NAME            = @"operation_xml";
NSString * const SIGNATURE_NODE_NAME                = @"signature";
NSString * const RATES_NODE_NAME                    = @"rates";
NSString * const VERSION_NODE_NAME                  = @"version";
NSString * const ACTION_NODE_NAME                   = @"action";
NSString * const STATUS_NODE_NAME                   = @"status";
NSString * const CODE_NODE_NAME                     = @"code";
NSString * const RESPONSE_DESCRIPTION_NODE_NAME     = @"response_description";

// XPath queries
NSString * const RESPONSE_OPERATION_XML_KEY         = @"response/liqpay/operation_envelope/operation_xml";
NSString * const RESPONSE_SIGNATURE_KEY             = @"response/liqpay/operation_envelope/signature";
NSString * const OPERATION_ENVELOPES_KEY            = @"response/liqpay/";
NSString * const RATES_XPATH                        = @"/rates/*";
NSString * const RESPONSE_ACTION_KEY                = @"response/action";
NSString * const RESPONSE_AMOUNT_KEY                = @"response/amount";
NSString * const RESPONSE_VERSION_KEY               = @"response/version";
NSString * const RESPONSE_BALANCES_KEY              = @"response/balances/";
NSString * const RESPONSE_CODE_KEY                  = @"response/code";
NSString * const RESPONSE_CURRENCY_KEY              = @"response/currency";
NSString * const RESPONSE_DESCRIPTION_KEY           = @"response/description";
NSString * const RESPONSE_KIND_KEY                  = @"response/kind";
NSString * const RESPONSE_MERCHANT_ID_KEY           = @"response/merchant_id";
NSString * const RESPONSE_ORDER_ID_KEY              = @"response/order_id";
NSString * const RESPONSE_PAY_WAY_KEY               = @"response/pay_way";
NSString * const RESPONSE_PHONE_KEY                 = @"response/phone";
NSString * const RESPONSE_RESP_DESCRIPTION_KEY      = @"response/response_description";
NSString * const RESPONSE_SENDER_PHONE_KEY          = @"response/sender_phone";
NSString * const RESPONSE_STATUS_KEY                = @"response/status";
NSString * const RESPONSE_TRANSACTION_ID_KEY        = @"response/transaction_id";
NSString * const RESPONSE_TO_KEY                    = @"response/to";
NSString * const TRANSACTION_TRANS_ID_KEY           = @"response/transaction/id";
NSString * const TRANSACTION_ORDER_ID_KEY           = @"response/transaction/order_id";
NSString * const TRANSACTION_AMOUNT_KEY             = @"response/transaction/amount";
NSString * const TRANSACTION_CURRENCY_KEY           = @"response/transaction/currency";
NSString * const TRANSACTION_DESCRIPTION_KEY        = @"response/transaction/description";
NSString * const TRANSACTION_FROM_KEY               = @"response/transaction/from";
NSString * const TRANSACTION_TO_KEY                 = @"response/transaction/to";
NSString * const TRANSACTION_REFERER_URL_KEY        = @"response/transaction/referer_url";

NSString * const     DEFAULT_FORM_NAME              = @"clicknbuyForm";

NSString * const  OPERATION_ENVELOPE_XML_TEMPLATE =
@"<operation_envelope>"
@"  <operation_xml>%@</operation_xml>"
@"  <signature>%@</signature>"
@"</operation_envelope>";

NSString * const  SEND_MONEY_XML_TEMPLATE =
@"<request>"
@"  <version>1.2</version>"
@"  <action>send_money</action>"
@"  <kind>%@</kind>"
@"  <merchant_id>%@</merchant_id>"
@"  <order_id>%@</order_id>"
@"  <to>%@</to>"
@"  <amount>%.2f</amount>"
@"  <currency>%@</currency>"
@"  <description>%@</description>"
@"</request>";

NSString * const  VIEW_BALANCE_XML_TEMPLATE =
@"<request>"
@"  <version>1.2</version>"
@"  <action>view_balance</action>"
@"  <merchant_id>%@</merchant_id>"
@"</request>";

NSString * const  VIEW_TRANSACTION_XML_TEMPLATE =
@"<request>"
@"  <version>1.2</version>"
@"  <action>view_transaction</action>"
@"  <merchant_id>%@</merchant_id>"
@"  <transaction_id>%@</transaction_id>"
@"  <transaction_order_id>%@</transaction_order_id>"
@"</request>";

NSString * const  PHONE_CREDIT_XML_TEMPLATE =
@"<request>"
@"  <version>1.2</version>"
@"  <action>phone_credit</action>"
@"  <merchant_id>%@</merchant_id>"
@"  <amount>%.2f</amount>"
@"  <currency>%@</currency>"
@"  <phone>%@</phone>"
@"  <order_id>%@</order_id>"
@"</request>";

NSString * const  CLICK_N_BUY_XML_TEMPLATE =
@"<request>"
@"  <version>1.2</version>"
@"  <result_url>%@</result_url>"
@"  <server_url>%@</server_url>"
@"  <merchant_id>%@</merchant_id>"
@"  <order_id>%@</order_id>"
@"  <amount>%.2f</amount>"
@"  <currency>%@</currency>"
@"  <description>%@</description>"
@"  <default_phone>%@</default_phone>"
@"  <pay_way>%@</pay_way>"
@"</request>";

NSString * const  CLICK_N_BUY_OPERATION_HTML_TEMPLATE = @"<input type='hidden' name='operation_xml' value='%@' />";
NSString * const  CLICK_N_BUY_SIGNATURE_HTML_TEMPLATE = @"<input type='hidden' name='signature' value='%@' />";
NSString * const  CLICK_N_BUY_HTML_TEMPLATE =
@"<form name='%@' action='%@' method='POST'>"
@" %@ %@"
@" <input type='submit' value='%@' />"
@"</form>";
