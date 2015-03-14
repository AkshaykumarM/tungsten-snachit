//
//  AppShare.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/31/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "AppShare.h"
#import "UserProfile.h"
#import "SWRevealViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>
#import "AFNetworking.h"
#import <Social/Social.h>
#import "global.h"
static NSString * const kClientId = @"332999389045-5ua94fad3hdmun0t3b713g35br0tnn8k.apps.googleusercontent.com";

@interface AppShare()<GPPSignInDelegate>


@end
@implementation AppShare
{
    UserProfile *user;
    UIButton *topProfileBtn;
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    [self setupProfilePic];
    
    self.sharingURL.text=[NSString stringWithFormat:@"%@",user.sharingURL];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
  
}


- (IBAction)fbBtn:(id)sender {
    // Put together the dialog parameters
   
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [controller setInitialText:@"snach.it, A fun + simple way to snach things!"];
        [controller addURL:[NSURL URLWithString:@"http://snach.it"]];
    [controller addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.ecellmit.com/snachit/snach_logo.png"]]]];
        
        [self presentViewController:controller animated:YES completion:Nil];
   
}


- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
- (IBAction)twBtn:(id)sender {
   
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:@"snach.it, A fun + simple way to snach things!"];
    [tweetSheet addURL:[NSURL URLWithString:@"http://snach.it"]];
    [tweetSheet addImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.ecellmit.com/snachit/snach_logo.png"]]]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
   
    
}

- (IBAction)linkedInBtn:(id)sender {
   
  }


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
                    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];
                    
                    [shareBuilder setURLToShare:[NSURL URLWithString:@"http://snach.it"]];
                    [shareBuilder setTitle:@"snach.it" description:@" A fun + simple way to snach things!" thumbnailURL:[NSURL URLWithString:@"http://www.ecellmit.com/snachit/snach_logo.png"]];
                    
                    [shareBuilder setContentDeepLinkID:kClientId];
                    [shareBuilder open];
                    
                    if (error) {
                        //Handle Error
                       
                    } else {
                        
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


- (IBAction)gPBtn:(id)sender {
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.clientID = kClientId;
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    signIn.delegate = self;
    [signIn authenticate];
    
   
}
-(void)setupProfilePic{
    /*Upper left profile pic work starts here*/
    
    //here i am setting the frame of profile pic and assigning it to a button
    CGRect frameimg = CGRectMake(0, 0, 40, 40);
    topProfileBtn = [[UIButton alloc] initWithFrame:frameimg];
    
    //assigning the default background image
    [topProfileBtn setBackgroundImage:[UIImage imageNamed:@"userIcon.png"] forState:UIControlStateNormal];
    topProfileBtn.clipsToBounds=YES;
    [topProfileBtn setShowsTouchWhenHighlighted:YES];
    
    //setting up corner radious, border and border color width to make it circular
    topProfileBtn.layer.cornerRadius = 20.0f;
    topProfileBtn.layer.borderWidth = 2.0f;
    topProfileBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    // setting action to the button
    [topProfileBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    
    //assigning button to top bar iterm
    UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:topProfileBtn];
    
    //adding bar item to left bar button item
    self.navigationItem.leftBarButtonItem=mailbutton;
    
    //checking if profile pic url is nil else download the image and assign it to imageview
    [self.navigationBar setItems:@[self.navigationItem]];
    
    if([global isValidUrl:user.profilePicUrl]){
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [topProfileBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        }];}
    
}

@end
