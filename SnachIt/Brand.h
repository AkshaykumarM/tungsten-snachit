//
//  Brand.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 2/19/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Brand : NSObject
@property (strong, nonatomic) NSString *brandId;
@property (strong, nonatomic) NSString *brandName;
@property (strong, nonatomic) NSString *brandImg;
@property (strong, nonatomic) NSArray *products;
@end
