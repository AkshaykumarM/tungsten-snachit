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

-(id)initWithProductId:(NSString*)productId withBrandId:(NSString*)brandId withProductName:(NSString*)productName withBrandName:(NSString*)brandName withProductImageURL:(NSURL*)productImageURL withBrandImageURL:(NSURL*)brandImageURL  withProductPrice:(NSString*)productPrice withProductDescription:(NSString*)productDescription
{
    self = [super init];
    self.productId=productId;
    self.brandId=brandId;
    self.productName=productName;
    self.brandName=brandName;
    self.productPrice=productPrice;
    self.productDescription=productDescription;
    self.productImageURL=productImageURL;
    self.brandImageURL=brandImageURL;
    return self;
}

@end
