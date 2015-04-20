//
//  SnachItPaymentInfo.h
//  SnachIt
//
//  Created by Akshay Maldhure on 3/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnachItPaymentInfo : NSObject {
    int _uniqueId;
    NSString *_name;
    NSString *_street;
    NSString *_city;
    NSString *_state;
    NSString *_zip;
    NSString *_phone;
    NSString *_cardname;
    NSString *_cardnumber;
    NSString *_cardexpdate;
    int cvv;
}

@property (nonatomic, assign) int uniqueId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *zip;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *cardname;
@property (nonatomic, copy) NSString *cardnumber;
@property (nonatomic, copy) NSString *cardexpdate;
@property (nonatomic, assign) int cvv;

- (id)initWithUniqueId:(int)uniqueId CardName:(NSString*)cardname CardNumber:(NSString*)cardNumber CardExpDate:(NSString*)expdate CardCVV:(int)cardcvv name:(NSString *)name street:(NSString*)street city:(NSString *)city state:(NSString *)state zip:(NSString *)zip phone:(NSString*)phone;


@end
