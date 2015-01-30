//
//  SnachItLogin.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/24/14.
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
UIActivityIndicatorView *activitySpinner;
UIView *backView;
@interface SnachItLogin()<GPPSignInDelegate>

@end

@implementation SnachItLogin
@synthesize emailTfield=_emailTfield;
@synthesize passwordTfield=_passwordTfield;

@synthesize mySpinner=_mySpinner;
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
    CALayer *emailborder = [CALayer layer];
    CALayer *passborder  = [CALayer layer];
    CGFloat borderWidth = 1;
    
    //setting bottom border to email filed
    emailborder.borderColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
    emailborder.frame = CGRectMake(0, self.emailTfield.frame.size.height - borderWidth, self.emailTfield.frame.size.width, self.emailTfield.frame.size.height);
    emailborder.borderWidth = borderWidth;
    [self.emailTfield.layer addSublayer:emailborder];
    self.emailTfield.layer.masksToBounds = YES;
   
    
    
    //setting bottom border to password filed
    passborder.borderColor =[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4].CGColor;
    passborder.frame = CGRectMake(0, self.passwordTfield.frame.size.height - borderWidth, self.passwordTfield.frame.size.width, self.passwordTfield.frame.size.height);
    passborder.borderWidth = borderWidth;
    [self.passwordTfield.layer addSublayer:passborder];
    self.passwordTfield.layer.masksToBounds = YES;
    
    
    
    
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
                          NSString *apns=firstName;
                          NSString *password=facebookId;
                          
                          if(email==nil){
                              password=facebookId;
                              email=facebookId;
                          }
                          SnachitSignup *signUp=[[SnachitSignup alloc]init];
                          NSInteger status=[signUp getSignUp:firstName LastName:lastName FullName:fullName EmailId:email Username:email Password:password Profilepic:profilePic PhoneNo:phoneNo APNSToken:apns SignUpVia:ssousing DOB:@""];
                          if(status==1){
                              int signinStatus=[self performSignIn:email Password:password SSOUsing:ssousing];
                              if(signinStatus==1){
                                  
                                  NSLog(@"Signed up with facebook Successfully");
                                  [self stopProcessing];
                                  [self.presentingViewController.presentingViewController.presentedViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                              }else{
                                   NSLog(@"Error occurred while signing in");
                                  [self stopProcessing];
                              }
                          }
                          else{
                              [self stopProcessing];
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
//    if([screenName isEqual:@"signup"]){
//   [[[self presentingViewController] presentingViewController]dismissModalViewControllerAnimated:YES ];
//    }
//    else{
//         [[[[self presentingViewController] presentingViewController]presentingViewController]dismissModalViewControllerAnimated:YES ];
//    }
    //request for user auth
  
    if([self performSignIn:self.emailTfield.text Password:self.passwordTfield.text SSOUsing:ssousing]==1){
           [self.presentingViewController.presentingViewController.presentedViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    [self stopProcessing];
            //[self.mySpinner stopAnimating];
            
            //caching userid for sso
            //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            //[defaults setObject:@"SnachIt" forKey:@"SSOUsing"];
            //perfoming segue to snach feed screen
          //;
    
   
   
//[self.mySpinner stopAnimating];
//    [self dismissViewControllerAnimated:NO completion:nil];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(int)performSignIn:(NSString*)username Password:(NSString*)password SSOUsing:(NSString*)ssoUsing{

    NSString *url=[NSString stringWithFormat:@"%@signInFromMobile/?username=%@&password=%@",maschineIP,username,password];
      NSURL *webURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL];
    NSURLResponse *response = nil;
    NSError *error = nil;
    //getting the data
    NSData *jasonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //json parse
  
  int status=0;
    
    if (jasonData) {
       
        NSDictionary *response= [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &error];
         NSLog(@"Json Data:%@  %@",response,password);
        NSLog(@"%@",[response objectForKey:@"success"]);
        if([[response objectForKey:@"success"] isEqual:@"true"])
        {
            
            NSDictionary *userprofile=[response objectForKey:@"userProfile"];
            [self setuserInfo:[userprofile valueForKey:@"CustomerId"] withUserName:[userprofile valueForKey:@"UserName"] withEmailId:[userprofile valueForKey:@"EmailID"] withProfilePicURL:[NSURL URLWithString:[userprofile valueForKey:@"ProfilePicUrl"]] withPhoneNumber:[userprofile valueForKey:@"PhoneNumber"] withFirstName:[userprofile valueForKey:@"FirstName"] withLastName:[userprofile valueForKey:@"LastName"] withFullName:[userprofile valueForKey:@"FullName"]  withDateOfBirth:[userprofile valueForKey:@"DateOfBirth"] withJoiningDate:[userprofile valueForKey:@"JoiningDate"]];
            NSLog(@"UserProfile:%@",userprofile);
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:ssoUsing forKey:@"SSOUsing"];
            [defaults setObject:username forKey:@"Username"];
            [defaults setObject:password forKey:@"Password"];
            [defaults setInteger:1  forKey:@"signedUp"];
            status=1;
        }
        else{
            status=0;
        }
        
    }
    return status;
}
-(void)startProcessing{
    
    backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:backView];
    activitySpinner=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [backView addSubview:activitySpinner];
    activitySpinner.center = CGPointMake(160, 240);
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
                                            [self.presentingViewController.presentingViewController.presentedViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
                                           
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
    NSString *apns=firstName;
    NSLog(@"While signup UserName:%@ Password: %@",email,googleId);
    NSInteger status=[signup getSignUp:firstName LastName:lastName FullName:fullName EmailId:email Username:email Password:googleId Profilepic:imageUrl PhoneNo:phoneNo APNSToken:apns SignUpVia:ssousing DOB:@"1993-5-7"];
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
    [defaults setObject:@"GP" forKey:@"SSOUsing"];
    [signIn authenticate];
  }

// ---- its call a web service to login with google+ info

- (IBAction)twBtn:(id)sender {
   
    TwitterViewController *startscreen = [[TwitterViewController alloc]
                                  initWithNibName:@"TwitterView" bundle:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"TW" forKey:@"SSOUsing"];
    [self presentViewController:startscreen animated:YES completion:nil];
}

-(void)setuserInfo:(NSString*)userId withUserName:(NSString*)username withEmailId:(NSString*)emailId withProfilePicURL:(NSURL*)profilePicURL withPhoneNumber:(NSString*)phoneNumber withFirstName:(NSString*)firstName withLastName:(NSString*)lastName withFullName:(NSString*)fullName withDateOfBirth:(NSString*)dateOfBirth withJoiningDate:(NSString*)joiningDate{
    
    UserProfile *profile=[[UserProfile
                           sharedInstance] initWithUserId:userId withUserName:username withEmailId:emailId withProfilePicURL:profilePicURL withPhoneNumber:phoneNumber withFirstName:firstName withLastName:lastName withFullName:fullName withDateOfBirth:dateOfBirth withJoiningDate:joiningDate];
    NSLog(@"profile:%@",profile.getUserId);
    
}








@end
