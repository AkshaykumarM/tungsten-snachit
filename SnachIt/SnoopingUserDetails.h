//
//  SnoopingUserDetails.h
//  SnachIt
//
//  Created by Akshay Maldhure on 1/24/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SnoopingUserDetails : NSObject
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *shipFullName;
@property (nonatomic,strong) NSString *shipStreetName;
@property (nonatomic,strong) NSString *shipCity;
@property (nonatomic,strong) NSString *shipState;
@property (nonatomic,strong) NSString *shipZipCode;
@property (nonatomic,strong) NSString *shipPhoneNumber;


@property (nonatomic,strong) NSString *paymentCardName;
@property (nonatomic,strong) NSString *paymentCardNumber;
@property (nonatomic,strong) NSString *paymentCardExpDate;
@property (nonatomic,strong) NSString *paymentCardCVV;
@property (nonatomic,strong) NSString *paymentFullName;
@property (nonatomic,strong) NSString *paymentStreetName;
@property (nonatomic,strong) NSString *paymentCity;
@property (nonatomic,strong) NSString *paymentState;
@property (nonatomic,strong) NSString *paymentZipCode;
@property (nonatomic,strong) NSString *paymentPhoneNumber;

+(SnoopingUserDetails*)sharedInstance;


-(id)initWithUserId:(NSString*)userId withShipFullName:(NSString*)shipFullName withShipStreetName:(NSString*)shipStreetname withShipCity:(NSString*)shipCity withShipState:(NSString*)shipState withShipZipCode:(NSString*)shipZipCode withShipPhoneNumber:(NSString*)shipPhoneNumber;

-(id)initWithPaymentCardName:(NSString*)paymentCardName withPaymentCardNumber:(NSString*)paymentCardNumber withpaymentCardExpDate:(NSString*)paymentCardExpDate withPaymentCardCvv:(NSString*)paymentCardCVV withPaymentFullName:(NSString*)paymentFullName withPaymentStreetName:(NSString*)paymentStreetname withPaymentCity:(NSString*)paymentCity withPaymentState:(NSString*)paymentState withPaymentZipCode:(NSString*)paymentZipCode withPaymentPhoneNumber:(NSString*)paymentPhoneNumber;

-(NSDictionary*)getUserShippingDetails;
-(NSDictionary*)getUserBillingDetails;
-(NSDictionary*)getUserCreditCardDetails;
@end
