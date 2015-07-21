//
//  SnachHistory.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/16/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>
#define HISTORY_PRODUCT_NAME @"productName"
#define HISTORY_PRODUCT_NAME @"productName"
#define HISTORY_PRODUCT_BRAND_NAME @"brandName"
#define HISTORY_PRODUCT_ORDERDATE @"dateOrdered"
#define HISTORY_PRODUCT_DELIVERYDATE @"deliveryDate"
#define HISTORY_PRODUCT_IMAGE @"productImage"
#define HISTORY_PRODUCT_STATUS @"status"
#define HISTORY_INFLIGHT @"inflight"
#define HISTORY_DELIVERED @"delivered"
#define HISTORY_ALL @"all"
#define HISTORY_TRACKING_NO @"trackingNumber"
#define HISTORY_SLUG @"slug"

@interface SnachHistory : NSObject
@property (strong, nonatomic) NSString *productImageUrl;
@property (strong, nonatomic) NSString *productName;
@property (strong, nonatomic) NSString *productBrandName;
@property (strong, nonatomic) NSString *productOrderedDate;
@property (strong, nonatomic) NSString *productDeliveryDate;
@property (strong, nonatomic) NSString *statusIcon;
@property (strong, nonatomic) NSString *productstatus;
@property (strong, nonatomic) NSString *trackingNo;
@property (strong, nonatomic) NSString *slug;
@end
