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
- (NSArray *)snachItAddressInfo:(NSString*)userid;
- (NSArray *)snachItPaymentInfo:(NSString*)userid;
- (AddressDetails *)snachItAddressDetails:(int)uniqueId UserId:(NSString*)userid;
- (PaymentDetails *)snachItPaymentDetails:(int)uniqueId UserId:(NSString*)userid;
- (NSDictionary*)addPayment:(NSString*)cardName CardNumber:(NSString*)cardNumber CardExpDate:(NSString*)expdate CardCVV:(NSString*)cvv Name:(NSString*)name Street:(NSString*)street City:(NSString*)city State:(NSString*)state Zip:(NSString*)zip Phone:(NSString*)phone UserId:(NSString*)userid;
- (NSDictionary*)addAddress:(NSString*)name Street:(NSString*)street City:(NSString*)city State:(NSString*)state Zip:(NSString*)zip Phone:(NSString*)phone UserId:(NSString*)userid;
-(void)copyDatabaseIntoDocumentsDirectory;
-(int)getSnachTime:(int)snachid UserId:(NSString*)userId SnoopTime:(int)snooptime;
-(BOOL)logtime:(NSString*)userid SnachId:(int)snachid SnachTime:(int)time;
-(BOOL)updatetime:(NSString*)userid SnachId:(int)snachid SnachTime:(int)time;
-(BOOL)deleteRecordFromPayment:(int)uniqueId Userid:(NSString*)userid;
-(BOOL)deleteRecordFromAddress:(int)uniqueId Userid:(NSString*)userid;
-(NSDictionary*)updateAddress:(NSString*)name Street:(NSString*)street City:(NSString*)city State:(NSString*)state Zip:(NSString*)zip Phone:(NSString*)phone UserId:(NSString*)userid RecordId:(NSString *)recordid;

-(NSDictionary*)updatePayment:(NSString *)cardName CardNumber:(NSString *)cardNumber CardExpDate:(NSString *)expdate CardCVV:(NSString *)cvv Name:(NSString *)name Street:(NSString *)street City:(NSString *)city State:(NSString *)state Zip:(NSString *)zip Phone:(NSString *)phone UserId:(NSString*)userid RecordId:(NSString*)recordId;
@end
