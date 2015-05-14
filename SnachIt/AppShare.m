//
//  AppShare.m
//  SnachIt
//
//  Created by Akshay Maldhure on 1/31/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "AppShare.h"
#import "UserProfile.h"
#import "SWRevealViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>


#import <Social/Social.h>
#import "global.h"
#import "Common.h"

#import "SnachItDB.h"
#import "SnoopedProduct.h"
#import "SnatchFeed.h"
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

static NSString * const kClientId = @"332999389045-5ua94fad3hdmun0t3b713g35br0tnn8k.apps.googleusercontent.com";
int linkedinsharetracker;
@interface AppShare()<GPPSignInDelegate,GPPShareDelegate>


@end
@implementation AppShare
{
    UserProfile *user;
    UIButton *topProfileBtn;
    UIView *backView;
    NSString *sharingMsg;
    NSString *sharingURL;
    NSString *appiconURL;
    NSString *referalCode;
    SnoopedProduct *product;
    
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
    CURRENTDB=SnoopTimeDBFile;
    [GPPShare sharedInstance].delegate = self;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    screenName=nil;
    // Set the gesture
    
    appiconURL=@"http://ec2-52-1-195-249.compute-1.amazonaws.com/media/media/";
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self setupProfilePic];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    if(![[defaults valueForKey:@"referalCodeStatus"] isEqual:@"1"])
    {
        referalCode=[NSString stringWithFormat:@"%@%@",user.userID,[Common getRandomStringWithLength:6]];
        [self sendReferalCode];
    }
    else{
        referalCode=[defaults valueForKey:@"referalCode"];
    }
    sharingURL=[self generateSharingURL];
    sharingMsg=@"Hey friends! You gotta download this app. It’s absolutely amazing and a quick way to shop for all those products you want…";
    linkedinsharetracker=0;
    
}

-(void)viewDidDisappear:(BOOL)animated{
    for(UIView *subview in [self.view subviews]) {
        [subview removeFromSuperview];
    }
    [super viewDidDisappear:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
    product=[SnoopedProduct sharedInstance];
}


- (IBAction)fbBtn:(id)sender {
    // Put together the dialog parameters
   if([global isConnected]){
        
        SLComposeViewController *fbsheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    fbsheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                [self resetSnoopTime];
                [self AskToViewDealNow];
                break;
        }
        
        //  dismiss the Tweet Sheet
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:^{
              
            }];
        });
    };

        [fbsheet setInitialText:[NSString stringWithFormat:@"%@ %@",sharingMsg,sharingURL]];
       if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            [fbsheet addURL:[NSURL URLWithString:@"snach.it"]];
       }
       
    [fbsheet addImage:[UIImage imageNamed:@"facebook_ad.png"]];
    
    [self presentViewController:fbsheet animated:NO completion:^{
        
    }];
   }
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


-(void)AskToViewDealNow{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Yippee!"
                                                    message:@"You have one more chance to snach this offer."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) { // Set buttonIndex == 0 to handel "Ok"/"Yes" button response
        snooptTracking=1;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];
        
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        [navController setViewControllers: @[rootViewController] animated: YES];
        
        [self.revealViewController pushFrontViewController:navController animated:YES];
    }
}



- (IBAction)twBtn:(id)sender {
   if([global isConnected]){
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any UI updates occur
    // on the main queue
   

    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                 break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                 [self resetSnoopTime];
                [self AskToViewDealNow];
                 break;
        }
        
        //  dismiss the Tweet Sheet
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:^{
                
            }];
        });
    };
    
    //  Set the initial body of the Tweet
    [tweetSheet setInitialText: [NSString stringWithFormat:@"%@ %@",sharingMsg,sharingURL]];
       if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
    [tweetSheet addURL:[NSURL URLWithString:@"snach.it"]];
       }
    [tweetSheet addImage:[UIImage imageNamed:@"twitter_ad.png"]];
    //  Adds an image to the Tweet.  For demo purposes, assume we have an
    //  image named 'larry.png' that we wish to attach

    
    //  Presents the Tweet Sheet to the user
    [self presentViewController:tweetSheet animated:NO completion:^{
       
    }];
    
   }
    
}

- (IBAction)linkedInBtn:(id)sender {
    if([global isConnected]){
    backView = [[UIView alloc] initWithFrame:self.view.frame];
    backView.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.3];
    [self.view addSubview:backView];
    
    //initializing linked in profile view 
//    profileTabView=[[ProfileTabView alloc] init];
//    profileTabView.parentVC=self;
//    profileTabView.view.frame=CGRectMake(0, 30, backView.frame.size.width, backView.frame.size.height-60);
//    profileTabView.sharingMsg=[NSString stringWithFormat:@"Snach.it %@ %@646x350.png %@",sharingMsg,appiconURL,sharingURL];
//    profileTabView.userid=user.userID;
//    profileTabView.snachid=product.snachId;
//    //place device check here
//    
//    //profileTabView.view.center=self.view.center;
//    [backView addSubview:profileTabView.view];
    }
  }
-(void) removeLinkedInview
{
    //[profileTabView.view removeFromSuperview];
    [backView removeFromSuperview];
    profileTabView=nil;
    backView=nil;
    if(linkedinsharetracker==1){
        [self AskToViewDealNow];
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    
  
    
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
                  
                    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
                    [shareBuilder setPrefillText:[NSString stringWithFormat:@"%@ %@",sharingMsg,sharingURL]];
                    //[shareBuilder setTitle:@"snach.it" description:sharingMsg thumbnailURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@googleplus_ad.png",appiconURL]]];
                    [shareBuilder attachImage:[UIImage imageNamed:@"googleplus_ad.png"]];
                    [shareBuilder open];
                    
                    if (error) {
                        //Handle Error
                          NSLog(@"Error Occured");
                       
                    } else {
                        
                        
                    }
                }];
        
       
    }
    
}

#pragma mark - GPPShareDelegate
- (void)finishedSharingWithError:(NSError *)error {
    
    if (!error) {
        [self resetSnoopTime];
        [self AskToViewDealNow];
    }
    
}

- (void)finishedSharing:(BOOL)shared{
    
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
    if([global isConnected]){
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.clientID = kClientId;
    signIn.scopes = @[ kGTLAuthScopePlusLogin ];
    signIn.delegate = self;
    
    [signIn authenticate];
    }
}


-(void)setupProfilePic{
    /*Upper left profile pic work starts here*/
    
    //here i am setting the frame of profile pic and assigning it to a button
    CGRect frameimg = CGRectMake(0, 0, 40, 40);
    topProfileBtn = [[UIButton alloc] initWithFrame:frameimg];
    
    //assigning the default background image
    [topProfileBtn setBackgroundImage:[UIImage imageNamed:DEFAULTPLACEHOLDER] forState:UIControlStateNormal];
    topProfileBtn.clipsToBounds=YES;
    [topProfileBtn setShowsTouchWhenHighlighted:YES];
    
    //setting up corner radious, border and border color width to make it circular
    topProfileBtn.layer.cornerRadius = 20.0f;
    topProfileBtn.layer.borderWidth = 2.0f;
    topProfileBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
     [topProfileBtn setContentMode:UIViewContentModeScaleAspectFill];
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

//this method generates referal code with combination of userid and 6 digit random text
-(NSString*)generateSharingURL{
    
    NSString *tempURL=[Common getTinyUrlForLink:[NSString stringWithFormat:@"%@snachit-referal-encode/?referal_cd=%@",ec2maschineIP,referalCode]];
    return tempURL;
}

//this method sends referal code to the backend
-(void)sendReferalCode{
      NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *url=[NSString stringWithFormat:@"%@store-user-referal-code/?customer_id=%@&referal_code=%@",ec2maschineIP,user.userID,referalCode];
    
    NSURL *webURL = [[NSURL alloc] initWithString:[url stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:webURL];
    NSURLResponse *response = nil;
    NSError *error = nil;
    //getting the data
    NSData *jasonData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(jasonData)
    {
        NSDictionary *response= [NSJSONSerialization JSONObjectWithData:jasonData options:NSJSONReadingMutableContainers error: &error];
        NSLog(@"\nResponse:%@ ",response);
        
        if([[response objectForKey:@"success"] isEqual:@"true"])
           {
            [defaults setObject:@"1" forKey:@"referalCodeStatus"];
            [defaults setObject:referalCode forKey:@"referalCode"];
           }
        else
            [defaults setObject:@"0" forKey:@"referalCodeStatus"];
        
    }
    
}

-(void)resetSnoopTime{
    if(![[SnachItDB database] logtime:user.userID SnachId:[product.snachId intValue] SnachTime:DEFAULT_SNOOPTIME]){
        [[SnachItDB database] updatetime:user.userID SnachId:[product.snachId intValue] SnachTime:DEFAULT_SNOOPTIME];
    }
}



@end
