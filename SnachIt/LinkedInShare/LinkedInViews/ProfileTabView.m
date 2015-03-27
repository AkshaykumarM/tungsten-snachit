//
//  iPhone OAuth Starter Kit
//
//  Supported providers: LinkedIn (OAuth 1.0a)
//
//  Lee Whitney
//  http://whitneyland.com
//

#import <Foundation/NSNotificationQueue.h>
#import "ProfileTabView.h"
#import "AppShare.h"
#import "SnachItDB.h"
#import "SnoopedProduct.h"
#import "global.h"
#import "SnatchFeed.h"
#define OAUTH_CONSUMER @"oAuth_consumer"
#define OAUTH_ACCESSTOKEN @"oAuth_accessToken"

@interface ProfileTabView()


@end

@implementation ProfileTabView
{
    SnoopedProduct *product;
}
@synthesize button, name, headline, oAuthLoginView, 
            status, postButton, postButtonLabel,
            statusTextView, updateStatusLabel,iconPostButton,iconSignInButton, activity, logoutButton, iconLogoutButton;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
CGFloat animatedDistance;
- (IBAction)closeButtonPressed:(id)sender {
    [_parentVC removeLinkedInview];
}

- (IBAction)button_TouchUp:(UIButton *)sender
{
    // check here if user has already a token place the profile call otherwise push signIn UI:
    consumer=[[ProfileTabView getConsumer] retain];
    accessToken=[[ProfileTabView getAccessToken] retain];
    
    if (consumer && accessToken) {
        [self profileApiCall];
    }
    else
    {
        oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:@"OAuthLoginView" bundle:nil];
        [oAuthLoginView retain];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginViewDidFinish:)
                                                     name:@"loginViewDidFinish"
                                                   object:oAuthLoginView];
        
        oAuthLoginView.parentVC=self;
        oAuthLoginView.view.autoresizesSubviews=YES;
         oAuthLoginView.view.frame=CGRectMake(0, 0, oAuthLoginView.view.frame.size.width, oAuthLoginView.view.frame.size.height);
        // register to be told when the login is finished
        [self.view addSubview:oAuthLoginView.view];
        
    }
    
}

- (IBAction)logout_TouchUp:(id)sender {
   
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Logout" message:@"Successfully logged out. Please login to continue!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        alert.tag=1;
        [alert release];
    
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        [ProfileTabView deleteAccessToken];
        [ProfileTabView deleteConumer];
        name.text=@"";
        headline.text=@"";
        iconSignInButton.hidden=false;
        button.hidden=false;
        [postButton setHidden:TRUE];
        [iconPostButton setHidden:TRUE];
        [postButtonLabel setHidden:TRUE];
        [statusTextView setHidden:TRUE];
        [updateStatusLabel setHidden:TRUE];
        [iconLogoutButton setHidden:TRUE];
        [logoutButton setHidden:TRUE];
    }
    if (alertView.tag==2) {
        [_parentVC removeLinkedInview];
    }
}


-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    if (!consumer && !accessToken) {
        consumer=[[ProfileTabView getConsumer] retain];
        accessToken=[[ProfileTabView getAccessToken] retain];
    }
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
    if (consumer&&accessToken) {
        [self profileApiCall];
    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong while loggin in. Please try again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        alert.tag=2;
        [alert release];
    }
    
}

- (void)profileApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~"];
    OAMutableURLRequest *request = 
//    [[OAMutableURLRequest alloc] initWithURL:url
//                                    consumer:oAuthLoginView.consumer
//                                       token:oAuthLoginView.accessToken
//                                    callback:nil
//                           signatureProvider:nil];
    
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:consumer
                                       token:accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(profileApiCallResult:didFinish:)
                  didFailSelector:@selector(profileApiCallResult:didFail:)];    
    [request release];
    
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data 
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *profile = [responseBody objectFromJSONString];
    [responseBody release];

    if ( profile )
    {
        name.text = [[NSString alloc] initWithFormat:@"%@ %@",
                     [profile objectForKey:@"firstName"], [profile objectForKey:@"lastName"]];
        headline.text = [profile objectForKey:@"headline"];
    }
    
    // The next thing we want to do is call the network updates
    [self networkApiCall:NO];

}


- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error 
{
    NSLog(@"%@",[error description]);
}

- (void)networkApiCall:(BOOL) isStatusUpdate
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT"];
    OAMutableURLRequest *request = 
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:consumer
                                       token:accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    if (isStatusUpdate) {
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(networkApiCallResultForStatus:didFinish:)
                      didFailSelector:@selector(networkApiCallResultForStatus:didFail:)];
    }
    else
    {
        [fetcher fetchDataWithRequest:request
                             delegate:self
                    didFinishSelector:@selector(networkApiCallResult:didFinish:)
                      didFailSelector:@selector(networkApiCallResult:didFail:)];
    }
    
    [request release];
    
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data 
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *person = [[[[[responseBody objectFromJSONString] 
                                objectForKey:@"values"] 
                                    objectAtIndex:0]
                                        objectForKey:@"updateContent"]
                                            objectForKey:@"person"];
    
    [responseBody release];
    
    if ( [person objectForKey:@"currentStatus"] )
    {
        iconSignInButton.hidden=TRUE;
        button.hidden=TRUE;
        [postButton setHidden:false];
        [iconPostButton setHidden:false];
        [postButtonLabel setHidden:false];
        [statusTextView setHidden:false];
        [updateStatusLabel setHidden:false];
        [iconLogoutButton setHidden:NO];
        [logoutButton setHidden:NO];

       /* status.text = [person objectForKey:@"currentStatus"]; */
    } else {
        [postButton setHidden:false];
        [iconPostButton setHidden:false];
        [postButtonLabel setHidden:false];
        [statusTextView setHidden:false];
        [updateStatusLabel setHidden:false];
        [iconLogoutButton setHidden:NO];
        [logoutButton setHidden:NO];

        /* status.text = [[[[person objectForKey:@"personActivities"]
                            objectForKey:@"values"]
                                objectAtIndex:0]
                                    objectForKey:@"body"]; */
        
    }
    
    if (oAuthLoginView) {
        [oAuthLoginView.view removeFromSuperview];
        //   [oAuthLoginView release];
        //oAuthLoginView=nil;
    }
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error 
{
    NSLog(@"%@",[error description]);
}

- (void)networkApiCallResultForStatus:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    
    NSDictionary *person = [[[[[responseBody objectFromJSONString]
                               objectForKey:@"values"]
                              objectAtIndex:0]
                             objectForKey:@"updateContent"]
                            objectForKey:@"person"];
    
    [responseBody release];
    
    if ( [person objectForKey:@"currentStatus"] )
    {
        iconSignInButton.hidden=TRUE;
        button.hidden=TRUE;
        [postButton setHidden:false];
        [iconPostButton setHidden:false];
        [postButtonLabel setHidden:false];
        [statusTextView setHidden:false];
        [updateStatusLabel setHidden:false];
        [iconLogoutButton setHidden:NO];
        [logoutButton setHidden:NO];
        
        /* status.text = [person objectForKey:@"currentStatus"]; */
    } else {
        [postButton setHidden:false];
        [iconPostButton setHidden:false];
        [postButtonLabel setHidden:false];
        [statusTextView setHidden:false];
        [updateStatusLabel setHidden:false];
        [iconLogoutButton setHidden:NO];
        [logoutButton setHidden:NO];
        
        /* status.text = [[[[person objectForKey:@"personActivities"]
         objectForKey:@"values"]
         objectAtIndex:0]
         objectForKey:@"body"]; */
        
    }
    
    
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Success" message:@"Status successfully shared to LinkedIn." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        alert.tag=2;
        [alert release];
    
    if (oAuthLoginView) {
        [oAuthLoginView.view removeFromSuperview];
        //   [oAuthLoginView release];
        //oAuthLoginView=nil;
    }
}

- (void)networkApiCallResultForStatus:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}


- (IBAction)postButton_TouchUp:(UIButton *)sender
{
    if ([[statusTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:@""]) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please enter status to share" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
        [alert show];
        [alert release];
        return;
    }
    [statusTextView resignFirstResponder];
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/shares"];
    OAMutableURLRequest *request = 
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:consumer
                                       token:accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [[NSDictionary alloc] 
                             initWithObjectsAndKeys:
                             @"anyone",@"code",nil], @"visibility", 
                            statusTextView.text, @"comment", nil];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *updateString = [update JSONString];
    
    [request setHTTPBodyWithString:updateString];
	[request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(postUpdateApiCallResult:didFinish:)
                  didFailSelector:@selector(postUpdateApiCallResult:didFail:)];    
    [request release];
}

- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data 
{
    // The next thing we want to do is call the network updates
    [self resetSnoopTime];
    linkedinsharetracker=1;
    [self networkApiCall:YES];
    
}



- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error 
{
    NSLog(@"%@",[error description]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.png"]];
    
    consumer=nil;
    accessToken=nil;
    
    statusTextView.layer.cornerRadius=3.0;
    statusTextView.clipsToBounds=YES;
    statusTextView.layer.shadowColor=[UIColor blueColor].CGColor;
    statusTextView.layer.shadowOffset=CGSizeMake(1, 1);
    
    
    UIImage *buttonImage = [[UIImage imageNamed:@"whiteButton.png"]
                            resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *buttonImageHighlight = [[UIImage imageNamed:@"whiteButtonHighlight.png"]
                                     resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    // Set the background for any states you plan to use
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal]
    ;
    [button setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [postButton setBackgroundImage:buttonImage forState:UIControlStateNormal]
    ;
    [postButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [logoutButton setBackgroundImage:buttonImage forState:UIControlStateNormal]
    ;
    [logoutButton setBackgroundImage:buttonImageHighlight forState:UIControlStateHighlighted];
    
    [activity setHidden:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    product=[SnoopedProduct sharedInstance];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    self.statusTextView.text=self.sharingMsg;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [consumer release];
    [accessToken release];
    if(oAuthLoginView){
      [ oAuthLoginView.view removeFromSuperview];
        [oAuthLoginView release];
        oAuthLoginView=nil;
    }
    [iconSignInButton release];
    [button release];
    [postButton release];
    [postButtonLabel release];
    [name release];
    [headline release];
    [status release];
    [updateStatusLabel release];
    [statusTextView release];
    [iconPostButton release];
    [activity release];
    [logoutButton release];
    [iconLogoutButton release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidUnload
{
    [super viewDidUnload];
    [iconSignInButton release];
    iconSignInButton=nil;
    
    [button release];
    button=nil;
    
    [postButton release];
    postButton =nil;
    
    [postButtonLabel release];
    postButtonLabel=nil;
    
    [name release];
    name=nil;
    
    [headline release];
    headline=nil;
    
    [status release];
    status=nil;
    
    [updateStatusLabel release];
    updateStatusLabel=nil;
    
    [statusTextView release];
    statusTextView=nil;
    
    [iconPostButton release];
    iconPostButton=nil;
    
    if (oAuthLoginView) {
        [oAuthLoginView.view removeFromSuperview];
        [oAuthLoginView release];
        oAuthLoginView=nil;
    }
    
    [activity release];
    activity=nil;
    
    [logoutButton release];
    logoutButton=nil;
    
    [iconLogoutButton release];
    iconLogoutButton=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) removeLoginView
{
    if (oAuthLoginView) {
        [oAuthLoginView.view removeFromSuperview];
        [oAuthLoginView release];
        oAuthLoginView=nil;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [statusTextView resignFirstResponder];
}

// These methods are to keep the record for login
+(void) setConsumerAtFile:(OAConsumer*)consumer1
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"consumer.txt"];
    
    NSMutableArray *myObject=[NSMutableArray array];
    [myObject addObject:consumer1];
    
    [NSKeyedArchiver archiveRootObject:myObject toFile:appFile];
}

+(void) deleteConumer
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"consumer.txt"];
    [[NSFileManager defaultManager] removeItemAtPath:appFile error:nil];
}

+(OAConsumer*) getConsumer
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"consumer.txt"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:appFile];
    if (fileExists) {
        NSMutableArray* myArray = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
        return [myArray objectAtIndex:0];
    }
    return nil;
   
}

+(void) setAccessTokenAtFile:(OAToken*)token
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"accessToken.txt"];
    
    NSMutableArray *myObject=[NSMutableArray array];
    [myObject addObject:token];
    
    [NSKeyedArchiver archiveRootObject:myObject toFile:appFile];
}

+(OAToken*) getAccessToken
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"accessToken.txt"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:appFile];
    if (fileExists) {
        NSMutableArray* myArray = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
        return [myArray objectAtIndex:0];
    }
    return nil;
}

+(void) deleteAccessToken
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"accessToken.txt"];
    [[NSFileManager defaultManager] removeItemAtPath:appFile error:nil];
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
-(void)resetSnoopTime{
    if(![[SnachItDB database] logtime:self.userid SnachId:[self.snachid intValue] SnachTime:(int)DEFAULT_SNOOPTIME]){
        [[SnachItDB database] updatetime:self.userid SnachId:[self.snachid intValue] SnachTime:(int)DEFAULT_SNOOPTIME];
    }
}



@end
