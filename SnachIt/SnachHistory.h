//
//  SnachHistory.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/16/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const HISTORY_PRODUCT_NAME;
extern NSString * const HISTORY_PRODUCT_BRAND_NAME;
extern NSString * const HISTORY_PRODUCT_ORDERDATE;
extern NSString * const HISTORY_PRODUCT_DELIVERYDATE;
extern NSString * const HISTORY_PRODUCT_IMAGE;
extern NSString * const HISTORY_PRODUCT_STATUS;
extern NSString * const HISTORY_INFLIGHT;
extern NSString * const HISTORY_DELIVERED;
extern NSString * const HISTORY_ALL;


@interface SnachHistory : NSObject
@property (strong, nonatomic) NSString *productImageUrl;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productBrandName;
@property (strong, nonatomic) NSString *productOrderedDate;
@property (strong, nonatomic) NSString *productDeliveryDate;
@property (strong, nonatomic) NSString *statusIcon;
@property (strong, nonatomic) NSString *productstatus;
@end
