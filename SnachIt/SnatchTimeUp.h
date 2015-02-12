//
//  SnatchTimeUp.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/16/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnatchTimeUp : UIViewController

- (IBAction)viewOtherDeals:(id)sender;

- (IBAction)shareAppBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *profilePicBarButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end
