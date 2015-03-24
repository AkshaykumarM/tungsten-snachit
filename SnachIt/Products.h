//
//  SnachedProducts.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/16/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const PRODUCTS_ID;
extern NSString * const PRODUCTS_SNACHID;
extern NSString * const PRODUCTS_IMAGE;
extern NSString * const PRODUCTS_SNACHSTATUS;

@interface Products : NSObject
@property (strong, nonatomic) NSString *productId;
@property (strong, nonatomic) NSString *snachId;
@property (strong, nonatomic) NSString *productImage;
@property (nonatomic, assign) bool snachStatus;
@end
