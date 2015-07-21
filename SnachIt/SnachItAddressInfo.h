//
//  SnachItAddressInfo.h
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnachItAddressInfo : NSObject {
    int _uniqueId;
    NSString *_name;
    NSString *_street;
    NSString *_city;
    NSString *_state;
    NSString *_zip;
    NSString *_phone;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *phone;
@property(assign)BOOL selected;
- (id)initWithUniqueId:(int)uniqueId name:(NSString *)name street:(NSString*)street city:(NSString *)city state:(NSString *)state zip:(NSString *)zip phone:(NSString*)phone;

@end
