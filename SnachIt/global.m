//
//  global.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/2/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "global.h"
#import <UIKit/UIKit.h>
NSString const *ec2maschineIP=@"http://192.168.0.121:8000/";
NSString const *tempmaschineIP=@"http://ecellmit.com/snachit/Snachit/";
NSString * const APPALLERTS=@"appAllerts";
NSString * const EMAILALLERTS=@"emailAllerts";
NSString * const SMSALLERTS=@"smsAllerts";
NSString * const VISA = @"^4[0-9]{12}(?:[0-9]{3})?$";
NSString * const MASTERCARD=@"^5[1-5][0-9]{14}$";
NSString * const AMEX=@"^3[47][0-9]{13}$";
NSString * const DINNERSCLUB=@"^3(?:0[0-5]|[68][0-9])[0-9]{11}$";
NSString * const DISCOVER=@"^6(?:011|5[0-9]{2})[0-9]{12}$";
NSString * const EMAIL_REGEX=@"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

bool isAllreadySignedUp=FALSE;
 NSString * const SSOUSING=@"SSOUsing";
 NSString * const USERNAME=@"Username";
 NSString * const PASSWORD=@"Password";
NSString *screenName;
NSString *ssousing;
NSString *APNSTOKEN;
int snooptTracking;
int i=0;//for screen tracking

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
    
    NSLog(@"Response: %@", result);

    
    return responseData;
}
+(BOOL)isValidUrl:(NSURL *)urlString{
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    return [NSURLConnection canHandleRequest:request];
}
+(void)showAllertForAllreadySignedUp{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                    message:@"You have allreday signed up with snach.it."
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
@end
