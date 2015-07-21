//
//  Brand.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/19/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>
 #define BRAND_BRANDID @"brandId"
 #define BRAND_BRANDNAME @"brandName"
 #define BRAND_BRANDIMAGE @"brandImage"
 #define BRAND_BRANDPRODUCTS @"products"
@interface Brand : NSObject

@property (strong, nonatomic) NSString *brandId;
@property (strong, nonatomic) NSString *brandName;
@property (strong, nonatomic) NSString *brandImg;
@property (strong, nonatomic) NSArray *products;
@end
