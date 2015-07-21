//
//  Trackings.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 4/24/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Checkpoints : NSObject
@property (strong, nonatomic) NSString *slug;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *created_at;
@property (strong, nonatomic) NSString *country_name;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *country_iso3;
@property (strong, nonatomic) NSString *tag;
@property (strong, nonatomic) NSString *checkpoint_time;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zip;
@end
