
//  SnachItLogin.m
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/24/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//
#import "SnachItLogin.h"
#import "SnachitSignup.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "global.h"
#import "TwitterViewController.h"
#import "UserProfile.h"


static NSString * const kClientId = @"332999389045-5ua94fad3hdmun0t3b713g35br0tnn8k.apps.googleusercontent.com";

NSString *const SIGNINSEGUE=@"signInSegue";
NSString *const USER_ID=@"userId";

UIView *backView;
@interface SnachItLogin()<GPPSignInDelegate>

@property (nonatomic, strong)	NSDictionary	*contents;
@property (nonatomic, strong)	id				currentPopTipViewTarget;

@property (nonatomic, strong)	NSMutableArray	*visiblePopTipViews;
@end

@implementation SnachItLogin
@synthesize emailTfield=_emailTfield;
@synthesize passwordTfield=_passwordTfield;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
UIActivityIndicatorView *activitySpinner;
UIView *backView;
CGFloat animatedDistance;
- (void)viewDidLoad
{
    [self setViewLookAndFeel];
    [super viewDidLoad];
    self.visiblePopTipViews = [NSMutableArray array];
    
    self.contents = [NSDictionary dictionaryWithObjectsAndKeys:
                     // Rounded rect buttons
                     @"Password must be atleast 6 characters", [NSNumber numberWithInt:13],
                     nil];
   
    
    // Array of (backgroundColor, textColor) pairs.
    // NSNull for either means leave as default.
    // A color scheme will be picked randomly per CMPopTipView.
   }

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
  
    screenName=@"signin";
    
   
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"view Will appear");
}

-(void)setViewLookAndFeel{
    
    
    UIColor *color = [UIColor whiteColor];
    self.emailTfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTfield.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: color}];
    self.emailTfield.keyboardType=UIKeyboardTypeEmailAddress;
    
    
    }


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField){
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
  
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textfield{
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

-(void)viewDidUnload{
    [self setEmailTfield:nil];
    [self setPasswordTfield:nil];
    
    [super viewDidUnload];
}
- (IBAction)fbBtn:(id)sender {
    [self startProcessing];
            ssousing=@"FB";
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
        [self stopProcessing];
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
     
        
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             
             // Retrieve the app delegate
             AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
             // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             if (!error && state == FBSessionStateOpen){
                 NSLog(@"Session opened");
                 if(FBSession.activeSession.isOpen)
                 {
                     [FBRequestConnection startForMeWithCompletionHandler:
                      ^(FBRequestConnection *connection, id user, NSError *error)
                      {
                          NSString *firstName = [user valueForKey:@"first_name"] ;
                          NSString *lastName = [user valueForKey:@"last_name"] ;
                          NSString *fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                          NSString *facebookId = [user valueForKey:@"id"];
                          NSString *email = [user objectForKey:@"email"];
                          NSString *profilePic = [[NSString alloc] initWithFormat: @"http://graph.facebook.com/%@/picture?type=large", facebookId];
                          NSString *phoneNo=@"";
                          
                          NSString *password=facebookId;
                          
                          if(email==nil){
                              password=facebookId;
                              email=facebookId;
                          }
                          SnachitSignup *signUp=[[SnachitSignup alloc]init];
                          NSInteger status=[signUp getSignUp:firstName LastName:lastName FullName:fullName EmailId:email Username:email Password:password Profilepic:profilePic PhoneNo:phoneNo APNSToken:APNSTOKEN SignUpVia:ssousing DOB:@""];
                          if(status==1){
                              int signinStatus=[self performSignIn:email Password:password SSOUsing:ssousing];
                              if(signinStatus==1){
                                  
                                  NSLog(@"Signed up with facebook Successfully");
                                  [self stopProcessing];
                                  [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                              }else{
                                  [global showAllertForAllreadySignedUp];
                                  [self stopProcessing];
                              }
                          }
                          else{
                              [global showAllertForAllreadySignedUp];
                              NSLog(@"Error occurred while sign up");
                          }
                      }];
                 }
             }
             else{
                 [self stopProcessing];
             }
         
         }];
    }
}

- (IBAction)signInBtn:(id)sender {
   //start spinner
    
    [self startProcessing];
    ssousing=@"SnachIt";
    if([self.emailTfield hasText]&&[self.passwordTfield hasText]){
            if([self performSignIn:self.emailTfield.text Password:self.passwordTfield.text SSOUsing:ssousing]==1){
       
            
                [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                
                
            }
            else{
            [global showAllertForInvalidCredentials];
            }
    }
    else{
        [global showAllertForEnterValidCredentials];
    }
    [self stopProcessing];
    
}

-(int)performSignIn:(NSString*)username Password:(NSString*)password SSOUsing:(NSString*)ssoUsing{

    NSString *url=[NSString stringWithFormat:@"%@signInFromMobile/?username=%@&password=%@",ec2maschineIP,username,password];
      NSURL *webURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL];
    NSURLResponse *response = nil;
    NSError *error = nil;
    //getting the data
    NSData *jasonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //json parse
    NSLog(@"\nRequest URL: %@",url);
  int status=0;
    
    if (jasonData) {
       
        NSDictionary *response= [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &error];
        NSLog(@"\nResponse:%@ ",response);
       
        if([[response objectForKey:@"success"] isEqual:@"true"])
        {
            //[global showAllertMsg:@"Sign in success"];
            NSDictionary *userprofile=[response objectForKey:@"userProfile"];
            [self setuserInfo:[userprofile valueForKey:@"CustomerId"] withUserName:[userprofile valueForKey:@"UserName"] withEmailId:[userprofile valueForKey:@"EmailID"] withProfilePicURL:[NSURL URLWithString:[userprofile valueForKey:@"ProfilePicUrl"]] withPhoneNumber:[userprofile valueForKey:@"PhoneNumber"] withFirstName:[userprofile valueForKey:@"FirstName"] withLastName:[userprofile valueForKey:@"LastName"] withFullName:[userprofile valueForKey:@"FullName"]   withJoiningDate:[userprofile valueForKey:@"JoiningDate"] withSnoopTime:[[userprofile valueForKey:@"snoop_time_limit"] intValue] withAppAlerts:[[userprofile valueForKey:@"app_alerts"] intValue] withSMSAlerts:[[userprofile valueForKey:@"sms_alerts"] intValue] withEmailAlerts:[[userprofile valueForKey:@"email_alerts"] intValue]];
            NSLog(@"UserProfile:%@",userprofile);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:ssoUsing forKey:SSOUSING];
            [defaults setObject:username forKey:USERNAME];
            [defaults setObject:password forKey:PASSWORD];
            [defaults setObject:@"1" forKey:LOGGEDIN];
            isAllreadyTried=TRUE;
            [defaults synchronize];
            status=1;
        }
        else{
            status=0;
            
        }
        
    }
    else{
        [global showAllertMsg:@"Server not responding"];
    }
    return status;
}
-(void)startProcessing{
    
    backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:backView];
    activitySpinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [backView addSubview:activitySpinner];
    activitySpinner.center = CGPointMake(self.view.center.x, self.view.center.y);
    activitySpinner.hidesWhenStopped = YES;
    [activitySpinner startAnimating];

}
-(void)stopProcessing{
    
    [activitySpinner stopAnimating];
    [backView removeFromSuperview];
}
- (IBAction)signUpHereBtn:(id)sender {
    SnachitSignup *startscreen = [[SnachitSignup alloc]
                                  initWithNibName:@"SignUpScreen" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];
}


//----------------------------------------------------------------------------
//---------------------------------------------------
// Google Plus Api Implementation


- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    ssousing=@"GP";
    NSLog(@"Received Error %@ and auth object==%@", error, auth);
    
    if (error) {
        // Do some error handling here.
         [self stopProcessing];
    } else {
        [self refreshInterfaceBasedOnSignIn];
        
        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
        
        NSLog(@"email %@ ", [NSString stringWithFormat:@"Email: %@",[GPPSignIn sharedInstance].authentication.userEmail]);
        NSLog(@"Received error %@ and auth object %@",error, auth);
        
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
                                    if([self getSignUpWithGooglePlus:person]==1)
                                    {
                                    
                                        if([self performSignIn:[GPPSignIn sharedInstance].authentication.userEmail Password:person.identifier SSOUsing:ssousing]==1){
                                            NSLog(@"While signin UserName:%@ Password: %@",[GPPSignIn sharedInstance].authentication.userEmail,person.identifier);
                                             [self stopProcessing];
                                            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                                           
                                        }
                                        else
                                             [self stopProcessing];
                                    }
                    else
                         [self stopProcessing];
                    
                    if (error) {
                        //Handle Error
                        [self stopProcessing];
                    } else {
                         [self stopProcessing];
                    }
                }];
    }
    
}

-(int)getSignUpWithGooglePlus:(GTLPlusPerson*)person
{   int state=0;
    SnachitSignup *signup =[[SnachitSignup alloc] init];
    NSString *firstName = person.name.givenName ;
    NSString *lastName = person.name.familyName;
    NSString *fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
    NSString *googleId = person.identifier;
    NSString *email = [GPPSignIn sharedInstance].authentication.userEmail;
    NSString *imageUrl = [[person.image.url substringToIndex:[person.image.url length] - 2] stringByAppendingString:@"200"];
    NSString *phoneNo=@"";
     NSLog(@"While signup UserName:%@ Password: %@",email,googleId);
    NSInteger status=[signup getSignUp:firstName LastName:lastName FullName:fullName EmailId:email Username:email Password:googleId Profilepic:imageUrl PhoneNo:phoneNo APNSToken:APNSTOKEN SignUpVia:ssousing DOB:@""];
    if(status==1)
    {
        state=1;
    }
    else
        state=0;
    return state;
}
-(void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {
        // The user is signed in.
        NSLog(@"Logged In");
        // Perform other actions here, such as showing a sign-out button
    } else {
        
        // Perform other actions here
    }
}
- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}
- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // The user is signed out and disconnected.
        // Clean up user data as specified by the Google+ terms.
    }
}

- (IBAction)gPlusBtn:(id)sender {
    [self startProcessing];
    [self googleSignIn];
  
    
}

-(void)googleSignIn{
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    // You previously set kClientID in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,kGTLAuthScopePlusMe,kGTLAuthScopePlusLogin,kGTLAuthScopePlusLogin,
                     nil]; //// defined in GTLPlusConstants.h
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    signIn.delegate = self;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"GP" forKey:SSOUSING];
    [signIn authenticate];
  }

// ---- its call a web service to login with google+ info

- (IBAction)twBtn:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 1;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFade;
    
    TwitterViewController *vc = [[TwitterViewController alloc]
                              initWithNibName:@"TwitterView" bundle:nil];;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:vc animated:NO completion:nil];

}

- (IBAction)signUpBtn:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    SnachitSignup *startscreen = [[SnachitSignup alloc]
                                  initWithNibName:@"SignUpScreen" bundle:nil];
    [self presentViewController:startscreen animated:NO completion:nil];
}

- (IBAction)passwordHelpBtn:(id)sender {
    [self dismissAllPopTipViews];
    
    if (sender == self.currentPopTipViewTarget) {
        // Dismiss the popTipView and that is all
        self.currentPopTipViewTarget = nil;
    }
    else {
        NSString *contentMessage = nil;
        UIView *contentView = nil;
        NSNumber *key = [NSNumber numberWithInteger:[(UIView *)sender tag]];
        id content = [self.contents objectForKey:key];
        if ([content isKindOfClass:[UIView class]]) {
            contentView = content;
        }
        else if ([content isKindOfClass:[NSString class]]) {
            contentMessage = content;
        }
    
        UIColor *backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        UIColor *textColor = [UIColor colorWithRed:0.882 green:0.643 blue:0.788 alpha:1] ;
        
       
        
        CMPopTipView *popTipView;
        if (contentView) {
            popTipView = [[CMPopTipView alloc] initWithCustomView:contentView];
        }
        else {
            popTipView = [[CMPopTipView alloc] initWithMessage:contentMessage];
        }
        popTipView.delegate = self;
        
        /* Some options to try.
         */
        //popTipView.disableTapToDismiss = YES;
        //popTipView.preferredPointDirection = PointDirectionUp;
        //popTipView.hasGradientBackground = NO;
        //popTipView.cornerRadius = 2.0;
        //popTipView.sidePadding = 30.0f;
        //popTipView.topMargin = 20.0f;
        //popTipView.pointerSize = 50.0f;
        popTipView.hasShadow = NO;
        popTipView.borderWidth=0;
          popTipView.textFont=[UIFont fontWithName:@"OpenSans" size:10];
        if (backgroundColor && ![backgroundColor isEqual:[NSNull null]]) {
            popTipView.backgroundColor = backgroundColor;
        }
        if (textColor && ![textColor isEqual:[NSNull null]]) {
            popTipView.textColor = textColor;
          
        }
        
        popTipView.animation =1.5;
        popTipView.has3DStyle = YES;
        
        popTipView.dismissTapAnywhere = YES;
        [popTipView autoDismissAnimated:YES atTimeInterval:2.0];
        
        if ([sender isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)sender;
            [popTipView presentPointingAtView:button inView:self.view animated:YES];
        }
       
        [self.visiblePopTipViews addObject:popTipView];
        self.currentPopTipViewTarget = sender;
    }

    
}

-(void)setuserInfo:(NSString*)userId withUserName:(NSString*)username withEmailId:(NSString*)emailId withProfilePicURL:(NSURL*)profilePicURL withPhoneNumber:(NSString*)phoneNumber withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withFullName:(NSString*)fullName withJoiningDate:(NSString*)joiningDate withSnoopTime:(int)snoopTime withAppAlerts:(int)appAlerts withSMSAlerts:(int)SMSAlerts withEmailAlerts:(int)emailAlerts{
    
    UserProfile *profile=[[UserProfile
                           sharedInstance] initWithUserId:userId withUserName:username withEmailId:emailId withProfilePicURL:profilePicURL withPhoneNumber:phoneNumber withFirstName:firstName withLastName:lastName withFullName:fullName withJoiningDate:joiningDate withSharingURL:[NSURL URLWithString:@""] withSnoopTime:snoopTime withAppAlerts:appAlerts withEmailAlerts:emailAlerts withSMSAlerts:SMSAlerts];
    
    
}

- (void)dismissAllPopTipViews
{
    while ([self.visiblePopTipViews count] > 0) {
        CMPopTipView *popTipView = [self.visiblePopTipViews objectAtIndex:0];
        [popTipView dismissAnimated:YES];
        [self.visiblePopTipViews removeObjectAtIndex:0];
    }
}



#pragma mark - CMPopTipViewDelegate methods

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView
{
    [self.visiblePopTipViews removeObject:popTipView];
    self.currentPopTipViewTarget = nil;
}


#pragma mark - UIViewController methods

- (void)willAnimateRotationToInterfaceOrientation:(__unused UIInterfaceOrientation)toInterfaceOrientation duration:(__unused NSTimeInterval)duration
{
    for (CMPopTipView *popTipView in self.visiblePopTipViews) {
        id targetObject = popTipView.targetObject;
        [popTipView dismissAnimated:NO];
        
        if ([targetObject isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)targetObject;
            [popTipView presentPointingAtView:button inView:self.view animated:NO];
        }
        else {
            UIBarButtonItem *barButtonItem = (UIBarButtonItem *)targetObject;
            [popTipView presentPointingAtBarButtonItem:barButtonItem animated:NO];
        }
    }
}



@end
