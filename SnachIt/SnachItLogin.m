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
static NSString * const kClientId = @"332999389045-5ua94fad3hdmun0t3b713g35br0tnn8k.apps.googleusercontent.com";

NSString *const SIGNINSEGUE=@"signInSegue";
NSString *const USER_ID=@"userId";

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

CGFloat animatedDistance;
- (void)viewDidLoad
{
    [self setViewLookAndFeel];
    [super viewDidLoad];
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkSessionIFActive];
    screenName=@"signin";
   
}

-(void)checkSessionIFActive{
  //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ID];
  //  NSString *userId = [defaults objectForKey:USER_ID];
//    if (userId!=nil) {
//        
//      // [self performSegueWithIdentifier:SIGNINSEGUE sender:self];
//    }
//    else
    if(FBSession.activeSession.isOpen){
        NSLog(@"sfdsfdfdff");
       // [self performSegueWithIdentifier:SIGNINSEGUE sender:self];
    }
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
    // If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        // Close the session and remove the access token from the cache
        // The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        // If the session state is not any of the two "open" states when the button is clicked
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
         }];
    }

    
}



- (IBAction)signInBtn:(id)sender {
    
  //stop spinner
    [self.mySpinner startAnimating];
    NSLog(@"%@",(UIButton *)sender);
    if([screenName isEqual:@"signup"]){
   [[[self presentingViewController] presentingViewController]dismissModalViewControllerAnimated:YES ];
    }
    else{
         [[[[self presentingViewController] presentingViewController]presentingViewController]dismissModalViewControllerAnimated:YES ];
    }
    //request for user auth
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSString *url=[NSString stringWithFormat:@"http://192.168.0.121:8000/signInFromMobile/?username=%@&password=%@",self.emailTfield.text,self.passwordTfield.text];

        [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
            if(responseObject[@"success"])
            {
            [self.mySpinner stopAnimating];
                
            //caching userid for sso
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
            [defaults setObject:self.emailTfield.text forKey:USER_ID];
                
            //perfoming segue to snach feed screen
            //[self performSegueWithIdentifier:SIGNINSEGUE sender:self];
                
            }
             
           
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             [self.mySpinner stopAnimating];
             //             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error..!!" message:@"Error Connecting to Server...!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             //  [alert show];
         }];
    
    
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
    NSLog(@"Received Error %@ and auth object==%@", error, auth);
    
    if (error) {
        // Do some error handling here.
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
                    if (error) {
                        //Handle Error
                    } else {
                        NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
                        NSLog(@"GoogleID=%@", person.identifier);
                        NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
                        NSLog(@"Gender=%@-----------%@", person.gender,[[person.image.url substringToIndex:[person.image.url length] - 2] stringByAppendingString:@"200"]);
                        userName= [[person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName] uppercaseString];
                        userProfilePic=[[person.image.url substringToIndex:[person.image.url length] - 2] stringByAppendingString:@"200"];
                       
                                           }
                }];
    }
    
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
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    // You previously set kClientID in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,kGTLAuthScopePlusMe,kGTLAuthScopePlusLogin,kGTLAuthScopePlusLogin,
                     nil]; //// defined in GTLPlusConstants.h
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    
    signIn.delegate = self;
    
    [signIn authenticate];
    
}

- (IBAction)twBtn:(id)sender {
    TwitterViewController *startscreen = [[TwitterViewController alloc]
                                  initWithNibName:@"TwitterView" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];
}

@end
