//
//  global.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/2/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
// Added comment

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
extern NSString const *ec2maschineIP;
extern NSString const *tempmaschineIP;
extern NSString * const APPALLERTS;
extern NSString * const EMAILALLERTS;
extern NSString * const SMSALLERTS;
extern NSString * APNSTOKEN;
extern NSString *screenName;
extern int i;
extern NSString * const VISA ;
extern NSString * const MASTERCARD;
extern NSString * const AMEX;
extern NSString * const DINNERSCLUB;
extern NSString * const DISCOVER;
extern NSString * const EMAIL_REGEX;

extern NSString *cardNumber;
extern NSString *cardExp;
extern NSString *cardCVV;

extern NSString * const SSOUSING;
extern NSString * const USERNAME;
extern NSString * const PASSWORD;


extern bool isApplicationLaunchedFromNotification;
extern float  RADIOUS;
extern float BORDERWIDTH;
extern int snooptTracking;
extern NSString *ssousing;
extern NSString *RECENTLY_ADDED_PAYMENT_INFO_TRACKER;
extern NSString *RECENTLY_ADDED_SHIPPING_INFO_TRACKER;
extern NSString *const DEFAULT_BACK_IMG;

extern NSString * const PRODUCT_IMAGES;
extern NSString * const PRODUCT_NAME;
extern NSString * const PRODUCT_BRAND_NAME;
extern NSString * const PRODUCT_PRICE;
extern NSString * const PRODUCT_BRAND_IMAGE;
extern NSString * const PRODUCT_IMAGE;
extern NSString * const PRODUCT_BRAND_ID;
extern NSString * const PRODUCT_ID;
extern NSString * const PRODUCT_SNACH_ID;
extern NSString * const PRODUCT_DESCRIPTION;
extern NSString * const PRODUCT_FOLLOW_STATUS;
@interface global : NSObject
/*
 This method will make post request and will return the response
 */
+(NSData*)makePostRequest:(NSData*)body requestURL:(NSString*)url;
+(BOOL)isValidUrl:(NSURL *)urlString;
+(void)showAllertForAllreadySignedUp;
+(void)showAllertForInvalidCredentials;
+(void)showAllertForEnterValidCredentials;
+(NSString*)getCardType:(NSString*)number;
+(void)showAllertMsg:(NSString*)msg;
+(void)setTextFieldInsets:(UITextField*)textfield;
@end
