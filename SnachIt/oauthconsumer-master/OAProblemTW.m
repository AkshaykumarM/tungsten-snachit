//
//  OAProblem.m
//  OAuthConsumer
//
//  Created by Alberto García Hierro on 03/09/08.
//  Copyright 2008 Alberto García Hierro. All rights reserved.
//	bynotes.com

#import "OAProblemTW.h"

NSString *signature_method_rejected1 = @"signature_method_rejected";
NSString *parameter_absent1 = @"parameter_absent";
NSString *version_rejected1 = @"version_rejected";
NSString *consumer_key_unknown1 = @"consumer_key_unknown";
NSString *token_rejected1 = @"token_rejected";
NSString *signature_invalid1 = @"signature_invalid";
NSString *nonce_used1 = @"nonce_used";
NSString *timestamp_refused1 = @"timestamp_refused";
NSString *token_expired1 = @"token_expired";
NSString *token_not_renewable1 = @"token_not_renewable";

@implementation OAProblemTW

@synthesize problem;

- (id)initWithPointer:(NSString *) aPointer
{
	if ((self = [super init])) {
		problem = [aPointer copy];
	}
	return self;
}

- (id)initWithProblem:(NSString *) aProblem
{
	NSUInteger idx = [[OAProblemTW validProblems] indexOfObject:aProblem];
	if (idx == NSNotFound) {
		return nil;
	}
	
	return [self initWithPointer: [[OAProblemTW validProblems] objectAtIndex:idx]];
}
	
- (id)initWithResponseBody:(NSString *) response
{
	NSArray *fields = [response componentsSeparatedByString:@"&"];
	for (NSString *field in fields) {
		if ([field hasPrefix:@"oauth_problem="]) {
			NSString *value = [[field componentsSeparatedByString:@"="] objectAtIndex:1];
			return [self initWithProblem:value];
		}
	}
	
	return nil;
}

- (void)dealloc
{
	[problem release];
	[super dealloc];
}

+ (OAProblemTW *)problemWithResponseBody:(NSString *) response
{
	return [[[OAProblemTW alloc] initWithResponseBody:response] autorelease];
}

+ (NSArray *)validProblems
{
	static NSArray *array;
	if (!array) {
		array = [[NSArray alloc] initWithObjects:signature_method_rejected1,
										parameter_absent1,
										version_rejected1,
										consumer_key_unknown1,
										token_rejected1,
										signature_invalid1,
										nonce_used1,
										timestamp_refused1,
										token_expired1,
										token_not_renewable1,
										nil];
	}
	
	return array;
}

- (BOOL)isEqualToProblem:(OAProblemTW *) aProblem
{
	return [problem isEqualToString:(NSString *)aProblem->problem];
}

- (BOOL)isEqualToString:(NSString *) aProblem
{
	return [problem isEqualToString:(NSString *)aProblem];
}

- (BOOL)isEqualTo:(id) aProblem
{
	if ([aProblem isKindOfClass:[NSString class]]) {
		return [self isEqualToString:aProblem];
	}
		
	if ([aProblem isKindOfClass:[OAProblemTW class]]) {
		return [self isEqualToProblem:aProblem];
	}
	
	return NO;
}

- (int)code {
	return [[[self class] validProblems] indexOfObject:problem];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"OAuth Problem: %@", (NSString *)problem];
}

#pragma mark class_methods

+ (OAProblemTW *)SignatureMethodRejected
{
	return [[[OAProblemTW alloc] initWithPointer:signature_method_rejected1] autorelease];
}

+ (OAProblemTW *)ParameterAbsent
{
	return [[[OAProblemTW alloc] initWithPointer:parameter_absent1] autorelease];
}

+ (OAProblemTW *)VersionRejected
{
	return [[[OAProblemTW alloc] initWithPointer:version_rejected1] autorelease];
}

+ (OAProblemTW *)ConsumerKeyUnknown
{
	return [[[OAProblemTW alloc] initWithPointer:consumer_key_unknown1] autorelease];
}

+ (OAProblemTW *)TokenRejected
{
	return [[[OAProblemTW alloc] initWithPointer:token_rejected1] autorelease];
}

+ (OAProblemTW *)SignatureInvalid
{
	return [[[OAProblemTW alloc] initWithPointer:signature_invalid1] autorelease];
}

+ (OAProblemTW *)NonceUsed
{
	return [[[OAProblemTW alloc] initWithPointer:nonce_used1] autorelease];
}

+ (OAProblemTW *)TimestampRefused
{
	return [[[OAProblemTW alloc] initWithPointer:timestamp_refused1] autorelease];
}

+ (OAProblemTW *)TokenExpired
{
	return [[[OAProblemTW alloc] initWithPointer:token_expired1] autorelease];
}

+ (OAProblemTW *)TokenNotRenewable
{
	return [[[OAProblemTW alloc] initWithPointer:token_not_renewable1] autorelease];
}
					  
@end
