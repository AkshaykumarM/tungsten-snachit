//
//  UserProfile.h
//  SnachIt
//
//  Created by Akshay Maldhure on 1/23/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULTPLACEHOLDER @"userIcon.png"
#define MEMBER_SINCE @"Member since "
#define DEFAULTBACKGROUNDIMG @"defbackimg.png"
@interface UserProfile : NSObject
@property (nonatomic,strong) NSString *userID;
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *emailID;
@property (nonatomic,strong) NSURL *profilePicUrl;
@property (nonatomic,strong) NSURL *backgroundUrl;
@property (nonatomic,strong) NSString *phoneNumber;
@property (nonatomic,strong) NSString *firstName;
@property (nonatomic,strong) NSString *lastName;
@property (nonatomic,strong) NSString *fullName;
@property (nonatomic,strong) NSString *dateOfBirth;
@property (nonatomic,strong) NSString *joiningDate;
@property (nonatomic,strong) NSURL *sharingURL;
@property (nonatomic,assign) int snoopTime;
@property (nonatomic,assign) int isappAlertsOn;
@property (nonatomic,assign) int isemailAlertsOn;
@property (nonatomic,assign) int issmsAlertsOn;
extern NSString * twUserId;
extern NSString * twFullname;
extern NSString * twProfilePic;
/*
This instance will be used to access currently logged in user info*/
+ (UserProfile *)sharedInstance;


-(id)initWithUserId:(NSString*)userId withUserName:(NSString*)username withEmailId:(NSString*)emailId withProfilePicURL:(NSURL*)profilePicURL withPhoneNumber:(NSString*)phoneNumber withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withFullName:(NSString*)fullName withJoiningDate:(NSString*)joiningDate withSharingURL:(NSURL*)sharingURL withSnoopTime:(int)snoopTime withAppAlerts:(int)appAlerts withEmailAlerts:(int)emailAlerts withSMSAlerts:(int)smsAlerts withBackgroundURL:(NSURL*)backgroundURL;

-(NSString*)getUserId;
@end
