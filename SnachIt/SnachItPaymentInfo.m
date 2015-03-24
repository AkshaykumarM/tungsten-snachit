//
//  SnachItPaymentInfo.m
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "SnachItPaymentInfo.h"

@implementation SnachItPaymentInfo
@synthesize uniqueId = _uniqueId;
@synthesize name = _name;
@synthesize street=_street;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip=_zip;
@synthesize phone=_phone;
@synthesize cardname=_cardname;
@synthesize cardnumber=_cardnumber;
@synthesize cardexpdate=_cardexpdate;
@synthesize cvv=_cvv;

- (id)initWithUniqueId:(int)uniqueId CardName:(NSString *)cardname CardNumber:(NSString *)cardNumber CardExpDate:(NSString *)expdate CardCVV:(int)cardcvv name:(NSString *)name street:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(int)zip phone:(NSString*)phone {
    if ((self = [super init])) {
        
        self.uniqueId = uniqueId;
        self.name = name;
        self.street=street;
        self.city = city;
        self.state = state;
        self.zip=zip;
        self.phone=phone;
        self.cardname=cardname;
        self.cardnumber=cardNumber;
        self.cardexpdate=expdate;
        self.cvv=cardcvv;
    }
    return self;
}

- (void) dealloc {
    self.name = nil;
    self.city = nil;
    self.state = nil;
    self.street=nil;
    self.cardname=nil;
    self.cardnumber=nil;
    self.cardexpdate=nil;
    [super dealloc];
}


@end
