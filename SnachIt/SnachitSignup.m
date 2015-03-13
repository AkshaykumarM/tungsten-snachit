//
//  SnachitSignup.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/26/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnachitSignup.h"
#import "SnachItLogin.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
#import "global.h"
#import "AFNetworking.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "AppDelegate.h"
#import "TwitterViewController.h"


@interface SnachitSignup()<GPPSignInDelegate>

@end

@implementation SnachitSignup
@synthesize emailTextField=_emailTextField;
@synthesize passwordTextField=_passwordTfield;

static NSString * const kClientId = @"332999389045-5ua94fad3hdmun0t3b713g35br0tnn8k.apps.googleusercontent.com";
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

NSInteger status=0;
UIView *backView;
UIActivityIndicatorView *activitySpinner;
CGFloat animatedDistance;
- (void)viewDidLoad
{
    [self setViewLookAndFeel];
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    screenName=@"signup";
    
}
-(void)setViewLookAndFeel{
    
    
    UIColor *color = [UIColor whiteColor];
    self.emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName: color}];
    self.passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName: color}];
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


- (IBAction)signUpBtn:(id)sender {
 
   
  //  [self performSegueWithIdentifier: @"signInScreenSegue" sender:self];
    if([self.emailTextField hasText] &&[self.passwordTextField hasText])
    {
        NSString *username= self.emailTextField.text;
        NSString *password= self.passwordTextField.text;
      
        NSLog(@"APNS TOKEN WHILE SNACH.IT SIGNUP: %@",APNSTOKEN);
        if([self IsEmailValid:username] && [password length]>=6)
        {
            NSInteger status=[self getSignUp:@"" LastName:@"" FullName:@"" EmailId:username Username:username Password:password Profilepic:@"" PhoneNo:@"" APNSToken:APNSTOKEN SignUpVia:@"SnachIt" DOB:@""];
         
            if(status==1 ){
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:1 forKey:@"signedUp"];
                [defaults setObject:username forKey:USERNAME];
                [defaults setObject:password forKey:PASSWORD];
                SnachItLogin *startscreen = [[SnachItLogin alloc]
                                 initWithNibName:@"LoginScreen" bundle:nil];
                [self presentViewController:startscreen animated:YES completion:nil];
            }
            else{
                [global showAllertForAllreadySignedUp];

            }
        }
        else{
            [global showAllertMsg:@"Enter valid Email id and Password must be greater than 6 digits."];
        }
        
    }else{
        [global showAllertForEnterValidCredentials];
    }
    
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
                        
                          NSInteger status=[self getSignUp:firstName LastName:lastName FullName:fullName EmailId:email Username:email Password:password Profilepic:profilePic PhoneNo:phoneNo APNSToken:APNSTOKEN SignUpVia:ssousing DOB:@""];
                          if(status==1 ){
                              SnachItLogin *signin=[[SnachItLogin alloc] init];
                              int signinStatus=[signin performSignIn:email Password:password SSOUsing:ssousing];
                              if(signinStatus==1){
                                  
                                  NSLog(@"Signed up with facebook Successfully");
                                  [self stopProcessing];
                                  [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                              }else{
                                  NSLog(@"Error occurred while signing in");
                                    [self stopProcessing];
                                  
                              }
                          }
                          else{
                              [self stopProcessing];
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
                        SnachItLogin *signin=[[SnachItLogin alloc]init];
                        if([signin performSignIn:[GPPSignIn sharedInstance].authentication.userEmail Password:person.identifier SSOUsing:ssousing]==1){
                            NSLog(@"While signin UserName:%@ Password: %@",[GPPSignIn sharedInstance].authentication.userEmail,person.identifier);
                            [self stopProcessing];
                            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
                            
                        }
                        else{
                            [self stopProcessing];
                            [global showAllertMsg:@"Problem occured while signup, this can occur "];
                        }
                    }
                    else
                    {
                        
                        [self stopProcessing];
                    }
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
    NSLog(@"While signup UserName:%@ Password: %@  APNS TOKEN: %@",email,googleId,APNSTOKEN);
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

- (IBAction)gplusBtn:(id)sender {
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
- (IBAction)loginHereBtn:(id)sender {
    SnachItLogin *startscreen = [[SnachItLogin alloc]
                                  initWithNibName:@"LoginScreen" bundle:nil];
    [self presentViewController:startscreen animated:YES completion:nil];
}



//this function will let signup the user and will provide 1 if success and 0 else


-(NSInteger)getSignUp:(NSString*)firstName LastName:(NSString*)lastName FullName:fullname EmailId:(NSString*)emailid Username:(NSString*)username Password:(NSString*)password Profilepic:(NSString*)profile_pic PhoneNo:(NSString*)phoneNo APNSToken:(NSString*)apnsToken SignUpVia:(NSString*)signUpVia DOB:(NSString*)dob{
    NSString *url;
    
        url=[NSString stringWithFormat:@"%@signUpFromMobile/?firstName=%@&lastName=%@&fullName=%@&emailid=%@&username=%@&password=%@&profile_pic=%@&phoneNo=%@&apnsToken=%@&signUpVia=%@",ec2maschineIP,firstName,lastName,fullname,emailid,username,password,profile_pic,phoneNo,apnsToken,signUpVia];
    NSURL *webURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSLog(@"Request URL: %@",url);
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    //getting the data
    NSData *jasonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (jasonData) {
        NSDictionary *response= [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &error];
        NSLog(@"RESPONSE:%@",response );
                   
        if([[response valueForKey:@"success"] isEqual:@"true"]|| [[response valueForKey:@"error_code"] integerValue]==2)
        {
             //[global showAllertMsg:@"Signed up successfully"];
            status=1;
        }
        else{
             [global showAllertMsg:@"Opps! something went wrong, while sign you in"];
            status=0;
        }
    }
    else{
        
        [global showAllertMsg:@"Server not responding"];
        status=0;
    }
    return status;
    
}

-(void)clearUserDefault{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    [defaults setNilValueForKey:@"signedUp"];
    [defaults setNilValueForKey:USERNAME];
    [defaults setNilValueForKey:PASSWORD];
}

-(BOOL)IsEmailValid:(NSString *)checkString
{
   
        BOOL stricterFilter = NO;
        NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
        NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
        NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        return [emailTest evaluateWithObject:checkString];
    
}


- (IBAction)loginBtn:(id)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    SnachItLogin *startscreen = [[SnachItLogin alloc]
                                 initWithNibName:@"LoginScreen" bundle:nil];
    [self presentViewController:startscreen animated:NO completion:nil];
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

@end
