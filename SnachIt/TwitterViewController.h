//
//  TwitterViewController.h
//  SnachIt
//
//  Created by Akshakumar Maldhure on 1/12/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthConsumerTW.h"
@interface TwitterViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *webview;
    OAConsumerTW* consumer;
    OATokenTW* requestToken;
    OATokenTW* accessToken;
}
@property (nonatomic,strong) OATokenTW* accessToken;
@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) NSString *isLogin;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *twitterLoginViewLoader;
- (IBAction)closeBtn:(id)sender;


@end
