//
//  UserProfile.m
//  SnachIt
//
//  Created by Akshay Maldhure on 1/23/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile
NSString * twUserId;
NSString * twFullname;
NSString * twProfilePic;

+ (UserProfile *)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(id)initWithUserId:(NSString*)userId withUserName:(NSString*)username withEmailId:(NSString*)emailId withProfilePicURL:(NSURL*)profilePicURL withPhoneNumber:(NSString*)phoneNumber withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withFullName:(NSString*)fullName withJoiningDate:(NSString*)joiningDate withSharingURL:(NSURL*)sharingURL withSnoopTime:(int)snoopTime withAppAlerts:(int)appAlerts withEmailAlerts:(int)emailAlerts withSMSAlerts:(int)smsAlerts withBackgroundURL:(NSURL*)backgroundURL
{
    self = [super init];
    self.userID=userId;
    self.username=username;
    self.emailID=emailId;
    self.profilePicUrl=profilePicURL;
    self.phoneNumber=phoneNumber;
    self.firstName=firstName;
    self.lastName=lastName;
    self.fullName=fullName;
    self.joiningDate=joiningDate;
    self.sharingURL=sharingURL;
    self.snoopTime=snoopTime;
    self.isappAlertsOn=appAlerts;
    self.isemailAlertsOn=emailAlerts;
    self.issmsAlertsOn=smsAlerts;
    self.backgroundUrl=backgroundURL;
    return self;
}

-(NSString*)getUserId{
    return self.userID;
}

@end
