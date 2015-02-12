//
//  global.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/2/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
// Added comment

#import <Foundation/Foundation.h>
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

extern NSString * const SSOUSING;
extern NSString * const USERNAME;
extern NSString * const PASSWORD;

extern bool isAllreadySignedUp;

extern float  RADIOUS;
extern float BORDERWIDTH;
extern int snooptTracking;
extern NSString *ssousing;
@interface global : NSObject
/*
 This method will make post request and will return the response
 */
+(NSData*)makePostRequest:(NSData*)body requestURL:(NSString*)url;
+(BOOL)isValidUrl:(NSURL *)urlString;
+(void)showAllertForAllreadySignedUp;
+(void)showAllertForInvalidCredentials;
+(void)showAllertForEnterValidCredentials;

@end
