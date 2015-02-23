//
//  Product.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 2/13/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *followStatus ;
@property (strong, nonatomic) NSString *friendCount ;
@end
