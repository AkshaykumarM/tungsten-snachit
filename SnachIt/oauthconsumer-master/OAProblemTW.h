//
//  OAProblem.h
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 03/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import <Foundation/Foundation.h>

enum {
	kOAProblemSignatureMethodRejected = 0,
	kOAProblemParameterAbsent,
	kOAProblemVersionRejected,
	kOAProblemConsumerKeyUnknown,
	kOAProblemTokenRejected,
	kOAProblemSignatureInvalid,
	kOAProblemNonceUsed,
	kOAProblemTimestampRefused,
	kOAProblemTokenExpired,
	kOAProblemTokenNotRenewable
};

@interface OAProblemTW : NSObject {
	NSString *problem;
}

@property (readonly) NSString *problem;

- (id)initWithProblem:(NSString *)aProblem;
- (id)initWithResponseBody:(NSString *)response;

- (BOOL)isEqualToProblem:(OAProblemTW *)aProblem;
- (BOOL)isEqualToString:(NSString *)aProblem;
- (BOOL)isEqualTo:(id)aProblem;
- (int)code;

+ (OAProblemTW *)problemWithResponseBody:(NSString *)response;

+ (NSArray *)validProblems;

+ (OAProblemTW *)SignatureMethodRejected;
+ (OAProblemTW *)ParameterAbsent;
+ (OAProblemTW *)VersionRejected;
+ (OAProblemTW *)ConsumerKeyUnknown;
+ (OAProblemTW *)TokenRejected;
+ (OAProblemTW *)SignatureInvalid;
+ (OAProblemTW *)NonceUsed;
+ (OAProblemTW *)TimestampRefused;
+ (OAProblemTW *)TokenExpired;
+ (OAProblemTW *)TokenNotRenewable;

@end
