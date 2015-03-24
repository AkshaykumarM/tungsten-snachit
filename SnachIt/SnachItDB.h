//
//  SnachItDB.h
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"

@class AddressDetails,PaymentDetails;
@interface SnachItDB : NSObject{
    sqlite3 *_database;
}

+ (SnachItDB*)database;
- (NSArray *)snachItAddressInfo;
- (NSArray *)snachItPaymentInfo;
- (AddressDetails *)snachItAddressDetails:(int)uniqueId;
- (PaymentDetails *)snachItPaymentDetails:(int)uniqueId;
- (NSDictionary*)addPayment:(NSString*)cardName CardNumber:(NSString*)cardNumber CardExpDate:(NSString*)expdate CardCVV:(NSString*)cvv Name:(NSString*)name Street:(NSString*)street City:(NSString*)city State:(NSString*)state Zip:(NSString*)zip Phone:(NSString*)phone;
- (NSDictionary*)addAddress:(NSString*)name Street:(NSString*)street City:(NSString*)city State:(NSString*)state Zip:(NSString*)zip Phone:(NSString*)phone;
-(void)copyDatabaseIntoDocumentsDirectory;
-(int)getSnachTime:(int)snachid UserId:(NSString*)userId SnoopTime:(int)snooptime;
-(BOOL)logtime:(NSString*)userid SnachId:(int)snachid SnachTime:(int)time;
-(BOOL)updatetime:(NSString*)userid SnachId:(int)snachid SnachTime:(int)time;
@end
