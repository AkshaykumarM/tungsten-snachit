//
//  OACall.h
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 04/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import <Foundation/Foundation.h>

@class OAProblemTW;
@class OACallTW;

@protocol OACallDelegateTW

- (void)call:(OACallTW *)call failedWithError:(NSError *)error;
- (void)call:(OACallTW *)call failedWithProblem:(OAProblemTW *)problem;

@end

@class OAConsumerTW;
@class OATokenTW;
@class OADataFetcherTW;
@class OAMutableURLRequestTW;
@class OAServiceTicketTW;

@interface OACallTW : NSObject {
	NSURL *url;
	NSString *method;
	NSArray *parameters;
	NSDictionary *files;
	NSObject <OACallDelegateTW> *delegate;
	SEL finishedSelector;
	OADataFetcherTW *fetcher;
	OAMutableURLRequestTW *request;
	OAServiceTicketTW *ticket;
}

@property(readonly) NSURL *url;
@property(readonly) NSString *method;
@property(readonly) NSArray *parameters;
@property(readonly) NSDictionary *files;
@property(nonatomic, retain) OAServiceTicketTW *ticket;

- (id)init;
- (id)initWithURL:(NSURL *)aURL;
- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod;
- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters;
- (id)initWithURL:(NSURL *)aURL method:(NSString *)aMethod parameters:(NSArray *)theParameters;
- (id)initWithURL:(NSURL *)aURL parameters:(NSArray *)theParameters files:(NSDictionary*)theFiles;

- (id)initWithURL:(NSURL *)aURL
		   method:(NSString *)aMethod
	   parameters:(NSArray *)theParameters
			files:(NSDictionary*)theFiles;

- (void)perform:(OAConsumerTW *)consumer
		  token:(OATokenTW *)token
		  realm:(NSString *)realm
	   delegate:(NSObject <OACallDelegateTW> *)aDelegate
	  didFinish:(SEL)finished;

@end
