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

-(id)initWithUserId:(NSString*)userId withProductId:(NSString*)productId withSnachId:(NSString*)snachId withEmailId:(NSString*)emailId withOrderQuantity:(NSString*)orderQuantity withSubTotal:(NSString*)subTotal withOrderTotal:(NSString*)orderTotal withShippingAndHandling:(NSString*)shippingAndHandling withSalesTax:(NSString*)salesTax withSpeed:(NSString*)speed withShippingCost:(NSString*)shippingCost withOrderDate:(NSString*)orderDate withDeliveryDate:(NSString*)deliveryDate{
    self = [super init];
    self.userId=userId;
    self.productId=productId;
    self.snachId=snachId;
    self.emailId=emailId;
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
-(NSDictionary*)getOrderDetails{
     NSDictionary *orderDetails=@{@"userId":self.userId,@"productId": self.productId,@"snachId": self.snachId,@"userEmail":self.emailId,@"orderQunatity":self.orderQuantity,@"subTotal":self.subTotal,@"orderTotal":self.orderTotal,@"shippingAndHandling":self.shippingAndHandling,@"salesTax": self.salesTax,@"speed":self.speed,@"shippingCost":self.shippingCost,@"orderDate":self.orderDate,@"deliveryDate":self.deliveryDate};
    return orderDetails;
}

@end
