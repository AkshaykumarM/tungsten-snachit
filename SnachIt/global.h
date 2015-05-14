//
//  global.h
//  SnachIt
//
//  Created by Akshakumar Maldhure on 1/2/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
// Added comment

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define DEFAULT_SNOOPTIME 30
//#define ec2maschineIP @"http://192.168.0.121:8000/"
#define ec2maschineIP @"http://ec2-52-1-195-249.compute-1.amazonaws.com/"
#define SSOUSING @"SSOUsing"
#define USERNAME @"Username"
#define PASSWORD @"Password"
#define LOGGEDIN @"LoggedIn"
#define DEFAULT_BILLING @"DefaultBilling"
#define DEFAULT_SHIPPING @"DefaultShipping"
#define SnachItDBFile @"snachit.sql"
#define SnoopTimeDBFile @"snoopTimes.sql"
#define checkInternetConnection @"You are not connected to internet, Please check connection."
#define RADIOUS 50.0f //to make profile pic circular
#define BORDERWIDTH 5.0f
extern NSString * APNSTOKEN;
extern NSString *screenName;

extern int i;
extern NSString *USERID;
extern NSString *SNACHID;
extern bool isAllreadyTried;
extern NSString *cardNumber;
extern NSString *cardExp;
extern NSString *cardCVV;


extern NSString *CURRENTDB;

extern bool isApplicationLaunchedFromNotification;

extern int snooptTracking;
extern NSString *ssousing;
extern int RECENTLY_ADDED_PAYMENT_INFO_TRACKER;
extern int RECENTLY_ADDED_SHIPPING_INFO_TRACKER;
extern NSString *screenName;



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
+(void)showAllertMsg:(NSString*)title Message:(NSString*)msg;
+(void)setTextFieldInsets:(UITextField*)textfield;
+(NSString*)processString :(NSString*)yourString;
+(BOOL)isConnected;//for checking internet connection
+(BOOL) stringIsNumeric:(NSString *) str ;
+(int)getWeekDaysCalc:(int)tempspeed;
+(NSDate *)addDays:(NSInteger)days toDate:(NSDate *)originalDate;

@end
