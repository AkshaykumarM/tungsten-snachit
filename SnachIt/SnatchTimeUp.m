//
//  SnatchTimeUp.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/16/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnatchTimeUp.h"
#import "SWRevealViewController.h"
#import "UserProfile.h"
#import "SnatchFeed.h"
#import "global.h"
@implementation SnatchTimeUp{
    UserProfile *user;
    UIButton *topProfileBtn;
    UINavigationBar *navbar;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Set the gesture
   
//     navbar= [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    //do something like background color, title, etc you self
//    [self.view addSubview:navbar];
    
    // Load the file content and read the data into arrays
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    
  
    if([global isValidUrl:user.profilePicUrl]){
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            CGRect frameimg = CGRectMake(0, 5, 40, 40);
            
            topProfileBtn = [[UIButton alloc] initWithFrame:frameimg];
            [topProfileBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
            topProfileBtn.clipsToBounds=YES;
            [topProfileBtn setShowsTouchWhenHighlighted:YES];
            topProfileBtn.layer.cornerRadius = 20.0f;
            topProfileBtn.layer.borderWidth = 2.0f;
            topProfileBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
            
            [topProfileBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *mailbutton =[[UIBarButtonItem alloc] initWithCustomView:topProfileBtn];
            
            self.navigationItem.leftBarButtonItem=mailbutton;
            self.profilePicBarButton= mailbutton;
            
            
            UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"time's up"];
            navigationItem.leftBarButtonItem = mailbutton;
            [self.navigationBar pushNavigationItem:navigationItem animated:NO];
            
        }];
    }

}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
}

- (IBAction)viewOtherDeals:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController pushFrontViewController:navController animated:YES];

}

- (IBAction)shareAppBtn:(id)sender {
    [self performSegueWithIdentifier:@"appshare" sender:self];
}


@end
