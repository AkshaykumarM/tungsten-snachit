//
//  Order.h
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/24/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *productId;
@property (nonatomic,strong) NSString *snachId;
@property (nonatomic,strong) NSString *emailId;
@property (nonatomic,strong) NSString *orderQuantity;
@property (nonatomic,strong) NSString *subTotal;
@property (nonatomic,strong) NSString *orderTotal;
@property (nonatomic,strong) NSString *shippingAndHandling;
@property (nonatomic,strong) NSString *salesTax;
@property (nonatomic,strong) NSString *speed;
@property (nonatomic,strong) NSString *shippingCost;
@property (nonatomic,strong) NSString *orderDate;
@property (nonatomic,strong) NSString *deliveryDate;


+(Order*)sharedInstance;

-(id)initWithUserId:(NSString*)userId withProductId:(NSString*)productId withSnachId:(NSString*)snachId withEmailId:(NSString*)emailId withOrderQuantity:(NSString*)orderQuantity withSubTotal:(NSString*)subTotal withOrderTotal:(NSString*)orderTotal withShippingAndHandling:(NSString*)shippingAndHandling withSalesTax:(NSString*)salesTax withSpeed:(NSString*)speed withShippingCost:(NSString*)shippingCost withOrderDate:(NSString*)orderDate withDeliveryDate:(NSString*)deliveryDate;

-(NSDictionary*)getOrderDetails;
@end
