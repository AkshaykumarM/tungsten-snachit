//
//  AddressDetails.h
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressDetails : NSObject {
    int _uniqueId;
    NSString *_name;
    NSString *_address;
    NSString *_city;
    NSString *_state;
    NSString *_zip;
    NSString *_phoneNumber;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *phoneNumber;

-(id)initWithUniqueId:(int)uniqueId name:(NSString *)name address:(NSString *)address city:(NSString *)city state:(NSString *)state zip:(NSString *)zip phoneNumber:(NSString *)phoneNumber;

@end
