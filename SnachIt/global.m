//
//  global.m
//  SnachIt
//
//  Created by Akshakumar Maldhure on 1/2/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "global.h"
#import "RegexValidator.h"
#import "Reachability.h"
//NSString const *ec2maschineIP=@"http://192.168.0.121:8000/";
NSString const *ec2maschineIP=@"http://ec2-52-1-195-249.compute-1.amazonaws.com/";
NSString *USERID;//this will be the global userid
NSString *SNACHID;//this will be the global snachid

bool isApplicationLaunchedFromNotification=FALSE;
bool isAllreadyTried=FALSE;
NSString * const SSOUSING=@"SSOUsing";
NSString * const USERNAME=@"Username";
NSString * const PASSWORD=@"Password";
NSString * const LOGGEDIN=@"LoggedIn";

NSString *const DEFAULT_BILLING=@"DefaultBilling";
NSString *const DEFAULT_SHIPPING=@"DefaultShipping";
NSUInteger const DEFAULT_SNOOPTIME=30;
NSString * const SnachItDBFile=@"snachit.sql";
NSString * const SnoopTimeDBFile=@"snoopTimes.sql";
NSString * const checkInternetConnection=@"You are not connected to internet, Please check connection.";
NSString *CURRENTDB;
NSString *screenName;
NSString *ssousing;
NSString *APNSTOKEN;
NSString *screenName=nil;
int snooptTracking;
int i=0;//for screen tracking
NSString *cardNumber=@"";
NSString *cardExp=@"";
NSString *cardCVV=@"";
int RECENTLY_ADDED_PAYMENT_INFO_TRACKER=-1;
int RECENTLY_ADDED_SHIPPING_INFO_TRACKER=-1;
@implementation global
float  RADIOUS=37.5f;//to make profile pic circular
float BORDERWIDTH=5.0f;


/*
 This method will make post request and will return the response
 */
+(NSData*)makePostRequest:(NSData*)body requestURL:(NSString*)url {
    NSError *error;
    NSData *responseData;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ec2maschineIP,url]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[body length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    
    NSHTTPURLResponse* urlResponse = nil;
    error = [[NSError alloc] init];
    responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
 
   
    
    return responseData;
}

+(BOOL)isValidUrl:(NSURL *)urlString{
    NSURLRequest *request = [NSURLRequest requestWithURL:urlString];
    return [NSURLConnection canHandleRequest:request];
}
+(void)showAllertForAllreadySignedUp{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                    message:@"You have alreday signed up with snach.it."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
+(void)showAllertForInvalidCredentials{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                    message:@"Please, enter valid credentials."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
+(void)showAllertForEnterValidCredentials{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!"
                                                    message:@"Please, enter email and password."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

+(void)showAllertMsg:(NSString*)title Message:(NSString*)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}


+(NSString*)getCardType:(NSString*)number{
    NSString *type;
    NSPredicate* visa = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", VISA];
    NSPredicate* mastercard = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MASTERCARD];
    NSPredicate* dinnersclub = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DINNERSCLUB];
    NSPredicate* discover = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DISCOVER];
    NSPredicate* amex = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", AMEX];
    
    if ([visa evaluateWithObject:number])
    {
        type=@"Visa";
    }
    else if ([mastercard evaluateWithObject:number])
    {
        type=@"Mastercard";
    }
    else if ([dinnersclub evaluateWithObject:number])
    {
        type=@"Diners Club";
    }
    else if ([discover evaluateWithObject:number])
    {
        type=@"Discover";
    }
    else if ([amex evaluateWithObject:number])
    {
        type=@"American Express";
    }
    else{
        type=@"Unknown";
    }
    return type;
}
+(void)setTextFieldInsets:(UITextField*)textfield{
    
    textfield.keyboardType = UIKeyboardTypeEmailAddress;
    textfield.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfield.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 20)];
    textfield.leftViewMode = UITextFieldViewModeAlways;
    
}
+(NSString*)processString :(NSString*)yourString
{
    if(yourString == nil){
        return @"";
    }
    int stringLength = (int)[yourString length];
    // the string you want to process
    int len = 4;  // the length
    NSMutableString *str = [NSMutableString string];
    int i = 0;
    for (; i < stringLength; i+=len) {
        @try{
            NSRange range = NSMakeRange(i, len);
            [str appendString:[yourString substringWithRange:range]];
            if(i!=stringLength -4){
                [str appendString:@" "]; //If required stringshould be in format XXXX-XXXX-XXXX-XXX then just replace [str appendString:@"-"]
            }}
        @catch(NSException *e){}
    }
    if (i < [str length]-1) {  // add remain part
        [str appendString:[yourString substringFromIndex:i]];
    }
    // str now is what your want
    
    return str;
}

+(BOOL)isConnected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    if(networkStatus == NotReachable)
    {
        [self showAllertMsg:@"Alert" Message:checkInternetConnection];
    }
    return networkStatus != NotReachable;
}
+(BOOL) stringIsNumeric:(NSString *) str {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSNumber *number = [formatter numberFromString:str];
    return !!number;
}

+(int)getWeekDaysCalc:(int)tempspeed{
    NSDate *endDate = [self addDays:tempspeed toDate:[NSDate date]];//this will be the end date
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *startDate = [NSDate date];//this will be the start date
    
    //logic for calculating weekdays between start and end date
    NSDateComponents *comps = [cal components:NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:startDate toDate:endDate options:kNilOptions];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    [fmt setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    [fmt setDateFormat:@"EEEE"];
    NSArray *weekend = [fmt weekdaySymbols];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF == 'Saturday' || SELF == 'Sunday'"];
    NSArray *weekendArr = [weekend filteredArrayUsingPredicate:pred];
    NSString *weekendsStr = [weekendArr componentsJoinedByString:@""];
    NSDateComponents *compsWithDay = [[NSDateComponents alloc] init];
    [compsWithDay setDay:1];
    NSString *dayNameStr = [fmt stringFromDate:startDate];
    NSUInteger count = 1;
    if ([weekendsStr rangeOfString:dayNameStr].location != NSNotFound) {
        count++;
    }
    for (int i = 0; i < comps.day; i++) {
        startDate = [cal dateByAddingComponents:compsWithDay toDate:startDate options:kNilOptions];
        dayNameStr = [fmt stringFromDate:startDate];
        if ([weekendsStr rangeOfString:dayNameStr].location != NSNotFound) {
            count++;
        }
    }
    //logic end here
    int total=tempspeed+count;
    NSDate *fdate = [self addDays:total toDate:startDate];
    NSDateFormatter *myFormatter = [[NSDateFormatter alloc] init];
    [myFormatter setDateFormat:@"EEEE"]; // day, like "Saturday"
    [myFormatter setDateFormat:@"c"]; // day number, like 7 for saturday
    
    //checking whether future day is saturday or sunday
    NSString *dayOfWeek = [myFormatter stringFromDate:fdate];
      if([dayOfWeek isEqual:@"6"]){ total+=2;}
      if([dayOfWeek isEqual:@"7"]){ total+=1;}
   
    return total;
}
+(NSDate *)addDays:(NSInteger)days toDate:(NSDate *)originalDate {
    NSDateComponents *components= [[NSDateComponents alloc] init];
    [components setDay:days];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingComponents:components toDate:originalDate options:0];
}


@end
