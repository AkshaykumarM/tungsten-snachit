//
//  global.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/2/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "global.h"
#import "RegexValidator.h"
//NSString const *ec2maschineIP=@"http://192.168.0.121:8000/";
NSString const *ec2maschineIP=@"http://ec2-52-1-195-249.compute-1.amazonaws.com/";
NSString * const APPALLERTS=@"appAllerts";     
NSString * const EMAILALLERTS=@"emailAllerts";
NSString * const SMSALLERTS=@"smsAllerts";
NSString *USERID;                                   //this will be the global userid
bool isApplicationLaunchedFromNotification=FALSE;
bool isAllreadyTried=FALSE;
 NSString * const SSOUSING=@"SSOUsing";
 NSString * const USERNAME=@"Username";
 NSString * const PASSWORD=@"Password";
 NSString * const LOGGEDIN=@"LoggedIn";
 NSString *const DEFAULT_BACK_IMG=@"DefaultBackImg";
 NSString *const DEFAULT_BILLING=@"DefaultBilling";
 NSString *const DEFAULT_SHIPPING=@"DefaultShipping";



NSString *screenName;
NSString *ssousing;
NSString *APNSTOKEN;
int snooptTracking;
int i=0;//for screen tracking
NSString *cardNumber=@"";
NSString *cardExp=@"";
NSString *cardCVV=@"";
int RECENTLY_ADDED_PAYMENT_INFO_TRACKER=-1;
int RECENTLY_ADDED_SHIPPING_INFO_TRACKER=-1;
@implementation global
float  RADIOUS=37.5f;//to make profile pic circular
float BORDERWIDTH=5.0f;
/*
 This method will make post request and will return the response
 */
+(NSData*)makePostRequest:(NSData*)body requestURL:(NSString*)url {
    NSError *error;
    NSData *responseData;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ec2maschineIP,url]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    
    NSHTTPURLResponse* urlResponse = nil;
    error = [[NSError alloc] init];
     responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"URL: %@", request);
    NSLog(@"Response: %@", result);
    
    
    return responseData;
}
+(BOOL)isValidUrl:(NSURL *)urlString{
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    return [NSURLConnection canHandleRequest:request];
}
+(void)showAllertForAllreadySignedUp{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                    message:@"You have alreday signed up with snach.it."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
+(void)showAllertForInvalidCredentials{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                    message:@"Please, enter valid email or password."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}
+(void)showAllertForEnterValidCredentials{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                    message:@"Please, enter email and password."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+(void)showAllertMsg:(NSString*)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+(NSString*)getCardType:(NSString*)number{
    NSString *type;
    NSPredicate* visa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VISA];
    NSPredicate* mastercard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MASTERCARD];
    NSPredicate* dinnersclub = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DINNERSCLUB];
    NSPredicate* discover = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DISCOVER];
    NSPredicate* amex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AMEX];
    
    if ([visa evaluateWithObject:number])
    {
        type=@"Visa";
    }
    else if ([mastercard evaluateWithObject:number])
    {
        type=@"Mastercard";
    }
    else if ([dinnersclub evaluateWithObject:number])
    {
        type=@"Diners Club";
    }
    else if ([discover evaluateWithObject:number])
    {
        type=@"Discover";
    }
    else if ([amex evaluateWithObject:number])
    {
        type=@"American Express";
    }
    else{
        type=@"Unknown";
    }
    return type;
}
+(void)setTextFieldInsets:(UITextField*)textfield{
    
    textfield.keyboardType = UIKeyboardTypeEmailAddress;
    textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
    
}
@end
