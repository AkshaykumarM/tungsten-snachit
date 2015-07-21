//
//  Common.h
//  SnachIt
//
//  Created by Akshay Maldhure on 2/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

@interface Common : NSObject
extern NSMutableArray *emailIds;//for storing mail ids


+(int)updateFollowStatus:(NSString*)brandId FollowStatus:(NSString*)fstatus ForUserId:(NSString*)userId;
+(NSDictionary*)getFollowBrandDictionaryForValues:(NSString*)brandId FollowStatus:(NSString*)status ForUserId:(NSString*)userId;
+ (NSMutableArray*)getallEmailIdsInAddressBook:(ABAddressBookRef)addressBook;
+(NSDictionary*)getDictionaryForFriendCount:(NSString*)productId SnachId:(NSString*)snachId EmailId:(NSString*)emailId;
+(NSDictionary*)getEmailDictionary:(NSString*)emailId;
+(NSString *) getRandomStringWithLength: (int) len;
+(NSString*)getTinyUrlForLink:(NSString*)URL;

@end
