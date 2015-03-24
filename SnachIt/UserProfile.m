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

-(id)initWithUserId:(NSString*)userId withUserName:(NSString*)username withEmailId:(NSString*)emailId withProfilePicURL:(NSURL*)profilePicURL withPhoneNumber:(NSString*)phoneNumber withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withFullName:(NSString*)fullName withDateOfBirth:(NSString*)dateOfBirth withJoiningDate:(NSString*)joiningDate withSharingURL:(NSURL *)sharingURL withSnoopTime:(int)snoopTime
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
    self.dateOfBirth=dateOfBirth;
    self.joiningDate=joiningDate;
    self.sharingURL=sharingURL;
    self.snoopTime=snoopTime;
    return self;
}

-(NSString*)getUserId{
    return self.userID;
}

@end
