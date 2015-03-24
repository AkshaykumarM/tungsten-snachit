//
//  FriendSnachs.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/16/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const FRIEND_NAME;
extern NSString * const FRIEND_IMAGE;
extern NSString * const FRIEND_SNACHS;
@interface FriendSnachs : NSObject
@property (strong, nonatomic) NSString *friendName;
@property (strong, nonatomic) NSString *freindProfilePic;
@property (strong, nonatomic) NSArray *snachedProducts;
@end
