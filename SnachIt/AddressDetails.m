//
//  AddressDetails.m
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "AddressDetails.h"

@implementation AddressDetails
@synthesize uniqueId = _uniqueId;
@synthesize name = _name;
@synthesize address=_address;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip = _zip;
@synthesize phoneNumber = _phoneNumber;


- (id)initWithUniqueId:(int)uniqueId name:(NSString *)name address:(NSString *)address city:(NSString *)city state:(NSString *)state zip:(int)zip phoneNumber:(int)phoneNumber{
    
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.name = name;
        self.address=address;
        self.city = city;
        self.state = state;
        self.zip = zip;
        self.phoneNumber= phoneNumber;
        
    }
    return self;
}

- (void) dealloc
{
    self.name = nil;
    self.city = nil;
    self.state = nil;
    self.address = nil;
    [super dealloc];
}

@end
