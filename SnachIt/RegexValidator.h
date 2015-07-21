//
//  RegexValidator.h
//  SnachIt
//
//  Created by Akshay Maldhure on 3/9/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegexValidator : NSObject
#define VISA @"^4[0-9]{12}(?:[0-9]{3})?$"
#define MASTERCARD @"^5[1-5][0-9]{14}$"
#define AMEX @"^3[47][0-9]{13}$"
#define DINNERSCLUB @"^3(?:0[0-5]|[68][0-9])[0-9]{11}$"
#define DISCOVER @"^6(?:011|5[0-9]{2})[0-9]{12}$"
#define EMAIL_REGEX @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

#define REGEX_USERNAME @"[a-zA-Z\\s]{3,50}"
#define REGEX_CITY  @"[a-zA-Z\\s]{2,30}"
#define REGEX_STATE  @"[A-Z]{2}"
#define REGEX_ZIP_CODE @"^([0-9]{5})(?:[-\\s]*([0-9]{4}))?$"
#define REGEX_CVV @"^[0-9]{3,4}$"
#define REGEX_PHONE_DEFAULT @"([1-9][0-9]{9})||([1-9][0-9]{9})"
#define REGEX_CREDIT_CARD_NO @"^(?:\\d[ -]?){12,18}\\d$"
#define REGEX_EXPDATE @"^(0[1-9]|1[0-2])\\/?([0-9]{4}|[0-9]{2})$"
#define REGEX_ADDRESS @"[A-Za-z0-9'\\.\\-\\s\\,\\/]{5,150}"
#define REGEX_NAME @"[a-zA-Z\\s]{3,25}"
#define REGEX_EMAIL @"[A-Z0-9a-z._%+-]{3,}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"

#define ERROR_USERNAME @"Please enter valid name"
#define ERROR_CITY @"Please enter valid city"
#define ERROR_STATE @"Please enter valid state"
#define ERROR_ZIPCODE @"Please enter valid zip code"
#define ERROR_CVV @"Please enter valid cvv"
#define ERROR_PHONE @"Please enter valid phone no"
#define ERROR_CREDITCARD @"Please enter valid card no"
#define ERROR_EXPDATE @"Please enter valid date"
#define ERROR_EMAILID @"Please enter valid mail id"
#define EROOR_ADDRESS @"Please enter valid address"
#define ERROR_EXPDATE @"Please enter valid date"
#define EROOR_FIRSTNAME @"Please enter valid first name"
#define EROOR_LASTNAME @"Please enter valid last name"

@end
