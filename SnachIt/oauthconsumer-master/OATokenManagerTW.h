//
//  OATokenManager.h
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 01/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OACallTW.h"

@class OATokenManagerTW;

@protocol OATokenManagerDelegateTW

- (BOOL)tokenManager:(OATokenManagerTW *)manager failedCall:(OACallTW *)call withError:(NSError *)error;
- (BOOL)tokenManager:(OATokenManagerTW *)manager failedCall:(OACallTW *)call withProblem:(OAProblemTW *)problem;

@optional

- (BOOL)tokenManagerNeedsToken:(OATokenManagerTW *)manager;

@end

@class OAConsumerTW;
@class OATokenTW;

@interface OATokenManagerTW : NSObject<OACallDelegateTW> {
	OAConsumerTW *consumer;
	OATokenTW *acToken;
	OATokenTW *reqToken;
	OATokenTW *initialToken;
	NSString *authorizedTokenKey;
	NSString *oauthBase;
	NSString *realm;
	NSString *callback;
	NSObject <OATokenManagerDelegateTW> *delegate;
	NSMutableArray *calls;
	NSMutableArray *selectors;
	NSMutableDictionary *delegates;
	BOOL isDispatching;
}


- (id)init;

- (id)initWithConsumer:(OAConsumerTW *)aConsumer token:(OATokenTW *)aToken oauthBase:(const NSString *)base
				 realm:(const NSString *)aRealm callback:(const NSString *)aCallback
			  delegate:(NSObject <OATokenManagerDelegateTW> *)aDelegate;

- (void)authorizedToken:(const NSString *)key;

- (void)fetchData:(NSString *)aURL finished:(SEL)didFinish;

- (void)fetchData:(NSString *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters
		 finished:(SEL)didFinish;

- (void)fetchData:(NSString *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters
			files:(NSDictionary *)theFiles finished:(SEL)didFinish;

- (void)fetchData:(NSString *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters
			files:(NSDictionary *)theFiles finished:(SEL)didFinish delegate:(NSObject*)aDelegate;

- (void)call:(OACallTW *)call failedWithError:(NSError *)error;
- (void)call:(OACallTW *)call failedWithProblem:(OAProblemTW *)problem;

@end
