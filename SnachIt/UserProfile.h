//
//  UserProfile.h
//  SnachIt
//
//  Created by Akshay Maldhure on 1/23/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *emailID;
@property (nonatomic,strong) NSURL *profilePicUrl;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *fullName;
@property (nonatomic,strong) NSString *dateOfBirth;
@property (nonatomic,strong) NSString *joiningDate;
extern NSString * twUserId;
extern NSString * twFullname;
extern NSString * twProfilePic;
/*
This instance will be used to access currently logged in user info*/
+ (UserProfile *)sharedInstance;


-(id)initWithUserId:(NSString*)userId withUserName:(NSString*)username withEmailId:(NSString*)emailId withProfilePicURL:(NSURL*)profilePicURL withPhoneNumber:(NSString*)phoneNumber withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withFullName:(NSString*)fullName withDateOfBirth:(NSString*)dateOfBirth withJoiningDate:(NSString*)joiningDate;

-(NSString*)getUserId;
@end
