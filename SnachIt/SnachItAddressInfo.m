//
//  SnachItAddressInfo.m
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "SnachItAddressInfo.h"

@implementation SnachItAddressInfo
@synthesize uniqueId = _uniqueId;
@synthesize name = _name;
@synthesize street=_street;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zip=_zip;
@synthesize phone=_phone;

- (id)initWithUniqueId:(int)uniqueId name:(NSString *)name street:(NSString *)street city:(NSString *)city state:(NSString *)state zip:(int)zip phone:(NSString*)phone {
    if ((self = [super init])) {
        self.uniqueId = uniqueId;
        self.name = name;
        self.street=street;
        self.city = city;
        self.state = state;
        self.zip=zip;
        self.phone=phone;
    }
    return self;
}

- (void) dealloc {
    self.name = nil;
    self.city = nil;
    self.state = nil;
    self.street=nil;
    self.phone=nil;
    [super dealloc];
}

@end
