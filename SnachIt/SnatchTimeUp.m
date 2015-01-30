//
//  SnatchTimeUp.m
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/16/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnatchTimeUp.h"
#import "SWRevealViewController.h"

@implementation SnatchTimeUp
- (void)viewDidLoad {
    [super viewDidLoad];
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    // Load the file content and read the data into arrays
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (IBAction)viewOtherDeals:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
