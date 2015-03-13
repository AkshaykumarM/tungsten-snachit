//
//  SnachedProducts.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 2/16/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Products : NSObject
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *snachId;
@property (strong, nonatomic) NSString *productImage;
@property (nonatomic, assign) bool snachStatus;
@end
