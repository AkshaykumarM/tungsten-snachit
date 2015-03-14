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
//extern NSString const *tempmaschineIP;
extern NSString * const APPALLERTS;
extern NSString * const EMAILALLERTS;
extern NSString * const SMSALLERTS;
extern NSString * APNSTOKEN;
extern NSString *screenName;
extern int i;
extern NSString *USERID;
extern bool isAllreadyTried;
extern NSString *cardNumber;
extern NSString *cardExp;
extern NSString *cardCVV;

extern NSString * const SSOUSING;
extern NSString * const USERNAME;
extern NSString * const PASSWORD;
extern NSString * const LOGGEDIN;
extern NSString * const DEFAULT_BILLING;
extern NSString * const DEFAULT_SHIPPING;

extern bool isApplicationLaunchedFromNotification;
extern float  RADIOUS;
extern float BORDERWIDTH;
extern int snooptTracking;
extern NSString *ssousing;
extern int RECENTLY_ADDED_PAYMENT_INFO_TRACKER;
extern int RECENTLY_ADDED_SHIPPING_INFO_TRACKER;


extern NSString *const DEFAULT_BACK_IMG;


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
