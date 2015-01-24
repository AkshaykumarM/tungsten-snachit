//
//  Order.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/24/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "Order.h"

@implementation Order

+ (Order *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)initWithUserId:(NSString*)userId withProductId:(NSString*)productId withOrderQuantity:(NSString*)orderQuantity withSubTotal:(NSString*)subTotal withOrderTotal:(NSString*)orderTotal withShippingAndHandling:(NSString*)shippingAndHandling withSalesTax:(NSString*)salesTax withSpeed:(NSString*)speed withShippingCost:(NSString*)shippingCost withOrderDate:(NSString*)orderDate withDeliveryDate:(NSString*)deliveryDate{
    self = [super init];
    self.userId=userId;
    self.productId=productId;
    self.orderQuantity=orderQuantity;
    self.subTotal=subTotal;
    self.orderTotal=orderTotal;
    self.shippingAndHandling=shippingAndHandling;
    self.salesTax=salesTax;
    self.speed=speed;
    self.shippingCost=shippingCost;
    self.orderDate=orderDate;
    self.deliveryDate=deliveryDate;
    
    return self;
}


@end
