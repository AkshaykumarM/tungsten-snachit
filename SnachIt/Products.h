//
//  SnachedProducts.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/16/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>
 #define PRODUCTS_ID @"productId"
 #define PRODUCTS_SNACHID @"snach_id"
 #define PRODUCTS_IMAGE @"productImg"
 #define PRODUCTS_SNACHSTATUS @"status"

@interface Products : NSObject
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *snachId;
@property (strong, nonatomic) NSString *productImage;
@property (nonatomic, assign) bool snachStatus;
@end
