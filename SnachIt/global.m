//
//  global.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/2/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "global.h"
NSString const *maschineIP=@"http://192.168.0.121:8000/";
NSString * const APPALLERTS=@"appAllerts";
NSString * const EMAILALLERTS=@"emailAllerts";
NSString * const SMSALLERTS=@"smsAllerts";
NSString *screenName;
NSString *ssousing;

int i=0;//for screen tracking
@implementation global

/*
 This method will make post request and will return the response
 */
+(NSData*)makePostRequest:(NSData*)body requestURL:(NSString*)url {
    NSError *error;
    NSData *responseData;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",maschineIP,url]]];
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


@end
