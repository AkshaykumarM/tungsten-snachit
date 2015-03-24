//
//  SnoopingUserDetails.m
//  SnachIt
//
//  Created by Akshay Maldhure on 1/24/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "SnoopingUserDetails.h"

@implementation SnoopingUserDetails
+ (SnoopingUserDetails *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


-(id)initWithUserId:(NSString*)userId withShipFullName:(NSString*)shipFullName withShipStreetName:(NSString*)shipStreetname withShipCity:(NSString*)shipCity withShipState:(NSString*)shipState withShipZipCode:(NSString*)shipZipCode withShipPhoneNumber:(NSString*)shipPhoneNumber{
    
    self = [super init];
    self.userId=userId;
    self.shipFullName=shipFullName;
    self.shipStreetName=shipStreetname;
    self.shipCity=shipCity;
    self.shipState=shipState;
    self.shipZipCode=shipZipCode;
    self.shipPhoneNumber=shipPhoneNumber;
    return self;
    
}

-(id)initWithPaymentCardName:(NSString*)paymentCardName withPaymentCardNumber:(NSString*)paymentCardNumber withpaymentCardExpDate:(NSString*)paymentCardExpDate  withPaymentCardCvv:(NSString*)paymentCardCVV withPaymentFullName:(NSString*)paymentFullName withPaymentStreetName:(NSString*)paymentStreetname withPaymentCity:(NSString*)paymentCity withPaymentState:(NSString*)paymentState withPaymentZipCode:(NSString*)paymentZipCode withPaymentPhoneNumber:(NSString*)paymentPhoneNumber{
    self = [super init];
    
    self.paymentCardName=paymentCardName;
    self.paymentCardNumber=paymentCardNumber;
    self.paymentCardExpDate=paymentCardExpDate;
    self.paymentCardCVV=paymentCardCVV;
    self.paymentFullName=paymentFullName;
    self.paymentStreetName=paymentStreetname;
    self.paymentCity=paymentCity;
    self.paymentState=paymentState;
    self.paymentZipCode=paymentZipCode;
    self.paymentPhoneNumber=paymentPhoneNumber;
    return self;

}

-(NSDictionary*)getUserShippingDetails{
      NSDictionary *shippingDetails=@{@"fullName":self.shipFullName,@"streetName": self.shipStreetName,@"city":self.shipCity,@"state":self.shipState,@"zip":self.shipZipCode,@"phoneNumber":self.shipPhoneNumber};
    return shippingDetails;
}

-(NSDictionary*)getUserBillingDetails{
    NSDictionary *shippingDetails=@{@"fullName":self.paymentFullName,@"streetName": self.paymentStreetName,@"city":self.paymentCity,@"state":self.paymentState,@"zip":self.paymentZipCode,@"phoneNumber":self.paymentPhoneNumber};
    return shippingDetails;
}

-(NSDictionary*)getUserCreditCardDetails{
    NSDictionary *creditCardDetails=@{@"cardName":self.paymentCardName,@"cardNumber": self.paymentCardNumber ,@"cardExpDate":self.paymentCardExpDate,@"cardCVV":self.paymentCardCVV};

return creditCardDetails;
}
@end
