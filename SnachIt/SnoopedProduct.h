//
//  SnoopedProduct.h
//  SnachIt
//
//  Created by Akshay Maldhure on 1/23/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnoopedProduct : NSObject
@property (nonatomic,strong) NSString *productId;
@property (nonatomic,strong) NSString *brandId;
@property (nonatomic,strong) NSString *snachId;
@property (nonatomic,strong) NSString *productName;
@property (nonatomic,strong) NSString *brandName;
@property (nonatomic,strong) NSData *productImageData;
@property (nonatomic,strong) NSData *brandImageData;
@property (nonatomic,strong) NSString *productPrice;
@property (nonatomic,strong) NSString *productDescription;
@property (nonatomic,strong) NSURL *brandImageURL;
@property (nonatomic,strong) NSURL *productImageURL;
@property (nonatomic,strong) NSString *productSalesTax;
@property (nonatomic,strong) NSString *productShippingCost;
@property (nonatomic,strong) NSString *productShippingSpeed;

+ (SnoopedProduct *)sharedInstance;


-(id)initWithProductId:(NSString*)productId withBrandId:(NSString*)brandId withSnachId:(NSString*)snachId withProductName:(NSString*)productName withBrandName:(NSString*)brandName withProductImageURL:(NSURL*)productImageURL withBrandImageURL:(NSURL*)brandImageURL  withProductPrice:(NSString*)productPrice withProductDescription:(NSString*)productDescription withProductSalesTax:(NSString*)salesTax withProductShippingCost:(NSString*)shippingCost withProductShippingSpeed:(NSString*)shippingSpeed;

@end
