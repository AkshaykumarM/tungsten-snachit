//
//  RegexValidator.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 3/9/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "RegexValidator.h"

@implementation RegexValidator
NSString * const VISA = @"^4[0-9]{12}(?:[0-9]{3})?$";
NSString * const MASTERCARD=@"^5[1-5][0-9]{14}$";
NSString * const AMEX=@"^3[47][0-9]{13}$";
NSString * const DINNERSCLUB=@"^3(?:0[0-5]|[68][0-9])[0-9]{11}$";
NSString * const DISCOVER=@"^6(?:011|5[0-9]{2})[0-9]{12}$";
NSString * const EMAIL_REGEX=@"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

NSString * const REGEX_USERNAME= @"[a-zA-Z\\s]*";
NSString * const REGEX_ZIP_CODE=@"^([0-9]{5})(?:[-\\s]*([0-9]{4}))?$";
NSString * const REGEX_CVV=@"^[0-9]{3,4}$";
NSString * const REGEX_PHONE_DEFAULT=@"^[(]{0,1}[0-9]{3}[)]{0,1}[-\\s\\.]{0,1}[0-9]{3}[-\\s\\.]{0,1}[0-9]{4}$";
NSString * const REGEX_CREDIT_CARD_NO=@"^(?:\\d[ -]?){12,18}\\d$";
NSString * const REGEX_EXPDATE=@"^(0[1-9]|1[0-2])\\/?([0-9]{4}|[0-9]{2})$";
@end
