//
//  RegexValidator.h
//  SnachIt
//
//  Created by Akshay Maldhure on 3/9/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegexValidator : NSObject
extern NSString * const VISA ;
extern NSString * const MASTERCARD;
extern NSString * const AMEX;
extern NSString * const DINNERSCLUB;
extern NSString * const DISCOVER;
extern NSString * const EMAIL_REGEX;

extern NSString * const REGEX_USERNAME;
extern NSString * const REGEX_ZIP_CODE;
extern NSString * const REGEX_CVV;
extern NSString * const REGEX_PHONE_DEFAULT;
extern NSString * const REGEX_CREDIT_CARD_NO;
extern NSString * const REGEX_EXPDATE;
@end
