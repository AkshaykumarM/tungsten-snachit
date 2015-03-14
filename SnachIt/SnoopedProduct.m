//
//  SnoopedProduct.m
//  SnachIt
//
//  Created by Akshay Maldhure on 1/23/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "SnoopedProduct.h"

@implementation SnoopedProduct
+ (SnoopedProduct *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)initWithProductId:(NSString*)productId withBrandId:(NSString*)brandId withSnachId:(NSString*)snachId withProductName:(NSString*)productName withBrandName:(NSString*)brandName withProductImageURL:(NSURL*)productImageURL withBrandImageURL:(NSURL*)brandImageURL  withProductPrice:(NSString*)productPrice withProductDescription:(NSString*)productDescription withProductSalesTax:(NSString*)salesTax withProductShippingCost:(NSString*)shippingCost withProductShippingSpeed:(NSString*)shippingSpeed
{
    self = [super init];
    self.productId=productId;
    self.brandId=brandId;
    self.snachId=snachId;
    self.productName=productName;
    self.brandName=brandName;
    self.productPrice=productPrice;
    self.productDescription=productDescription;
    self.productImageURL=productImageURL;
    self.brandImageURL=brandImageURL;
    self.productSalesTax=salesTax;
    self.productShippingCost=shippingCost;
    self.productShippingSpeed=shippingSpeed;
    return self;
}

@end
