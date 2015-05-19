//
//  AppDelegate.m
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/10/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "AppDelegate.h"
#import "SnachItLogin.h"
#import "global.h"


#import "SnachItDB.h"
#import "SnachItAddressInfo.h"
static NSString * const kClientId = @"332999389045-5ua94fad3hdmun0t3b713g35br0tnn8k.apps.googleusercontent.com";
@interface AppDelegate ()<GPPDeepLinkDelegate,GPPSignInDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    // color selected text ---> Pink
    
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
     UIUserNotificationTypeBadge |
     UIUserNotificationTypeSound
                                      categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];

        UIImage *navBackgroundImage = [UIImage imageNamed:@"nav_bg.png"];
    
    [[UINavigationBar appearance] setBackgroundImage:navBackgroundImage forBarMetrics:UIBarMetricsDefault];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.window.frame.size.width, 20)];
    view.backgroundColor=[UIColor whiteColor];
    [self.window.rootViewController.view addSubview:view];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:0.616 green:0.102 blue:0.471 alpha:1] , UITextAttributeTextColor,
                                                           [UIColor colorWithRed:0.608 green:0.133 blue:0.471 alpha:1] ,UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                           UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"CenturyGothic" size:18.0], UITextAttributeFont, nil]];
    
   
   
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.608 green:0.133 blue:0.471 alpha:1]];

    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.616 green:0.102 blue:0.471 alpha:1] } forState:UIControlStateSelected];
    
    // color disabled text ---> grey
    [[UISegmentedControl appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:0.557 green:0.557 blue:0.557 alpha:1] } forState:UIControlStateNormal];
    
    // color tint segmented control ---> white
    [[UISegmentedControl appearance] setTintColor:[UIColor whiteColor]];
    
    
    [self openFbSession];
    [GPPSignIn sharedInstance].clientID = kClientId;
    [GPPDeepLink setDelegate:self];
    [GPPDeepLink readDeepLinkAfterInstall];
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (notification)
    {
        NSLog(@"Notification");
    }

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
           
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
               
                
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
    [self.window endEditing:YES];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
 
     [FBAppCall handleDidBecomeActive];

    

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    CURRENTDB=SnoopTimeDBFile;
    @try{
        if(screenName!=nil){
    if(![[SnachItDB database] logtime:USERID SnachId:[SNACHID intValue] SnachTime:0])
    {
        [[SnachItDB database]updatetime:USERID SnachId:[SNACHID intValue] SnachTime:0];
    }
        }
    }
    @catch(NSException *e){}
   
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    APNSTOKEN=[[[[NSString stringWithFormat:@"%@",deviceToken] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@">" withString:@""] stringByReplacingOccurrencesOfString:@"<" withString:@""];
   
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown && interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    APNSTOKEN=@"";
    NSLog(@"Failed to get token, error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
           isApplicationLaunchedFromNotification=TRUE;
}

@end
