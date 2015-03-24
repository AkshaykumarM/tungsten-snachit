//
//  Order.m
//  SnachIt
//
//  Created by Akshay Maldhure on 1/24/15.
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

-(id)initWithUserId:(NSString*)userId withProductId:(NSString*)productId withSnachId:(NSString*)snachId withEmailId:(NSString*)emailId withOrderQuantity:(NSString*)orderQuantity withSubTotal:(NSString*)subTotal withOrderTotal:(NSString*)orderTotal withShippingCost:(NSString*)shippingCost withFreeShipping:(NSString*)freeShipping withSalesTax:(NSString*)salesTax withSpeed:(NSString*)speed withOrderDate:(NSString*)orderDate withDeliveryDate:(NSString*)deliveryDate withFixedSt:(NSString*)fixedSt;{
    self = [super init];
    self.userId=userId;
    self.productId=productId;
    self.snachId=snachId;
    self.emailId=emailId;
    self.orderQuantity=orderQuantity;
    self.subTotal=subTotal;
    self.orderTotal=orderTotal;
    self.salesTax=salesTax;
    self.shippingCost=shippingCost;
    self.freeshipping=freeShipping;
    self.speed=speed;
    self.orderDate=orderDate;
    self.deliveryDate=deliveryDate;
    self.st=fixedSt;
    return self;
}

-(NSDictionary*)getOrderDetails{

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    NSDate *orderDate = [[NSDate alloc] init];
    NSDate *deliveryDate = [[NSDate alloc] init];
    [df setDateFormat:@"dd/MM/yy"];
    orderDate=[df dateFromString:self.orderDate];
    deliveryDate=[df dateFromString:self.deliveryDate];
    [df setDateFormat:@"yyyy-MM-dd"];
     NSDictionary *orderDetails=@{@"userId":self.userId,@"productId": self.productId,@"snachId": self.snachId,@"userEmail":self.emailId,@"orderQunatity":self.orderQuantity,@"subTotal":self.subTotal,@"orderTotal":self.orderTotal,@"salesTax": self.salesTax,@"speed":self.speed,@"shippingCost":self.shippingCost,@"orderDate":[df stringFromDate:orderDate],@"deliveryDate":[df stringFromDate:deliveryDate]};
    return orderDetails;
}

@end
