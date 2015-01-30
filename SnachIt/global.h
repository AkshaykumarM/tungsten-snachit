//
//  global.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/2/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
// Added comment

#import <Foundation/Foundation.h>
extern NSString const *maschineIP;

extern NSString * const APPALLERTS;
extern NSString * const EMAILALLERTS;
extern NSString * const SMSALLERTS;

extern NSString *screenName;
extern int i;
extern NSString *ssousing;
@interface global : NSObject
/*
 This method will make post request and will return the response
 */
+(NSData*)makePostRequest:(NSData*)body requestURL:(NSString*)url;

@end
