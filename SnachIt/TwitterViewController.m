//
//  TwitterViewController.m
//  SnachIt
//
//  Created by Akshakumar Maldhure on 1/12/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "TwitterViewController.h"
#import "TwitterEmailIdView.h"
#import "UserProfile.h"

NSString *client_id = @"GEgPnkP8nWL4IKvZVuow6J4pM";
NSString *secret = @"GHJBrsN0cGQGnGttzovNzpJgHzxBVXSI0HrJEnz2LX0z2e283u";
NSString *callback = @"http://codegerms.com/callback";


@interface TwitterViewController()

@end
@implementation TwitterViewController
@synthesize webview, isLogin,accessToken;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.twitterLoginViewLoader startAnimating];
    consumer = [[OAConsumerTW alloc] initWithKey:client_id secret:secret realm:nil];
    NSURL* requestTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"];
    OAMutableURLRequestTW* requestTokenRequest = [[OAMutableURLRequestTW alloc] initWithURL:requestTokenUrl
                                                                               consumer:consumer
                                                                                  token:nil
                                                                                  realm:nil
                                                                      signatureProvider:nil];
    OARequestParameterTW* callbackParam = [[OARequestParameterTW alloc] initWithName:@"oauth_callback" value:callback];
    [requestTokenRequest setHTTPMethod:@"POST"];
    [requestTokenRequest setParameters:[NSArray arrayWithObject:callbackParam]];
    OADataFetcherTW* dataFetcher = [[OADataFetcherTW alloc] init];
    [dataFetcher fetchDataWithRequest:requestTokenRequest
                             delegate:self
                    didFinishSelector:@selector(didReceiveRequestToken:data:)
                      didFailSelector:@selector(didFailOAuth:error:)];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveRequestToken:(OAServiceTicketTW*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    requestToken = [[OATokenTW alloc] initWithHTTPResponseBody:httpBody];
    
    NSURL* authorizeUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
    OAMutableURLRequestTW* authorizeRequest = [[OAMutableURLRequestTW alloc] initWithURL:authorizeUrl
                                                                            consumer:nil
                                                                               token:nil
                                                                               realm:nil
                                                                   signatureProvider:nil];
    NSString* oauthToken = requestToken.key;
    OARequestParameterTW* oauthTokenParam = [[OARequestParameterTW alloc] initWithName:@"oauth_token" value:oauthToken];
    [authorizeRequest setParameters:[NSArray arrayWithObject:oauthTokenParam]];
    
    [webview loadRequest:authorizeRequest];
}

- (void)didReceiveAccessToken:(OAServiceTicketTW*)ticket data:(NSData*)data {
    NSString* httpBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    accessToken = [[OATokenTW alloc] initWithHTTPResponseBody:httpBody];
    // WebServiceSocket *connection = [[WebServiceSocket alloc] init];
    //  connection.delegate = self;
     // [connection fetch:1 withPostdata:pdata withGetData:@"" isSilent:NO];
    NSLog(@"%@",accessToken.secret);
 
    
    
    if (accessToken) {
        NSURL* userdatarequestu = [NSURL URLWithString:@"https://api.twitter.com/1.1/account/verify_credentials.json"];
        OAMutableURLRequestTW* requestTokenRequest = [[OAMutableURLRequestTW alloc] initWithURL:userdatarequestu
                                                                                   consumer:consumer
                                                                                      token:accessToken
                                                                                      realm:nil
                                                                          signatureProvider:nil];
        
        [requestTokenRequest setHTTPMethod:@"GET"];
        OADataFetcherTW* dataFetcher = [[OADataFetcherTW alloc] init];
        [dataFetcher fetchDataWithRequest:requestTokenRequest
                                 delegate:self
                        didFinishSelector:@selector(didReceiveuserdata:data:)
                          didFailSelector:@selector(didFailOdatah:error:)];    } else {
            // ERROR!
        }
    
    
    
}


- (void)didReceiveuserdata:(OAServiceTicketTW*)ticket data:(NSData*)data {
    
    
    NSError *error;
    NSDictionary *userData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSLog(@"%@",userData);
    NSLog(@"%@", [userData objectForKey:@"id"]);
    CATransition* transition = [CATransition animation];
    transition.duration = 0.35;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    twUserId=[userData objectForKey:@"id"];
    twFullname=[userData objectForKey:@"name"];
    twProfilePic=[[userData objectForKey:@"profile_image_url"] stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"];
   
    TwitterEmailIdView *vc = [[TwitterEmailIdView alloc]
                              initWithNibName:@"TwitterEmailId" bundle:nil];
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:vc animated:NO completion:nil];

}

- (void)didFailOAuth:(OAServiceTicketTW*)ticket error:(NSError*)error {
    // ERROR!
}


- (void)didFailOdatah:(OAServiceTicketTW*)ticket error:(NSError*)error {
    // ERROR!
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    //  [indicator startAnimating];
    NSString *temp = [NSString stringWithFormat:@"%@",request];
    //  BOOL result = [[temp lowercaseString] hasPrefix:@"http://codegerms.com/callback"];
    // if (result) {
    NSRange textRange = [[temp lowercaseString] rangeOfString:[@"http://codegerms.com/callback" lowercaseString]];
    
    if(textRange.location != NSNotFound){
        
        
        // Extract oauth_verifier from URL query
        NSString* verifier = nil;
        NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
        for (NSString* param in urlParams) {
            NSArray* keyValue = [param componentsSeparatedByString:@"="];
            NSString* key = [keyValue objectAtIndex:0];
            if ([key isEqualToString:@"oauth_verifier"]) {
                verifier = [keyValue objectAtIndex:1];
                break;
            }
        }
        
        if (verifier) {
            NSURL* accessTokenUrl = [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
            OAMutableURLRequestTW* accessTokenRequest = [[OAMutableURLRequestTW alloc] initWithURL:accessTokenUrl consumer:consumer token:requestToken realm:nil signatureProvider:nil];
            OARequestParameterTW* verifierParam = [[OARequestParameterTW alloc] initWithName:@"oauth_verifier" value:verifier];
            [accessTokenRequest setHTTPMethod:@"POST"];
            [accessTokenRequest setParameters:[NSArray arrayWithObject:verifierParam]];
            OADataFetcherTW* dataFetcher = [[OADataFetcherTW alloc] init];
            [dataFetcher fetchDataWithRequest:accessTokenRequest
                                     delegate:self
                            didFinishSelector:@selector(didReceiveAccessToken:data:)
                              didFailSelector:@selector(didFailOAuth:error:)];
        } else {
            // ERROR!
        }
        
        [webView removeFromSuperview];
        
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    // ERROR!
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // [indicator stopAnimating];
    [self.twitterLoginViewLoader stopAnimating];
}

- (IBAction)closeBtn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
