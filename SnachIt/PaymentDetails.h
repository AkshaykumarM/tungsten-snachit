//
//  PaymentDetails.h
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentDetails : NSObject{
    int _uniqueId;
    NSString *_name;
    NSString *_address;
    NSString *_city;
    NSString *_state;
    int _zip;
    int _phoneNumber;
    NSString *_cardname;
    NSString *_cardnumber;
    NSString *_expdate;
    int _cvv;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, assign) int zip;
@property (nonatomic, assign) int phoneNumber;
@property (nonatomic, copy) NSString *cardname;
@property (nonatomic, copy) NSString *cardnumber;
@property (nonatomic, copy) NSString *expdate;
@property (nonatomic, assign) int cvv;

- (id)initWithUniqueId:(int)uniqueId CardName:(NSString*)cardname CardNumber:(NSString*)cardNumber CardExpdate:(NSString*)expdate CardCVV:(int)cvv name:(NSString *)name address:(NSString *)address city:(NSString *)city state:(NSString *)state zip:(int)zip phoneNumber:(int)phoneNumber;
@end
