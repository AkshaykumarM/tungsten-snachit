//
//  BillingInformation.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "BillingInformation.h"
#import "SWRevealViewController.h"
#import "SnatchFeed.h"
@implementation BillingInformation

- (void)viewDidLoad {
    [super viewDidLoad];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self setViewLookAndFeel];
    // Load the file content and read the data into arrays
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
-(void)setViewLookAndFeel{
    self.profilePic.layer.cornerRadius= self.profilePic.frame.size.width/1.96;
    
    
    self.profilePic.clipsToBounds = YES;
    self.profilePic.layer.borderWidth = 3.0f;
    self.profilePic.layer.borderColor = [UIColor whiteColor].CGColor;
}
- (IBAction)saveBtn:(id)sender {
   
    [self performSegueWithIdentifier:@"billSegue" sender:self];
}

- (IBAction)backBtn:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SnatchFeed *rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"snachfeed"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    [navController setViewControllers: @[rootViewController] animated: YES];
    
    [self.revealViewController pushFrontViewController:navController animated:YES];
}
@end
