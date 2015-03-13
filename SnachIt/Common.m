//
//  Common.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 2/20/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "Common.h"
#import "global.h"

@implementation Common
NSMutableArray *emailIds;

+(int)updateFollowStatus:(NSString*)brandId FollowStatus:(NSString*)fstatus ForUserId:(NSString*)userId{
    NSError *error;
    int status=0;
    NSData *followJson = [NSJSONSerialization dataWithJSONObject:[self getFollowBrandDictionaryForValues:brandId FollowStatus:fstatus ForUserId:userId] options:NSJSONWritingPrettyPrinted error:&error];
    @try{
        NSData *responseD=[global makePostRequest:followJson requestURL:@"brand-follow-status/" ];
        if (responseD) {
            NSDictionary *response= [NSJSONSerialization JSONObjectWithData:responseD options:NSJSONReadingMutableContainers error: &error];
            
            if([[response objectForKey:@"success"] isEqual:@"true"])
                status=1;
            else
                status=0;
        }}
    @catch(NSException *exception){
        NSLog(@"%@",exception);
    }
    
    return status;
}

/*
 This method will return the dictionary for updating follow status
 */
+(NSDictionary*)getFollowBrandDictionaryForValues:(NSString*)brandId FollowStatus:(NSString*)status ForUserId:(NSString*)userId{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setValue:userId forKey:@"customerId"];
    [dictionary setValue:brandId forKey:@"brandId"];
    [dictionary setValue:status forKey:@"status"];
    return dictionary;
}

/***
 This function will return all the email id's from the phoonebook in an Array.
 **/
+ (NSMutableArray*)getallEmailIdsInAddressBook:(ABAddressBookRef)addressBook
{
    NSMutableArray *emails= [NSMutableArray array];
    NSArray *allPeople = CFBridgingRelease(ABAddressBookCopyArrayOfAllPeople(addressBook));
    NSInteger numberOfPeople = [allPeople count];
    
    for (NSInteger i = 0; i < numberOfPeople; i++) {
        ABRecordRef person = (__bridge ABRecordRef)allPeople[i];
        ABMultiValueRef emailIds = ABRecordCopyValue(person, kABPersonEmailProperty);
        CFIndex numberOfEmailIds = ABMultiValueGetCount(emailIds);
        for (CFIndex i = 0; i < numberOfEmailIds; i++) {
            NSString *email = CFBridgingRelease(ABMultiValueCopyValueAtIndex(emailIds, i));
            [emails addObject:email];
            
        }
        CFRelease(emailIds);
        
    }
    
    return emails;
}

+(NSDictionary*)getDictionaryForFriendCount:(NSString*)productId SnachId:(NSString*)snachId EmailId:(NSString*)emailId{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    if(emailIds){
    [dic setObject:productId forKey:@"productId"];
    [dic setObject:snachId forKey:@"snachId"];
    [dic setObject:emailIds forKey:@"contactList"];
    [dic setObject:emailId forKey:@"userEmail"];
    }
    return dic;
}

+(NSDictionary*)getEmailDictionary:(NSString*)emailId{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    if(emailIds){
        [dic setObject:emailIds forKey:@"contactList"];
        [dic setObject:emailId forKey:@"userEmail"];
    }
    return dic;
}

@end
