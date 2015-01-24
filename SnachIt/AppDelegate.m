//
//  AppDelegate.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/10/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "AppDelegate.h"
#import "SnachItLogin.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // color selected text ---> Pink
    [[UISegmentedControl appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.647 green:0.208 blue:0.522 alpha:1] } forState:UIControlStateSelected];
    
    // color disabled text ---> grey
    [[UISegmentedControl appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1] } forState:UIControlStateNormal];
    
    // color tint segmented control ---> white
    [[UISegmentedControl appearance] setTintColor:[UIColor whiteColor]];
    
    
    [self openFbSession];
    
    return YES;
}



-(void) openFbSession{
    // Whenever a person opens the app, check for a cached session

    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                          
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        //        UIButton *loginButton = [self.customLoginViewController loginButton];
        //        [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
        NSLog(@"fb");
    }
    
}
-(NSString*) isFBSessionActive{
    if (FBSession.activeSession.isOpen) {
        return @"YES";
        // If there's no cached session, we will show a login button
    } else {
        //        UIButton *loginButton = [self.customLoginViewController loginButton];
        //        [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
        return @"NO";
    }
}
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    // Set the button title as "Log in with Facebook"
    //    UIButton *loginButton = [self.customLoginViewController loginButton];
    //    [loginButton setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
    //
    // Confirm logout message
    [self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    //    UIButton *loginButton = self.customLoginViewController.loginButton;
    //    [loginButton setTitle:@"Log out" forState:UIControlStateNormal];
    //
    // Welcome message
    //[self showMessage:@"You're now logged in" withTitle:@"Welcome!"];
    
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}


// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    //Handling with google+ url handler
    if([[url absoluteString] hasPrefix:@"com.tungsten.snachit:"])
    {
      return  [GPPURLHandler handleURL:url sourceApplication:sourceApplication annotation:annotation];
    }
    //Handling with facebook url handler
     if([[url absoluteString] hasPrefix:@"fb620918038012591:"])
    {
        return [FBSession.activeSession handleOpenURL:url];

    }
    return false;
   }



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 
     [FBAppCall handleDidBecomeActive];
    
    if (FBSession.activeSession.isOpen) {
        
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 NSString *firstName = user.first_name ;
                 NSString *lastName = user.last_name;
                 NSString *facebookId = [user objectID];
                 NSString *email = [user objectForKey:@"email"];
                 NSString *imageUrl = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
                 NSString *phoneNo=@"";
                 NSString *apns=firstName;
                 
                 [self getSignUp:firstName LastName:lastName EmailId:email Username:[NSString stringWithFormat:@"%@%@", firstName,lastName] Password:firstName Profilepic:imageUrl PhoneNo:phoneNo APNSToken:apns SignUpVia:@"FB" DOB:@"1993-5-7"];
             
             }
         }];
    }
    
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    
    NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
     
    // 1. Create a |GTLServicePlus| instance to send a request to Google+.
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
    plusService.retryEnabled = YES;
    
    // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    // 3. Use the "v1" version of the Google+ API.*
    plusService.apiVersion = @"v1";
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    //Handle Error
                } else {
                    NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                    NSLog(@"GoogleID=%@", person.identifier);
                    NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                    NSLog(@"Gender=%@-----------%@", person.gender,[[person.image.url substringToIndex:[person.image.url length] - 2] stringByAppendingString:@"200"]);
                   NSString *userName= [[person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName] uppercaseString];
                   NSString *userProfilePic=[[person.image.url substringToIndex:[person.image.url length] - 2] stringByAppendingString:@"200"];
                  // [self getSignUp:person.name.givenName LastName:person.name.familyName EmailId:[GPPSignIn sharedInstance].authentication.userEmail Username:[NSString stringWithFormat:@"%@%@", firstName,lastName] Password:firstName Profilepic:imageUrl PhoneNo:phoneNo APNSToken:apns SignUpVia:@"GPlus" DOB:@"1993-5-7"];

                }
            }];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(void)getSignUp:(NSString*)firstName LastName:(NSString*)lastName EmailId:(NSString*)emailid Username:(NSString*)username Password:(NSString*)password Profilepic:(NSString*)profile_pic PhoneNo:(NSString*)phoneNo APNSToken:(NSString*)apnsToken SignUpVia:(NSString*)signUpVia DOB:(NSString*)dob{
    
    NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@ %@",firstName,lastName,emailid,username,password,profile_pic,phoneNo,apnsToken,signUpVia,dob);
    
    
}

@end
