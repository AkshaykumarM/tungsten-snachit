//
//  Product.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/13/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const PRODUCT_IMAGES;
extern NSString * const PRODUCT_NAME;
extern NSString * const PRODUCT_BRAND_NAME;
extern NSString * const PRODUCT_PRICE;
extern NSString * const PRODUCT_BRAND_IMAGE;
extern NSString * const PRODUCT_IMAGE;
extern NSString * const PRODUCT_BRAND_ID;
extern NSString * const PRODUCT_ID;
extern NSString * const PRODUCT_SNACH_ID;
extern NSString * const PRODUCT_DESCRIPTION;
extern NSString * const PRODUCT_FOLLOW_STATUS;
extern NSString * const PRODUCT_SALESTAX;
extern NSString * const PRODUCT_SHIPPINGCOST;
extern NSString * const PRODUCT_SHIPPINGSPEED;
extern NSString * const PRODUCT_SNACH_STATUS;
@interface Product : NSObject

@property (strong, nonatomic) NSArray *productImages;
@property (strong, nonatomic) NSString *productname;
@property (strong, nonatomic) NSString *brandname ;
@property (strong, nonatomic) NSString *price ;
@property (strong, nonatomic) NSString *brandimage;
@property (strong, nonatomic) NSString *productImage;
@property (strong, nonatomic) NSString *brandId;
@property (strong, nonatomic) NSString *productId ;
@property (strong, nonatomic) NSString *snachId ;
@property (nonatomic,assign) int snooptime ;
@property (strong,nonatomic) NSString *salesTax;
@property (strong,nonatomic) NSString *shippingPrice;
@property (strong,nonatomic) NSString *speed;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *followStatus ;
@property (strong, nonatomic) NSString *friendCount ;
@property (nonatomic,assign) bool status;
@end
