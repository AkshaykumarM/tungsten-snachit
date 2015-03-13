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
   
    // Set the gesture
   
//     navbar= [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    //do something like background color, title, etc you self
//    [self.view addSubview:navbar];
    
    // Load the file content and read the data into arrays
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
      self.navigationController.navigationBar.topItem.title = @"time's up";
    
  
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    user=[UserProfile sharedInstance];
    [self setupProfilePic];
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
-(void)setupProfilePic{
    /*Upper left profile pic work starts here*/
    
    //here i am setting the frame of profile pic and assigning it to a button
    CGRect frameimg = CGRectMake(0, 5, 40, 40);
    topProfileBtn = [[UIButton alloc] initWithFrame:frameimg];
     [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
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
    
    [self.navigationBar setItems:@[self.navigationItem]];
    //checking if profile pic url is nil else download the image and assign it to imageview
    
    
    if([global isValidUrl:user.profilePicUrl]){
        
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:user.profilePicUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            [topProfileBtn setBackgroundImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
        }];}
    
}


@end
