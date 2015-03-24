//
//  PaymentDetails.m
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "PaymentDetails.h"

@implementation PaymentDetails
@synthesize uniqueId = _uniqueId;
@synthesize name = _name;
@synthesize address=_address;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize phoneNumber = _phoneNumber;
@synthesize cardname= _cardname;
@synthesize cardnumber=_cardnumber;
@synthesize expdate=_expdate;
@synthesize cvv=_cvv;

- (id)initWithUniqueId:(int)uniqueId CardName:(NSString *)cardname CardNumber:(NSString *)cardNumber CardExpdate:(NSString *)expdate CardCVV:(int)cvv name:(NSString *)name address:(NSString *)address city:(NSString *)city state:(NSString *)state zip:(int)zip phoneNumber:(int)phoneNumber{
    
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.name = name;
        self.address=address;
        self.city = city;
        self.state = state;
        self.zip = zip;
        self.phoneNumber= phoneNumber;
        self.cardname=cardname;
        self.cardnumber=cardNumber;
        self.expdate=expdate;
        self.cvv=cvv;
        
    }
    return self;
}

- (void) dealloc
{
    self.name = nil;
    self.city = nil;
    self.state = nil;
    self.address = nil;
    self.cardname=nil;
    self.cardnumber=nil;
    self.expdate=nil;
    [super dealloc];
}

@end
